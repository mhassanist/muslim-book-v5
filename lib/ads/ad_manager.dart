import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:muslim_book/models/banner_names_enum.dart';

class AdManager {
  static late FirebaseRemoteConfig remoteConfig;
  static late Widget exsitBanner;
  static late Widget boslaBanner;

  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-8586064191208277~4831882751";
    } else if (Platform.isIOS) {
      return "ca-app-pub-8586064191208277~4831882751";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static getAdUnitId(BannerName bannerName) {
    switch (bannerName) {
      case BannerName.AZKAR:
        return remoteConfig.getString('Azkar');
      case BannerName.COMPETITION:
        return remoteConfig.getString('down_Competition_1');
      case BannerName.BOSLA:
        return remoteConfig.getString('Bosla');
      case BannerName.SEBHA:
        return remoteConfig.getString('Sabha');
      case BannerName.DownEditAzan:
        return remoteConfig.getString('Down_Edit_Azan');
      case BannerName.DownStartCompetition:
        return remoteConfig.getString('down_start_Competition');
      case BannerName.Top:
        return remoteConfig.getString('Top');
      case BannerName.TheMiddleOfTheCompetition:
        return remoteConfig.getString('The_middle_of_the_competition');
    }
  }
}
