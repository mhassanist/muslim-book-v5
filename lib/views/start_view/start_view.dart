import 'package:muslim_book/views/start_view/start_view_mobile_portrait/start_view_mobile_portrait.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class StartView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ScreenTypeLayout(
      mobile: OrientationLayoutBuilder(
        portrait: (context) => StartViewMobilePortraitView(),
      ),
    );
  }
}
