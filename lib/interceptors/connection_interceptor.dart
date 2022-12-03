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
      throw Failure(null, Constants.NO_CONNECTION_EXCEPTION);
    }
    super.onRequest(options, handler);
  }
}
