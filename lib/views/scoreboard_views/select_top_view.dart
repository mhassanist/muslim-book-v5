import 'package:muslim_book/views/scoreboard_views/select_top_view/top_select_view_mobile_portrait.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SelectTopView extends StatefulWidget {
  @override
  _SelectTopViewState createState() => _SelectTopViewState();
}

class _SelectTopViewState extends State<SelectTopView> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayoutBuilder(
        portrait: (context) => TopSelectionPage(),
      ),
    );
  }
}
