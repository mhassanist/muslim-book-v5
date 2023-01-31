// import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:muslim_book/network_utils/api_service.dart';
import 'package:muslim_book/sebha_feature/online_sebha/models/tasabeeh_model.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:muslim_book/utils/locator.dart';

class OnlineSebhaProvider extends ChangeNotifier {
  bool _showCongratulations = false;
  int _currentIndex = 0;
  late TasbeehModel _currentTasbeeh = TasbeehModel(
      content: '',
      count: 0,
      counted: 0,
      editable: false,
      id: 0,
      totalCounted: 0,
      note: '');
  final CarouselController controller = CarouselController();
  bool _allowClickSound = locator<Prefs>().allowTasbeehClickSound;
  List<TasbeehModel> _tsabeehList = [];
  bool _mounted = true;

  OnlineSebhaProvider() {
    if (_tsabeehList.isEmpty) {
      uploadLastSebhaCount();
      getTsabeehList();
    }
  }

  void getTsabeehList() async {
    if (_mounted) {
      _tsabeehList = await locator<ApiService>().getTasbeehList();
      if (_tsabeehList.isNotEmpty) _currentTasbeeh = _tsabeehList[currentIndex];
      if (_mounted) notifyListeners();
    }
  }

  Future increaseOrSetTasbeehValue({int? count}) async {
    if (_allowClickSound) {
      AudioPlayer().play(AssetSource('audio/click.mp3'));
    }
    _currentTasbeeh.counted = count ?? _currentTasbeeh.counted + 1;
    _currentTasbeeh.totalCounted = count ?? _currentTasbeeh.totalCounted + 1;

    notifyListeners();
    await locator<Prefs>().setSebhaCount(locator<Prefs>().sebhaCount + 1);
    if (_currentTasbeeh.counted == _currentTasbeeh.count) {
      // controller.nextPage();
      // _audioCache.play('allah_make_you_from_heaven.wav');
      // await player
      //     .play(AssetSource('assets/audio/allah_make_you_from_heaven.wav'));
      // allahMakeYouFromHeavenAudioPlayer.resume();
      await AudioPlayer()
          .play(AssetSource('audio/allah_make_you_from_heaven.wav'));
      _currentTasbeeh.counted = 0;
      showCongratulations = true;
      await Future.delayed(Duration(seconds: 4));
      showCongratulations = false;
    }
  }

  bool get showCongratulations => _showCongratulations;

  set showCongratulations(bool value) {
    _showCongratulations = value;
    notifyListeners();
  }

  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    _currentIndex = value;
    _currentTasbeeh = _tsabeehList[value];
    notifyListeners();
  }

  TasbeehModel get currentTasbeeh => _currentTasbeeh;
  set currentTasbeeh(TasbeehModel value) {
    _currentTasbeeh = value;
    notifyListeners();
  }

  bool get allowClickSound => _allowClickSound;
  void setAllowClickSound() {
    _allowClickSound = !_allowClickSound;
    locator<Prefs>().setTasbeehClickSound(!_allowClickSound);
    notifyListeners();
  }

  List<TasbeehModel> get list => _tsabeehList;

  Future addNewTasbeeh(name, count) async {
    var res = await locator<ApiService>()
        .addNewTasbeeh({"count": count, "content": name});
    if (res) {
      var newList = await locator<ApiService>().getTasbeehList();
      _tsabeehList.add(newList.last);
      notifyListeners();
    }
  }

  Future uploadLastSebhaCount() async {
    if (_mounted) if (locator<Prefs>().sebhaCount > 0) {
      locator<ApiService>().updateSebhaCount().then((value) async {
        if (value) await locator<Prefs>().setSebhaCount(0);
      });
    }
  }

  @override
  void dispose() {
    _mounted = false;
    super.dispose();
  }
}
