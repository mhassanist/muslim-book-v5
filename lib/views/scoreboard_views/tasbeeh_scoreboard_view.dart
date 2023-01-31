import 'package:muslim_book/providers/tasbeeh_top_provider.dart';
import 'package:muslim_book/providers/user_provider.dart';
import 'package:muslim_book/views/scoreboard_views/tabspeeh_scoreboard/tasbeeh_scoreboard_screen_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

class TasbeehScoreboardView extends StatefulWidget {
  @override
  _TasbeehScoreboardViewState createState() => _TasbeehScoreboardViewState();
}

class _TasbeehScoreboardViewState extends State<TasbeehScoreboardView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<UserProvider, TasbeehTopProvider>(
      create: (_) => TasbeehTopProvider(null),
      update: (_, user, __) => TasbeehTopProvider(user),
      child: ScreenTypeLayout(
        mobile: OrientationLayoutBuilder(
          portrait: (context) => TasbeehScoreboardScreenContainer(),
        ),
      ),
    );
  }
}
