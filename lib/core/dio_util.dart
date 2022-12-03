import 'package:dio/dio.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';

//singleton class to share the same dio object for the whole app
class DioUtil {
  static late DioUtil _instance;
  static late Dio _dio;

  static DioUtil getInstance() {
    if (_instance == null) {
      _dio = Dio(_getOptions());
    }
    return _instance;
  }

  static Dio get dio => _dio;

  static void setDioAgain() {
    _dio = Dio(_getOptions());
  }

  static BaseOptions _getOptions() {
    BaseOptions options = BaseOptions(
      followRedirects: false,
      validateStatus: (status) => status! <= 500,
    );
    options.connectTimeout = 30 * 1000; //10 sec
    options.receiveTimeout = 30 * 1000; //20 sec
    options.baseUrl = "https://muslim-book.net/api/";
    var token = locator<Prefs>().getToken();

    options.headers = {
      "X-localization": "${locator<Prefs>().getLang()}",
      'Authorization':
          "Bearer ${token != null && token.isNotEmpty ? token : "YZsiAFPyX3O29xcyoflxArylNNRWfExs4fwnsVIgrYUg03TV4XoVYOq23FM3"}"
    };
    options.contentType = "application/json";
    //print("shiammmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmma_ttttttttttt");
    //print(options.headers);

    return options;
  }

  //this just returns the language key
  static String handleDioError(DioError dioError) {
    String errorDescription = "";
    switch (dioError.type) {
      case DioErrorType.connectTimeout:
      //Connection timeout with API server
        errorDescription = "timeout";
        break;
      case DioErrorType.sendTimeout:
        errorDescription = "timeout";
        break;
      case DioErrorType.receiveTimeout:
        errorDescription = "timeout";
        break;
      case DioErrorType.response:
        print("Received invalid status code: ${dioError.response?.statusCode}");
        errorDescription = "unknown_error";
        break;
      case DioErrorType.cancel:
        errorDescription = "request_cancelled";
        break;
      case DioErrorType.other:
        errorDescription = "checkout_internet";
        break;
    }
    return errorDescription;
  }
}
