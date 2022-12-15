import 'package:muslim_book/providers/top_provider.dart';
import 'package:muslim_book/providers/user_provider.dart';
import 'package:muslim_book/views/top_view/select_top_view/top_select_view_mobile_portrait.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'competition_top_view_mobile_portrait/competition_top_view_mobile_portrait.dart';

class CompetitionTopView extends StatefulWidget {
  @override
  _CompetitionTopViewState createState() => _CompetitionTopViewState();
}

class _CompetitionTopViewState extends State<CompetitionTopView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProxyProvider<UserProvider, TopProvider>(
      create: (_) => TopProvider(null),
      update: (_, user, __) => TopProvider(user),
      child:ScreenTypeLayout(
        mobile: OrientationLayoutBuilder(
          portrait: (context) => CompetitionTopPage(),
        ),
      ),
    );
  }
}
