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
        title: Text("رتبة المسابقة الإسبوعية"),
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
