import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:muslim_book/firebase_options.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:muslim_book/utils/sailor.dart';

import 'ads/ad_manager.dart';

void _passErrorsToCrashlytics() {
  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
}

Future<void> _initAdMob() async {
  // Admob.initialize();
  MobileAds.instance.initialize();
}

Future<FirebaseRemoteConfig> _setupRemoteConfig() async {
  final remoteConfig = FirebaseRemoteConfig.instance;
  remoteConfig.setDefaults(<String, dynamic>{
    'down_Competition_1': 'ca-app-pub-8586064191208277/2234874389',
    'Sabha': 'ca-app-pub-8586064191208277/9405322350',
    'Azkar': 'ca-app-pub-8586064191208277/2234874389',
    'Bosla': 'ca-app-pub-8586064191208277/2234874389',
    'Down_Edit_Azan': 'ca-app-pub-8586064191208277/6219411880',
    'down_start_Competition': 'ca-app-pub-8586064191208277/4415375627',
    'Top': 'ca-app-pub-8586064191208277/5354527555',
    'The_middle_of_the_competition': 'ca-app-pub-8586064191208277/2784204532',
  });
  try {
    // Using default duration to force fetching from remote server.
    await remoteConfig.fetch(
      // expiration: const Duration(seconds: 0),
    );
    await remoteConfig.fetchAndActivate();
  } catch (exception) {
    if (kDebugMode) {
      print('Unable to fetch remote config. Cached or default values will be '
          'used');
    }
  }
  return remoteConfig;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  AdManager.remoteConfig = await _setupRemoteConfig();

  /// Catch errors via Crashlytics
  _passErrorsToCrashlytics();

  /// Ads
  _initAdMob();

  /// Make App Portrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// Init App Routes
  Routes.createRoutes();

  /// Get it Singletons
  await setupLocator();
  await locator<Prefs>().setSharedPreferences();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  await FacebookAudienceNetwork.init();
  // final loaded = await getLocale();

  runApp(
    const ProviderScope(child: MyAppT(),), // Wrap your app
  );
}

class MyAppT extends StatefulWidget {
  const MyAppT({Key? key}) : super(key: key);

  @override
  State<MyAppT> createState() => _MyAppTState();
}

class _MyAppTState extends State<MyAppT> {
  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(child: Text('Hello')),
      ),
    );
  }
}
