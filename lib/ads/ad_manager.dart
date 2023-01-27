import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:muslim_book/models/banner_names_enum.dart';

class AdManager {
  static late FirebaseRemoteConfig remoteConfig;
  static late Widget exsitBanner;
  static late Widget boslaBanner;

  static getAdUnitId(BannerName bannerName) {
    bool isProductionEnvironment = false;  // HAMZA: TODO: Get adUnitId from firebase
    if (isProductionEnvironment) {
      switch (bannerName) {
        case BannerName.AZKAR:
          String adUnitId = remoteConfig.getString('Azkar');
          return adUnitId;
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
    } else {
      return Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'
          : 'ca-app-pub-3940256099942544/2934735716';
    }
  }
}
