import 'package:base_app/utils/locator.dart';
import 'package:base_app/utils/prefs.dart';
import 'package:dio/dio.dart';

//singleton class to share the same dio object for the whole app
class DioUtil {
  static DioUtil _instance;
  static Dio _dio;

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
      validateStatus: (status) => status <= 500,
    );
    options.connectTimeout = 30 * 1000; //10 sec
    options.receiveTimeout = 30 * 1000; //20 sec
    options.baseUrl = "https://muslim-book.net/api/";

    options.headers = {
    "X-localization": "${locator<Prefs>().getLang()}",
      'Authorization':
          "Bearer YZsiAFPyX3O29xcyoflxArylNNRWfExs4fwnsVIgrYUg03TV4XoVYOq23FM3"
    };
    options.contentType = "application/json";

    return options;
  }

  //this just returns the language key
  static String handleDioError(DioError dioError) {
    String errorDescription = "";
    switch (dioError.type) {
      case DioErrorType.CANCEL:
        errorDescription = "request_cancelled";
        break;
      case DioErrorType.CONNECT_TIMEOUT:
        //Connection timeout with API server
        errorDescription = "timeout";
        break;
      case DioErrorType.DEFAULT:
        errorDescription = "checkout_internet";
        break;
      case DioErrorType.RECEIVE_TIMEOUT:
        errorDescription = "timeout";
        break;
      case DioErrorType.RESPONSE:
        print("Received invalid status code: ${dioError.response.statusCode}");
        errorDescription = "unknown_error";
        break;
      case DioErrorType.SEND_TIMEOUT:
        errorDescription = "timeout";
        break;
    }
    return errorDescription;
  }
}
