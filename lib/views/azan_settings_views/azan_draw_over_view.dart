import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/locator.dart';
import 'package:base_app/utils/prefs.dart';
import 'package:base_app/views/azan_settings_views/pick_country_view.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../utils/sizing_info_extension.dart';

class AzanDrawOverView extends StatefulWidget {
  const AzanDrawOverView({Key key}) : super(key: key);

  @override
  _AzanDrawOverViewState createState() => _AzanDrawOverViewState();
}

class _AzanDrawOverViewState extends State<AzanDrawOverView>
    with WidgetsBindingObserver {
//  bool buttonPressed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkOverLay(context);
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColorDark,
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                      "assets/images/on_boarding/draw_over_apps_background.png"),
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
                 "",
                  style: TextStyle(
                      color: const Color(0XFFFFAA3F),
                      fontWeight: FontWeight.bold,
                      fontSize: sizeConfig.blockSizeHorizontal * 6),
                ),
                SizedBox(
                  height: sizeConfig.blockSizeVertical * 2,
                ),
                SizedBox(
                  height: sizeConfig.blockSizeVertical * 5,
                ),
                buttonsRow(sizeConfig, context),

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
      shape: StadiumBorder(),
      fillColor: Colors.white,
      child: Text(
        AppLocalizations.of(context).translate("activate_azan"),
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
    Constants.platform.invokeMethod("askOverlay").then((result) async {
      if (result) {
        await goToNextPage(context);
      }
    });
  }

  Future goToNextPage(context) async {
    await Constants.platform.invokeMethod(Constants.FIRE_COMPETITION_POP_UP);
    await Constants.platform.invokeMethod("fireAzkarPopUp");
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (c) => PickCountryView()));
  }

  _checkOverLay(context) async {
    Constants.platform.invokeMethod("checkOverlay").then((result) {
      if (result) {
        goToNextPage(context);
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkOverLay(context);
     }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
