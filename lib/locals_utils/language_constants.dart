import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String LANGUAGE_CODE = 'languageCode';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  _prefs.setString(LANGUAGE_CODE, languageCode);
  return Locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LANGUAGE_CODE) ?? "ar";
  return Locale(languageCode);
}

TextDirection setTextDirection(Locale lang) {
  return lang.languageCode == "ar" ? TextDirection.rtl : TextDirection.ltr;
}

String tr(BuildContext context, String key) {
  return AppLocalizations.of(context)!.translate(key);
}
