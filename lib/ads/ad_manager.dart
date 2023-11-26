// ignore_for_file: dead_code

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:muslim_book/models/banner_names_enum.dart';
import 'package:muslim_book/network_utils/remote_config.dart';
import 'package:muslim_book/utils/locator.dart';

class AdManager {
  static late FirebaseRemoteConfig remoteConfig;
  static bool isProductionEnvironment = true;

  static String getBannerAdUnitId(BannerName bannerName) {
    if (isProductionEnvironment) {
      return locator<RemoteConfigService>().showFacebookAdsBanner
          ? remoteConfig.getString('${bannerName.name}_facebook')
          : remoteConfig.getString(bannerName.name);
    } else {
      return 'ca-app-pub-3940256099942544/6300978111';
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
