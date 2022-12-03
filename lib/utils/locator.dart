// import 'package:progress_dialog/network_utils/api_service.dart';
// import 'package:progress_dialog/network_utils/remote_config.dart';
// import 'package:progress_dialog/network_utils/settings_apis.dart';
// import 'package:progress_dialog/providers/azan_provider.dart';
// import 'package:progress_dialog/providers/changePassword_provider.dart';
// import 'package:progress_dialog/providers/competition_provider.dart';
// import 'package:progress_dialog/providers/edit_profile_provider.dart';
// import 'package:progress_dialog/providers/location_provider.dart';
// import 'package:progress_dialog/providers/myProfile_provider.dart';
// import 'package:progress_dialog/providers/pick_azan_methods_provider.dart';
// import 'package:progress_dialog/providers/pick_azan_shiekh_provider.dart';
// import 'package:progress_dialog/providers/pick_fajr_azan_shiekh_provider.dart';
// import 'package:progress_dialog/providers/settings_provider.dart';
// import 'package:progress_dialog/quran/quran_database/quran_dao.dart';
// import 'package:progress_dialog/ramadan/provider/ramadan_provider.dart';
// import 'package:progress_dialog/sebha_feature/offline_sebha/database/sebha_database.dart';
// import 'package:progress_dialog/singletons/azan_singleton.dart';
// import 'package:progress_dialog/singletons/ramadan_singleton.dart';
import 'package:get_it/get_it.dart';
// import 'package:muslim_book/utils/prefs.dart';

GetIt locator = GetIt.instance;

void setupLocator() async {
  // locator.registerSingleton(RemoteConfigService());
  // locator.registerLazySingleton(() => Prefs());
  // locator.registerLazySingleton(() => ApiService());
  // locator.registerLazySingleton(() => AzanSingleton());
  // locator.registerLazySingleton(() => RamadanSingleton());
  // locator.registerLazySingleton(() => SettingsApis());
  // locator.registerLazySingleton(() => SebhaDataBase());
  // locator.registerLazySingleton<QuranDao>(() => QuranDao());
  // await locator<QuranDao>().initHive();
  // locator.registerFactory(() => CompetitionProvider(null));
  // locator.registerFactory(() => LocationProvider());
  // locator.registerFactory(() => PickAzanMethodsProvider());
  // locator.registerFactory(() => AzanProvider());
  // locator.registerFactory(() => SettingsProvider());
  // locator.registerFactory(() => PickAzanShiekhProvider());
  // locator.registerFactory(() => RamadanProvider());
  // locator.registerFactory(() => PickFajrAzanShiekhProvider());
  // locator.registerFactory(() => EditProfileProvider());
  // locator.registerFactory(() => ChangePasswordProvider());
  ////locator.registerFactory(() => RatingProvider());
  // locator.registerFactory(() => MyProfileProvider());
}
