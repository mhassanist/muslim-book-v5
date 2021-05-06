import 'package:base_app/network_utils/api_service.dart';
import 'package:base_app/network_utils/remote_config.dart';
import 'package:base_app/network_utils/settings_apis.dart';
import 'package:base_app/providers/azan_provider.dart';
import 'package:base_app/providers/changePassword_provider.dart';
import 'package:base_app/providers/competition_provider.dart';
import 'package:base_app/providers/edit_profile_provider.dart';
import 'package:base_app/providers/location_provider.dart';
import 'package:base_app/providers/myProfile_provider.dart';
import 'package:base_app/providers/pick_azan_methods_provider.dart';
import 'package:base_app/providers/pick_azan_shiekh_provider.dart';
import 'package:base_app/providers/pick_fajr_azan_shiekh_provider.dart';
import 'package:base_app/providers/settings_provider.dart';
import 'package:base_app/quran/quran_database/quran_dao.dart';
import 'package:base_app/ramadan/provider/ramadan_provider.dart';
import 'package:base_app/sebha_feature/offline_sebha/database/sebha_database.dart';
import 'package:base_app/singletons/azan_singleton.dart';
import 'package:base_app/singletons/ramadan_singleton.dart';
import 'package:base_app/utils/prefs.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

void setupLocator() async {
  locator.registerSingleton(RemoteConfigService());
  locator.registerLazySingleton(() => Prefs());
  locator.registerLazySingleton(() => ApiService());
  locator.registerLazySingleton(() => AzanSingleton());
  locator.registerLazySingleton(() => RamadanSingleton());
  locator.registerLazySingleton(() => SettingsApis());
  locator.registerLazySingleton(() => SebhaDataBase());

  locator.registerLazySingleton<QuranDao>(() => QuranDao());
  await locator<QuranDao>().initHive();

  locator.registerFactory(() => CompetitionProvider(null));
  locator.registerFactory(() => LocationProvider());
  locator.registerFactory(() => PickAzanMethodsProvider());
  locator.registerFactory(() => AzanProvider());
  locator.registerFactory(() => SettingsProvider());
  locator.registerFactory(() => PickAzanShiekhProvider());
  locator.registerFactory(() => RamadanProvider());
  locator.registerFactory(() => PickFajrAzanShiekhProvider());
  locator.registerFactory(() => EditProfileProvider());
  locator.registerFactory(() => ChangePasswordProvider());
  //locator.registerFactory(() => RatingProvider());
  locator.registerFactory(() => MyProfileProvider());
}
