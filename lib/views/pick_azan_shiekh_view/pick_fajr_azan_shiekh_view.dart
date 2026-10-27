import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/local_storage/local_storage_manager.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/models/azan_sound.dart';
import 'package:muslim_book/providers/azan_fajr_sounds_provider.dart';
import 'package:muslim_book/providers/azan_sounds_provider.dart';
import 'package:muslim_book/providers/pick_fajr_azan_shiekh_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/widgets/base_widget.dart';
import 'package:muslim_book/widgets/load_more_azan_sounds_button.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:path/path.dart' show join;

//
// if there is no data in a local database, show the sounds from assets
//
class PickFajrAzanShiekhView extends StatefulWidget {
  const PickFajrAzanShiekhView({super.key});

  @override
  State<PickFajrAzanShiekhView> createState() => _PickAzanShiekhViewState();
}

class _PickAzanShiekhViewState extends State<PickFajrAzanShiekhView>
    with TickerProviderStateMixin {
  PickFajrAzanShiekhProvider? _fajrAzanSoundFromAssetsProvider; //from assets
  late AzanFairSoundsProvider
      _moreFajrAzanSoundsProvider; //from web or local database

  final audioPlayer = AudioPlayer();
  List<AnimationController> animationList = [];
  List<AnimationController> animationListWeb = [];
  String currentPlayingItemId = '';

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
      currentPlayingItemId = '';
      _playingWebIndex = null;
    });
    for (final c in animationList) {
      c.reverse();
    }
    for (final c in animationListWeb) {
      c.reverse();
    }
  }

  void _toggleAssetPreview(int index) {
    final id = Constants.FAJR_SHIEKH_NAMES[index]["id"];
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
    animationList.forEach((f) {
      f.dispose();
    });

    animationListWeb.forEach((f) {
      f.dispose();
    });

    try {
      audioPlayer.stop();
    } catch (e) {}

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _moreFajrAzanSoundsProvider = Provider.of<AzanFairSoundsProvider>(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        screenNoLongerActive = true;
        try {
          audioPlayer.stop();
        } catch (e) {}
        Navigator.of(context).pop();
      },
      child: BaseView<PickFajrAzanShiekhProvider>(onModelReady: (model) {
        _fajrAzanSoundFromAssetsProvider = model;
        _fajrAzanSoundFromAssetsProvider?.loadAssetsFajrSheikhId();
      }, builder: (_, model, __) {
        return SafeArea(
          child: Scaffold(
              appBar: _buildAppBar(context),
              body: ResponsiveBuilder(builder: (context, sizeConfig) {
                return FutureBuilder(
                  future: LocalStorageManager.storage.ready,
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.data == true) {
                      //local storage ready
                      return _buildAzanSoundsList(sizeConfig);
                    } else {
                      return Container();
                    }
                  },
                );
              })),
        );
      }),
    );
  }

  PreferredSize _buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: AppBar(
        backgroundColor: const Color(0XFF347D53),
        title: Text(
          AppLocalizations.of(context)!.translate("select_fajr_shiekh"),
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: <Widget>[
          MaterialButton(
            child: Text(
              AppLocalizations.of(context)!.translate("save"),
              style: TextStyle(color: Constants.CANVAS_COLOR),
            ),
            onPressed: () {
              //on clicking save button
              if (displayingFromAssets) {
                _fajrAzanSoundFromAssetsProvider?.saveAssetsFajrSheikhId(context);
              } else {
                final azanSound = _moreFajrAzanSoundsProvider.getAzanSound(
                  _moreFajrAzanSoundsProvider.pickedAzanShiekhIndex,
                );
                if (azanSound != null) {
                  _moreFajrAzanSoundsProvider.saveDownloadedFajrShiekhJson(
                    azanSound.toJSON(),
                    context,
                  );
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
    //WE DONT USE IDS BUT LEFT IF THERE IS FUTURE ADDITIONS
    String path = join(tempPath, "azan_mshary_fajr.mp3");
    if (request != _playRequest || screenNoLongerActive) return;
    await audioPlayer.play(DeviceFileSource(path));
  }

  Future playAzanFromLocalDatabase(index) async {
    final request = ++_playRequest;
    _moreFajrAzanSoundsProvider.pickedAzanShiekhIndex = index;
    setState(() {
      _playingWebIndex = index;
      currentPlayingItemId = '';
    });
    for (int i = 0; i < animationListWeb.length; i++) {
      i == index ? animationListWeb[i].forward() : animationListWeb[i].reverse();
    }
    AzanSound? azanSound = _moreFajrAzanSoundsProvider.getAzanSound(index);
    if (azanSound != null && azanSound.localPath.isEmpty) {
      await _moreFajrAzanSoundsProvider.downloadFile(index);
      azanSound = _moreFajrAzanSoundsProvider.getAzanSound(index);
    }
    if (request != _playRequest || screenNoLongerActive || azanSound == null) {
      return;
    }
    await audioPlayer.play(DeviceFileSource(azanSound.localPath));
  }

  _buildGetMoreAzanSoundsButton(sizeConfig) {
    var state = _moreFajrAzanSoundsProvider.viewState == ViewState.Idle
        ? CrossFadeState.showFirst
        : CrossFadeState.showSecond;
    return LoadMoreAzanSoundsButton(
        text: "press_here",
        onTap: () {
          if (_moreFajrAzanSoundsProvider.viewState == ViewState.Idle) {
            _moreFajrAzanSoundsProvider.loadAzanSounds();
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
    while (animationList.length < Constants.FAJR_SHIEKH_NAMES.length) {
      animationList.add(AnimationController(
          vsync: this, duration: Duration(milliseconds: 300)));
    }
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: Constants.FAJR_SHIEKH_NAMES.length + 1,
                itemBuilder: (context, index) {
                  if (index == Constants.FAJR_SHIEKH_NAMES.length) {
                    return Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Text(
                            AppLocalizations.of(context)!
                                .translate("click_here_for_more_azan_sheikh"),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            )),
                      ),
                      _buildGetMoreAzanSoundsButton(sizeConfig)
                    ]);
                  } else {
                    return ListTile(
                      selected: _fajrAzanSoundFromAssetsProvider!
                              .pickedAzanShiekhIndex ==
                          index,
                      onTap: () {
                        _fajrAzanSoundFromAssetsProvider!
                            .pickedAzanShiekhIndex = index;
                        _toggleAssetPreview(index);
                      },
                      title: Text(
                        Constants.FAJR_SHIEKH_NAMES[index]["name"],
                        overflow: TextOverflow.ellipsis,
                      ),
                      leading: Constants.FAJR_SHIEKH_NAMES[index]["id"] ==
                              currentPlayingItemId
                          ? Icon(Icons.check)
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
                  }
                }),
          ),
        ],
      ),
    );
  }

  _buildAzanSoundsList(sizeConfig) {
    //initially check if there is local azan sounds stored
    if (_moreFajrAzanSoundsProvider.loadedState ==
        DataLoadingState.notLoaded) {
      _moreFajrAzanSoundsProvider.checkForLocal();
      return Container();
      //if there is no local downloaded files, load from assets and show
      // load more button
    } else if (_moreFajrAzanSoundsProvider.loadedState ==
        DataLoadingState.canBeLoadedFromWeb) {
      return _buildAzanSoundsListFromAssets(sizeConfig);
      //if there are local files, load from local database
    } else if (_moreFajrAzanSoundsProvider.loadedState ==
        DataLoadingState.localAvailable) {
      displayingFromAssets = false;

      while (animationListWeb.length <
          _moreFajrAzanSoundsProvider.azanSounds.length) {
        animationListWeb.add(AnimationController(
            vsync: this, duration: Duration(milliseconds: 300)));
      }
      return ListView.builder(
          itemCount: _moreFajrAzanSoundsProvider.azanSounds.length,
          itemBuilder: (context, index) {
            if (_moreFajrAzanSoundsProvider.filesStates[index] ==
                    FileDownloadState.initial &&
                index == _moreFajrAzanSoundsProvider.pickedAzanShiekhIndex) {
                  // Not during build: it updates the selection and state
                  WidgetsBinding.instance.addPostFrameCallback(
                      (_) => playAzanFromLocalDatabase(index));
                }
            return ListTile(
              selected:
                  _moreFajrAzanSoundsProvider.pickedAzanShiekhIndex == index,
              onTap: () => _toggleWebPreview(index),
              title: Text(
                _moreFajrAzanSoundsProvider.azanSounds[index].name,
                overflow: TextOverflow.ellipsis,
              ),
              leading:
                  index == _moreFajrAzanSoundsProvider.pickedAzanShiekhIndex
                      ? Icon(Icons.check)
                      : null,
              trailing: _moreFajrAzanSoundsProvider.filesStates[index] ==
                          FileDownloadState.downloaded ||
                      _moreFajrAzanSoundsProvider.filesStates[index] ==
                          FileDownloadState.initial
                  ? IconButton(
                      onPressed: () => _toggleWebPreview(index),
                      icon: _moreFajrAzanSoundsProvider.filesStates[index] ==
                              FileDownloadState.initial
                          ? Icon(
                              Icons.arrow_circle_down,
                              size: 32,
                            )
                          : AnimatedIcon(
                              icon: AnimatedIcons.play_pause,
                              progress: animationListWeb[index],
                              color: Theme.of(context).primaryColor,
                            ),
                    )
                  : CircularProgressIndicator(),
            );
          });
    }
  }
}
