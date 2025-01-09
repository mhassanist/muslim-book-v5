import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'home_view_mobile_portrait/home_view_mobile_portrait.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout.builder(
      mobile: (BuildContext context) => OrientationLayoutBuilder(
        portrait: (context) => HomeViewMobilePortrait(),
      ),
    );
  }
}
