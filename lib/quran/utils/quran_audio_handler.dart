import 'dart:async';
import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:muslim_book/quran/models/quran_model.dart';
import 'package:muslim_book/quran/utils/quran_top_level_functions.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuranAudioHandler extends BaseAudioHandler {
  late SharedPreferences prefs;

  late final AudioHandler audioHandler;
  final player = AudioPlayer();
  final String baseUrl = "https://cdn.alquran.cloud/media/audio/ayah/";
  String ayahUrl = '';
  int surahNumber = 0;
  int ayahIndex = 0;
  int renewSurah = 0;
  int playCount = 0;
  int playerCount = 0;

  QuranModel? model;
  Surah? surah;
  String sheikhId = '';

  static final QuranAudioHandler _quranAudioHandler =
      QuranAudioHandler._internal();

  factory QuranAudioHandler() {
    return _quranAudioHandler;
  }

  QuranAudioHandler._internal();

  initialize() async {
    audioHandler = await AudioService.init(
        config: AudioServiceConfig(
          androidNotificationChannelId: 'com.muslim_book.muslim_book',
          androidNotificationChannelName: 'مسلم بوك',
          notificationColor: Color(0XFF037e40),
        ),
        builder: () => QuranAudioHandler());
    onCompleteListener();
  }

  void startListening({required Map<String, dynamic> params}) async {
    playbackState.add(playbackState.value.copyWith(
        systemActions: {MediaAction.seekForward},
        controls: getPlayControllers(),
        playing: true,
        processingState: AudioProcessingState.loading));
    prefs = await SharedPreferences.getInstance();
    playCount = prefs.getInt(Constants.REPEAT_AYAh_COUNT) ?? 3;
    playerCount = 1;
    setParameters(params);
    ayahUrl = "$baseUrl$sheikhId/${surah?.ayahs[ayahIndex].number}";
    await play();
  }

  @override
  Future<void> play() async {
    setMediaItem();
    await player.play(UrlSource(ayahUrl));
    playbackState.add(playbackState.value.copyWith(
      systemActions: {MediaAction.seekForward},
      controls: getPlayControllers(),
      playing: true,
      processingState: AudioProcessingState.ready,
    ));
    renewSurah = 0;
  }

  void setMediaItem() {
    mediaItem.add(
      MediaItem(
        extras: {"surahIndex": surahNumber, "renewSurah": renewSurah},
        id: "$ayahIndex",
        album: "${surah?.englishName}",
        title: "${surah?.name}",
      ),
    );
  }

  @override
  Future<void> pause() async {
    playbackState.add(playbackState.value.copyWith(
        controls: getPauseControllers(),
        systemActions: {MediaAction.seekForward},
        playing: false,
        processingState: AudioProcessingState.ready));

    player.pause();
  }

  @override
  Future<void> stop() async {
    player.release();
    if (ayahIndex == surah?.ayahs.length) {
      playbackState.add(playbackState.value.copyWith(
          controls: [replayControl],
          playing: false,
          processingState: AudioProcessingState.completed));
    } else {
      playbackState.add(playbackState.value.copyWith(
          controls: [],
          playing: false,
          processingState: AudioProcessingState.completed));
      return super.stop();
    }
  }

  @override
  Future<void> skipToNext() async {
    playNext();
  }

  @override
  Future<void> skipToPrevious() async {
    playPrevious();
  }

  void setParameters(Map<String, dynamic> params) {
    surahNumber = params["surah"] - 1;
    ayahIndex = params["ayahIndex"] - 1;
    sheikhId = params["sheikhId"];
    if (model == null) model = QuranModel.fromJson(params["quranModel"]);
    surah = model?.surahs[surahNumber];
  }

  void onCompleteListener() {
    player.onPlayerComplete.listen((event) {
      if (prefs.getBool(Constants.ALLOW_REPEAT_AYA) ?? false) {
        if (playerCount < playCount) {
          playerCount = playerCount + 1;
          this.play();
        } else {
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
      this.play();
    } else {
      changeNextSurahIndex();
    }
  }

  void changeNextSurahIndex() {
    renewSurah = 1;
    if (surahNumber == 113) {
      surahNumber = 0;
    } else {
      surahNumber++;
    }
    ayahIndex = 0;
    surah = model?.surahs[surahNumber];
    ayahUrl = "$baseUrl$sheikhId/${surah?.ayahs[ayahIndex].number}";
    this.play();
  }

  void changePreviousSurahIndex() {
    if (surahNumber == 0) {
      surahNumber = 113;
    } else {
      surahNumber--;
    }
    ayahIndex = 0;
    renewSurah = 1;
    surah = model?.surahs[surahNumber];
    ayahUrl = "$baseUrl$sheikhId/${surah?.ayahs[ayahIndex].number}";
    this.play();
  }

  void playPrevious() async {
    if (ayahIndex > 0) {
      ayahIndex--;
      ayahUrl = "$baseUrl$sheikhId/${surah?.ayahs[ayahIndex].number}";
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
