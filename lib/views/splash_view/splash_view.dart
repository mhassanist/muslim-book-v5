import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/network_utils/azan_apis.dart';
import 'package:muslim_book/network_utils/settings_apis.dart';
import 'package:muslim_book/providers/user_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:muslim_book/views/start_view/start_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:muslim_book/utils/sizing_info_extension.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  Future invokeMethod() async {
    // try {
    //   await Constants.platform.invokeMethod("fireAzan");
    //   await Constants.platform.invokeMethod(Constants.FIRE_COMPETITION_POP_UP);
    //   await Constants.platform.invokeMethod("fireAzkarPopUp");
    //   await Constants.platform.invokeMethod(Constants.Open_Competition);
    //   await Constants.platform.invokeMethod(Constants.open_Azkar);
    //   await Constants.platform.invokeMethod("checkOverlay");
    // } catch (e) {
    //   e.printError();
    //   // message = e.toString();
    // }
  }

  Future initializeData() async {
    await Provider.of<UserProvider>(context, listen: false).checkLogin();
    await invokeMethod();
    if (locator<Prefs>().getIsAzanUrlValid) {
      // if (locator<Prefs>().getAzanModel() != null) {
      //   MonthAzanModel model =
      //       MonthAzanModel.fromJson(locator<Prefs>().getAzanModel());
      //   if (model.data.first.date.gregorian.month.number !=
      //       DateTime.now().month) {
      //     await AzanApis().getAzan();
      //   }
      // } else
      await AzanApis().getAzan();
    }
    var checkOverLay = false;
    try {
      checkOverLay = await Constants.platform.invokeMethod("checkOverlay");
    } catch (e) {
      e.printError();
    }

    if (await locator<SettingsApis>().getAppVersion()) {
      _showVersionDialog(context);
    } else {
      if (locator<Prefs>().getIsFirstTime()) {
        await sendAzanFilesToTemperory();
        Get.offNamed("/azan_draw_over");
      } else if (!checkOverLay) {
        Get.offNamed("/azan_draw_over");
        // } else if (!checkBattery)
        //   Get.dialog(AdjustBatteryView(isStart: true,));
      } else {
        // Get.offAll(StartView());
        Get.offAll(() => StartView());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, SizingInformation sizeConfig) {
      return Scaffold(
        backgroundColor: const Color(0XFF145344),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image:
                  AssetImage("assets/images/splash_view/background.png"))),
          child: Stack(
            children: <Widget>[
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      colorFilter:
                      new ColorFilter.mode(Colors.white, BlendMode.srcIn),
                      image: AssetImage(
                        "assets/images/splash_view/decoration.png",
                      ),
                    ),
                  ),
                  child: Center(
                    child: Image.asset(
                      "assets/images/splash_view/logo.png",
                      width: sizeConfig.blockSizeHorizontal * 30,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(
                      bottom: sizeConfig.blockSizeVertical * 10),
                  child: Text(
                    AppLocalizations.of(context)!.translate("Largestmuslim"),
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: sizeConfig.blockSizeHorizontal * 6),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Future<void> sendAzanFilesToTemperory() async {
    String tempPath = (await getApplicationDocumentsDirectory()).path;

    var dbPath2 = join(tempPath, "after_azan.mp3");
    ByteData data2 = await rootBundle.load("assets/audio/after_azan.mp3");
    List<int> bytes2 =
    data2.buffer.asUint8List(data2.offsetInBytes, data2.lengthInBytes);
    await File(dbPath2).writeAsBytes(bytes2);
    for (var item in AppLocalizations.of(context)!.isEnglish()
        ? Constants.EN_SHIEKH_NAMES
        : Constants.AR_SHIEKH_NAMES) {
      var dbPath = join(tempPath, "azan_${item["id"]}.mp3");
      ByteData data =
      await rootBundle.load("assets/audio/azan_${item["id"]}.mp3");
      List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await File(dbPath).writeAsBytes(bytes);
    }
    for (int i = 1; i <= 6; i++) {
      if (i != 2) {
        var dbPath = join(tempPath, "before_$i.mp3");
        ByteData data = await rootBundle.load("assets/audio/before_$i.mp3");
        List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        await File(dbPath).writeAsBytes(bytes);
      }
    }

    //var dbPath = join(tempPath, "fajr_ebtehal.mp3");
    //ByteData data = await rootBundle.load("assets/audio/fajr_ebtehal.mp3");
    var dbPath = join(tempPath, "korsi_ayat.mp3");
    ByteData data = await rootBundle.load("assets/audio/korsi_ayat.mp3");

    List<int> bytes =
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await File(dbPath).writeAsBytes(bytes);

    //move default fajr azan mashary to storage
    var dbPathFajr = join(tempPath, "azan_mshary_fajr.mp3");
    ByteData dataFajr =
    await rootBundle.load("assets/audio/azan_mshary_fajr.mp3");
    List<int> bytesFajr = dataFajr.buffer
        .asUint8List(dataFajr.offsetInBytes, dataFajr.lengthInBytes);
    await File(dbPathFajr).writeAsBytes(bytesFajr);
  }

  //  _checkLogin(BuildContext context) async {
  // //    String email = locator<Prefs>().getEmail();
  // //    String password = locator<Prefs>().getPassword();
  // //    print(email);
  // //    print(password);
  // //    bool isInternetConnected = await NetworkController.checkInternet();
  // //    if (isInternetConnected) {
  // //      Map<String, dynamic> body = {
  // //        "email": email,
  // //        "password": password,
  // //      };
  // //      LoginModel _apiResponseModel = await LoginApis.postLogin(body);
  // //      print(_apiResponseModel);
  // //      if (_apiResponseModel != null) {
  // //        if (_apiResponseModel.success == true) {
  // //          bool isSaved = _apiResponseModel.success == true;
  // //          if (isSaved) {
  // //            // userId = _apiResponseModel.data['id'];
  // //            apiToken = _apiResponseModel.data['api_token'];
  // //            print(apiToken);
  // //            locator<Prefs>().setIsLogged(true);
  // //            locator<Prefs>().setCountryName(_apiResponseModel.data['country']);
  // //
  // //            print(_apiResponseModel.message);
  // //            return;
  // //          }
  // //        } else {
  // //          // not successfully login
  // //
  // //        }
  // //      } else {
  // //        // exception message
  // //
  // //      }
  // //    } else {
  // //      //no internet
  // //
  // //    }
  // //  }

  _showVersionDialog(context) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
            child: AlertDialog(
              title:
              Text(AppLocalizations.of(context)!.translate("new_update")),
              content: Text(
                  AppLocalizations.of(context)!.translate("please_update")),
              actions: <Widget>[
                ElevatedButton(
                  child: Text(
                    AppLocalizations.of(context)!.translate("update_now"),
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    LaunchReview.launch();
                  },
                  // color: Constants.ACCENT_COLOR,
                ),
              ],
            ),
            onWillPop: () async {
              return false;
            });
      },
    );
  }
}
