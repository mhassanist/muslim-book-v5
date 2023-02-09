import 'dart:ui';

// import 'package:admob_flutter/admob_flutter.dart';
import 'package:audio_service/audio_service.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:fancy_dialog/FancyGif.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:muslim_book/ads/admob_rectangle.dart';
import 'package:muslim_book/ads/admob_rectangle_updated.dart';
import 'package:muslim_book/ads/load_ui_with_add.dart';
import 'package:muslim_book/azkar_feature/providers/azkar_provider.dart';
import 'package:muslim_book/firebase_options.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/models/banner_names_enum.dart';
import 'package:muslim_book/providers/azan_fajr_sounds_provider.dart';
import 'package:muslim_book/providers/azan_sounds_provider.dart';
import 'package:muslim_book/providers/user_provider.dart';
import 'package:muslim_book/quran/provider/quran_pages_pic_bloc.dart';
import 'package:muslim_book/quran/provider/quran_provider.dart';
import 'package:muslim_book/quran/utils/quran_audio_handler.dart';
import 'package:muslim_book/ramadan/provider/ramadan_provider.dart';
import 'package:muslim_book/sebha_feature/online_sebha/controllers/online_sebha_controller.dart';
import 'package:muslim_book/sebha_feature/providers/sebha_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/palette.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:muslim_book/utils/sailor.dart';
import 'package:muslim_book/utils/sizing_info_extension.dart';
import 'package:muslim_book/views/splash_view/splash_view.dart';
import 'package:muslim_book/views/start_view/start_view.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ads/ad_manager.dart';
import 'azan_feature/controllers/azan_controller.dart';
import 'home_feature/controllers/home_controller.dart';
import 'islamic_feature/bloc/islamic_post_details_bloc.dart';
import 'locals_utils/language_constants.dart';

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

late AudioHandler _audioHandler; // singleton.

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AdManager.remoteConfig = await _setupRemoteConfig();

  /// Catch errors via Crashlytics
  _passErrorsToCrashlytics();

  QuranAudioHandler().initialize();

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
    ProviderScope(
      child: MyApp(localeLoaded: await getLocale()),
    ), // Wrap your app
  );
}

class MyApp extends StatefulWidget {
  final Locale localeLoaded;
  // static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  // static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
  static bool loading = false;
  static bool loadingAddMobe = false;

  const MyApp({
    super.key,
    required this.localeLoaded,
  });

  static Future setLocale(BuildContext context, Locale newLocale) async {
    final state = context.findAncestorStateOfType<_MyAppState>();
    if (state != null) {
      state.setLocale(newLocale);
    }
  }

  static void _launchURL() async {
    if (!await launchUrl(
      Uri.parse(
          'https://play.google.com/store/apps/details?id=com.muslim_book.muslim_book'),
      mode: LaunchMode.externalApplication,
    )) print('Could not launch');
  }

