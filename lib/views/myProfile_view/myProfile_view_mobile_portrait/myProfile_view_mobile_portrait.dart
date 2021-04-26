import 'dart:io';

import 'package:base_app/enams/view_state_enum.dart';
import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/providers/myProfile_provider.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/widgets/appBar_widget.dart';
import 'package:base_app/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:screenshot/screenshot.dart';
import 'myProfile_mobile_portrait_ui.dart';

class MyProfilePage extends StatefulWidget {
  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  MyProfileUI ui;
  MyProfileProvider provider;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return BaseView<MyProfileProvider>(onModelReady: (model) async {
        //provider = model;
        ui = MyProfileUI(sizeConfig, context, model,screenshotController);
      }, builder: (_, model, __) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: Constants.CANVAS_COLOR,
            appBar: appBar(context, sizeConfig,
                AppLocalizations.of(context).translate("my_profile"),
                key: key),
            body: model.viewState == ViewState.Loading
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Constants.PRIMARY_COLOR),
                      ),
                    ),
                  )
                : Screenshot(
              controller: screenshotController,
                  child: Container(
                    color: Theme.of(context).canvasColor,
                      child: ListView(
                        padding: EdgeInsets.only(bottom: 20),
                        children: <Widget>[
                          ui.imageWidget(),
                          ui.personalData(),
                          ui.points(),
                          ui.textShare(),
                          ui.socialmedia()
                        ],
                      ),
                    ),
                ),
          ),
        );
      });
    });
  }
}
