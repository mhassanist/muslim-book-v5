import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';

class Failure {
  int statusCode;
  String? _message;

  Failure(this._message, this.statusCode) {
    _getMessage();
  }

  set message(String s) {
    _message = s;
  }

  String get message {
    if (_message != null) return _message!;
    final messages = statusCode == Constants.NO_CONNECTION_EXCEPTION
        ? _noConnectionException()
        : _unknownError();
    return locator<Prefs>().getLang() == Constants.EN
        ? messages["en"]!
        : messages["ar"]!;
  }

  void _getMessage() {
    if (_message != null) {
      switch (statusCode) {
        case Constants.NO_CONNECTION_EXCEPTION:
          _noConnectionException();
          break;
      }
    }
  }

  Map<String, String> _noConnectionException() {
    return {
      "en": "Could not reach the server. Check your internet connection",
      "ar": "تعذر الاتصال بالخادم، تحقق من اتصالك بالإنترنت",
    };
  }

  Map<String, String> _unknownError() {
    return {
      "en": "Something went wrong. Please try again",
      "ar": "حدث خطأ، يرجى المحاولة مرة أخرى",
    };
  }

  @override
  String toString() {
    return message;
  }
}
