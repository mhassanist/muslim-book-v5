import 'package:auto_size_text/auto_size_text.dart';
import 'package:base_app/azan_feature/views/azan_view.dart';
import 'package:base_app/home_feature/controllers/home_controller.dart';
import 'package:base_app/islamic_feature/views/islamics_view.dart';
import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/providers/user_provider.dart';
import 'package:base_app/sebha_feature/views/sebha_view.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../utils/sizing_info_extension.dart';

class SideDrawerMenu {
  SizingInformation sizeConfig;
  final BuildContext context;
  String email;
  String name;
  String flag;
  String countryName;
  String image;

  SideDrawerMenu(
    this.context,
  ) {
    email = Provider.of<UserProvider>(context).user?.email;
    name = Provider.of<UserProvider>(context).user?.name;
    flag = Provider.of<UserProvider>(context).user?.flag;
    countryName = Provider.of<UserProvider>(context).user?.country;
    image = Provider.of<UserProvider>(context).user?.image;
  }

  buildDrawer() {
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      this.sizeConfig = sizeConfig;
      return Container(
        width: sizeConfig.blockSizeHorizontal * 65,
        child: Drawer(
          child: Container(
            padding: const EdgeInsets.only(left: 16.0, right: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
              //boxShadow: [BoxShadow(color: Colors.black45)],
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: Container(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Container(
                          height: sizeConfig.blockSizeHorizontal * 10,
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.arrow_back,
                              color: Constants.CANVAS_COLOR,
                              size: sizeConfig.blockSizeHorizontal * 6,
                            ),
                          ),
                        ),
                      ),
                   Column(
                        children: <Widget>[
                          Provider.of<UserProvider>(context).isLoggedIn
                              ? Column(children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).accentColor,
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: NetworkImage(
                                              image ?? flag,
                                            ),
                                            fit: BoxFit.cover)),
                                    height: sizeConfig.blockSizeHorizontal * 25,
                                    width: sizeConfig.blockSizeHorizontal * 25,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: AutoSizeText(
                                            name,
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Constants.PRIMARY_COLOR,
                                                fontSize: sizeConfig
                                                        .blockSizeHorizontal *
                                                    4),
                                          ),
                                        ),

                                        Visibility(
                                            visible: countryName != null,
                                            child: SizedBox(
                                              height: 10,
                                            )),
                                        // if (countryName != null)
                                        Visibility(
                                            visible: countryName != null &&
                                                countryName.isNotEmpty,
                                            child: AutoSizeText(
                                              "$countryName",
                                              style: TextStyle(
                                                  color:
                                                      Constants.PRIMARY_COLOR,
                                                  fontSize: sizeConfig
                                                          .blockSizeHorizontal *
                                                      4),
                                            )),
                                        Visibility(
                                          visible:
                                              email != null && email.isNotEmpty,
                                          child: SizedBox(
                                            height: 10,
                                          ),
                                        ),
                                        Visibility(
                                            visible: email != null &&
                                                email.isNotEmpty,
                                            child: Text(
                                              email,
                                              style: TextStyle(
                                                color: Constants.PRIMARY_COLOR,
                                                fontSize: sizeConfig
                                                        .blockSizeHorizontal *
                                                    3,
                                              ),
                                            )),
                                      ]),
                                ])
                              : Container(),
                          //
                          // Column(
                          //         children: <Widget>[
                          //           SizedBox(height: 10.0),
                          //           _buildRow(
                          //               Icons.person,
                          //               AppLocalizations.of(context)
                          //                   .translate("login"), () {
                          //             Navigator.of(context).pop();
                          //             Navigator.pushNamed(
                          //                 context, "/LoginPopUpView");
                          //           }, false, ""),
                          //           _buildDivider(),
                          //           _buildRow(
                          //               Icons.person_add,
                          //               AppLocalizations.of(context)
                          //                   .translate("create_account"), () {
                          //             Navigator.of(context).pop();
                          //             Navigator.pushNamed(
                          //                 context, "/signup_view");
                          //           }, false, ""),
                          //           _buildDivider(),
                          //           _buildRow(
                          //               Icons.star,
                          //               AppLocalizations.of(context)
                          //                   .translate("rating_muslim_book"),
                          //               () {
                          //             //Navigator.of(context).pop();
                          //             // Navigator.pushNamed(
                          //             //     context, "/rating_view");
                          //             LaunchReview.launch();
                          //           }, false, ""),
                          //           _buildDivider(),
                          //         ],
                          //       ),

                          // _buildRow(null, "رمضانيات", () {
                          //   Navigator.of(context).pop();
                          //   Navigator.pushNamed(context, '/RamadanView');
                          // }, true, "assets/images/slider_view/antern.svg"),
                          _buildDivider(),
                          _buildRow(null, AppLocalizations.of(context).translate("Prayer_Timings"), () {
                            Navigator.of(context).pop();
                            Get.to(AzanView());
                          }, true, "assets/images/slider_view/prayer.svg"),
                          _buildDivider(),
                          _buildRow(null, AppLocalizations.of(context).translate("Qiblah"), () {
                            Navigator.of(context).pop();
                            Provider.of<UserProvider>(
                                    Get.find<HomeController>()
                                        .scaffoldKey
                                        .currentContext,
                                    listen: false)
                                .selectedPage = 1;
                          }, true, "assets/images/start_view/compass_icon.svg"),
                          _buildDivider(),
                          _buildRow(null, AppLocalizations.of(context).translate("quran"), () {
                            Navigator.of(context).pop();
                            Provider.of<UserProvider>(
                                    Get.find<HomeController>()
                                        .scaffoldKey
                                        .currentContext,
                                    listen: false)
                                .selectedPage = 0;
                          }, true, "assets/images/slider_view/koran.svg"),
                          _buildDivider(),
                          _buildRow(null, AppLocalizations.of(context).translate("rosary"), () {
                            Navigator.of(context).pop();
                            // await
                            Get.to(SebhaView());
                          }, true, "assets/images/sebha_view/sebha_icon.svg"),
                          _buildDivider(),
                          _buildRow(null,AppLocalizations.of(context).translate("azkar"), () {
                            Navigator.of(context).pop();
                            Provider.of<UserProvider>(
                                    Get.find<HomeController>()
                                        .scaffoldKey
                                        .currentContext,
                                    listen: false)
                                .selectedPage = 4;
                          }, true, "assets/images/start_view/azkar.svg"),
                          _buildDivider(),
                          _buildRow(null, AppLocalizations.of(context).translate("competitions"), () {
                            Navigator.of(context).pop();
                            Provider.of<UserProvider>(
                                    Get.find<HomeController>()
                                        .scaffoldKey
                                        .currentContext,
                                    listen: false)
                                .selectedPage = 3;
                          }, true, "assets/images/start_view/quizes_icon.svg"),
                          _buildDivider(),
                          _buildRow(Icons.drag_indicator, AppLocalizations.of(context).translate("more"), () {
                            Navigator.of(context).pop();
                            Get.to(IslamicsView());
                          }, false, ""),
                          _buildDivider(),
                          _buildRow(Icons.wine_bar, AppLocalizations.of(context).translate("best"), () {
                            Navigator.of(context).pop();
                            Navigator.pushNamed(context, "/SelectTopView");
                          }, false, ""),
                          // _buildDivider(),
                          //  _buildRow(
                          //      Icons.person_add,
                          //      AppLocalizations.of(context)
                          //          .translate("edit_my_profile"), () {
                          //    Navigator.of(context).pop();
                          //    Navigator.pushNamed(
                          //        context, "/edit_profile_view");
                          //  }),
                          _buildDivider(),

                          _buildRow(
                              Icons.person,
                              AppLocalizations.of(context)
                                  .translate("my_profile"), () {
                            Navigator.of(context).pop();
                            Navigator.pushNamed(context, "/myProfile_view");
                          }, false, ""),
                          _buildDivider(),
                          _buildRow(
                              Icons.settings,
                              AppLocalizations.of(context)
                                  .translate("settings"), () {
                            Navigator.of(context).pop();
                            Navigator.pushNamed(context, '/settings');
                          }, false, ""),


                          Container(
                            height: 20,
                          )
                          // _buildDivider(),
                          // _buildRow(
                          //     Icons.star,
                          //     AppLocalizations.of(context)
                          //         .translate("rating_muslim_book"),
                          //     () {
                          //   Navigator.of(context).pop();
                          //   // Navigator.pushNamed(
                          //   //     context, "/rating_view");
                          //   LaunchReview.launch();
                          // }),
                          // _buildDivider(),
                          // _buildRow(
                          //     Icons.exit_to_app,
                          //     AppLocalizations.of(context)
                          //         .translate("log_out"), () {
                          //   //locator<Prefs>().setIsLogged(false);
                          //   exitPopUp();
                          // }, false, ""),
                          // _buildDivider(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Divider _buildDivider() {
    return Divider(
      color: Colors.green,
    );
  }

  Widget _buildRow(IconData icon, String title, Function function, bool isSvg,
      String svgImage) {
    return Material(
      color: Theme.of(context).primaryColorDark,
      child: InkWell(
        onTap: function,
        child: Container(
          height: sizeConfig.blockSizeVertical * 6,
          width: sizeConfig.blockSizeHorizontal * 65,
          child: Row(children: [
            !isSvg
                ? Icon(
                    icon,
                    color: Constants.CANVAS_COLOR,
                    size: sizeConfig.blockSizeHorizontal * 5,
                  )
                : SvgPicture.asset(
                    svgImage,
                    width: sizeConfig.blockSizeHorizontal * 5,
                    // fit: BoxFit.cover,
                    color: Colors.white,
                  ),
            SizedBox(width: 10.0),
            Text(
              title,
              style: TextStyle(
                  color: Constants.CANVAS_COLOR,
                  fontSize: sizeConfig.blockSizeHorizontal * 4),
            ),
          ]),
        ),
      ),
    );
  }

  exitPopUp() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              child: Text(
                AppLocalizations.of(context).translate("are_you_sure"),
                style: TextStyle(
                  fontSize: sizeConfig.blockSizeHorizontal * 6,
                  color: Theme.of(context).primaryColorDark,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: sizeConfig.blockSizeHorizontal * 30,
                  height: sizeConfig.blockSizeVertical * 6,
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: RawMaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(sizeConfig.blockSizeVertical),
                    ),
                    onPressed: () {
                      Provider.of<UserProvider>(context, listen: false)
                          .logOut();
                      Navigator.pop(context);
                      Provider.of<UserProvider>(context, listen: false)
                          .selectedPage = 2;
                      Navigator.pushReplacementNamed(context, "/start_view");
                    },
                    fillColor: Theme.of(context).primaryColor,
                    child: Text(
                      AppLocalizations.of(context).translate("yes"),
                      style: TextStyle(
                        fontSize: sizeConfig.blockSizeHorizontal * 6,
                        color: Constants.CANVAS_COLOR,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  width: sizeConfig.blockSizeHorizontal * 30,
                  height: sizeConfig.blockSizeVertical * 6,
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: RawMaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(sizeConfig.blockSizeVertical),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    fillColor: Theme.of(context).accentColor,
                    child: Text(
                      AppLocalizations.of(context).translate("cancel"),
                      style: TextStyle(
                        fontSize: sizeConfig.blockSizeHorizontal * 6,
                        color: Constants.CANVAS_COLOR,
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }
}
