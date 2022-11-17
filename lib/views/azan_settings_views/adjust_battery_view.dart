import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/views/azan_settings_views/xiaomi_settings_view.dart';
import 'package:device_info/device_info.dart';
import 'package:base_app/providers/user_provider.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/locator.dart';
import 'package:base_app/utils/prefs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../utils/sizing_info_extension.dart';

class AdjustBatteryView extends StatefulWidget {
  final bool isStart;

  const AdjustBatteryView({Key key, this.isStart}) : super(key: key);

  @override
  _AdjustBatteryViewState createState() => _AdjustBatteryViewState();
}

class _AdjustBatteryViewState extends State<AdjustBatteryView>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _checkBattery(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(sizeConfig.blockSizeHorizontal * 5),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: ClipRRect(
              borderRadius:
                  BorderRadius.circular(sizeConfig.blockSizeHorizontal * 5),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(),
                  height: sizeConfig.blockSizeHorizontal * 75,
                  width: sizeConfig.blockSizeHorizontal * 75,
                  padding: EdgeInsets.only(),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          alignment: Alignment.bottomCenter,
                          constraints: BoxConstraints.expand(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                sizeConfig.blockSizeHorizontal * 5),
                            child: Image.asset(
                              "assets/images/on_boarding/praying_man.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              vertical: sizeConfig.blockSizeVertical * 2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate("allowing_app_to_work_always"),
                                textAlign: TextAlign.center,
                                style: textStyle(
                                    const Color(0XFFFFAA3F),
                                    FontWeight.bold,
                                    sizeConfig.blockSizeHorizontal * 8),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: sizeConfig.blockSizeVertical * 5,
                                    horizontal:
                                        sizeConfig.blockSizeHorizontal * 15),
                                child: Text(
                                  AppLocalizations.of(context).translate("toOpenNotification"),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          sizeConfig.blockSizeHorizontal * 4,
                                      height: 1.2),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: RawMaterialButton(
                          onPressed: () {
                            _editBattery(context);
                          },
                          padding: EdgeInsets.symmetric(
                              horizontal: sizeConfig.blockSizeHorizontal * 5,
                              vertical: sizeConfig.blockSizeVertical * 2),
                          shape: StadiumBorder(),
                          fillColor: Colors.white,
                          child: Text(
                            AppLocalizations.of(context).translate("allow_notification"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColorDark,
                                fontSize: sizeConfig.blockSizeHorizontal * 4,
                                height: 1.2),
                          ),
                        ),
                      )
                      // buttonsRow(sizeConfig, context)
                      ,
                      Align(
                          alignment: Alignment.topLeft,
                          child: InkWell(
                              onTap: () async {
                                 widget.isStart
                                    ? await goToNextPage(context)
                                    : Navigator.of(context).pop();
                              },
                              child: CircleAvatar(
                                radius: 14.0,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.close,
                                    color: Theme.of(context).primaryColorDark),
                              ))),
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

  Widget buttonsRow(SizingInformation sizeConfig, context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 2,
          child: RawMaterialButton(
            padding: EdgeInsets.symmetric(
                vertical: sizeConfig.blockSizeVertical * 1.5),
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(sizeConfig.blockSizeVertical)),
            onPressed: () async {
              _editBattery(context);
            },
            fillColor: Theme.of(context).primaryColor,
            child: Text(
              AppLocalizations.of(context).translate("allow_for_edit_battery"),
              style: textStyle(Constants.CANVAS_COLOR, FontWeight.w700,
                  sizeConfig.blockSizeHorizontal * 4),
            ),
          ),
        ),
      ],
    );
  }

  TextStyle textStyle(color, weight, double size) {
    return TextStyle(
        fontWeight: weight, color: color, fontFamily: "arabic", fontSize: size);
  }

  _editBattery(context) async {
    Constants.platform.invokeMethod("allowBatteryEditing").then((result) async {
      if (result) {
        await goToNextPage(context);
      }
    });
  }

  Future goToNextPage(context) async {
    locator<Prefs>().setShowSettings(true);
    locator<Prefs>().setIsFirstTime(false);

    if (await Constants.platform.invokeMethod("checkIsXiaomi")) {
      Get.offAll(XiaomiSettingsView());
    } else {
      Navigator.of(context).pushReplacementNamed("/start_view");
    }
  }

  _checkBattery(context) async {
    Constants.platform.invokeMethod("checkBatteryEditing").then((result) async {
      if (result) {
        goToNextPage(context);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkBattery(context);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
