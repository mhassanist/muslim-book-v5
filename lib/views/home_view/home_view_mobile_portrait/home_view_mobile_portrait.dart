import 'package:muslim_book/azkar_feature/views/azkar_list_view.dart';

import 'package:muslim_book/providers/user_provider.dart';
import 'package:muslim_book/quran/views/quran_section_screen.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../utils/sizing_info_extension.dart';

class HomeViewMobilePortrait extends StatefulWidget {
  @override
  _HomeViewMobilePortraitState createState() => _HomeViewMobilePortraitState();
}

class _HomeViewMobilePortraitState extends State<HomeViewMobilePortrait> {
  SizingInformation sizeConfig;
  bool visible = locator<Prefs>().getShowSettings();

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Constants.CANVAS_COLOR,
          body: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(top: kToolbarHeight),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () async {
                          if (locator<Prefs>().getIsFirstTime()) {
                            Navigator.pushNamed(context, "/pick_country_view");
                          } else {
                            Provider.of<UserProvider>(context, listen: false)
                                .selectedPage = 0;
                            Navigator.pushReplacementNamed(
                                context, "/start_view");
                          }
                        },
                        child: Container(
                          height: sizeConfig.blockSizeHorizontal * 40,
                          width: sizeConfig.blockSizeHorizontal * 40,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              SvgPicture.asset(
                                "assets/images/start_view/azan_icon.svg",
                                height: sizeConfig.blockSizeHorizontal * 20,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              Text(
                                locator<Prefs>().getIsFirstTime()
                                    ? AppLocalizations.of(context)
                                        .translate("adjust_azan")
                                    : AppLocalizations.of(context)
                                        .translate("azan_times"),
                                style: TextStyle(
                                  fontSize: sizeConfig.blockSizeHorizontal * 6,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      item(
                          sizeConfig,
                          1,
                          "assets/images/start_view/compass_icon.svg",
                          "compass")
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      item(
                        sizeConfig,
                        3,
                        "assets/images/start_view/quizes_icon.svg",
                        "competitions",
                      ),
                      item(
                          sizeConfig,
                          4,
                          "assets/images/start_view/leaderboard_icon.svg",
                          "first"),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (c) => QuranSectionScreen()));
                        },
                        child: Container(
                          height: sizeConfig.blockSizeHorizontal * 40,
                          width: sizeConfig.blockSizeHorizontal * 40,
                          child: Column(
                            children: <Widget>[
                              SvgPicture.asset(
                                "assets/images/quran_view/icon.svg",
                                width: sizeConfig.blockSizeHorizontal * 30,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  AppLocalizations.of(context)!.translate("quran"),
                                  style: TextStyle(
                                    fontSize:
                                        sizeConfig.blockSizeHorizontal * 6,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (locator<Prefs>().getShowSettings())
                        FlatButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/settings');
                          },
                          child: Container(
                            height: sizeConfig.blockSizeHorizontal * 40,
                            width: sizeConfig.blockSizeHorizontal * 40,
                            child: Column(
                              children: <Widget>[
                                Icon(
                                  Icons.settings,
                                  size: sizeConfig.blockSizeHorizontal * 25,
                                  color: Theme.of(context).primaryColorDark,
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .translate("settings"),
                                  style: TextStyle(
                                    fontSize:
                                        sizeConfig.blockSizeHorizontal * 6,
                                    color: Theme.of(context).primaryColorDark,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  item(sizeConfig, null,
                      "assets/images/azkar_view/azkar_icon.svg", "azkar",
                      onTap: () => Get.to(AzkarListView()))
//                Visibility(
//                  visible: visible,
//                  child: ,
//                ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget item(
      SizingInformation sizeConfig, int position, String svgPhoto, String title,
      {Function onTap}) {
    return FlatButton(
      onPressed: onTap ??
          () {
            Provider.of<UserProvider>(context, listen: false).selectedPage =
                position;
          },
      child: Container(
        height: sizeConfig.blockSizeHorizontal * 40,
        width: sizeConfig.blockSizeHorizontal * 40,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SvgPicture.asset(
              svgPhoto,
              height: sizeConfig.blockSizeHorizontal * 20,
              color: Theme.of(context).primaryColorDark,
            ),
            Text(
              AppLocalizations.of(context)!.translate(title),
              style: TextStyle(
                fontSize: sizeConfig.blockSizeHorizontal * 6,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
