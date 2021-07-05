import 'dart:io';

import 'package:base_app/models/banner_names_enum.dart';
// import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';

class AdManager {
  static RemoteConfig remoteConfig;
  static Widget exsitBanner;
  static Widget boslaBanner;

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
        break;
      case BannerName.COMPETITION:
        return remoteConfig.getString('down_Competition_1');
        break;
      case BannerName.BOSLA:
        return remoteConfig.getString('Bosla');
        break;
      case BannerName.SEBHA:
        return remoteConfig.getString('Sabha');
        break;
      case BannerName.DownEditAzan:
        return remoteConfig.getString('Down_Edit_Azan');
        break;
      case BannerName.DownStartCompetition:
        return remoteConfig.getString('down_start_Competition');
        break;
      case BannerName.Top:
        return remoteConfig.getString('Top');
        break;
      case BannerName.TheMiddleOfTheCompetition:
        return remoteConfig.getString('The_middle_of_the_competition');
        break;
    }
  }
}
