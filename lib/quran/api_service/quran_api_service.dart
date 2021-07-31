import 'package:base_app/quran/models/reciters_model.dart';
import 'package:dio/dio.dart';
import 'package:base_app/quran/models/quran_model.dart';
import 'package:base_app/quran/quran_database/quran_dao.dart';
import 'package:base_app/utils/locator.dart';

class QuranApiService {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: 1000 * 30,
    baseUrl: "https://api.alquran.cloud/v1/",
  ));

  Future getWrittenQuran() async {
    try {
      await getReciters();
      await getTranslationAndTransliteration();
      await downloadTranslationOrTransliteration("en.ahmedali", true);
      await downloadTranslationOrTransliteration("en.transliteration", false);
      var res = await _dio.get("quran/quran-uthmani");
//    await getEnglishTransliteration();
      QuranModel model = QuranModel.fromMap(res.data["data"]);
      return model;
    } catch (e) {
       return e;
    }
  }

  Future<void> getReciters() async {
    var res = await _dio.get("edition?format=audio&type=versebyverse");
    QuranTypeModel model = QuranTypeModel.fromMap(res.data);
    await locator<QuranDao>().saveReciters(model);
  }

  Future<void> getTranslationAndTransliteration() async {
    var res = await _dio.get("edition?format=text");
    QuranTypeModel model = QuranTypeModel.fromMap(res.data);
    await locator<QuranDao>().saveTranslationAndTransliteration(model);
  }

  Future downloadTranslationOrTransliteration(String id, bool val) async {
    var res = await _dio.get("quran/$id");
    QuranModel model = QuranModel.fromMap(res.data["data"]);
    await locator<QuranDao>().addDownloadedTranslation(id, model, val);
  }
}
