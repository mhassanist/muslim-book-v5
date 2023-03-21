// ignore_for_file: dead_code

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:muslim_book/models/banner_names_enum.dart';

class AdManager {
  static late FirebaseRemoteConfig remoteConfig;
  static bool showFacebookAds = false;
  static bool isProductionEnvironment = true;

  static String getBannerAdUnitId(BannerName bannerName) {
    if (isProductionEnvironment) {
      String unitId = remoteConfig.getString(bannerName.name);
      return unitId;
    } else {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
  }

  static String getInterstitialAdUnitId(BannerName bannerName) {
    if (isProductionEnvironment) {
      String unitId = remoteConfig.getString(bannerName.name);
      return unitId;
    } else {
      return 'ca-app-pub-3940256099942544/1033173712';
    }
  }
}
