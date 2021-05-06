import 'dart:async';

import 'package:base_app/exceptions/failure.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:dio/dio.dart';

class ErrorInterceptor extends InterceptorsWrapper {
  @override
  Future onError(DioError err) {
    print("error is ${err.error}");
    if (err.response == null) {
      throw Failure(err.toString(), Constants.NO_CONNECTION_EXCEPTION);
    }
    var res = err.response.data;
    throw Failure(
        res["errors"].toString().replaceAll("[", "").replaceAll("]", ""),
        err.response.statusCode);
  }
}
