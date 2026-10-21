import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart';
import 'package:get/get.dart';
import 'package:muslim_book/exceptions/failure.dart';
import 'package:muslim_book/interceptors/connection_interceptor.dart';
import 'package:muslim_book/interceptors/error_interceptor.dart';
import 'package:muslim_book/models/answer_model.dart' as answer;
import 'package:muslim_book/models/competitions_model.dart';
import 'package:muslim_book/models/countries_model.dart';
import 'package:muslim_book/models/facebook_model.dart';
import 'package:muslim_book/models/score_model.dart';
import 'package:muslim_book/models/top_model.dart';
import 'package:muslim_book/models/user_model.dart';
import 'package:muslim_book/providers/user_provider.dart';
import 'package:muslim_book/sebha_feature/models/sebha_top_model.dart';
import 'package:muslim_book/sebha_feature/online_sebha/models/tasabeeh_model.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final Dio _dio = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 30),
      baseUrl: Constants.BASE_URL,
      headers: {"X-localization": locator<Prefs>().getLang()}));
  late UserProvider _userProvider;

  set userProvider(UserProvider val) {
    _userProvider = val;
  }

  ApiService() {
    _dio.interceptors.add(ConnectionInterceptor());
    _dio.interceptors.add(ErrorInterceptor());
    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          queryParameters: true,
          requestBody: true,
          responseHeader: true,
          showProcessingTime: false,
          canShowLog: true,
        ),
      );
    }
  }

  /// Normalises anything thrown by a request into a [Failure] so callers can
  /// rely on getting either a model or a Failure back.
  Failure _toFailure(Object e) {
    if (e is Failure) return e;
    if (e is DioException && e.error is Failure) return e.error as Failure;
    return Failure(null, Constants.NO_CONNECTION_EXCEPTION);
  }

  Future login(Map<String, dynamic> body) async {
    try {
      var response = await _dio.post("users/login", data: body);
      if (response.data is! Failure) {
        return UserModel.fromMap(response.data["data"]);
      } else {
        return response.data;
      }
    } catch (e) {
      e.printInfo(info: 'ApiService login');
      return _toFailure(e);
    }
  }

  Future register(Map<String, dynamic> body) async {
    try {
      var response = await _dio.post("users/register", data: body);
      if (response.data is! Failure) {
        return UserModel.fromMap(response.data["data"]);
      } else {
        return response.data;
      }
    } catch (e) {
      e.printInfo(info: 'ApiService register');
      return _toFailure(e);
    }
  }

  Future googleLogin(map) async {
    try {
      var response = await _dio.post("users/google/login", data: map);
      if (response.data is! Failure) {
        UserModel model = UserModel.fromMap(response.data["data"]);
        return model;
      } else {
        return response.data;
      }
    } catch (e) {
      e.printInfo(info: 'ApiService google login');
      return _toFailure(e);
    }
  }

  Future getQuestions() async {
    try {
      var response = await _dio.get("questions/daily",
          options: Options(headers: {
            "Authorization": "Bearer ${_userProvider.user.apiToken}"
          }));
      if (response.data is! Failure) {
        QuestionsModel model = QuestionsModel.fromMap(response.data);
        return model;
      } else {
        return response.data;
      }
    } catch (e) {
      e.printInfo(info: 'ApiService getQuestions');
    }
  }

  Future postAnswer(Map<String, dynamic> map) async {
    // var res = await _dio.post(
    //   "answers",
    //   data: map,
    //   options: Options(
    // headers: {
    //   "Authorization": "Bearer ${_userProvider.user.apiToken}",
    //   "Content-Type": "application/x-www-form-urlencoded"
    // },
    //   ),
    // );
    try {
      var resource = await http.post(
        // Uri.https('${Constants.BASE_URL}answers'),
        Uri.https(Constants.BASE_API_URL, '${Constants.BASE_API_PATH}answers'),
        body: map,
        headers: {
          "Authorization": "Bearer ${_userProvider.user.apiToken}",
          "Content-Type": "application/x-www-form-urlencoded"
        },
      );
      var res = json.decode(resource.body);
      //print(res);
      // if (map["additional"] == "force" && !(res.data is Failure)) {
      if (map["additional"] == "force" && res['success']) {
        return answer.AnswerModel.fromMap(res).data;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future faceBookLogging(map) async {
    try {
      var response = await _dio.post("users/facebook/login", data: map);
      if (response.data is! Failure) {
        UserModel model = UserModel.fromMap(response.data["data"]);
        return model;
      } else {
        return response.data;
      }
    } catch (e) {
      e.printInfo(info: 'ApiService faceBookLogging');
      return _toFailure(e);
    }
  }

  Future<TopModel?> getTop() async {
    try {
      var response = await _dio.get("users/top/11",
          options: Options(headers: {
            "Authorization": 'Bearer ${_userProvider.user.apiToken}',
          }));
      //print(response.data);
      if (response.data is! Failure) {
        TopModel model = TopModel.fromMap(response.data);
        return model;
      } else {
        return null;
      }
    } catch (e) {
      e.printInfo(info: 'ApiService getTop');
      return null;
    }
  }

  Future<TopModel?> getTasbeehTop() async {
    try {
      var response = await _dio.get("reminds/top/11",
          options: Options(headers: {
            "Authorization": 'Bearer ${_userProvider.user.apiToken}',
          }));
      //print(response.data);
      if (response.data is! Failure) {
        TopModel model = TopModel.fromMap(response.data);
        return model;
      } else {
        return null;
      }
    } catch (e) {
      e.printInfo(info: 'ApiService getTasbeehTop');
      return null;
    }
  }

  Future<ScoreModel?> getUserScore() async {
    try {
      var response = await _dio.get(
        "users/score/${_userProvider.user.id}",
        options: Options(
          headers: {"Authorization": 'Bearer ${_userProvider.user.apiToken}'},
        ),
      );
      if (response.data is! Failure) {
        ScoreModel model = ScoreModel.fromMap(response.data);
        return model;
      } else {
        return null;
      }
    } on DioError catch (e) {
      // errormessage = DioExceptions.fromDioError(e).message;
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<FacebookModel?> faceBookAccountDetails(token) async {
    try {
      // var response = await http.get(Uri.https(
      //     'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=$token'));
      var response = await http.get(
        Uri.https('graph.facebook.com', '/v16.0/me', {
          "fields": "name,first_name,last_name,email,picture",
          "access_token": "$token"
        }),
      );
      FacebookModel model = FacebookModel.fromJson(response.body);
      // final graphResponse = await http.get(Uri.https(
      //   'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${token}',
      // ));
      final graphResponse = await http.get(
        Uri.https('graph.facebook.com', '/v16.0/me', {
          "fields":
          "name,picture.width(800).height(800),first_name,last_name,email",
          "access_token": "$token"
        }),
      );

      Map ddddv = json.decode(graphResponse.body);
      //print(graphResponse.body);
      //print("--------------");
      //print(response.body);
      model.image = ddddv['picture']['data']['url'];
      //print(ddddv['picture']['data']['url']);
      //print("--------------");
      //print(model.image);
      return model;
    } catch (e) {
      e.printInfo(info: 'ApiService FacebookModel');
      return null;
    }
  }

  Future getCountries(String code) async {
    try {
      http.Response response = await http.get(
        // Uri.https('${Constants.BASE_URL}countries/list'),
        Uri.https(Constants.BASE_API_URL, '${Constants.BASE_API_PATH}countries/list'),
        headers: {"X-localization": code},
      );
      if (response.statusCode == 200) {
        CountriesModel model =
        CountriesModel.fromJson(utf8.decode(response.bodyBytes));
        return model;
      }
    } catch (ex) {
      return null;
    }
  }

  Future editProfile(Map<String, dynamic> body) async {
    try {
      var response = await _dio.patch("users/${_userProvider.user.id}",
          data: body,
          options: Options(headers: {
            "Authorization": 'Bearer ${_userProvider.user.apiToken}',
          }));
      if (response.data is! Failure) {
        UserModel model = UserModel.fromMap(response.data["data"]);
        return model;
      } else {
        return response.data;
      }
    } catch (e) {
      e.printInfo(info: 'ApiService editProfile');
      return _toFailure(e);
    }
  }

  Future<bool> updateSebhaCount() async {
    try {
      await _dio.post(
        "reminds/pulse",
        data: {"total": "${locator<Prefs>().sebhaCount}"},
        options: Options(
          headers: {
            "Authorization": 'Bearer ${_userProvider.user.apiToken}',
          },
        ),
      );
      return true;
    } catch (e) {
      e.printInfo(info: 'ApiService updateSebhaCount => arrived to updateUserCount $e');
      return false;
    }
  }

  Future<List<TasbeehModel>> getTasbeehList() async {
    try {
      var res = await _dio.get(
        "reminds",
        options: Options(
          headers: {
            "Authorization": 'Bearer ${_userProvider.user.apiToken}',
          },
        ),
      );
      TasabeehModel model = TasabeehModel.fromMap(res.data);
      return model.tasbeehList;
    } catch (e) {
      e.printInfo(info: 'ApiService getTasbeehList => $e');
      return [];
    }
  }

  Future addNewTasbeeh(Map<String, String> map) async {
    try {
      await _dio.post("reminds",
          data: map,
          options: Options(headers: {
            "Authorization": 'Bearer ${_userProvider.user.apiToken}',
          }));
      return true;
    } catch (e) {
      e.printInfo(info: 'ApiService addNewTasbeeh');
    }
    return false;
  }

  Future<List<SebhaTopModelData>> getTopSebha() async {
    try {
      var res = await _dio.get("reminds/top/10",
          options: Options(headers: {
            "Authorization": 'Bearer ${_userProvider.user.apiToken}',
          }));

      List<SebhaTopModelData> model = SebhaTopModel.fromMap(res.data).list;
      return model;
    } catch (e) {
      e.printInfo(info: 'ApiService getTopSebha');
      return [];
    }
  }

  Future<SebhaTopModelData> getSebhaProfile() async {
    try {
      var res = await _dio.get(
        "reminds/me",
        options: Options(
          headers: {
            "Authorization": 'Bearer ${_userProvider.user.apiToken}',
          },
        ),
      );
      SebhaTopModelData model = SebhaTopModelData.fromMap(res.data["data"]);
      return model;
    } catch (e) {
      e.printInfo(info: 'ApiService getSebhaProfile');
      return SebhaTopModelData();
    }
  }
}
