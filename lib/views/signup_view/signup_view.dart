import 'package:base_app/views/signup_view/signup_view_mobile_portrait/signup_view_mobile_portrait.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignupView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayoutBuilder(
        portrait: (context) => SignupViewMobilePortrait(),
      ),
    );
  }
}

