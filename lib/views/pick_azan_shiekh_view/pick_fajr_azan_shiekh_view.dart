import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:base_app/enams/view_state_enum.dart';
import 'package:base_app/local_storage/local_storage_manager.dart';
import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/models/azan_sound.dart';
import 'package:base_app/providers/azan_fajr_sounds_provider.dart';
import 'package:base_app/providers/azan_sounds_provider.dart';
import 'package:base_app/providers/pick_azan_shiekh_provider.dart';
import 'package:base_app/providers/pick_fajr_azan_shiekh_provider.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/widgets/base_widget.dart';
import 'package:base_app/widgets/general_wigets/loading_button.dart';
import 'package:base_app/widgets/load_more_azan_sounds_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:path/path.dart' show join;

//
// if there is no data in a local database, show the sounds from assets
//
class PickFajrAzanShiekhView extends StatefulWidget {
  @override
  _PickAzanShiekhViewState createState() => _PickAzanShiekhViewState();
}

class _PickAzanShiekhViewState extends State<PickFajrAzanShiekhView>
    with TickerProviderStateMixin {
  PickFajrAzanShiekhProvider _fajrAzanSoundFromAssetsProvider; //from assets
  AzanFairSoundsProvider _moreFajrAzanSoundsProvider; //from web or local database

  AudioPlayer audioPlayer = AudioPlayer();
  List<AnimationController> animationList = [];
  List<AnimationController> animationListWeb = [];
  String currentPlayingItemId;

  bool displayingFromAssets = false;
  bool screenNoLongerActive=false;

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
    _moreFajrAzanSoundsProvider = Provider.of<AzanFairSoundsProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        screenNoLongerActive = true;
        try {
          audioPlayer.stop();
        } catch (e) {}
        Navigator.of(context).pop();
        return false;
      },
      child: BaseView<PickFajrAzanShiekhProvider>(onModelReady: (model) {
        _fajrAzanSoundFromAssetsProvider = model;
        _fajrAzanSoundFromAssetsProvider.loadAssetsFajrSheikhId();
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
        title: Text(
          AppLocalizations.of(context).translate("select_fajr_shiekh"),
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text(
              AppLocalizations.of(context).translate("save"),
              style: TextStyle(color: Constants.CANVAS_COLOR),
            ),
            onPressed: () {
              //on clicking save button
              if (displayingFromAssets)
                _fajrAzanSoundFromAssetsProvider.saveAssetsFajrSheikhId(context);
              else
                _moreFajrAzanSoundsProvider.saveDownloadedFajrShiekhJson(
                    _moreFajrAzanSoundsProvider
                        .getAzanSound(_moreFajrAzanSoundsProvider.pickedAzanShiekhIndex)
                        .toJSON(),
                    context);
            },
          )
        ],
      ),
    );
  }

  Future playAzan(id, index) async {
    String tempPath = (await getApplicationDocumentsDirectory()).path;
    //WE DONT USE IDS BUT LEFT IF THERE IS FUTURE ADDITIONS
    String path = join(tempPath, "azan_mshary_fajr.mp3");
    if(!screenNoLongerActive)
    await audioPlayer.play(path, isLocal: true);
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
    if (_moreFajrAzanSoundsProvider.getAzanSound(index).localPath == null) {
      await _moreFajrAzanSoundsProvider.downloadFile(index);
    }
    if(!screenNoLongerActive)
      await audioPlayer.play(_moreFajrAzanSoundsProvider.getAzanSound(index).localPath);
    _moreFajrAzanSoundsProvider.pickedAzanShiekhIndex = index;
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

    Constants.FAJR_SHIEKH_NAMES.forEach((f) {
      animationList.add(AnimationController(
          vsync: this, duration: Duration(milliseconds: 300)));
    });
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: Constants.FAJR_SHIEKH_NAMES.length + 1,
                itemBuilder: (context, index) {
                  if(index == Constants.FAJR_SHIEKH_NAMES.length)
                    return Column(children: [
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
                    ]);
                  else
                  return ListTile(
                    selected:
                        _fajrAzanSoundFromAssetsProvider.pickedAzanShiekhIndex ==
                            index,
                    onTap: () {
                      _fajrAzanSoundFromAssetsProvider.pickedAzanShiekhIndex =
                          index;
                      if (Constants.FAJR_SHIEKH_NAMES[index]["id"] ==
                          currentPlayingItemId) {
                        audioPlayer.stop();
                        currentPlayingItemId = null;
                        animationList[index].reverse();
                      } else {
                        playAzan(Constants.FAJR_SHIEKH_NAMES[index]["id"], index);
                      }
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
                      onPressed: () {
                        if (Constants.FAJR_SHIEKH_NAMES[index]["id"] ==
                            currentPlayingItemId) {
                          audioPlayer.stop();
                          currentPlayingItemId = null;
                          animationList[index].reverse();
                        } else {
                          playAzan(Constants.FAJR_SHIEKH_NAMES[index]["id"], index);
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

        ],
      ),
    );
  }

  _buildAzanSoundsList(sizeConfig) {
    //initially check if there is local azan sounds stored
    if (_moreFajrAzanSoundsProvider.loadedState == DataLoadingState.notLoaded) {
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

      _moreFajrAzanSoundsProvider.azanSounds.forEach((f) {
        animationListWeb.add(AnimationController(
            vsync: this, duration: Duration(milliseconds: 300)));
      });
      return ListView.builder(
          itemCount: _moreFajrAzanSoundsProvider.azanSounds.length,
          itemBuilder: (context, index) {
            return ListTile(
              selected: _moreFajrAzanSoundsProvider.pickedAzanShiekhIndex == index,
              onTap: () async {
                if (_moreFajrAzanSoundsProvider.pickedAzanShiekhIndex == index) {
                  audioPlayer.stop();
                  _moreFajrAzanSoundsProvider.pickedAzanShiekhIndex = null;
                  animationListWeb[index].reverse();
                } else {
                  playAzanFromLocalDatabase(index);
                }
              },
              title: Text(
                _moreFajrAzanSoundsProvider.azanSounds[index].name,
                overflow: TextOverflow.ellipsis,
              ),
              leading: index == _moreFajrAzanSoundsProvider.pickedAzanShiekhIndex
                  ? Icon(Icons.check)
                  : null,
              trailing: _moreFajrAzanSoundsProvider.filesStates[index] ==
                          FileDownloadState.downloaded ||
                      _moreFajrAzanSoundsProvider.filesStates[index] ==
                          FileDownloadState.initial
                  ? IconButton(
                      onPressed: () {
                        if (index ==
                            _moreFajrAzanSoundsProvider.pickedAzanShiekhIndex) {
                          audioPlayer.stop();
                          _moreFajrAzanSoundsProvider.pickedAzanShiekhIndex = null;
                          animationListWeb[index].reverse();
                        } else {
                          playAzanFromLocalDatabase(index);
                        }
                      },
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
