import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:muslim_book/models/banner_names_enum.dart';

class AdManager {
  static late FirebaseRemoteConfig remoteConfig;
  // Debug/profile builds use Google's test ad units to avoid invalid traffic
  static bool isProductionEnvironment = kReleaseMode;

  static String getBannerAdUnitId(BannerName bannerName) {
    if (isProductionEnvironment) {
      return remoteConfig.getString(bannerName.name);
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
