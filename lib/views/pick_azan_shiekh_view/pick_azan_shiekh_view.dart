import 'package:audioplayers/audioplayers.dart';
import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/local_storage/local_storage_manager.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/providers/azan_sounds_provider.dart';
import 'package:muslim_book/providers/pick_azan_shiekh_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/widgets/base_widget.dart';
import 'package:muslim_book/widgets/load_more_azan_sounds_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

//
// if there is no data in a local database, show the sounds from assets
//
class PickAzanShiekhView extends StatefulWidget {
  final String azanId;
  final bool applyToAll;

  const PickAzanShiekhView(
    this.azanId,
    this.applyToAll, {
    Key key,
  }) : super(key: key);

  @override
  _PickAzanShiekhViewState createState() => _PickAzanShiekhViewState();
}

class _PickAzanShiekhViewState extends State<PickAzanShiekhView>
    with TickerProviderStateMixin {
  PickAzanShiekhProvider _azanSoundFromAssetsProvider; //from assets
  AzanSoundsProvider _moreSoundsProvider; //from web or local database

  AudioPlayer audioPlayer = AudioPlayer();
  List<AnimationController> animationList = [];
  List<AnimationController> animationListWeb = [];
  String currentPlayingItemId;

  bool displayingFromAssets = false;

  bool screenNoLongerActive = false;

  @override
  void dispose() {
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
    _moreSoundsProvider = Provider.of<AzanSoundsProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        screenNoLongerActive = true;
        try {
          audioPlayer.stop();
        } catch (e) {}
        Navigator.of(context).pop();
        return false;
      },
      child: BaseView<PickAzanShiekhProvider>(onModelReady: (model) {
        _azanSoundFromAssetsProvider = model;
        _azanSoundFromAssetsProvider.loadSelectedShiekh(widget.azanId, context);
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
                      return _buildAzanSoundsList(sizeConfig, widget.azanId);
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
          AppLocalizations.of(context)!.translate("select_shiekh"),
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              AppLocalizations.of(context)!.translate("save"),
              style: TextStyle(color: Constants.CANVAS_COLOR),
            ),
            onPressed: () {
              //on clicking save button
              if (displayingFromAssets) {
                _azanSoundFromAssetsProvider.saveAssetsSelectedShiekh(
                    context, widget.azanId,
                    _azanSoundFromAssetsProvider.pickedAzanShiekhIndex,
                    saveToAll: widget.applyToAll);
              } else {
                _moreSoundsProvider.saveDownloadedShiekhJson(
                    _moreSoundsProvider
                        .getAzanSound(_moreSoundsProvider.pickedAzanShiekhIndex)
                        .toJSON(),
                    this.widget.azanId,
                    context,
                    widget.applyToAll);
              }
            },
          )
        ],
      ),
    );
  }

  Future playAzan(id, index) async {
    String tempPath = (await getApplicationDocumentsDirectory()).path;
    String path = join(tempPath, "azan_$id.mp3");
    if (!screenNoLongerActive) await audioPlayer.play(path, isLocal: true);

    animationList[index].forward();
    setState(() {
      currentPlayingItemId = id;
    });
    for (int i = 0; i < animationList.length; i++) {
      if (i != index) {
        animationList[i].reverse();
      }
    }
    animationList.forEach((f) {});
  }

  Future playAzanFromLocalDatabase(index) async {
    if (_moreSoundsProvider.getAzanSound(index).localPath == null) {
      await _moreSoundsProvider.downloadFile(index);
    }
    if (!screenNoLongerActive)
      await audioPlayer.play(_moreSoundsProvider.getAzanSound(index).localPath);
    _moreSoundsProvider.pickedAzanShiekhIndex = index;
    setState(() {
      animationListWeb[index].forward();
    });

    for (int i = 0; i < animationListWeb.length; i++) {
      if (i != index) {
        animationListWeb[i].reverse();
      }
    }
    animationListWeb.forEach((f) {});
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

    AppLocalizations.of(context)!.isEnglish()
        ? Constants.EN_SHIEKH_NAMES.forEach((f) {
            animationList.add(AnimationController(
                vsync: this, duration: Duration(milliseconds: 300)));
          })
        : Constants.AR_SHIEKH_NAMES.forEach((f) {
            animationList.add(AnimationController(
                vsync: this, duration: Duration(milliseconds: 300)));
          });
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
                      if (AppLocalizations.of(context)!.isEnglish()
                          ? Constants.EN_SHIEKH_NAMES[index]["id"]
                          : Constants.AR_SHIEKH_NAMES[index]["id"] ==
                              currentPlayingItemId) {
                        audioPlayer.stop();
                        currentPlayingItemId = null;
                        animationList[index].reverse();
                      } else {
                        playAzan(
                            AppLocalizations.of(context)!.isEnglish()
                                ? Constants.EN_SHIEKH_NAMES[index]["id"]
                                : Constants.AR_SHIEKH_NAMES[index]["id"],
                            index);
                      }
                    },
                    title: Text(
                      AppLocalizations.of(context)!.isEnglish()
                          ? Constants.EN_SHIEKH_NAMES[index]["name"]
                          : Constants.AR_SHIEKH_NAMES[index]["name"],
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: AppLocalizations.of(context)!.isEnglish()
                        ? Constants.EN_SHIEKH_NAMES[index]["id"]
                        : Constants.AR_SHIEKH_NAMES[index]["id"] ==
                                currentPlayingItemId
                            ? Icon(Icons.check)
                            : null,
                    trailing: IconButton(
                      onPressed: () {
                        if (AppLocalizations.of(context)!.isEnglish()
                            ? Constants.EN_SHIEKH_NAMES[index]["id"]
                            : Constants.AR_SHIEKH_NAMES[index]["id"] ==
                                currentPlayingItemId) {
                          audioPlayer.stop();
                          currentPlayingItemId = null;
                          animationList[index].reverse();
                        } else {
                          playAzan(
                              AppLocalizations.of(context)!.isEnglish()
                                  ? Constants.EN_SHIEKH_NAMES[index]["id"]
                                  : Constants.AR_SHIEKH_NAMES[index]["id"],
                              index);
                        }
                      },
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
                    AppLocalizations.of(context)
                        .translate("click_here_for_more_azan_sheikh"),
                    style: TextStyle(
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
      if (_moreSoundsProvider.azanSounds == null ||
          _moreSoundsProvider.azanSounds.length == 0) {
        _moreSoundsProvider.loadAzanSounds();
      }
      displayingFromAssets = false;
      _moreSoundsProvider.azanSounds.forEach((f) {
        animationListWeb.add(AnimationController(
            vsync: this, duration: Duration(milliseconds: 300)));
      });
      return ListView.builder(
          itemCount: _moreSoundsProvider.azanSounds.length,
          itemBuilder: (context, index) {
            return ListTile(
              selected: _moreSoundsProvider.pickedAzanShiekhIndex == index,
              onTap: () async {
                if (_moreSoundsProvider.pickedAzanShiekhIndex == index) {
                  audioPlayer.stop();
                  _moreSoundsProvider.pickedAzanShiekhIndex = null;
                  animationListWeb[index].reverse();
                } else {
                  playAzanFromLocalDatabase(index);
                }
              },
              title: Text(
                _moreSoundsProvider.azanSounds[index].name,
                overflow: TextOverflow.ellipsis,
              ),
              leading: index == _moreSoundsProvider.pickedAzanShiekhIndex
                  ? Icon(Icons.check)
                  : null,
              trailing: _moreSoundsProvider.filesStates[index] ==
                          FileDownloadState.downloaded ||
                      _moreSoundsProvider.filesStates[index] ==
                          FileDownloadState.initial
                  ? IconButton(
                      onPressed: () {
                        if (index ==
                            _moreSoundsProvider.pickedAzanShiekhIndex) {
                          audioPlayer.stop();
                          _moreSoundsProvider.pickedAzanShiekhIndex = null;
                          animationListWeb[index].reverse();
                        } else {
                          playAzanFromLocalDatabase(index);
                        }
                      },
                      icon: _moreSoundsProvider.filesStates[index] ==
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
