import 'dart:convert';
import 'dart:ui';

// import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:disable_battery_optimization/disable_battery_optimization.dart';
// import 'package:easy_audience_network/easy_audience_network.dart';
import 'package:muslim_book/ads/admob_interstitial.dart';
import 'package:muslim_book/azkar_feature/screens/azkar_categories_grid_screen.dart';
import 'package:muslim_book/core/push_notification_service.dart';
import 'package:muslim_book/home_feature/controllers/home_controller.dart';
import 'package:muslim_book/home_feature/views/home_view.dart';
import 'package:muslim_book/islamic_feature/views/islamic_post_details_from_notification.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/main.dart';
import 'package:muslim_book/models/push_notification_model.dart';
import 'package:muslim_book/network_utils/remote_config.dart';
import 'package:muslim_book/providers/user_provider.dart';
import 'package:muslim_book/quran/views/quran_section_screen.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:muslim_book/views/azan_settings_views/adjust_battery_view.dart';
import 'package:muslim_book/views/compass_view/compass_view.dart';
import 'package:muslim_book/views/competition_view/competition_view.dart';
import 'package:muslim_book/views/login_pop_up_view/login_pop_up_view.dart';
import 'package:muslim_book/widgets/SideDrawerMenu_widget.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:launch_review/launch_review.dart';
import 'package:provider/provider.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../utils/sizing_info_extension.dart';

class StartViewMobilePortraitView extends StatefulWidget {
  @override
  _StartViewMobilePortraitViewState createState() =>
      _StartViewMobilePortraitViewState();
}

