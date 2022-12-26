import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:muslim_book/quran/models/quran_model.dart';
import 'package:muslim_book/quran/utils/quran_top_level_functions.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranAudioService extends BackgroundAudioTask {
  late SharedPreferences prefs;

  final _audioPlayer = AudioPlayer();
  final String baseUrl = "https://cdn.alquran.cloud/media/audio/ayah/";
  String ayahUrl = '';
  int surahNumber = 0;
  int ayahIndex = 0;
  int renewSurah = 0;
  int playCount = 0;
  int playerCount = 0;

//  int ayahNumber;
  QuranModel? model;
  Surah? surah;
  String sheikhId = '';

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    prefs = await SharedPreferences.getInstance();
    playCount = prefs.getInt(Constants.REPEAT_AYAh_COUNT) ?? 3;
    playerCount = 1;

    await _audioPlayer.setReleaseMode(ReleaseMode.STOP);
    implementParams(params ?? {});
    onCompleteListener();
    AudioServiceBackground.setState(
        systemActions: [MediaAction.seekForward],
        controls: getPlayControllers(),
        playing: true,
        processingState: AudioProcessingState.loading);

    ayahUrl = "$baseUrl$sheikhId/${surah?.ayahs[ayahIndex].number}";
    await _audioPlayer.play("$ayahUrl");
    setMediaItem();

    AudioServiceBackground.setState(
      controls: getPlayControllers(),
      playing: true,
      processingState: AudioProcessingState.ready,
      systemActions: [MediaAction.seekForward],
    );
  }

  void setMediaItem() {
    AudioServiceBackground.setMediaItem(
      MediaItem(
        extras: {"surahIndex": surahNumber, "renewSurah": renewSurah},
        id: "$ayahIndex",
        album: "${surah?.englishName}",
        title: "${surah?.name}",
      ),
    );
  }

  @override
  Future<void> onPause() async {
    // Broadcast that we're paused, and what controls are available.
    AudioServiceBackground.setState(
        controls: getPauseControllers(),
        systemActions: [MediaAction.seekForward],
        playing: false,
        processingState: AudioProcessingState.ready);
    // Pause the audio.
    _audioPlayer.pause();
  }

  @override
  Future<void> onStop() async {
    _audioPlayer.stop();
    if (ayahIndex == surah?.ayahs.length) {
      await AudioServiceBackground.setState(
          controls: [replayControl],
          playing: false,
          processingState: AudioProcessingState.completed);
    } else {
      await AudioServiceBackground.setState(
          controls: [],
          playing: false,
          processingState: AudioProcessingState.completed);
      return super.onStop();
    }
  }

  @override
  Future<void> onPlay() async {
    setMediaItem();
    AudioServiceBackground.setState(
      controls: getPlayControllers(),
      playing: true,
      processingState: AudioProcessingState.ready,
      systemActions: [MediaAction.seekForward],
    );
    await _audioPlayer.play(ayahUrl);
    renewSurah = 0;
  }

  @override
  Future<void> onSkipToNext() async {
    playNext();
  }

  @override
  Future<void> onSkipToPrevious() async {
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
    _audioPlayer.onPlayerCompletion.listen((event) {
      if (prefs.getBool(Constants.ALLOW_REPEAT_AYA) ?? false) {
        if (playerCount < playCount) {
         // print(
              //"first play count is $playCount and playerCount is $playerCount");
          playerCount = playerCount + 1;
          this.onPlay();
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
    if (surah != null && ayahIndex < surah!.ayahs.length) {
      ayahUrl = "$baseUrl$sheikhId/${surah!.ayahs[ayahIndex].number}";
      this.onPlay();
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
    ayahUrl = "$baseUrl$sheikhId/${surah?.ayahs[ayahIndex].number}";
    this.onPlay();
  }

  void changePreviousSurahIndex() {
    if (surahNumber == 0) {
      surahNumber = 113;
    } else
      surahNumber--;
    ayahIndex = 0;
    renewSurah = 1;
    surah = model?.surahs[surahNumber];
    ayahUrl = "$baseUrl$sheikhId/${surah?.ayahs[ayahIndex].number}";
    this.onPlay();
  }

  void playPrevious() async {
    if (ayahIndex > 0) {
      ayahIndex--;
      ayahUrl = "$baseUrl$sheikhId/${surah?.ayahs[ayahIndex].number}";
      this.onPlay();
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
