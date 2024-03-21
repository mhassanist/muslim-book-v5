import 'package:flutter/material.dart';
import 'package:muslim_book/text_styles.dart';

class AppScaffoldTitleWidget extends StatelessWidget {
  const AppScaffoldTitleWidget({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: almaraiTextStyle?.copyWith(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 23,
      ),
    );
  }
}