class _StartViewMobilePortraitViewState
    extends State<StartViewMobilePortraitView> with WidgetsBindingObserver {
  List<Widget> _pages = [];
  bool isAdd = false;
  late FirebaseRemoteConfig remoteConfig;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  NotificationData data = NotificationData();

  @override
  void initState() {
    /// TODO: Need to fix crash
    /// Null check operator used on a null value
    /// https://console.firebase.google.com/project/muslim-book-ab937/crashlytics/app/android:com.muslim_book.muslim_book/issues/47ca52f70117154164fdd5e218968ae4?time=last-seven-days&types=crash&versions=4.5.9%20(86);4.5.9%20(85)&sessionEventKey=65FA6BD5029B00167A97ECE83220EF99_1926750034962515725
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await PushNotificationService().initialise();
      await PushNotificationService().initNotification(context);

      invokeMethod();

      final notificationAppLaunchDetails = await flutterLocalNotificationsPlugin
          .getNotificationAppLaunchDetails();
      if (notificationAppLaunchDetails != null &&
          notificationAppLaunchDetails.didNotificationLaunchApp == true) {
        Map<String, dynamic> dataa = jsonDecode(
            notificationAppLaunchDetails.notificationResponse!.payload!);
        String postId = dataa["post_id"];
        String catName = dataa["cat_name"];
        String catId = dataa["cat_id"];
        data.postId = postId;
        data.catName = catName;
        data.catId = catId;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    IslamicPostDetailsFromNotification(data)));
      }
    });
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    Get.find<HomeController>().scaffoldKey = key;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Constants.PRIMARY_DARK_COLOR,
    ));
    check();
    checkPermissions();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    check();
    switch (state) {
      case AppLifecycleState.resumed:
        check();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future invokeMethod() async {
    try {
      await Constants.platform.invokeMethod("fireAzan");
      await Constants.platform.invokeMethod(Constants.FIRE_COMPETITION_POP_UP);
      await Constants.platform.invokeMethod("fireAzkarPopUp");
      await Constants.platform.invokeMethod(Constants.Open_Competition);
      await Constants.platform.invokeMethod(Constants.open_Azkar);
      await Constants.platform.invokeMethod("checkOverlay");
    } catch (e) {
      e.printError();
      // message = e.toString();
    }
  }

  check() async {
    var showCompetition =
        await Constants.platform.invokeMethod(Constants.Open_Competition);
    // List<dynamic> phoneNumbersList = await Constants.platform
    //    .invokeMethod(Constants.FIRE_COMPETITION_POP_UP);
    await Constants.platform.invokeMethod(Constants.FIRE_COMPETITION_POP_UP);
    if (showCompetition != null) {
      Provider.of<UserProvider>(context, listen: false).selectedPage = 3;
    }
    var openAzkar = await Constants.platform.invokeMethod(Constants.open_Azkar);
    if (openAzkar != null) {
      Provider.of<UserProvider>(context, listen: false).selectedPage = 4;
    }
  }

  checkPermissions() async {
    bool? checkBattery = await DisableBatteryOptimization.isBatteryOptimizationDisabled;
    if (checkBattery != null && !checkBattery) {
      Get.dialog(const AdjustBatteryView(isStart: false));
      setState(() {
        isAdd = true;
      });
    }
  }

  final GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _pages = [
      QuranSectionScreen(),
      CompassView(),
      HomeView(),
      Provider.of<UserProvider>(context).isLoggedIn
          ? CompetitionView()
          : LoginPopUpView(),
      AzkarCategoriesGridScreen(),
    ];
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        // canPop: false also blocks the drawer's own back handling, so Back
        // asked to exit the app with the side menu still open
        if (key.currentState?.isDrawerOpen ?? false) {
          key.currentState!.closeDrawer();
          return;
        }
        // Every PopScope in the route is notified (unlike WillPopScope), so let
        // the competition tab's own confirmation handle back while it's shown
        if (_isCompetitionTabShown()) return;
        if (await _onWillPop() && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        // appBar: AppBar(
        //   actions: [
        //
        //     Icon(Icons.favorite),
        //     Padding(
        //       padding: EdgeInsets.symmetric(horizontal: 16),
        //       child: Icon(Icons.search),
        //     ),
        //   ],
        // ),

        drawer: SideDrawerMenu(
          context,
        ).buildDrawer(),
        key: key,
        // body: Container(),
        body: Stack(
          children: <Widget>[
            Container(
                width: double.infinity,
                child: _pages[Provider.of<UserProvider>(context).selectedPage]),
            // SafeArea(
            //   child: Container(
            //     height: kToolbarHeight,
            //     child: ResponsiveBuilder(builder: (context, sizeConfig) {
            //       return appBar(
            //         context,
            //         sizeConfig,
            //         _pagesNames[
            //             Provider.of<UserProvider>(context).selectedPage],
            //         backgroundColor: getPageColor(context)[
            //             Provider.of<UserProvider>(context).selectedPage],
            //         key: key,
            //       );
            //     }),
            //   ),
            // ),
          ],
        ),

        bottomNavigationBar: ResponsiveBuilder(
          builder: (_, sizeConfig) => BottomNavigationBar(
            onTap: (position) async {
              if (position == 0) {
                if (locator<Prefs>().getIsFirstTime()) {
                  Navigator.pushNamed(context, "/pick_country_view");
                } else {
                  Provider.of<UserProvider>(context, listen: false)
                      .selectedPage = 0;
                }
              } else {
                onPageChanged(position);
              }
            },
            type: BottomNavigationBarType.fixed,
            items: navigationItems(context, sizeConfig),
            backgroundColor: Theme.of(context).primaryColorDark,
            //showUnselectedLabels: false,
            selectedItemColor: Constants.CANVAS_COLOR,
            currentIndex: Provider.of<UserProvider>(context).selectedPage,
            unselectedItemColor: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }

  Drawer sideNav() {
    return Drawer(
        child: Stack(children: <Widget>[
      //first child be the blur background
      BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          //this is dependent on the import statment above
          child: Container(
              decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5)))),
      ListView(padding: EdgeInsets.zero, children: <Widget>[
        DrawerHeader(child: Text('Hello Drawer Title')),
        // ListTitle(
        // leading: Icon(Icons.dashboard, color: Colors.white)
        // title: "Dashboard"
        // onTap: (){
        //
        // }
        // )
      ])
    ]));
  }

  void showModal(context) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(8),
            height: 200,
            alignment: Alignment.center,
            child: Text('Modal'),
          );
        });
  }

  bool _isCompetitionTabShown() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return userProvider.selectedPage == 3 && userProvider.isLoggedIn;
  }

  Future<bool> _onWillPop() async {
    if (Provider.of<UserProvider>(context, listen: false).selectedPage != 2) {
      Provider.of<UserProvider>(context, listen: false).selectedPage = 2;
    } else {
      await MyApp.exitBottomSheet(context);
      return false;
    }
    return false;
  }

  Future<bool> _onWillPop2() async {
    if (Provider.of<UserProvider>(context, listen: false).selectedPage != 2) {
      Provider.of<UserProvider>(context, listen: false).selectedPage = 2;
    } else {
      return (await showDialog(
            context: context,
            builder: (cc) => ResponsiveBuilder(builder: (context, sizeConfig) {
              return new SimpleDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                    child: Text(
                      AppLocalizations.of(context)!
                          .translate("are_you_sure_exit"),
                      style: TextStyle(
                        fontSize: sizeConfig.blockSizeHorizontal * 6,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
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
                            SystemNavigator.pop();
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
                            Navigator.of(context).pop(false);
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
                  // Divider(
                  //   color: Colors.green,
                  // ),
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.translate("or"),
                      style: TextStyle(
                        fontSize: sizeConfig.blockSizeHorizontal * 5,
                        color: Theme.of(context).primaryColorDark,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
                    width: sizeConfig.blockSizeHorizontal * 30,
                    height: sizeConfig.blockSizeVertical * 6,
                    margin: EdgeInsets.only(top: 20, bottom: 20),
                    child: RawMaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(sizeConfig.blockSizeVertical),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        // Navigator.pushNamed(context, "/rating_view");
                        /// TODO: Select a new lib to review
                        // LaunchReview.launch();
                        SystemNavigator.pop();
                      },
                      fillColor: Theme.of(context).primaryColor,
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate("rating_muslim_book?"),
                        style: TextStyle(
                          fontSize: sizeConfig.blockSizeHorizontal * 5,
                          color: Constants.CANVAS_COLOR,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          )) ??
          false;
    }
    return false;
  }

  List<String> _pagesNames(context) => [
        AppLocalizations.of(context)!.translate("quran"),
        AppLocalizations.of(context)!.translate("Qiblah"),
        AppLocalizations.of(context)!.translate("home"),
        AppLocalizations.of(context)!.translate("competitions"),
        AppLocalizations.of(context)!.translate("azkar")
      ];

  List<Color> getPageColor(context) => [
        Colors.transparent,
        Constants.CANVAS_COLOR,
        Constants.CANVAS_COLOR,
        Provider.of<UserProvider>(context, listen: false).isLoggedIn
            ? Constants.CANVAS_COLOR
            : Colors.transparent,
        Constants.CANVAS_COLOR,
      ];

  List<BottomNavigationBarItem> navigationItems(
      context, SizingInformation sizeConfig) {
    return [
      BottomNavigationBarItem(
        label: _pagesNames(context)[0],
        icon: SvgPicture.asset(
          "assets/images/start_view/mushaf.svg",
          width: sizeConfig.blockSizeHorizontal * 7,
          color: Theme.of(context).colorScheme.secondary,
        ),
        activeIcon: SvgPicture.asset(
          "assets/images/start_view/mushaf.svg",
          width: sizeConfig.blockSizeHorizontal * 7,
          color: Constants.CANVAS_COLOR,
        ),
      ),
      BottomNavigationBarItem(
        label: _pagesNames(context)[1],
        icon: SvgPicture.asset(
          "assets/images/start_view/compass_icon.svg",
          width: sizeConfig.blockSizeHorizontal * 6,
          color: Theme.of(context).colorScheme.secondary,
        ),
        activeIcon: SvgPicture.asset(
          "assets/images/start_view/compass_icon.svg",
          width: sizeConfig.blockSizeHorizontal * 6,
          color: Constants.CANVAS_COLOR,
        ),
      ),
      BottomNavigationBarItem(
        label: _pagesNames(context)[2],
        icon: Icon(
          Icons.home,
          size: sizeConfig.blockSizeHorizontal * 8,
          color: Theme.of(context).colorScheme.secondary,
        ),
        activeIcon: Icon(
          Icons.home,
          size: sizeConfig.blockSizeHorizontal * 8,
          color: Constants.CANVAS_COLOR,
        ),
      ),
      BottomNavigationBarItem(
        label: _pagesNames(context)[3],
        icon: SvgPicture.asset(
          "assets/images/start_view/quizes_icon.svg",
          width: sizeConfig.blockSizeHorizontal * 8,
          color: Theme.of(context).colorScheme.secondary,
        ),
        activeIcon: SvgPicture.asset(
          "assets/images/start_view/quizes_icon.svg",
          width: sizeConfig.blockSizeHorizontal * 8,
          color: Constants.CANVAS_COLOR,
        ),
      ),
      BottomNavigationBarItem(
        label: _pagesNames(context)[4],
        icon: SvgPicture.asset(
          "assets/images/start_view/azkar.svg",
          width: sizeConfig.blockSizeHorizontal * 6,
          color: Theme.of(context).colorScheme.secondary,
        ),
        activeIcon: SvgPicture.asset(
          "assets/images/start_view/azkar.svg",
          width: sizeConfig.blockSizeHorizontal * 6,
          color: Constants.CANVAS_COLOR,
        ),
      ),
    ];
  }

  void onPageChanged(position) {
    Provider.of<UserProvider>(context, listen: false).selectedPage = position;
  }

}
