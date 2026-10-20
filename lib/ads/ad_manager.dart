// ignore_for_file: dead_code

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:muslim_book/models/banner_names_enum.dart';
import 'package:muslim_book/network_utils/remote_config.dart';
import 'package:muslim_book/utils/locator.dart';

class AdManager {
  static late FirebaseRemoteConfig remoteConfig;
  // Debug/profile builds use Google's test ad units to avoid invalid traffic
  static bool isProductionEnvironment = kReleaseMode;

  static String getBannerAdUnitId(BannerName bannerName) {
    if (isProductionEnvironment) {
      return locator<RemoteConfigService>().showFacebookAdsBanner
          ? remoteConfig.getString('${bannerName.name}_facebook')
          : remoteConfig.getString(bannerName.name);
    } else {
      return 'ca-app-pub-3940256099942544/9214589741';
    }
  }

  static String getInterstitialAdUnitId(BannerName bannerName) {
    if (isProductionEnvironment) {
      return remoteConfig.getString(bannerName.name);
    } else {
      return 'ca-app-pub-3940256099942544/1033173712';
    }
  }
}
