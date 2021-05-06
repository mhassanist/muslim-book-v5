import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'myProfile_view_mobile_portrait/myProfile_view_mobile_portrait.dart';

class MyProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayoutBuilder(
        portrait: (context) => MyProfilePage(),
      ),
    );
  }
}
