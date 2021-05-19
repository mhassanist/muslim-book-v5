import 'package:admob_flutter/admob_flutter.dart';
// import 'package:alice/alice.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:base_app/ads/ad_manager.dart';
import 'package:base_app/azan_feature/controllers/azan_controller.dart';
import 'package:base_app/azkar_feature/providers/azkar_provider.dart';
import 'package:base_app/home_feature/controllers/home_controller.dart';
import 'package:base_app/providers/azan_fajr_sounds_provider.dart';
import 'package:base_app/providers/azan_sounds_provider.dart';
import 'package:base_app/providers/user_provider.dart';
import 'package:base_app/quran/provider/quran_provider.dart';
import 'package:base_app/ramadan/provider/ramadan_provider.dart';
import 'package:base_app/sebha_feature/online_sebha/controllers/online_sebha_controller.dart';
import 'package:base_app/sebha_feature/providers/sebha_provider.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/prefs.dart';
import 'package:base_app/utils/sailor.dart';
import 'package:base_app/views/splash_view/splash_view.dart';
import 'package:base_app/views/start_view/start_view.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
// import 'package:device_preview/device_preview.dart' show DevicePreview;
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'locals_utils/app_localizations.dart';
import 'utils/Constants.dart';
import 'utils/locator.dart';
// Alice alice = Alice(showNotification: true ,navigatorKey:  Routes.sailor.navigatorKey);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Constants.platform.invokeMethod("fireAzan");
  await Constants.platform.invokeMethod("fireCannonRamadan");
  await Constants.platform.invokeMethod("fireMshartRamadan");
  _initAdMob();

  await AndroidAlarmManager.initialize();
  AdManager.remoteConfig = await setupRemoteConfig();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Routes.createRoutes();
  setupLocator();

  await locator<Prefs>().setSharedPreferences();
  Crashlytics.instance.enableInDevMode = true;
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  FacebookAudienceNetwork.init();
  runApp(
    // DevicePreview(
    //   enabled: false,
    //   // enabled: !kReleaseMode,
    //   builder: (context) =>
          MyApp(), // Wrap your app
    // ),
  );
}

_initAdMob() {
  Admob.initialize();
}

Future<RemoteConfig> setupRemoteConfig() async {
  await Firebase.initializeApp();
  RemoteConfig remoteConfig = await RemoteConfig.instance;
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
    await remoteConfig.fetch(expiration: const Duration(seconds: 0));
    await remoteConfig.activateFetched();
  } on FetchThrottledException catch (exception) {
    // Fetch throttled.
    print(exception);
  } catch (exception) {
    print('Unable to fetch remote config. Cached or default values will be '
        'used');
  }
  return remoteConfig;
}

class MyApp extends StatefulWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
  FirebaseAnalyticsObserver(analytics: analytics);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AzanController _azanController = Get.put(AzanController());
  final HomeController _homeController = Get.put(HomeController());
  String showCompetition, openAzkar;

  @override
  void initState() {
    invokeMethod();
    super.initState();
  }
  //ramadan_time shaimaaaaaaaaaaaaaa
  Future invokeMethod() async {
    await Constants.platform.invokeMethod("fireAzan");
    await Constants.platform.invokeMethod("fireCannonRamadan");
    await Constants.platform.invokeMethod("fireMshartRamadan");
    await Constants.platform.invokeMethod(Constants.FIRE_COMPETITION_POP_UP);
    await Constants.platform.invokeMethod("fireAzkarPopUp");
    await receiveMessage();
  }

  Future<String> receiveMessage() async {
    String message = '';
    try {
      showCompetition =
      await Constants.platform.invokeMethod(Constants.Open_Competition);
      openAzkar = await Constants.platform.invokeMethod(Constants.open_Azkar);
    } on PlatformException catch (e) {
      message = e.message;
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider<QuranProvider>(
          create: (_) => QuranProvider(),
        ),
        ChangeNotifierProvider<RamadanProvider>(
          create: (_) => RamadanProvider(),
        ),
        ChangeNotifierProvider<AzkarProvider>(
          create: (_) => AzkarProvider(),
        ),
        ChangeNotifierProvider<SebhaProvider>(
          create: (_) => SebhaProvider(),
        ),
        ChangeNotifierProvider<AzanSoundsProvider>(
          create: (_) => AzanSoundsProvider(),
        ),
        ChangeNotifierProvider<AzanFairSoundsProvider>(
          create: (_) => AzanFairSoundsProvider(),
        ),
        ChangeNotifierProvider<OnlineSebhaProvider>(
            create: (_) => OnlineSebhaProvider()),
        // ChangeNotifierProxyProvider<UserProvider, OnlineSebhaProvider>(
        // create: (_) => OnlineSebhaProvider(null),
        // update: (_, userProvider, __) => OnlineSebhaProvider(userProvider),
        // ),
      ],
      child: ConnectivityAppWrapper(
        app: GetMaterialApp(
          title: 'مسلم بوك',
          debugShowCheckedModeBanner: false,
          supportedLocales: [
            Locale("ar"),
            Locale("en"),
          ],
          // navigatorKey: alice.getNavigatorKey(),
          navigatorObservers: <NavigatorObserver>[MyApp.observer],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate
          ],
          builder: (BuildContext context, Widget child) {
            return new Directionality(
              textDirection: TextDirection.rtl,
              child: child,
            );
          },
            localeResolutionCallback: (local, supportedLocals) {
            print("shimaaa_local " +supportedLocals.first.languageCode);
            return supportedLocals.first;
          },
          theme: ThemeData(
            textTheme: GoogleFonts.almaraiTextTheme(
              Theme.of(context).textTheme,
            ),
            primarySwatch: Colors.blue,
            accentColor: Constants.ACCENT_COLOR,
            primaryColor: Constants.PRIMARY_COLOR,
            primaryColorDark: Constants.PRIMARY_DARK_COLOR,
            canvasColor: Constants.CANVAS_COLOR,
          ),
          home: showCompetition != null ||  openAzkar != null ? StartView() : SplashView(),
          navigatorKey: Routes.sailor.navigatorKey,
          onGenerateRoute: Routes.sailor.generator(),
        ),
      ),
    );
  }
}
