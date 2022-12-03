import 'package:muslim_book/exceptions/failure.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:dio/dio.dart';

class ErrorInterceptor extends InterceptorsWrapper {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print("error is ${err.error}");
    if (err.response == null) {
      throw Failure(err.toString(), Constants.NO_CONNECTION_EXCEPTION);
    }
    var res = err.response!.data;
    throw Failure(
        res["errors"].toString().replaceAll("[", "").replaceAll("]", ""),
        err.response!.statusCode!);
  }
}
