import 'package:base_app/azan_feature/controllers/azan_controller.dart';
import 'package:base_app/azan_feature/views/azan_view.dart';
import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/locator.dart';
import 'package:base_app/utils/prefs.dart';
import 'package:base_app/utils/sizing_info_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AzanHomeWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final AzanController controller = Get.find<AzanController>();

    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return Container(
        height: sizeConfig.blockSizeVertical * 17,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(sizeConfig.blockSizeHorizontal * 6),
          image: DecorationImage(
              image: AssetImage("assets/images/home_view/azan_background.png"),
              fit: BoxFit.cover),
        ),
        child: Row(
          children: [
            Expanded(
              child: GetBuilder<AzanController>(
                  init: AzanController(),
                  builder: (controller) {
                    if (locator<Prefs>().getAzanModel() == null) {
                      return Container(
                          margin: EdgeInsetsDirectional.only(start: 15),
                          child: Center(
                            child: Text(
                              "“سُبْحَانَ اللَّهِ وَبِحَمْدِهِ ، سُبْحَانَ اللَّهِ الْعَظِيمِ”",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: sizeConfig.blockSizeHorizontal * 4),
                            ),
                          ));
                    } else {
                      // return Container();
                      //print(locator<Prefs>().getAssalahTime("2"));
                      var nextSalah =
                          controller.getAzanList(context)[controller.nextAzanKey - 1];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: sizeConfig.blockSizeVertical * 3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                                AppLocalizations.of(context)
                                        .translate("salah") +
                                    " "+AppLocalizations.of(context).translate(nextSalah.key),
                                // "صلاة ${nextSalah.title}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        sizeConfig.blockSizeHorizontal * 5)),
                            Text(
                                "${nextSalah.time} ${int.parse(nextSalah.hours) >= 12 ? AppLocalizations.of(context).translate("evening") : AppLocalizations.of(context).translate("morning")}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        sizeConfig.blockSizeHorizontal * 5)),
                            Text(
                              
                              "${AppLocalizations.of(context).translate("left")}: ${controller.remaining.inHours > 10 ? controller.remaining.inHours : "0${controller.remaining.inHours}"}:${DateFormat("mm:ss").format(DateTime.fromMillisecondsSinceEpoch(controller.remaining.inMilliseconds))}",
                              style: TextStyle(
                                  color: Constants.PRIMARY_COLOR,
                                  fontWeight: FontWeight.bold,
                                  fontSize: sizeConfig.blockSizeHorizontal * 3),
                            ),
                          ],
                        ),
                      ); // print(locator<Prefs>().getAssalahTime("1"));

                    }
                  }),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  
                  "${DateFormat.EEEE(Localizations.localeOf(context).languageCode).format(DateTime.now())}  ${DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(DateTime.now())}",
                  locale: Locale('en'),
                  style: TextStyle(
                      color: Constants.PRIMARY_COLOR,
                      fontWeight: FontWeight.bold,
                      fontSize: sizeConfig.blockSizeHorizontal * 3),
                ),
                // SizedBox(
                //   height: sizeConfig.blockSizeVertical,
                // ),
                // Text(
                //   "${DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(DateTime.now())}",
                //   style: TextStyle(
                //       color: Constants.PRIMARY_COLOR,
                //       fontWeight: FontWeight.bold,
                //       fontSize: sizeConfig.blockSizeHorizontal * 3),
                // ),
                SizedBox(
                  height: sizeConfig.blockSizeVertical,
                ),
                Text(
                  "${controller.getHijriDate(context)}",
                  style: TextStyle(
                      color: Constants.PRIMARY_COLOR,
                      fontWeight: FontWeight.bold,
                      fontSize: sizeConfig.blockSizeHorizontal * 3),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                      horizontal: sizeConfig.blockSizeHorizontal * 4,
                      vertical: sizeConfig.blockSizeVertical),
                  child: RawMaterialButton(
                    onPressed: () {
                      if (locator<Prefs>().getAzanModel() != null) {
                        Get.to(AzanView());
                      } else {}
                    },
                    elevation: 5,
                    padding: EdgeInsets.symmetric(
                        vertical: sizeConfig.blockSizeVertical * .5),
                    shape: StadiumBorder(),
                    child: Text(
                      AppLocalizations.of(context).translate("Prayer_Timings"),
                      style: TextStyle(
                          color: Constants.PRIMARY_DARK_COLOR,
                          fontWeight: FontWeight.bold,
                          fontSize: sizeConfig.blockSizeHorizontal * 4),
                    ),
                    fillColor: Colors.white,
                  ),
                ),
              ],
            )),
          ],
        ),
      );
    });
  }
}
