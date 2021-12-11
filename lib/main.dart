import 'package:admob_flutter/admob_flutter.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:base_app/ads/ad_manager.dart';
import 'package:base_app/ads/admob_rectangle.dart';
import 'package:base_app/ads/load_ui_with_add.dart';
import 'package:base_app/azan_feature/controllers/azan_controller.dart';
import 'package:base_app/azkar_feature/providers/azkar_provider.dart';
import 'package:base_app/home_feature/controllers/home_controller.dart';
import 'package:base_app/locals_utils/language_constants.dart';
import 'package:base_app/providers/azan_fajr_sounds_provider.dart';
import 'package:base_app/providers/azan_sounds_provider.dart';
import 'package:base_app/providers/user_provider.dart';
import 'package:base_app/quran/provider/quran_pages_pic_bloc.dart';
import 'package:base_app/quran/provider/quran_provider.dart';
import 'package:base_app/ramadan/provider/ramadan_provider.dart';
import 'package:base_app/sebha_feature/online_sebha/controllers/online_sebha_controller.dart';
import 'package:base_app/sebha_feature/providers/sebha_provider.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/prefs.dart';
import 'package:base_app/utils/sailor.dart';
import 'package:base_app/utils/sizing_info_extension.dart';
import 'package:base_app/views/splash_view/splash_view.dart';
import 'package:base_app/views/start_view/start_view.dart';
import 'package:connectivity_wrapper/connectivity_wrapper.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:fancy_dialog/FancyGif.dart';
import 'package:fancy_dialog/fancy_dialog.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderScope;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'islamic_feature/bloc/islamic_post_details_bloc.dart';
import 'locals_utils/app_localizations.dart';
import 'models/banner_names_enum.dart';
import 'utils/Constants.dart';
import 'utils/locator.dart';

const String LAGUAGE_CODE = 'languageCode';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _initAdMob();
  await AndroidAlarmManager.initialize();
  AdManager.remoteConfig = await setupRemoteConfig();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  Routes.createRoutes();
  setupLocator();
  await locator<Prefs>().setSharedPreferences();
  Locale loaded = await getLocale();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  FacebookAudienceNetwork.init();
  runApp(
    ProviderScope(child: MyApp()), // Wrap your app
  );
}

_initAdMob() {
  Admob.initialize();
  MobileAds.instance.initialize();
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
    //print(exception);
  } catch (exception) {
    print('Unable to fetch remote config. Cached or default values will be '
        'used');
  }
  return remoteConfig;
}

class MyApp extends StatefulWidget {
  // Locale localeLoadedd;
  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  static bool loading = false;
  static bool loadingAddMobe = false;

  // MyApp(this.localeLoadedd);

