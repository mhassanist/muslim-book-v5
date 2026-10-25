import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:muslim_book/quran/utils/ayah_audio.dart';
import 'package:muslim_book/quran/models/quran_model.dart';
import 'package:muslim_book/quran/utils/quran_top_level_functions.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranAudioService extends BaseAudioHandler {
  late SharedPreferences prefs;

  final _audioPlayer = AudioPlayer();
  String ayahUrl = '';
  int surahNumber = 0;
  int ayahIndex = 0;
  int renewSurah = 0;
  late int playCount;
  int playerCount = 0;

//  int ayahNumber;
  QuranModel? model;
  Surah? surah;
  String sheikhId = '';

  // @override
  // Future<void> onStart(Map<String, dynamic>? params) async {
  // // void onStart(Map<String, dynamic> params) async {
  //   prefs = await SharedPreferences.getInstance();
  //   playCount = prefs.getInt(Constants.REPEAT_AYAh_COUNT) ?? 3;
  //   playerCount = 1;

  //   await _audioPlayer.setReleaseMode(ReleaseMode.stop);
  //   implementParams(params ?? {});
  //   onCompleteListener();
  //   AudioServiceBackground.setState(
  //       systemActions: [MediaAction.seekForward],
  //       controls: getPlayControllers(),
  //       playing: true,
  //       processingState: AudioProcessingState.loading,);

  //   ayahUrl = "$baseUrl$sheikhId/${surah?.ayahs[ayahIndex].number}";
  //   await _audioPlayer.play(UrlSource("$ayahUrl"));
  //   setMediaItem();

  //   AudioServiceBackground.setState(
  //     controls: getPlayControllers(),
  //     playing: true,
  //     processingState: AudioProcessingState.ready,
  //     systemActions: [MediaAction.seek],
  //   );
  // }

  // void setMediaItem() {
  //   AudioServiceBackground.setMediaItem(
  //     MediaItem(
  //       extras: {"surahIndex": surahNumber, "renewSurah": renewSurah},
  //       id: "$ayahIndex",
  //       album: "${surah?.englishName}",
  //       title: "${surah?.name}",
  //     ),
  //   );
  // }

  @override
  Future<void> pause() async {
    // Broadcast that we're paused, and what controls are available.
    playbackState.add(PlaybackState(
        controls: getPauseControllers(),
        systemActions: {MediaAction.seek},
        playing: false,
        processingState: AudioProcessingState.ready));
    // Pause the audio.
    _audioPlayer.pause();
  }

  @override
  Future<void> stop() async {
    _audioPlayer.stop();
    if (ayahIndex == surah?.ayahs.length) {
      playbackState.add(PlaybackState(
        controls: [replayControl],
        playing: false,
        processingState: AudioProcessingState.completed,
      ));
    } else {
      playbackState.add(PlaybackState(
          controls: [],
          playing: false,
          processingState: AudioProcessingState.completed));
      return super.stop();
    }
  }

  @override
  Future<void> play() async {
    mediaItem.add(null);
    playbackState.add(PlaybackState(
      controls: getPlayControllers(),
      playing: true,
      processingState: AudioProcessingState.ready,
      systemActions: {MediaAction.seek},
    ));
    await AyahAudio.play(_audioPlayer, sheikhId, surah?.ayahs[ayahIndex].number);
    renewSurah = 0;
  }

  @override
  Future<void> skipToNext() async {
    playNext();
  }

  @override
  Future<void> skipToPrevious() async {
    playPrevious();
  }

  void implementParams(Map<String, dynamic> params) {
    surahNumber = params["surah"] - 1;
    ayahIndex = params["ayahIndex"] - 1;
    sheikhId = params["sheikhId"];
    if (model == null) model = QuranModel.fromJson(params["quranModel"]);
    surah = model?.surahs[surahNumber];
  }

  void onCompleteListener() {
    _audioPlayer.onPlayerComplete.listen((event) {
      if (prefs.getBool(Constants.ALLOW_REPEAT_AYA) ?? false) {
        if (playerCount < playCount) {
          // print(
          //     "first play count is $playCount and playerCount is $playerCount");
          playerCount = playerCount + 1;
          this.play();
        } else {
          // print(
          //     "second play count is $playCount and playerCount is $playerCount");

          playerCount = 1;
          playNext();
        }
      } else {
        playNext();
      }
    });
  }

  void playNext() async {
    ayahIndex++;
    if (ayahIndex < surah!.ayahs.length) {
      ayahUrl = AyahAudio.url(sheikhId, surah!.ayahs[ayahIndex].number);
      this.play();
    } else
      changeNextSurahIndex();
  }

  void changeNextSurahIndex() {
    renewSurah = 1;
    if (surahNumber == 113) {
      surahNumber = 0;
    } else
      surahNumber++;
    ayahIndex = 0;
    surah = model?.surahs[surahNumber];
    ayahUrl = AyahAudio.url(sheikhId, surah?.ayahs[ayahIndex].number);
    this.play();
  }

  void changePreviousSurahIndex() {
    if (surahNumber == 0) {
      surahNumber = 113;
    } else
      surahNumber--;
    ayahIndex = 0;
    renewSurah = 1;
    surah = model?.surahs[surahNumber];
    ayahUrl = AyahAudio.url(sheikhId, surah?.ayahs[ayahIndex].number);
    this.play();
  }

  void playPrevious() async {
    if (ayahIndex > 0) {
      ayahIndex--;
      ayahUrl = AyahAudio.url(sheikhId, surah?.ayahs[ayahIndex].number);
      this.play();
    } else {
      changePreviousSurahIndex();
    }
  }

  List<MediaControl> getPlayControllers() {
    return [
      skipToNextControl,
      pauseControl,
      skipToPreviousControl,
      stopControl
    ];
  }

  List<MediaControl> getPauseControllers() {
    return [skipToNextControl, playControl, skipToPreviousControl, stopControl];
  }
}

// class A extends BaseAudioHandler with QueueHandler, SeekHandler {
//
//   // The most common callbacks:
//   Future<void> play() async {
//     // All 'play' requests from all origins route to here. Implement this
//     // callback to start playing audio appropriate to your app. e.g. music.
//   }
//   Future<void> pause() async {
//     // Broadcast that we're paused, and what controls are available.
//     AudioServiceBackground.setState(
//     controls: getPauseControllers(),
//     systemActions: [MediaAction.seekTo],
//     playing: false,
//     processingState: AudioProcessingState.ready);
//     // Pause the audio.
//     _audioPlayer.pause();
//   }
//   Future<void> stop() async {}
//   Future<void> seek(Duration position) async {}
//   Future<void> skipToQueueItem(int i) async {}
//
// }