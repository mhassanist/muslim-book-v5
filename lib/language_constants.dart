import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String LAGUAGE_CODE = 'languageCode';

//languages code
// const String ENGLISH = 'en';
// const String FARSI = 'fa';
// const String ARABIC = 'ar';
// const String HINDI = 'hi';
Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LAGUAGE_CODE, languageCode);
  return Locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LAGUAGE_CODE) ?? "en";
  return Locale(languageCode);
}

TextDirection setTextDirection(Locale lang) {
  return lang.languageCode == "ar" ? TextDirection.rtl : TextDirection.ltr;
}

// Locale _locale(String languageCode) {
//   switch (languageCode) {
//     case ENGLISH:
//       return Locale(ENGLISH, 'US');
//     case FARSI:
//       return Locale(FARSI, "IR");
//     case ARABIC:
//       return Locale(ARABIC, "SA");
//     case HINDI:
//       return Locale(HINDI, "IN");
//     default:
//       return Locale(ENGLISH, 'US');
//   }
// }

String tr(BuildContext context, String key) {
  return AppLocalizations.of(context).translate(key);
}
