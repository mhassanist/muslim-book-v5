import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:base_app/network_utils/api_service.dart';
import 'package:base_app/providers/user_provider.dart';
import 'package:base_app/sebha_feature/offline_sebha/database/sebha_database.dart';
import 'package:base_app/utils/locator.dart';
import 'package:base_app/utils/prefs.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SebhaProvider extends ChangeNotifier {
  bool _showCongratulations = false;
  int _currentIndex = 0;
  Tasbeeh _currentTasbeeh;
  AudioCache _audioCache;
  final CarouselController controller = CarouselController();
  bool _allowClickSound = locator<Prefs>().allowTasbeehClickSound;
  List<Tasbeeh> _tsabeehList;

  SebhaProvider() {
    checkTasbeehHistory();
    setAudioCache();
  }
  void setAudioCache() {
    _audioCache = AudioCache(
        prefix: "audio/",
        fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
  }

  void getTsabeehList() async {
    _tsabeehList = await locator<SebhaDataBase>().allTsabeeh;
    if (_tsabeehList.isNotEmpty) currentTasbeeh = _tsabeehList[currentIndex];
  }

  Future increaseTasbeeh({int count}) async {
    if (_allowClickSound) _audioCache.play('click.mp3');
    await locator<SebhaDataBase>().updateTasbeeh(_currentTasbeeh.copyWith(
        counted: count ?? _currentTasbeeh.counted + 1));
    currentTasbeeh =
        await locator<SebhaDataBase>().getTasbeehById(_currentTasbeeh.id);

    if (_currentTasbeeh.counted == _currentTasbeeh.totalCounter) {
      _audioCache.play('allah_make_you_from_heaven.wav');

      // controller.nextPage();
      showCongratulations = true;
      await Future.delayed(Duration(seconds: 4));
      showCongratulations = false;
    }
  }

  void checkTasbeehHistory() async {
    String lastUpdate = locator<Prefs>().lastUpdatedTasbeehDate;
    String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

    if (lastUpdate != todayDate) {
      var value = await locator<SebhaDataBase>().allTsabeeh;
      value.forEach(
        (element) async {
          await locator<SebhaDataBase>()
              .updateTasbeeh(element.copyWith(counted: 0));
        },
      );
    }
    locator<Prefs>().setLastUpdatedTasbeehDate(todayDate);
    getTsabeehList();
  }

  bool get showCongratulations => _showCongratulations;

  set showCongratulations(bool value) {
    _showCongratulations = value;
    notifyListeners();
  }

  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    _currentIndex = value;

    getTsabeehList();
  }

  Tasbeeh get currentTasbeeh => _currentTasbeeh;
  set currentTasbeeh(Tasbeeh value) {
    _currentTasbeeh = value;
    notifyListeners();
  }

  bool get allowClickSound => _allowClickSound;
  void setAllowClickSound() {
    _allowClickSound = !_allowClickSound;
    locator<Prefs>().setTasbeehClickSound(!_allowClickSound);
    notifyListeners();
  }

  List<Tasbeeh> get list => _tsabeehList;
}
