import 'package:muslim_book/exceptions/failure.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:dio/dio.dart';

class ErrorInterceptor extends InterceptorsWrapper {
  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print("error is ${err.error}");
    // Pass the Failure along via the handler instead of throwing, so the
    // caller's catch block receives it (as DioException.error)
    if (err.response == null) {
      // No raw Dio text: Failure falls back to its localized message
      handler.next(err.copyWith(
          error: Failure(null, Constants.NO_CONNECTION_EXCEPTION)));
      return;
    }
    var res = err.response!.data;
    handler.next(err.copyWith(
        error: Failure(
            res is Map
                ? res["errors"].toString().replaceAll("[", "").replaceAll("]", "")
                : null,
            err.response!.statusCode!)));
  }
}
