import 'package:muslim_book/providers/top_provider.dart';
import 'package:muslim_book/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'quiz_scoreboard/quiz_scoreboard_screen_containert.dart';

class QuizScoreboard extends StatefulWidget {
  @override
  _QuizScoreboardState createState() => _QuizScoreboardState();
}

class _QuizScoreboardState extends State<QuizScoreboard> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<UserProvider, TopProvider>(
      create: (_) => TopProvider(null),
      update: (_, user, __) => TopProvider(user),
      child: ScreenTypeLayout(
        mobile: OrientationLayoutBuilder(
          portrait: (context) => QuizScoreboardScreenContainer(),
        ),
      ),
    );
  }
}
