import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/NetworkServices.dart';

TextTheme? almaraiTextTheme;
TextStyle? almaraiTextStyle;

Future<void> initGoogleFontsTextStyles() async {
  if (await NetworkController.checkInternet()) {
    almaraiTextTheme = GoogleFonts.almaraiTextTheme();

    almaraiTextStyle = GoogleFonts.almarai(
      color: Constants.PRIMARY_DARK_COLOR,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    );
  }
}