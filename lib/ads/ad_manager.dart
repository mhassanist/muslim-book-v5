import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:muslim_book/models/banner_names_enum.dart';

class AdManager {
  static late FirebaseRemoteConfig remoteConfig;
  // static late Widget boslaBanner;

  static String getAdUnitId(BannerName bannerName) {
    bool isProductionEnvironment = true;
    if (isProductionEnvironment) {
      String unitId = remoteConfig.getString(bannerName.name);
      return unitId;
      // ignore: dead_code
    } else {
      return 'ca-app-pub-3940256099942544/6300978111';
    }
  }
}
