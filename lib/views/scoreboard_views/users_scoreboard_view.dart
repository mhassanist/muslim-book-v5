import 'package:muslim_book/views/scoreboard_views/select_top_view/top_users_scoreboards_screen.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class UsersScoreboardView extends StatefulWidget {
  @override
  _UsersScoreboardViewState createState() => _UsersScoreboardViewState();
}

class _UsersScoreboardViewState extends State<UsersScoreboardView> {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      mobile: OrientationLayoutBuilder(
        portrait: (context) => TopUserScorebardsScreen(),
      ),
    );
  }
}