  static Future setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }

  static void _launchURL() async {
    if (!await launch(
        "https://play.google.com/store/apps/details?id=com.muslim_book.muslim_book"))
      print('Could not launch');
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
            child: LoadUiWithAdd(
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
                    AppLocalizations.of(context).translate("are_you_sure_exit"),
                    style: TextStyle(
                      fontSize: sizeConfig.blockSizeHorizontal * 5,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                    child: Container(child: AdMobRectangle(BannerName.Top))),
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
                          if(locator<Prefs>().getDateOfClickLike() == null &&
                              locator<Prefs>().getDateOfClickNotLike() == null){
                            _showRateAppDialog(context);
                          }
                          if (locator<Prefs>().getDateOfClickLike() !=
                              null) {
                            DateTime before = DateTime.fromMillisecondsSinceEpoch(
                                locator<Prefs>().getDateOfClickLike());
                            DateTime now = DateTime.now();
                            Duration timeDifference = now.difference(before);
                            print(timeDifference.inDays);

                              if (timeDifference != null) {
                                  if ((timeDifference.inDays >= 30 && locator<Prefs>().getCountOfClickLike() == 1)  ||
                                      (timeDifference.inDays >= 90 && locator<Prefs>().getCountOfClickLike() == 2)) {
                                    _showRateAppDialog(context);
                                  } else {
                                    SystemNavigator.pop();
                                  }
                              }else{
                                SystemNavigator.pop();
                              }
                          }
                          if (locator<Prefs>().getDateOfClickNotLike() !=
                              null) {
                            DateTime before = DateTime.fromMillisecondsSinceEpoch(
                                locator<Prefs>().getDateOfClickLike());
                            DateTime now = DateTime.now();
                            Duration timeDifference = now.difference(before);
                            print(timeDifference.inDays);

                            if (timeDifference != null) {
                                if ((timeDifference.inDays >= 15 && locator<Prefs>().getCountOfClickNotLike() == 1) ||
                                    (timeDifference.inDays >= 30 && locator<Prefs>().getCountOfClickNotLike() == 2) ||
                                    (timeDifference.inDays >= 45 && locator<Prefs>().getCountOfClickNotLike() == 3)) {
                                  _showRateAppDialog(context);
                                } else {
                                  SystemNavigator.pop();
                                }
                            }else{
                              SystemNavigator.pop();
                            }
                          }
                        },
                        fillColor: Theme.of(context).primaryColor,
                        child: Text(
                          AppLocalizations.of(context).translate("yes"),
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
                        fillColor: Theme.of(context).accentColor,
                        child: Text(
                          AppLocalizations.of(context).translate("cancel"),
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
          title: "شكراً لإستخدامك مسلم بوك",
          descreption:
          "سوف نكون ممتنين جداً إذا أضفت تعليق جيد على البرنامج فذلك يساعدنا على تطوير البرنامج مجانا للمسلمين و نشره على سوق الأندرويد بين الدول الإسلامية\n\n",
          okColor: Theme.of(context).primaryColor,
          okFun: () async {
            if(locator<Prefs>().getDateOfClickNotLike() == null){
              await locator<Prefs>().setDateOfClickNotLike(DateTime.now().millisecondsSinceEpoch);
              await locator<Prefs>().setCountOfClickNotLike(1);
            }else{
              if(locator<Prefs>().getCountOfClickNotLike() != null){
                await locator<Prefs>().setCountOfClickNotLike(locator<Prefs>().getCountOfClickNotLike()+1);
              }
            }
            SystemNavigator.pop();
          },
          cancelFun: () async {
            if(locator<Prefs>().getDateOfClickLike() == null){
              await locator<Prefs>().setDateOfClickLike(DateTime.now().millisecondsSinceEpoch);
              await locator<Prefs>().setCountOfClickLike(1);
            }else{
              if(locator<Prefs>().getCountOfClickLike() != null){
                await locator<Prefs>().setCountOfClickLike(locator<Prefs>().getCountOfClickLike()+1);
              }
            }
            _launchURL();
            SystemNavigator.pop();
          },
          gifPath: FancyGif.SUBMIT,
          cancelColor:
          Theme.of(context).primaryColor,
          cancel: "أعجبنى",
          ok: "لم يعجبني",
        ));
  }
}

class _MyAppState extends State<MyApp> {
  AzanController _azanController = Get.put(AzanController());
  HomeController _homeController = Get.put(HomeController());
  String showCompetition, openAzkar;
  var checkOverLay;
  Locale localeLoaded;

  @override
  void initState() {
    super.initState();
    invokeMethod();
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
      message = e.message;
    }
    return message;
  }

  loadLocal() async {
    Locale loaded = await getLocale();
    localeLoaded = loaded;
  }

  @override
  Widget build(BuildContext context) {
    loadLocal();
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
            return AppLocalizations.of(context).translate("muslim_book");
          },
          debugShowCheckedModeBanner: false,
          supportedLocales: [
            const Locale("ar"),
            const Locale("en"),
            const Locale("fr")
          ],
          locale: localeLoaded,
          navigatorObservers: <NavigatorObserver>[MyApp.observer],
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            AppLocalizations.delegate, // Add this line
          ],
          builder: (BuildContext context, Widget child) {
            //print("shaimmmmmmmmmmmmmmmaaaa 2   " + localeLoaded.languageCode);

            return new Directionality(
              textDirection: setTextDirection(localeLoaded),
              child: child,
            );
          },
          localeResolutionCallback: (locale, supportedLocales) {
            return localeLoaded;
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
