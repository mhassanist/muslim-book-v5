import 'package:base_app/ads/ad_manager.dart';
import 'package:base_app/azan_feature/controllers/azan_controller.dart';
import 'package:base_app/azan_feature/models/azan_model.dart';
import 'package:base_app/local_storage/local_storage_manager.dart';
import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/models/azan_sound.dart';
import 'package:base_app/providers/pick_azan_methods_provider.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/sizing_info_extension.dart';
import 'package:base_app/views/edit_time_prayer_view/edit_time_prayer_view.dart';
import 'package:base_app/views/pick_azan_shiekh_view/pick_azan_shiekh_view.dart';
import 'package:base_app/views/pick_azan_shiekh_view/pick_fajr_azan_shiekh_view.dart';
import 'package:base_app/widgets/base_widget.dart';
import 'package:base_app/widgets/share_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AzanView extends StatefulWidget {
  @override
  _AzanViewState createState() => _AzanViewState();
}

class _AzanViewState extends State<AzanView> {
   AzanController controller ;

  PickAzanMethodsProvider _provider;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    controller= Get.find<AzanController>();
    final size = MediaQuery.of(context).size;
    final isSmall = size.width <= 450;
    return ResponsiveBuilder(builder: (context, sizeConfig) {
      return controller.getAzanList(context) == null
          ? Container()
          : BaseView<PickAzanMethodsProvider>(onModelReady: (model) {
              _provider = model;
              _provider.provideDefaultValueToMazhab(context);
              _provider.provideDefaultValueToMethod(context);
            }, builder: (_, model, __) {
              return GetBuilder<AzanController>(builder: (controller) {
                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                            "assets/images/azan_view_v2/background_${controller.nextAzanKey == 2 ? 1 : controller.nextAzanKey}.png"),
                        fit: BoxFit.cover),
                  ),
                  child: Scaffold(
                    backgroundColor: Colors.transparent,
                    appBar: AppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      title: Text(
                        AppLocalizations.of(context).translate("Prayer_Timings"),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: sizeConfig.blockSizeHorizontal * 6),
                      ),

                        actions: [
                          InkWell(
                              onTap: () {
                                Get.dialog(ShareDialog());
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Icon(Icons.share),
                              )),
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, '/settings');
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: Icon(Icons.settings),
                            ),
                          ),
                          Container(
                            width: 10,
                          )


                      ],
                    ),
                    body:

                    Container(
                      // padding: EdgeInsets.only(
                      //     bottom: sizeConfig.blockSizeVertical * 2),
                      child: Column(
                        children: [
                          isSmall ?
                          Expanded(child: Container())
                              :Container(),
                          Container(
                            margin: EdgeInsets.only(
                                bottom: sizeConfig.blockSizeVertical * 3),
                            child: Column(
                              children: [
                                Text(
                                  "${AppLocalizations.of(context).translate("Day")}:${DateFormat.EEEE(Localizations.localeOf(context).languageCode).format(DateTime.now())}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                      sizeConfig.blockSizeHorizontal * 6),
                                ),
                                SizedBox(
                                  height: sizeConfig.blockSizeVertical,
                                ),
                                Text(
                                  "${DateFormat.yMMMd(Localizations.localeOf(context).languageCode).format(DateTime.now())}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                      sizeConfig.blockSizeHorizontal * 6),
                                ),
                                SizedBox(
                                  height: sizeConfig.blockSizeVertical,
                                ),
                                Text(
                                  "${controller.getHijriDate(context)}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                      sizeConfig.blockSizeHorizontal * 6),
                                )
                              ],
                            ),
                          ),
                          for (int i = 0;
                          i < controller.getAzanList(context).length;
                          i++)
                            buildSingleAzan(
                                controller.getAzanList(context)[i], sizeConfig, i)
                          ,

                          Container(
                              height: 100,
                              child: AdManager.boslaBanner)                        ],
                      ),
                    ),


                  ),
                );
              });
            });
    });
  }

  Widget buildSingleAzan(Azan azan, SizingInformation sizeConfig, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          if (controller.azanValue[index].id == "1") {
            chooseFajrSheikh();
          } else {
            chooseSheikh(controller.azanValue[index].id);
          }
        });
      },
      child: Container(
        height: 43,
        margin: EdgeInsets.symmetric(
            horizontal: sizeConfig.blockSizeHorizontal * 2,
            vertical: sizeConfig.blockSizeVertical / 2),
        decoration: BoxDecoration(
            color: Colors.white
                .withOpacity(index == controller.nextAzanKey - 1 ? 1 : .5),
            borderRadius:
                BorderRadius.circular(sizeConfig.blockSizeHorizontal * 4)),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            controller.azanValue[index].volumeEnable =
                                !controller.azanValue[index].volumeEnable;
                            controller.saveAzanMute(
                                controller.azanValue[index].volumeEnable,
                                controller.azanValue[index].id);
                          });
                        },
                        child: Container(
                            height: MediaQuery.of(context).size.height,

                            // height: double.infinity,
                            padding: EdgeInsets.symmetric(
                                // horizontal: sizeConfig.blockSizeHorizontal * 2,
                                horizontal: sizeConfig.blockSizeVertical * 1.5),
                            // color: Colors.amberAccent,

                            decoration: BoxDecoration(
                                color: index == controller.nextAzanKey - 1
                                    ? Colors.grey.withOpacity(.2)
                                    : Colors.white.withOpacity(.5),
                                borderRadius: BorderRadius.circular(
                                    sizeConfig.blockSizeHorizontal * 4)),
                            child: controller.azanValue[index].volumeEnable
                                ? SvgPicture.asset(
                                    "assets/images/azan_view/volume_up.svg",
                                    height: 20.0,
                                    width: 20.0,
                                    allowDrawingOutsideViewBox: true,
                                  )
                                : SvgPicture.asset(
                                    "assets/images/azan_view/volume_off.svg",
                                    height: 24.0,
                                    width: 24.0,
                                    allowDrawingOutsideViewBox: true,
                                  )),
                      ),
                      SizedBox(
                        width: sizeConfig.blockSizeHorizontal,
                      ),
                      Text(
                        AppLocalizations.of(context).translate(controller.azanValue[index].key),
                        style: TextStyle(
                            color: Constants.PRIMARY_DARK_COLOR,
                            fontWeight: FontWeight.bold,
                            fontSize: sizeConfig.blockSizeHorizontal * 4),
                      ),
                    ])),
            // SizedBox(
            //   width: sizeConfig.blockSizeHorizontal,
            // ),
            Expanded(
                flex: 1,
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // SizedBox(
                      //   width: sizeConfig.blockSizeHorizontal * 2,
                      // ),
                      (index == controller.nextAzanKey - 1)
                          ? GetBuilder<AzanController>(builder: (con) {
                              return Expanded(
                                  flex: 2,
                                  child: Text(
                                    "${con.remaining.inHours > 10 ? con.remaining.inHours : "0${con.remaining.inHours}"}:${DateFormat("mm:ss").format(DateTime.fromMillisecondsSinceEpoch(con.remaining.inMilliseconds))}",
                                    style: TextStyle(
                                      color: Constants.PRIMARY_DARK_COLOR,
                                      fontWeight: FontWeight.bold,
                                      fontSize:
                                          sizeConfig.blockSizeHorizontal * 5,
                                    ),
                                    textAlign: TextAlign.center,
                                  ));
                            })
                          : Container()
                    ],
                  ),
                )),
            Container(
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                    width: 65,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            controller.getFormattedTime(
                                controller.azanValue[index].time.split(":")[0] +
                                    ":" +
                                    ((int.parse(controller
                                                .azanValue[index].minute) +
                                            controller.azanValue[index].count))
                                        .toString()),
                            style: TextStyle(
                                color: Constants.PRIMARY_DARK_COLOR,
                                fontSize: sizeConfig.blockSizeHorizontal * 4.5),
                          ),
                          SizedBox(
                            width: 2,
                          ),
                          Text(
                            "${int.parse(controller.azanValue[index].hours) >= 12 ? "م" : "ص"}",
                            style: TextStyle(
                                color: Constants.PRIMARY_DARK_COLOR,
                                fontSize: sizeConfig.blockSizeHorizontal * 4),
                            textAlign: TextAlign.center,
                          ),
                        ])),
                /*Container(
                    height: 50,
                    width: 40,
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/azan_view/edite.svg",
                            height: 20.0,
                            allowDrawingOutsideViewBox: true,
                          )
                        ])),*/
                InkWell(
                    onTap: () {
                      _modalBottomSheetMenu(controller.azanValue[index]);
                    },
                    child: Container(
                        height: 50,
                        width: 40,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                "assets/images/azan_view/setting.svg",
                                height: 24.0,
                                width: 24.0,
                                allowDrawingOutsideViewBox: true,
                              )
                            ]))),
              ]),
            )
          ],
        ),
      ),
    );
  }

  void chooseSheikh(String azanId) async {
    int newShiekhIndex = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => PickAzanShiekhView(
              azanId: azanId,
            )));
    List<AzanSound> sounds = await LocalStorageManager().loadAzanSoundsList();
    if (sounds != null && sounds[newShiekhIndex] != null) {
      _provider.pickedAzanShiekh = sounds[newShiekhIndex].toJSON();
    }
    if (sounds == null && newShiekhIndex != null) {
      _provider.pickedAzanShiekh =AppLocalizations.of(context).isEnglish()? Constants.EN_SHIEKH_NAMES[newShiekhIndex]:Constants.AR_SHIEKH_NAMES[newShiekhIndex];
    }
  }

  void chooseFajrSheikh() async {
    int newShiekhIndex = await Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => PickFajrAzanShiekhView()));
    List<AzanSound> sounds = (await LocalStorageManager().loadAzanSoundsList());
    if (newShiekhIndex != null && sounds != null && sounds.length > 0) {
      _provider.pickedFajrAzanShiekh = sounds[newShiekhIndex].toJSON();
    } else if (newShiekhIndex != null) {
      _provider.pickedFajrAzanShiekh = Constants.FAJR_SHIEKH_NAMES[0];
    }
  }

  void _modalBottomSheetMenu(Azan azanValue) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => EditTimePrayer(
          showAppBar:  true,
          azan: azanValue,
          updateAzan: listenToUpdate,
        ),
      ),
    );
  }

  listenToUpdate() {
    setState(() {
      controller.azanValue.clear();
    });
    controller.onStart();
    // controller.getAzanList();
    // controller.startRemainingStream();
  }
}
