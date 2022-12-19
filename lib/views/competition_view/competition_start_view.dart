import 'package:muslim_book/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quiver/async.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:muslim_book/utils/sizing_info_extension.dart';

class CompetitionStartView extends StatefulWidget {
  CompetitionStartView({super.key});

  @override
  _CompetitionStartViewState createState() => _CompetitionStartViewState();
}

class _CompetitionStartViewState extends State<CompetitionStartView> {
  int secondsCounter = 5;
  @override
  void initState() {
    super.initState();
    CountdownTimer(Duration(seconds: 5), Duration(seconds: 1)).listen((data) {})
      ..onData((data) {
        setState(() {
          secondsCounter--;
        });
      })
      ..onDone(() {
        goToStart();
      });
  }

  void goToStart() {
    Navigator.pushReplacementNamed(context, "/start_view");
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, SizingInformation sizeConfig) {
      return Scaffold(
        backgroundColor: const Color(0XFF2E6E49),
        body: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Container(
                  margin: EdgeInsets.only(
                      top: sizeConfig.blockSizeVertical * 2,
                      right: sizeConfig.blockSizeVertical * 2,
                      left: sizeConfig.blockSizeVertical * 2),
                  width: sizeConfig.blockSizeHorizontal * 10,
                  height: sizeConfig.blockSizeHorizontal * 10,
                  child: FloatingActionButton(
                      backgroundColor: const Color(0XFF588B6D),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: sizeConfig.blockSizeHorizontal * 7,
                      ),
                      onPressed: () {
                        goToStart();
                      }),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: sizeConfig.blockSizeVertical * 2),
                child: Text(
                  "جاهز للتحدي ؟",
                  style: TextStyle(
                      color: const Color(0XFFFFAA3F),
                      fontSize: sizeConfig.blockSizeHorizontal * 8),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: sizeConfig.blockSizeVertical * 2,
                    bottom: sizeConfig.blockSizeVertical * 5),
                child: Text(
                  "من الممكن أن يكون لديك أسئلة جديدة ؟",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: sizeConfig.blockSizeHorizontal * 6),
                ),
              ),
              Expanded(
                  child: Image.asset(
                "assets/images/competition_view/drum_pic.png",
                fit: BoxFit.fill,
                width: double.infinity,
              )),
              Container(
                margin:
                    EdgeInsets.only(bottom: sizeConfig.blockSizeVertical * 4),
                child: RawMaterialButton(
                  onPressed: () {
                    Provider.of<UserProvider>(context, listen: false)
                        .selectedPage = 3;
                    goToStart();
                  },
                  padding: EdgeInsets.symmetric(
                      horizontal: sizeConfig.blockSizeHorizontal * 25,
                      vertical: sizeConfig.blockSizeVertical * 2),
                  shape: StadiumBorder(),
                  fillColor: Colors.white,
                  child: Text(
                    "إبدأ الآن",
                    style: TextStyle(
                        color: const Color(0XFF2E6E49),
                        fontSize: sizeConfig.blockSizeHorizontal * 5),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
