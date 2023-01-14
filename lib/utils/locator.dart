import 'package:muslim_book/network_utils/api_service.dart';
import 'package:muslim_book/network_utils/remote_config.dart';
import 'package:muslim_book/network_utils/settings_apis.dart';
import 'package:muslim_book/providers/azan_provider.dart';
import 'package:muslim_book/providers/changePassword_provider.dart';
import 'package:muslim_book/providers/competition_provider.dart';
import 'package:muslim_book/providers/edit_profile_provider.dart';
import 'package:muslim_book/providers/location_provider.dart';
import 'package:muslim_book/providers/myProfile_provider.dart';
import 'package:muslim_book/providers/pick_azan_methods_provider.dart';
import 'package:muslim_book/providers/pick_azan_shiekh_provider.dart';
import 'package:muslim_book/providers/pick_fajr_azan_shiekh_provider.dart';
import 'package:muslim_book/providers/settings_provider.dart';
import 'package:muslim_book/quran/quran_database/quran_dao.dart';
import 'package:muslim_book/ramadan/provider/ramadan_provider.dart';
import 'package:muslim_book/sebha_feature/offline_sebha/database/sebha_database.dart';
import 'package:muslim_book/singletons/azan_singleton.dart';
import 'package:muslim_book/singletons/ramadan_singleton.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
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