  static Future<Widget> exitBottomSheet(context) async {
    return await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ResponsiveBuilder(builder: (context, sizeConfig) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.55,
          decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(25.0),
              topRight: const Radius.circular(25.0),
            ),
          ),
          child: Center(
            child: LoadUiWithAd(
              mainView: Column(children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                  width: MediaQuery.of(context).size.width,
                  decoration: new BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate("are_you_sure_exit"),
                    style: TextStyle(
                      fontSize: sizeConfig.blockSizeHorizontal * 5,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                    child: Container(
                        child:
                            AdmobRectangleUpdated(bannerName: BannerName.Top))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: sizeConfig.blockSizeHorizontal * 30,
                      height: sizeConfig.blockSizeVertical * 6,
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: RawMaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              sizeConfig.blockSizeVertical),
                        ),
                        onPressed: () {
                          if (locator<Prefs>().getDateOfClickLike() == null &&
                              locator<Prefs>().getDateOfClickNotLike() ==
                                  null) {
                            _showRateAppDialog(context);
                          } else {
                            if (locator<Prefs>().getCountOfOpenDialog() == 3) {
                              SystemNavigator.pop();
                            } else {
                              if (locator<Prefs>().getDateOfClickLike() !=
                                      null &&
                                  locator<Prefs>().getDateOfClickNotLike() ==
                                      null) {
                                DateTime before =
                                    DateTime.fromMillisecondsSinceEpoch(
                                  locator<Prefs>().getDateOfClickLike() ?? 0,
                                );
                                DateTime now = DateTime.now();
                                Duration timeDifference =
                                    now.difference(before);
                                print(timeDifference.inDays);

                                if (timeDifference != null) {
                                  if ((timeDifference.inDays >= 30 &&
                                          locator<Prefs>()
                                                  .getCountOfClickLike() ==
                                              1) ||
                                      (timeDifference.inDays >= 90 &&
                                          locator<Prefs>()
                                                  .getCountOfClickLike() ==
                                              2)) {
                                    _showRateAppDialog(context);
                                  } else {
                                    SystemNavigator.pop();
                                  }
                                } else {
                                  SystemNavigator.pop();
                                }
                              } else if (locator<Prefs>()
                                          .getDateOfClickNotLike() !=
                                      null &&
                                  locator<Prefs>().getDateOfClickLike() ==
                                      null) {
                                DateTime before =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        locator<Prefs>()
                                                .getDateOfClickNotLike() ??
                                            0);
                                DateTime now = DateTime.now();
                                Duration timeDifference =
                                    now.difference(before);
                                print(timeDifference.inDays);

                                if (timeDifference != null) {
                                  if ((timeDifference.inDays >= 15 && locator<Prefs>().getCountOfClickNotLike() == 1) ||
                                      (timeDifference.inDays >= 30 &&
                                          locator<Prefs>()
                                                  .getCountOfClickNotLike() ==
                                              2) ||
                                      (timeDifference.inDays >= 45 &&
                                          locator<Prefs>()
                                                  .getCountOfClickNotLike() ==
                                              3)) {
                                    _showRateAppDialog(context);
                                  } else {
                                    SystemNavigator.pop();
                                  }
                                } else {
                                  SystemNavigator.pop();
                                }
                              } else if (locator<Prefs>()
                                          .getDateOfClickLike() !=
                                      null &&
                                  locator<Prefs>().getDateOfClickNotLike() !=
                                      null) {
                                DateTime dateOfLike =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        locator<Prefs>().getDateOfClickLike() ??
                                            0);
                                DateTime now = DateTime.now();
                                Duration likeTimeDifference =
                                    now.difference(dateOfLike);
                                print(likeTimeDifference.inDays);

                                DateTime dateOfNotLike =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        locator<Prefs>()
                                                .getDateOfClickNotLike() ??
                                            0);
                                DateTime dateOfNotLikeNow = DateTime.now();
                                Duration notLikeTimeDifference =
                                    dateOfNotLikeNow.difference(dateOfNotLike);
                                print(notLikeTimeDifference.inDays);

                                if (locator<Prefs>().getCountOfClickLike() ==
                                        1 &&
                                    locator<Prefs>().getCountOfClickNotLike() ==
                                        1) {
                                  if (likeTimeDifference.inDays >= 30 &&
                                      notLikeTimeDifference.inDays >= 15) {
                                    _showRateAppDialog(context);
                                  } else if (notLikeTimeDifference.inDays >=
                                      15) {
                                    _showRateAppDialog(context);
                                  } else {
                                    SystemNavigator.pop();
                                  }
                                } else if (locator<Prefs>()
                                            .getCountOfClickLike() ==
                                        2 &&
                                    locator<Prefs>().getCountOfClickNotLike() ==
                                        1) {
                                  if (likeTimeDifference.inDays >= 90 &&
                                      notLikeTimeDifference.inDays >= 30) {
                                    _showRateAppDialog(context);
                                  } else if (notLikeTimeDifference.inDays >=
                                      30) {
                                    _showRateAppDialog(context);
                                  } else {
                                    SystemNavigator.pop();
                                  }
                                } else if (locator<Prefs>()
                                            .getCountOfClickLike() ==
                                        1 &&
                                    locator<Prefs>().getCountOfClickNotLike() ==
                                        2) {
                                  if (likeTimeDifference.inDays >= 30) {
                                    _showRateAppDialog(context);
                                  } else if (notLikeTimeDifference.inDays >=
                                      30) {
                                    _showRateAppDialog(context);
                                  } else {
                                    SystemNavigator.pop();
                                  }
                                }
                              }
                            }
                          }
                        },
                        fillColor: Theme.of(context).primaryColor,
                        child: Text(
                          AppLocalizations.of(context)!.translate("yes"),
                          style: TextStyle(
                            fontSize: sizeConfig.blockSizeHorizontal * 6,
                            color: Constants.CANVAS_COLOR,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: sizeConfig.blockSizeHorizontal * 30,
                      height: sizeConfig.blockSizeVertical * 6,
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: RawMaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              sizeConfig.blockSizeVertical),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        fillColor: Theme.of(context).colorScheme.secondary,
                        child: Text(
                          AppLocalizations.of(context)!.translate("cancel"),
                          style: TextStyle(
                            fontSize: sizeConfig.blockSizeHorizontal * 6,
                            color: Constants.CANVAS_COLOR,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ]),
            ),
          ),
        );
      }),
    );
  }

  @override
  _MyAppState createState() => _MyAppState();

  static void _showRateAppDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => FancyDialog(
        title: AppLocalizations.of(context)!.translate("thanx_to_use_app"),
        description:
            AppLocalizations.of(context)!.translate("rate_app_description"),
        okColor: Theme.of(context).primaryColor,
        okFun: () async {
          if (locator<Prefs>().getCountOfOpenDialog() == null) {
            await locator<Prefs>().setCountOfOpenDialog(1);
          } else {
            await locator<Prefs>().setCountOfOpenDialog(
                (locator<Prefs>().getCountOfOpenDialog() ?? 0) + 1);
          }
          if (locator<Prefs>().getDateOfClickNotLike() == null) {
            await locator<Prefs>()
                .setDateOfClickNotLike(DateTime.now().millisecondsSinceEpoch);
            await locator<Prefs>().setCountOfClickNotLike(1);
          } else {
            if (locator<Prefs>().getCountOfClickNotLike() != null) {
              await locator<Prefs>().setCountOfClickNotLike(
                  (locator<Prefs>().getCountOfClickNotLike() ?? 0) + 1);
            }
          }
          SystemNavigator.pop();
        },
        cancelFun: () async {
          if (locator<Prefs>().getCountOfOpenDialog() == null) {
            await locator<Prefs>().setCountOfOpenDialog(1);
          } else {
            await locator<Prefs>().setCountOfOpenDialog(
                (locator<Prefs>().getCountOfOpenDialog() ?? 0) + 1);
          }
          if (locator<Prefs>().getDateOfClickLike() == null) {
            await locator<Prefs>()
                .setDateOfClickLike(DateTime.now().millisecondsSinceEpoch);
            await locator<Prefs>().setCountOfClickLike(1);
          } else {
            if (locator<Prefs>().getCountOfClickLike() != null) {
              await locator<Prefs>().setCountOfClickLike(
                  (locator<Prefs>().getCountOfClickLike() ?? 0) + 1);
            }
          }
          _launchURL();
          SystemNavigator.pop();
        },
        gifPath: FancyGif.SUBMIT,
        cancelColor: Theme.of(context).primaryColor,
        cancel: AppLocalizations.of(context)!.translate("like"),
        ok: AppLocalizations.of(context)!.translate("not_like"),
      ),
    );
  }
}

