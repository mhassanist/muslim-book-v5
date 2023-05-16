import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../utils/sizing_info_extension.dart';
// import 'package:android_intent/android_intent.dart';
import 'package:android_intent_plus/android_intent.dart';

class XiaomiSettingsView extends StatefulWidget {
  const XiaomiSettingsView({super.key});

  @override
  _XiaomiSettingsViewState createState() => _XiaomiSettingsViewState();
}

class _XiaomiSettingsViewState extends State<XiaomiSettingsView>
    with WidgetsBindingObserver {
//  bool buttonPressed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColorDark,
          body: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      "assets/images/onboarding/draw_over_apps_background.png"),
                  fit: BoxFit.cover),
            ),
            padding: EdgeInsets.only(
                bottom: sizeConfig.blockSizeVertical * 5,
                top: sizeConfig.blockSizeVertical * 15,
                left: sizeConfig.blockSizeHorizontal * 5,
                right: sizeConfig.blockSizeHorizontal * 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.translate("please_enter_other_Permission"),
                  style: TextStyle(
                      height: 1.5,
                      color: const Color(0XFFFFAA3F),
                      fontWeight: FontWeight.bold,
                      fontSize: sizeConfig.blockSizeHorizontal * 6),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: sizeConfig.blockSizeVertical * 2,
                ),
                SizedBox(
                  height: sizeConfig.blockSizeVertical * 8,
                ),
                buttonsRow(sizeConfig, context)
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buttonsRow(SizingInformation sizeConfig, context) {
    return RawMaterialButton(
      onPressed: () {
        _canOverLay(context);
      },
      padding: EdgeInsets.symmetric(
          horizontal: sizeConfig.blockSizeHorizontal * 20,
          vertical: sizeConfig.blockSizeVertical * 2),
      shape: const StadiumBorder(),
      fillColor: Colors.white,
      child: Text(
        AppLocalizations.of(context)!.translate("activate_permissions"),
        textAlign: TextAlign.center,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColorDark,
            fontSize: sizeConfig.blockSizeHorizontal * 4,
            height: 1.2),
      ),
    );
  }

  _canOverLay(context) async {
    if (GetPlatform.isAndroid) {
      final intent = AndroidIntent(
        action: 'action_application_details_settings',
        data: 'package:com.muslim_book.muslim_book',
      );
      await intent.launch();
      goToNextPage(context);
    }
  }

  Future goToNextPage(context) async {
    Get.offAllNamed("/start_view");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
