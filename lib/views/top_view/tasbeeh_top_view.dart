import 'package:base_app/providers/tasbeeh_top_provider.dart';
import 'package:base_app/providers/top_provider.dart';
import 'package:base_app/providers/user_provider.dart';
import 'package:base_app/views/top_view/tabspeeh_top_view_mobile_portrait/tasbeeh_top_view_mobile_portrait.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class TasbeehTopView extends StatefulWidget {
  @override
  _TasbeehTopViewState createState() => _TasbeehTopViewState();
}

class _TasbeehTopViewState extends State<TasbeehTopView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<UserProvider, TasbeehTopProvider>(
      create: (_) => TasbeehTopProvider(null),
      update: (_, user, __) => TasbeehTopProvider(user),
      child:ScreenTypeLayout(
        mobile: OrientationLayoutBuilder(
          portrait: (context) => TasbeehTopPage(),
        ),
      ),
    );
  }
}
