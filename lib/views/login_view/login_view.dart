import 'package:muslim_book/views/login_view/login_view_mobile_portrait/login_view_mobile_portrait.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayoutBuilder(
        portrait: (context) => LoginViewMobilePortrait(),
      ),
    );
  }
}

