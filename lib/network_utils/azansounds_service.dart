import 'package:muslim_book/models/azan_sound.dart';
// import 'package:muslim_book/sebha_feature/models/sebha_top_model.dart';
// import 'package:muslim_book/sebha_feature/online_sebha/models/tasabeeh_model.dart';
import 'package:muslim_book/exceptions/failure.dart';
import 'package:muslim_book/interceptors/connection_interceptor.dart';
import 'package:muslim_book/interceptors/error_interceptor.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:dio/dio.dart';

class AzanSoundsAPI {
  final Dio _dio = Dio(BaseOptions(
      connectTimeout: 1000 * 30,
      baseUrl: Constants.BASE_URL,
      headers: {"X-localization": "${locator<Prefs>().getLang()}",
      "Authorization":"Bearer YZsiAFPyX3O29xcyoflxArylNNRWfExs4fwnsVIgrYUg03TV4XoVYOq23FM3"}));

  AzanSoundsAPI() {
    _dio.interceptors.add(ConnectionInterceptor());
    _dio.interceptors.add(ErrorInterceptor());
  }

  Future requestAzanSounds() async {
    var response = await _dio.get("azan/list");
    if (!(response.data is Failure)) {
      List<AzanSound> models =  AzanSoundsList().fromJson(response.data["data"]);
      return models;
    } else {
      return response.data;
    }
  }

}