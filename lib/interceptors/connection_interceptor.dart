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
      /// TODO: Fix crash
      /// https://console.firebase.google.com/project/muslim-book-ab937/crashlytics/app/android:com.muslim_book.muslim_book/issues/e6b833756f0374065790607b1cba6ccd?time=last-seven-days&types=crash&sessionEventKey=65F92918008800013804FC4A61B279E6_1926756546075250190
      throw Failure(null, Constants.NO_CONNECTION_EXCEPTION);
    }
    super.onRequest(options, handler);
  }
}
