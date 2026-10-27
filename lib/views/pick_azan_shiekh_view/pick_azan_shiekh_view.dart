import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';
import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/local_storage/local_storage_manager.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/providers/azan_sounds_provider.dart';
import 'package:muslim_book/providers/pick_azan_shiekh_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/widgets/base_widget.dart';
import 'package:muslim_book/widgets/load_more_azan_sounds_button.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../models/azan_sound.dart';

//
// if there is no data in a local database, show the sounds from assets
//
class PickAzanShiekhView extends StatefulWidget {
  final String azanId;
  final bool applyToAll;

  const PickAzanShiekhView(
    this.azanId,
    this.applyToAll, {
    super.key,
  });

  @override
  State<PickAzanShiekhView> createState() => _PickAzanShiekhViewState();
}

class _PickAzanShiekhViewState extends State<PickAzanShiekhView>
    with TickerProviderStateMixin {
  late PickAzanShiekhProvider _azanSoundFromAssetsProvider; //from assets
  late AzanSoundsProvider _moreSoundsProvider; //from web or local database

  final audioPlayer = AudioPlayer();
  List<AnimationController> animationList = [];
  List<AnimationController> animationListWeb = [];
  String? currentPlayingItemId = '';

  bool displayingFromAssets = false;

  bool screenNoLongerActive = false;

  // Bumped on every play/stop, so a slow load from an earlier tap can't start
  // playing after a later one (fast taps used to leave the wrong one playing)
  int _playRequest = 0;
  int? _playingWebIndex;
  StreamSubscription<void>? _completeSubscription;

  @override
  void initState() {
    super.initState();
    _completeSubscription =
        audioPlayer.onPlayerComplete.listen((_) => _stopPreview());
  }

  void _stopPreview() {
    _playRequest++;
    audioPlayer.stop();
    if (!mounted) return;
    setState(() {
      currentPlayingItemId = null;
      _playingWebIndex = null;
    });
    for (final c in animationList) {
      c.reverse();
    }
    for (final c in animationListWeb) {
      c.reverse();
    }
  }

  String _assetShiekhId(int index) =>
      (AppLocalizations.of(context)!.isEnglish()
          ? Constants.EN_SHIEKH_NAMES
          : Constants.AR_SHIEKH_NAMES)[index]["id"];

  void _toggleAssetPreview(int index) {
    final id = _assetShiekhId(index);
    if (id == currentPlayingItemId) {
      _stopPreview();
    } else {
      playAzan(id, index);
    }
  }

  void _toggleWebPreview(int index) {
    if (_playingWebIndex == index) {
      _stopPreview();
    } else {
      playAzanFromLocalDatabase(index);
    }
  }

  @override
  void dispose() {
    _completeSubscription?.cancel();
    for (final f in animationList) {
      f.dispose();
    }
    for (final f in animationListWeb) {
      f.dispose();
    }
    try {
      audioPlayer.stop();
    } catch (e) {
      e.printInfo();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _moreSoundsProvider = Provider.of<AzanSoundsProvider>(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        screenNoLongerActive = true;
        try {
          audioPlayer.stop();
        } catch (e) {e.printInfo();}
        Navigator.of(context).pop();
      },
      child: BaseView<PickAzanShiekhProvider>(
        onModelReady: (model) {
          _azanSoundFromAssetsProvider = model;
          _azanSoundFromAssetsProvider.loadSelectedShiekh(
              widget.azanId, context,
          );
        },
        builder: (_, model, __) {
          return SafeArea(
            child: Scaffold(
                appBar: _buildAppBar(context),
                body: ResponsiveBuilder(builder: (context, sizeConfig) {
                  return FutureBuilder(
                    future: LocalStorageManager.storage.ready,
                    builder: (BuildContext context, snapshot) {
                      if (snapshot.data == true) {
                        //local storage ready
                        return _buildAzanSoundsList(sizeConfig, widget.azanId);
                      } else {
                        return Container();
                      }
                    },
                  );
                })),
          );
        },
      ),
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: AppBar(
        backgroundColor: const Color(0XFF347D53),
        title: AutoSizeText(
          AppLocalizations.of(context)!.translate("select_shiekh"),
          maxLines: 1,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: <Widget>[
          MaterialButton(
            child: Text(
              AppLocalizations.of(context)!.translate("save"),
              style: const TextStyle(color: Constants.CANVAS_COLOR),
            ),
            onPressed: () {
              //on clicking save button
              if (displayingFromAssets) {
                _azanSoundFromAssetsProvider.saveAssetsSelectedShiekh(
                    context,
                    widget.azanId,
                    _azanSoundFromAssetsProvider.pickedAzanShiekhIndex,
                    saveToAll: widget.applyToAll);
              } else {
                AzanSound? azanSound = _moreSoundsProvider
                    .getAzanSound(_moreSoundsProvider.pickedAzanShiekhIndex);
                if (azanSound != null) {
                  _moreSoundsProvider.saveDownloadedShiekhJson(
                      azanSound.toJSON(),
                      widget.azanId,
                      context,
                      widget.applyToAll);
                }
              }
            },
          )
        ],
      ),
    );
  }

  Future playAzan(id, index) async {
    final request = ++_playRequest;
    setState(() {
      currentPlayingItemId = id;
      _playingWebIndex = null;
    });
    for (int i = 0; i < animationList.length; i++) {
      i == index ? animationList[i].forward() : animationList[i].reverse();
    }
    String tempPath = (await getApplicationDocumentsDirectory()).path;
    String path = join(tempPath, "azan_$id.mp3");
    if (request != _playRequest || screenNoLongerActive) return;
    await audioPlayer.play(DeviceFileSource(path));
  }

  Future playAzanFromLocalDatabase(index) async {
    final request = ++_playRequest;
    _moreSoundsProvider.pickedAzanShiekhIndex = index;
    setState(() {
      _playingWebIndex = index;
      currentPlayingItemId = null;
    });
    for (int i = 0; i < animationListWeb.length; i++) {
      i == index ? animationListWeb[i].forward() : animationListWeb[i].reverse();
    }
    if (_moreSoundsProvider.getAzanSound(index) != null) {
      await _moreSoundsProvider.downloadFile(index);
    }
    final azanSound = _moreSoundsProvider.getAzanSound(index);
    if (request != _playRequest || screenNoLongerActive || azanSound == null) {
      return;
    }
    await audioPlayer.play(DeviceFileSource(azanSound.localPath));
  }

  _buildGetMoreAzanSoundsButton(sizeConfig) {
    var state = _moreSoundsProvider.viewState == ViewState.Idle
        ? CrossFadeState.showFirst
        : CrossFadeState.showSecond;
    return LoadMoreAzanSoundsButton(
        text: "press_here",
        onTap: () {
          if (_moreSoundsProvider.viewState == ViewState.Idle) {
            _moreSoundsProvider.loadAzanSounds();
            setState(() {
              state = CrossFadeState.showSecond;
            });
          } else {
            setState(() {
              state = CrossFadeState.showSecond;
            });
          }
        },
        state: state);
  }

  _buildAzanSoundsListFromAssets(sizeConfig) {
    displayingFromAssets = true;

    // Create the controllers once; this used to add a new set on every build
    while (animationList.length < Constants.AR_SHIEKH_NAMES.length) {
      animationList.add(AnimationController(
          vsync: this, duration: const Duration(milliseconds: 300)));
    }
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: AppLocalizations.of(context)!.isEnglish()
                    ? Constants.EN_SHIEKH_NAMES.length
                    : Constants.AR_SHIEKH_NAMES.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    selected:
                        _azanSoundFromAssetsProvider.pickedAzanShiekhIndex ==
                            index,
                    onTap: () {
                      _azanSoundFromAssetsProvider.pickedAzanShiekhIndex =
                          index;
                      _toggleAssetPreview(index);
                    },
                    title: Text(
                      AppLocalizations.of(context)!.isEnglish()
                          ? Constants.EN_SHIEKH_NAMES[index]["name"]
                          : Constants.AR_SHIEKH_NAMES[index]["name"],
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading:
                        _azanSoundFromAssetsProvider.pickedAzanShiekhIndex ==
                                index
                            ? const Icon(Icons.check)
                            : null,
                    trailing: IconButton(
                      onPressed: () => _toggleAssetPreview(index),
                      icon: AnimatedIcon(
                        icon: AnimatedIcons.play_pause,
                        progress: animationList[index],
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  );
                }),
          ),
          Expanded(
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                    AppLocalizations.of(context)!
                        .translate("click_here_for_more_azan_sheikh"),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    )),
              ),
              _buildGetMoreAzanSoundsButton(sizeConfig)
            ]),
          )
        ],
      ),
    );
  }

  _buildAzanSoundsList(sizeConfig, String azanId) {
    screenNoLongerActive = false;
    //initially check if there is local azan sounds stored
    if (_moreSoundsProvider.loadedState == DataLoadingState.notLoaded) {
      _moreSoundsProvider.checkForLocal(azanId);
      return Container();
      //if there is no local downloaded files, load from assets and show
      // load more button
    } else if (_moreSoundsProvider.loadedState ==
        DataLoadingState.canBeLoadedFromWeb) {
      return _buildAzanSoundsListFromAssets(sizeConfig);
      //if there are local files, load from local database
    } else if (_moreSoundsProvider.loadedState ==
        DataLoadingState.localAvailable) {
      if (_moreSoundsProvider.azanSounds.isEmpty) {
        _moreSoundsProvider.loadAzanSounds();
      }
      displayingFromAssets = false;
      while (animationListWeb.length < _moreSoundsProvider.azanSounds.length) {
        animationListWeb.add(AnimationController(
            vsync: this, duration: const Duration(milliseconds: 300)));
      }
      return ListView.builder(
          itemCount: _moreSoundsProvider.azanSounds.length,
          itemBuilder: (context, index) {
            if (_moreSoundsProvider.filesStates[index] ==
                    FileDownloadState.initial &&
                index == _moreSoundsProvider.pickedAzanShiekhIndex) {
                  // Not during build: it updates the selection and state
                  WidgetsBinding.instance.addPostFrameCallback(
                      (_) => playAzanFromLocalDatabase(index));
                }
            return ListTile(
              selected: _moreSoundsProvider.pickedAzanShiekhIndex == index,
              onTap: () => _toggleWebPreview(index),
              title: Text(
                _moreSoundsProvider.azanSounds[index].name,
                overflow: TextOverflow.ellipsis,
              ),
              leading: index == _moreSoundsProvider.pickedAzanShiekhIndex
                  ? const Icon(Icons.check)
                  : null,
              trailing: _moreSoundsProvider.filesStates[index] ==
                          FileDownloadState.downloaded ||
                      _moreSoundsProvider.filesStates[index] ==
                          FileDownloadState.initial
                  ? IconButton(
                      onPressed: () => _toggleWebPreview(index),
                      icon: _moreSoundsProvider.filesStates[index] ==
                              FileDownloadState.initial
                          ? const Icon(
                              Icons.arrow_circle_down,
                              size: 32,
                            )
                          : AnimatedIcon(
                              icon: AnimatedIcons.play_pause,
                              progress: animationListWeb[index],
                              color: Theme.of(context).primaryColor,
                            ),
                    )
                  : const CircularProgressIndicator(),
            );
          });
    }
  }
}
