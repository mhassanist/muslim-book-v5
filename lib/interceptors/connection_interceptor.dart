import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:muslim_book/exceptions/failure.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:dio/dio.dart';

class ConnectionInterceptor extends InterceptorsWrapper {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // Reject instead of throwing: a throw from this async callback escaped
      // as an uncaught error and crashed the app
      handler.reject(DioException(
        requestOptions: options,
        type: DioExceptionType.connectionError,
        error: Failure(null, Constants.NO_CONNECTION_EXCEPTION),
      ));
      return;
    }
    super.onRequest(options, handler);
  }
}
