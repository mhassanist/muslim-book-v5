import 'package:base_app/islamic_feature/views/islamics_view.dart';
import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/providers/user_provider.dart';
import 'package:base_app/sebha_feature/views/sebha_view.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class HomeController extends GetxController {
  final CarouselController controller = CarouselController();
  int _currentIndex = 0;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  get currentIndex => _currentIndex;

  List<Map<String, dynamic>> getCategories(BuildContext context) {
    return [
      {
        "icon": "assets/images/start_view/quizes_icon.svg",
        "name": AppLocalizations.of(context).translate(
            "competitions"), //AppLocalizations.of(context).translate("competitions"),
        "onTap": () =>
            Provider.of<UserProvider>(scaffoldKey.currentContext, listen: false)
                .selectedPage = 3
      },
      {
        "icon": "assets/images/sebha_view/sebha_icon.svg",
        "name": AppLocalizations.of(context).translate("rosary"),
        // "name": "السبحة",
        "onTap": () async {
          await Get.to(SebhaView());

          //checkShareDialogHistory();
        }
      },
      {
        "icon": "assets/images/start_view/azkar.svg",
        "name": AppLocalizations.of(context).translate("azkar"),
        "onTap": () =>
            Provider.of<UserProvider>(scaffoldKey.currentContext, listen: false)
                .selectedPage = 4
      },
      {
        "icon": "assets/images/start_view/mushaf.svg",
        "name": AppLocalizations.of(context).translate("quran"),
        "onTap": () =>
            Provider.of<UserProvider>(scaffoldKey.currentContext, listen: false)
                .selectedPage = 0
      },
      {
        "icon": "assets/images/start_view/compass_icon.svg",
        "name": AppLocalizations.of(context).translate("Qiblah"),
        "onTap": () =>
            Provider.of<UserProvider>(scaffoldKey.currentContext, listen: false)
                .selectedPage = 1
      },
      {
        "icon": "assets/icons/iconappbar.svg",
        "name": AppLocalizations.of(context).translate("more"),
        "onTap": () async {
          //Get.find<HomeController>().scaffoldKey.currentState.openDrawer();
          Get.to(IslamicsView());
        }
        //Get.find<HomeController>().scaffoldKey.currentState.openDrawer()
      },
    ];
  }
}
