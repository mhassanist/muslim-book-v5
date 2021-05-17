import 'package:base_app/azan_feature/controllers/azan_controller.dart';
import 'package:base_app/azan_feature/views/azan_view.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/locator.dart';
import 'package:base_app/utils/prefs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:base_app/utils/sizing_info_extension.dart';

class AzanHomeWidget extends StatelessWidget {
  final AzanController controller = Get.find<AzanController>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return Container(
        margin:
            EdgeInsets.symmetric(vertical: sizeConfig.blockSizeVertical * 1.5),
        height: sizeConfig.blockSizeVertical * 25,
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
                          child: Center(
                        child: Text(
                          "“سُبْحَانَ اللَّهِ وَبِحَمْدِهِ ، سُبْحَانَ اللَّهِ الْعَظِيمِ”",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: sizeConfig.blockSizeHorizontal * 5),
                        ),
                      ));
                    } else {
                      // return Container();
                      print(locator<Prefs>().getAssalahTime("1"));
                      final nextSalah =
                          controller.getAzanList()[controller.nextAzanKey - 1];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: sizeConfig.blockSizeVertical * 3.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("صلاة ${nextSalah.title}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        sizeConfig.blockSizeHorizontal * 6)),
                            Text(
                                "${nextSalah.time} ${int.parse(nextSalah.hours) >= 12 ? "مساءا" : "صباحا"}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize:
                                        sizeConfig.blockSizeHorizontal * 6)),
                            Text(
                              "متبقي : ${controller.remaining.inHours > 10 ? controller.remaining.inHours : "0${controller.remaining.inHours}"}:${DateFormat("mm:ss").format(DateTime.fromMillisecondsSinceEpoch(controller.remaining.inMilliseconds))}",
                              style: TextStyle(
                                  color: Constants.PRIMARY_COLOR,
                                  fontWeight: FontWeight.bold,
                                  fontSize: sizeConfig.blockSizeHorizontal * 4),
                            ),
                          ],
                        ),
                      );    // print(locator<Prefs>().getAssalahTime("1"));
                      // final nextSalah =
                      //     controller.getAzanList()[controller.nextAzanKey - 1];
                      // return Padding(
                      //   padding: EdgeInsets.symmetric(
                      //       vertical: sizeConfig.blockSizeVertical * 3.5),
                      //   child: Column(
                      //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //     children: [
                      //       Text("صلاة ${nextSalah.title}",
                      //           style: TextStyle(
                      //               color: Colors.white,
                      //               fontWeight: FontWeight.bold,
                      //               fontSize:
                      //                   sizeConfig.blockSizeHorizontal * 6)),
                      //       Text(
                      //           "${nextSalah.time} ${int.parse(nextSalah.hours) >= 12 ? "مساءا" : "صباحا"}",
                      //           style: TextStyle(
                      //               color: Colors.white,
                      //               fontWeight: FontWeight.bold,
                      //               fontSize:
                      //                   sizeConfig.blockSizeHorizontal * 6)),
                      //       Text(
                      //         "متبقي : ${controller.remaining.inHours > 10 ? controller.remaining.inHours : "0${controller.remaining.inHours}"}:${DateFormat("mm:ss").format(DateTime.fromMillisecondsSinceEpoch(controller.remaining.inMilliseconds))}",
                      //         style: TextStyle(
                      //             color: Constants.PRIMARY_COLOR,
                      //             fontWeight: FontWeight.bold,
                      //             fontSize: sizeConfig.blockSizeHorizontal * 4),
                      //       ),
                      //     ],
                      //   ),
                      // );
                    }
                  }),
            ),
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "يوم  ${controller.currentDayName}",
                  style: TextStyle(
                      color: Constants.PRIMARY_COLOR,
                      fontWeight: FontWeight.bold,
                      fontSize: sizeConfig.blockSizeHorizontal * 4),
                ),
                SizedBox(
                  height: sizeConfig.blockSizeVertical,
                ),
                Text(
                  "${controller.currentDate}",
                  style: TextStyle(
                      color: Constants.PRIMARY_COLOR,
                      fontWeight: FontWeight.bold,
                      fontSize: sizeConfig.blockSizeHorizontal * 4),
                ),
                SizedBox(
                  height: sizeConfig.blockSizeVertical,
                ),
                Text(
                  "${controller.getHijriDate()}",
                  style: TextStyle(
                      color: Constants.PRIMARY_COLOR,
                      fontWeight: FontWeight.bold,
                      fontSize: sizeConfig.blockSizeHorizontal * 4),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(
                      horizontal: sizeConfig.blockSizeHorizontal * 2,
                      vertical: sizeConfig.blockSizeVertical * 2),
                  child: RawMaterialButton(
                    onPressed: () {
                      if (locator<Prefs>().getAzanModel() != null) {
                        Get.to(AzanView());
                      } else {}
                    },
                    elevation: 5,
                    padding: EdgeInsets.symmetric(
                        vertical: sizeConfig.blockSizeVertical * 2),
                    shape: StadiumBorder(),
                    child: Text(
                      "مواقيت الصلاة",
                      style: TextStyle(
                          color: Constants.PRIMARY_DARK_COLOR,
                          fontWeight: FontWeight.bold,
                          fontSize: sizeConfig.blockSizeHorizontal * 5),
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
