import 'dart:convert';
import 'package:base_app/models/answer_model.dart' as answer;
import 'package:base_app/models/azan_sound.dart';
import 'package:base_app/models/countries_model.dart';
import 'package:base_app/models/score_model.dart';
import 'package:base_app/models/top_model.dart';
import 'package:base_app/sebha_feature/models/sebha_top_model.dart';
import 'package:base_app/sebha_feature/online_sebha/models/tasabeeh_model.dart';
import 'package:http/http.dart' as http;
import 'package:base_app/exceptions/failure.dart';
import 'package:base_app/interceptors/connection_interceptor.dart';
import 'package:base_app/interceptors/error_interceptor.dart';
import 'package:base_app/models/competitions_model.dart';
import 'package:base_app/models/facebook_model.dart';
import 'package:base_app/models/user_model.dart';
import 'package:base_app/providers/user_provider.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/locator.dart';
import 'package:base_app/utils/prefs.dart';
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