class _MyAppState extends State<MyApp> {
  AzanController _azanController = Get.put(AzanController());
  HomeController _homeController = Get.put(HomeController());
  String? showCompetition;
  String? openAzkar;
  var checkOverLay;
  late Locale localeLoaded;

  @override
  void initState() {
    super.initState();
    // invokeMethod();
    localeLoaded = widget.localeLoaded;
    // WidgetsBinding.instance.addPostFrameCallback((_) => invokeMethod());
    SchedulerBinding.instance.addPostFrameCallback((_) => invokeMethod());
  }

  setLocale(Locale _locale) {
    getLocale().then((locale) {
      //print("shaimmmmmmmmmmmmmmmaaaa 2  " + locale.languageCode);
      setState(() {
        localeLoaded = locale;
      });
    });
  }

  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      //print("shaimmmmmmmmmmmmmmmaaaa 3   " + locale.languageCode);
      setState(() {
        localeLoaded = locale;
      });
    });
    super.didChangeDependencies();
  }

  Future invokeMethod() async {
    await Constants.platform.invokeMethod("fireAzan");
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
      checkOverLay = await Constants.platform.invokeMethod("checkOverlay");
    } on PlatformException catch (e) {
      message = e.message ?? '';
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
        ChangeNotifierProvider<IslamicPostDetailsBloc>(
            create: (_) => IslamicPostDetailsBloc()),
        ChangeNotifierProvider<QuranPagesPicBloc>(
            create: (_) => QuranPagesPicBloc()),
      ],
      child: ConnectivityAppWrapper(
        app: GetMaterialApp(
          onGenerateTitle: (context) {
            return AppLocalizations.of(context)!.translate("muslim_book");
          },
          debugShowCheckedModeBanner: false,
          // supportedLocales: [
          //   const Locale("ar"),
          //   const Locale("en"),
          //   const Locale("fr")
          // ],
          // supportedLocales: AppLocalizations.supportedLocales,
          supportedLocales: [Locale('en'), Locale('ar'), Locale('fr')],
          locale: localeLoaded,
          // navigatorObservers: <NavigatorObserver>[MyApp.observer],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate, // Add this line
          ],
          builder: (BuildContext context, Widget? child) {
            //print("shaimmmmmmmmmmmmmmmaaaa 2   " + localeLoaded.languageCode);

            return Directionality(
              textDirection: setTextDirection(localeLoaded ?? Locale('ar')),
              child: child ?? Container(),
            );
          },
          localeResolutionCallback: (locale, supportedLocales) {
            return localeLoaded;
          },
          theme: ThemeData(
            textTheme: GoogleFonts.almaraiTextTheme(
              Theme.of(context).textTheme,
            ),
            primarySwatch: Palette.kToDark,
            // accentColor: Constants.ACCENT_COLOR,  (Depricated)
            primaryColor: Constants.PRIMARY_COLOR,
            primaryColorDark: Constants.PRIMARY_DARK_COLOR,
            canvasColor: Constants.CANVAS_COLOR,
          ).copyWith(
            colorScheme: ThemeData().colorScheme.copyWith(
                secondary: Constants.ACCENT_COLOR,
                primary: Constants.PRIMARY_COLOR),
          ),

          home: checkOverLay != null
              ? showCompetition != null || openAzkar != null
                  ? StartView()
                  : SplashView()
              : SplashView(),
          navigatorKey: Routes.sailor.navigatorKey,
          onGenerateRoute: Routes.sailor.generator(),
        ),
      ),
    );
  }
}

// lib/network_utils/ApiService (getTasbeehList, getTopSebha, getSebhaProfile)
// lib/ramadan/widgets/ayah_widget
// lib/ramadan/widgets/surah_widget
// lib/quran/widgets/ayah_widget
// lib/quran/widgets/surah_widget
