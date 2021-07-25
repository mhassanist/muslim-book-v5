import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';

class CompetitionTopView extends StatefulWidget {
  CompetitionTopView({Key key}) : super(key: key);

  @override
  _CompetitionTopViewState createState() => _CompetitionTopViewState();
}

class _CompetitionTopViewState extends State<CompetitionTopView> {
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
        title: Text(AppLocalizations.of(context).translate("rank_weekly")),
        centerTitle: true,
        backGroundColor: const Color(0XFFF1F6F3),
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Row(
                children: [
                  
                ],
              ),
            ],
          ),
        ));
  }
}
