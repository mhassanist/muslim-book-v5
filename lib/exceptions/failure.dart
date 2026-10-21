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
    if (_message == null) {
      switch (statusCode) {
        case Constants.NO_CONNECTION_EXCEPTION:
          return locator<Prefs>().getLang() == Constants.EN
              ? _noConnectionException()["en"] as String
              : _noConnectionException()["ar"] as String;
      }
    }
    return _message!;
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

  @override
  String toString() {
    return message;
  }
}
