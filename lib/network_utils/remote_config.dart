import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  RemoteConfig remoteConfig;

  RemoteConfigService() {
    setRemoteConfig();
  }

  void setRemoteConfig() async {
    remoteConfig = await RemoteConfig.instance;
    try {
      await remoteConfig.fetch();
      await remoteConfig.activateFetched();
    } catch (e) {}
  }

  String get betweenQuestionsPopUpAdsId =>
      remoteConfig.getString("between_questions_pop_up");
  String get underCompetitionAdsId =>
      remoteConfig.getString("down_Competition");
  String get underStartCompetitionAdsId =>
      remoteConfig.getString("down_start_Competition");
  String get azanPopUpAdId => remoteConfig.getString("after_azan_pop_up");

  String get azkar => remoteConfig.getString("azkar");
  String get belowAzkar => remoteConfig.getString("Down_Azkar");
}
