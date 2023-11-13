import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// DioExceptions
class DioExceptions implements Exception {
  /// fromDioError
  DioExceptions.fromDioError(DioError dioError) {
    switch (dioError.type) {
      case DioErrorType.sendTimeout:
        message = "timeout";
        break;
      case DioErrorType.receiveTimeout:
        message = "timeout";
        break;
      case DioErrorType.cancel:
        message = "request_cancelled";
        break;
      case DioErrorType.connectionTimeout:
        message = "timeout";
        break;
      case DioErrorType.badCertificate:
      // TODO: Handle this case.
        break;
      case DioErrorType.badResponse:
        if (kDebugMode) {
          print(
              "Received invalid status code: ${dioError.response?.statusCode}");
        }
        message = "unknown_error";
        break;
      case DioErrorType.connectionError:
        message = "connectionError";
        break;
      case DioErrorType.unknown:
        message = "unknown_error";
        break;
    }
  }

  /// message
  late String message;

  @override
  String toString() => message;
}
