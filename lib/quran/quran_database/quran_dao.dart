import 'package:muslim_book/quran/models/quran_model.dart' as quranModel;
import 'package:muslim_book/quran/models/quran_model.dart' as model;
import 'package:muslim_book/quran/models/reciters_model.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class QuranDao {
  late Box _quranBox;

  quranModel.QuranModel? _quranModel;

  Map<dynamic, dynamic> _downloadedTransliterationAndTranslation = {};

  Map<dynamic, dynamic> get downloadedTransliterationAndTranslation =>
      _downloadedTransliterationAndTranslation;

  QuranTypeModel? _recitersModel;

  String get selectedTranslation => _userModel?.selectedTranslation ?? '';
  String get selectedTransliteration => _userModel?.selectedTransliteration ?? '';

  QuranTypeModel? _translationAndTransliterationModel;

  QuranTypeModel? get translationAndTransliterationModel =>
      _translationAndTransliterationModel;

  QuranTypeModel? get recitersModel => _recitersModel;

  quranModel.QuranUserModel? _userModel;

  quranModel.QuranUserModel? get quranUserModel => _userModel;

  String? get quranModelAsJson => _quranModel?.toJson() ?? null;
  Stream<quranModel.QuranUserModel>? _userModelStream;

  Stream<quranModel.QuranUserModel>? get quranUserModelStream =>
      _userModelStream;

  Future initHive() async {
    final dir = await getApplicationSupportDirectory();
    Hive.init(dir.path);
    Hive
      ..registerAdapter(
        model.QuranModelAdapter(),
      )
      ..registerAdapter(
        model.SurahAdapter(),
      )
      ..registerAdapter(
        model.AyahAdapter(),
      )
      ..registerAdapter(
        model.QuranUserModelAdapter(),
      )
      ..registerAdapter(
        QuranTypeModelAdapter(),
      )
      ..registerAdapter(
        QuranTypeDataAdapter(),
      );
    _quranBox = await Hive.openBox(Constants.QURAN_BOX);
  }

  Future<bool> isQuranAlreadyDownLoaded() async {
    await openQuranBox();
    await saveUserModelStream();
    if (_quranBox.containsKey(Constants.QURAN_DATABASE) &&
        _quranBox.containsKey(Constants.RECITERS_DATABASE)) {
      _recitersModel = await _quranBox.get(Constants.RECITERS_DATABASE);

      _downloadedTransliterationAndTranslation =
          _quranBox.get(Constants.DOWNLOADED_TRANSLATION_DATABASE);

      _translationAndTransliterationModel =
          await _quranBox.get(Constants.TRANSLATION_TRANSLITERATION_DATABASE);

      _quranModel = await _quranBox.get(Constants.QURAN_DATABASE);
      if (_quranModel != null &&
          _quranModel!.surahs.last.ayahs.last.number ==
              Constants.LAST_AYAH_NUMBER &&
          _recitersModel != null &&
          _translationAndTransliterationModel != null) {
        return true;
      }
    }
    return false;
  }

  Future openQuranBox() async {
    if (_quranBox == null) {
      _quranBox = await Hive.openBox(Constants.QURAN_BOX);
    }
  }

  Future saveUserModelStream() async {
    _userModel = await _quranBox.get(Constants.QURAN_USER_DATABASE);
    _userModelStream =
        _quranBox.watch(key: Constants.QURAN_USER_DATABASE).map((event) {
      return event.key == Constants.QURAN_USER_DATABASE ? event.value : null;
    });
  }

  List<QuranTypeData> get getAllReciters => _recitersModel?.data ?? [];

  List<QuranTypeData>? get getAllTranslations =>
      _translationAndTransliterationModel?.data
          .where((element) => element.type == "translation")
          .toList();

  List<QuranTypeData>? get getAllTransliterations =>
      _translationAndTransliterationModel?.data
          .where((element) => element.type == "transliteration")
          .toList();

  List<quranModel.Surah> get getAllSuras => _quranModel?.surahs ?? [];

  List<quranModel.Surah> get getEnglishTranslation => [];

  List<quranModel.Surah> get getEnglishTransliteration => [];

  Future<void> saveQuran(quranModel.QuranModel model) async {
    await _quranBox.put(Constants.QURAN_DATABASE, model);
    _quranModel = model;
  }

  void dispose() {
    _quranBox.close();
  }

  Future saveReciters(QuranTypeModel model) async {
    await _quranBox!.put(Constants.RECITERS_DATABASE, model);
    _recitersModel = model;
    await updateUserSelectedReciter(model.data[7]);
  }

  Future saveSelectedTranslation(String id) async {
    quranModel.QuranUserModel? model =
        await _quranBox!.get(Constants.QURAN_USER_DATABASE);
    if (model == null) {
      model = quranModel.QuranUserModel();
    }
    model.selectedTranslation = id;
    _userModel = model;
    await saveUserChanges(model);
  }

  Future saveSelectedTransliteration(String id) async {
    quranModel.QuranUserModel? model =
        await _quranBox!.get(Constants.QURAN_USER_DATABASE);
    if (model == null) {
      model = quranModel.QuranUserModel();
    }
    model.selectedTransliteration = id;
    _userModel = model;
    await saveUserChanges(model);
  }

  Future updateUserSelectedReciter(QuranTypeData reciter) async {
    quranModel.QuranUserModel? model =
        await _quranBox!.get(Constants.QURAN_USER_DATABASE);
    if (model == null) {
      model = quranModel.QuranUserModel();
    }
    model.selectedReciter = reciter;
    _userModel = model;
    await saveUserChanges(model);
  }

  Future addDownloadedTranslation(
      String key, quranModel.QuranModel value, bool isTranslation) async {
    Map<dynamic, dynamic> map =
        (await _quranBox!.get(Constants.DOWNLOADED_TRANSLATION_DATABASE)) ?? {};

    map["$key"] = value;
    await _quranBox!.put(Constants.DOWNLOADED_TRANSLATION_DATABASE, map);
    _downloadedTransliterationAndTranslation = map;
    if (isTranslation) {
      await saveSelectedTranslation(key);
    } else
      await saveSelectedTransliteration(key);
  }

  Future allowTranslation(bool value) async {
    quranModel.QuranUserModel model =
        (await _quranBox!.get(Constants.QURAN_USER_DATABASE))
            ?? quranModel.QuranUserModel();
    model.allowTranslation = value;
    _userModel = model;
    await saveUserChanges(model);
  }

  Future allowTransliteration(bool value) async {
    quranModel.QuranUserModel model =
        await _quranBox?.get(Constants.QURAN_USER_DATABASE);
    if (model == null) {
      model = quranModel.QuranUserModel();
    }
    model.allowTransliteration = value;
    _userModel = model;
    await saveUserChanges(model);
  }

  Future saveUserChanges(quranModel.QuranUserModel model) async {
    if (_quranBox.containsKey(Constants.QURAN_USER_DATABASE)) {
      await model.save();
    } else
      await _quranBox.put(Constants.QURAN_USER_DATABASE, model);
  }

  Future updateUserProgress(int surah, int ayah) async {
    quranModel.QuranUserModel model =
        await _quranBox.get(Constants.QURAN_USER_DATABASE);
    if (model == null) {
      model = quranModel.QuranUserModel();
    }
    model.lastReadSurahId = surah;
    model.lastReadAyahId = ayah;
    await saveUserChanges(model);
  }

  Future saveUserProgress(index, progress) async {
    if (_quranModel != null) {
      _quranModel!.surahs[index].progress = progress;
      await _quranModel!.save();
    }
  }

  Future saveTranslationAndTransliteration(QuranTypeModel model) async {
    await _quranBox.put(Constants.TRANSLATION_TRANSLITERATION_DATABASE, model);
    _translationAndTransliterationModel = model;
    await allowTranslation(false);
    await allowTransliteration(false);
  }
}
