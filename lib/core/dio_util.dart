import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_pretty_dio_logger/flutter_pretty_dio_logger.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';

//singleton class to share the same dio object for the whole app
class DioUtil {
  static DioUtil? _instance;

  static late Dio _dio;
  static Dio get dio => _dio;

  static DioUtil getInstance() {
    if (_instance == null) {
      _dio = Dio(_getOptions());
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
    return _instance!;
  }

  static void setDioAgain() {
    _dio = Dio(_getOptions());

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

  static BaseOptions _getOptions() {
    BaseOptions options = BaseOptions(
      followRedirects: false,
      validateStatus: (status) => status! <= 500,
    );
    options.connectTimeout = const Duration(seconds: 10); //10 sec
    options.receiveTimeout = const Duration(seconds: 20); //20 sec
    options.baseUrl = "https://muslim-book.net/api/";
    var token = locator<Prefs>().getToken();

    options.headers = {
      "X-localization": locator<Prefs>().getLang(),
      'Authorization':
      "Bearer ${token != null && token.isNotEmpty ? token : "YZsiAFPyX3O29xcyoflxArylNNRWfExs4fwnsVIgrYUg03TV4XoVYOq23FM3"}"
    };
    options.contentType = "application/json";
    return options;
  }

  //this just returns the language key
  static String handleDioError(DioError dioError) {
    String errorDescription = "";
    switch (dioError.type) {
      case DioErrorType.sendTimeout:
        errorDescription = "timeout";
        break;
      case DioErrorType.receiveTimeout:
        errorDescription = "timeout";
        break;
      case DioErrorType.cancel:
        errorDescription = "request_cancelled";
        break;
      case DioErrorType.connectionTimeout:
        errorDescription = "timeout";
        break;
      case DioErrorType.badCertificate:
      // TODO: Handle this case.
        break;
      case DioErrorType.badResponse:
        if (kDebugMode) {
          print("Received invalid status code: ${dioError.response?.statusCode}");
        }
        errorDescription = "unknown_error";
        break;
      case DioErrorType.connectionError:
        errorDescription = "connectionError";
        break;
      case DioErrorType.unknown:
        errorDescription = "unknown_error";
        break;
    }
    return errorDescription;
  }
}
