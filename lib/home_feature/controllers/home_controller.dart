import 'package:base_app/providers/user_provider.dart';
import 'package:base_app/ramadan/views/ramadan_view.dart';
import 'package:base_app/sebha_feature/views/sebha_view.dart';
import 'package:base_app/utils/locator.dart';
import 'package:base_app/utils/prefs.dart';
import 'package:base_app/widgets/share_dialog.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeController extends GetController {
  final CarouselController controller = CarouselController();
  int _currentIndex = 0;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // set currentIndex(int val) {
  //   _currentIndex = val;
  //   update();
  // }

  get currentIndex => _currentIndex;

  List<Map<String, dynamic>> get categories => [
        {
          "icon": "assets/images/start_view/quizes_icon.svg",
          "name": "المسابقات",
          "onTap": () => Provider.of<UserProvider>(scaffoldKey.currentContext,
                  listen: false)
              .selectedPage = 3
        },
        {
          "icon": "assets/images/sebha_view/sebha_icon.svg",
          "name": "السبحة",
          "onTap": () async {
            await Get.to(SebhaView());

            checkShareDialogHistory();
          }
        },
        {
          "icon": "assets/images/start_view/azkar.svg",
          "name": "الأذكار",
          "onTap": () => Provider.of<UserProvider>(scaffoldKey.currentContext,
                  listen: false)
              .selectedPage = 4
        },
        {
          "icon": "assets/images/start_view/mushaf.svg",
          "name": "القرآن",
          "onTap": () => Provider.of<UserProvider>(scaffoldKey.currentContext,
                  listen: false)
              .selectedPage = 0
        },
    {
      "icon":  "assets/images/slider_view/antern.svg",
      "name": "رمضانيات",
      "onTap": () => Get.to(RamadanView()),
     },
        {
          "icon": "assets/images/start_view/compass_icon.svg",
          "name": "إتجاه القبلة",
          "onTap": () => Provider.of<UserProvider>(scaffoldKey.currentContext,
                  listen: false)
              .selectedPage = 1
        },
        // {
        //   "icon": "assets/images/start_view/azan_icon.svg",
        //   "name": "موقيت الصلاة",
        //   "onTap": () => Get.to(AzanView())
        // },
        // {
        //   "icon": "assets/images/start_view/leaderboard_icon.svg",
        //   "name": "الأوائل",
        //   "onTap": () => Get.to(SelectTopView())
        //   // "onTap": () => Get.to(CompetitionTopView())
        // },
        // {
        //   "icon": "assets/images/start_view/settings_icon.svg",
        //   "name": "الإعدادات",
        //   "onTap": () => Get.to(SettingsView())
        // },
      ];

  void checkShareDialogHistory() async {
    String lastUpdate = locator<Prefs>().lastUpdatedShowShareDialogTap;
    String todayDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
    if (lastUpdate != todayDate) {
      Get.dialog(ShareDialog());
    }
    locator<Prefs>().setLastUpdatedShowShareDialogTap(todayDate);
  }
}
