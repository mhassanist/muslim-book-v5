import 'dart:async';

import 'package:base_app/exceptions/failure.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';

class ConnectionInterceptor extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      throw Failure(null, Constants.NO_CONNECTION_EXCEPTION);
    }
    return options;
  }
}
