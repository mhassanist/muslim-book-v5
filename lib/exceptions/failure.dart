import 'package:base_app/utils/locator.dart';
import 'package:base_app/utils/prefs.dart';

import '../utils/Constants.dart';

class Failure {
  int statusCode;
  String _message;

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
              ? _noConnectionException()["en"]
              : _noConnectionException()["ar"];
          break;
      }
    }
    return _message;
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
    return {"en": "There Is No Connection", "ar": "لا يود إنترنت"};
  }

  @override
  String toString() {
    return message;
  }
}
