import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppScaffoldTitleWidget extends StatelessWidget {
  const AppScaffoldTitleWidget({Key key,@required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.almarai(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 23),
    );
  }
}
