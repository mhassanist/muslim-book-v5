import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'changePassword_view_mobile_portrait/changePassword_view_mobile_portrait.dart';

class ChangePasswordView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayoutBuilder(
        portrait: (context) => ChangePasswordPage(),
      ),
    );
  }
}

