import 'package:audio_service/audio_service.dart';
import 'package:base_app/enams/view_state_enum.dart';
import 'package:base_app/network_utils/api_service.dart';
import 'package:base_app/providers/view_state_provider.dart';
import 'package:base_app/quran/api_service/quran_api_service.dart';
import 'package:base_app/quran/models/quran_model.dart' as model;
import 'package:base_app/quran/models/quran_model.dart';
import 'package:base_app/quran/models/reciters_model.dart';
import 'package:base_app/quran/quran_database/quran_dao.dart';
import 'package:base_app/quran/utils/quran_top_level_functions.dart';
import 'package:base_app/quran/widgets/downloading_translation_widget.dart';
import 'package:base_app/utils/locator.dart';
import 'package:base_app/utils/prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuranProvider extends ViewStateProvider {
  QuranProvider() {
    checkIsQuranDownloaded();
  }

  // String _errormessage = "";
  // String get errorMessage =>_errormessage;
  // set errorMessage(String s){
  //   _errormessage = s;
  //   notifyListeners();

  // }
  QuranDao _quranDao = locator<QuranDao>();
  bool _allowTranslation;
  bool _allowTransliteration;
  bool _allowRepeatAyah = locator<Prefs>().allowRepeatingAyah;

  bool get allowRepeatAyah => _allowRepeatAyah;

  set allowRepeatAyah(bool val) {
    _allowRepeatAyah = val;
    locator<Prefs>().setAllowRepeatingAyah(val);
    notifyListeners();
  }

  String get selectedTranslation => _quranDao.selectedTranslation;
  String get selectedTransliteration => _quranDao.selectedTransliteration;

  bool get allowTranslation => _allowTranslation;

  bool get allowTransliteration => _allowTransliteration;
  QuranTypeData _selectedReciter;

  String get selectedReciter => _selectedReciter.identifier;

  List<model.Surah> _allSuras;

  List<model.Surah> get allSuras => _allSuras;

  List<QuranTypeData> _allReciters;

  List<QuranTypeData> get allReciters => _allReciters;

  List<QuranTypeData> _allTranslation;

  List<QuranTypeData> get allTranslation => _allTranslation;

  Map<dynamic, dynamic> _downloadedTranslation;

  Map<dynamic, dynamic> get downloadedTranslation => _downloadedTranslation;

  List<QuranTypeData> _allTransliteration;

  List<QuranTypeData> get allTransliteration => _allTransliteration;

  List<model.Surah> _enSuras;

  List<model.Surah> get enSuras => _enSuras;

  List<model.Surah> _enTransliteration;

  List<model.Surah> get enTransliteration => _enTransliteration;

  Stream<QuranUserModel> get quranUserModelStream =>
      _quranDao.quranUserModelStream;

  QuranUserModel get quranUserModel => _quranDao.quranUserModel;

  Future changeUserProgress(int surah, int ayah) async {
    await _quranDao.updateUserProgress(surah, ayah);
  }

  void checkIsQuranDownloaded() async {
    setViewState(ViewState.Loading);
    if (!await _quranDao.isQuranAlreadyDownLoaded()) {
      var res = await QuranApiService().getWrittenQuran();
      if (res != null && res is model.QuranModel) {
        await _quranDao.saveQuran(res);
        saveData();
      } else{
        setViewState(ViewState.Idle);
        errorMessage = res.toString();
      }
    } else {
      saveData();
    }
    setViewState(ViewState.Idle);

  }

  void saveData() async {
    _allSuras = _quranDao.getAllSuras;

    _allReciters = _quranDao.getAllReciters;

    _enSuras = _quranDao.getEnglishTranslation;

    _enTransliteration = _quranDao.getEnglishTransliteration;

    _selectedReciter = _quranDao.quranUserModel?.selectedReciter;

    _allTranslation = _quranDao.getAllTranslations;

    _allTransliteration = _quranDao.getAllTransliterations;

    _allowTranslation = _quranDao.quranUserModel?.allowTranslation ?? false;

    _allowTransliteration =
        _quranDao.quranUserModel?.allowTransliteration ?? false;

    _downloadedTranslation =
        _quranDao.downloadedTransliterationAndTranslation ?? {};
    setViewState(ViewState.Idle);
  }

  @override
  void dispose() {
    _quranDao.dispose();
    super.dispose();
  }

  String getSurahName(id) {
    return _allSuras
        .singleWhere((element) => element.number == id)
        .name
        .replaceAll("سُورَةُ", "")
        .replaceAll("سورة", "");
  }

  Future saveSurahProgress(index, progress) async {
    await _quranDao.saveUserProgress(index, progress);
  }

  void startListeningToAyah({model.Ayah ayah, model.Surah surah}) async {
    if (AudioService.running) {
      await AudioService.stop();
      await Future.delayed(Duration(milliseconds: 400));
    }
    await AudioService.start(
      androidNotificationIcon: 'mipmap/launcher_icon',
      androidNotificationColor: 0XFF037e40,
      backgroundTaskEntrypoint: quranStartListeningPoint,
      params: {
        'sheikhId': "$selectedReciter",
        "ayahIndex": ayah.numberInSurah,
        "surah": surah.number,
        "quranModel": _quranDao.quranModelAsJson
      },
    );
  }

  Future updateReciter(String val) async {
    QuranTypeData reciter =
        allReciters.singleWhere((element) => element.identifier == val);
    await _quranDao.updateUserSelectedReciter(reciter);
    _selectedReciter = reciter;
    notifyListeners();
  }

  Future setAllowTranslation(bool val) async {
    await _quranDao.allowTranslation(val);
    _allowTranslation = val;
    notifyListeners();
  }

  Future setAllowTransliteration(bool val) async {
    await _quranDao.allowTransliteration(val);
    _allowTransliteration = val;
    notifyListeners();
  }

  Future downLoadTranslation(
      String s, BuildContext context, bool isTranslate) async {
    try {
      Get.dialog(DownloadingTranslationWidget(), barrierDismissible: false);
      var response = await QuranApiService()
          .downloadTranslationOrTransliteration(s, isTranslate);
      _downloadedTranslation =
          _quranDao.downloadedTransliterationAndTranslation ?? {};
      Navigator.pop(context);
      notifyListeners();
    } catch (e) {
      Navigator.pop(context);
      Get.snackbar("حدث حطأ", "هناك مشكلة في الإنترنت",
          borderRadius: 0,
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
          margin: EdgeInsets.zero);
    }
  }

  Future updateSelectedTranslation(String id) async {
    await locator<QuranDao>().saveSelectedTranslation(id);
    notifyListeners();
  }

  Future updateSelectedTransliteration(String id) async {
    await locator<QuranDao>().saveSelectedTransliteration(id);
    notifyListeners();
  }
}
