import 'package:muslim_book/providers/location_provider.dart';
import 'package:muslim_book/views/settings_view/settings_view_mobile_portrait/settings_view_mobile_portrait.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';


class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (c)=>LocationProvider(),
      child: ScreenTypeLayout(
        mobile: OrientationLayoutBuilder(
          portrait: (context) => const SettingsViewMobilePortrait(),
        ),
      ),
    );
  }
}
