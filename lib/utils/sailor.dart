import 'package:base_app/azan_feature/views/azan_view.dart';
import 'package:base_app/quran/views/quran_view.dart';
import 'package:base_app/ramadan/views/ramadan_view.dart';
import 'package:base_app/views/azan_settings_views/adjust_battery_view.dart';
import 'package:base_app/views/azan_settings_views/azan_draw_over_view.dart';
import 'package:base_app/views/azan_settings_views/pick_azan_method_view.dart';
import 'package:base_app/views/azan_settings_views/pick_country_view.dart';
import 'package:base_app/views/changePassword_view/changePassword_view.dart';
import 'package:base_app/views/competition_view/competition_start_view.dart';
import 'package:base_app/views/competition_view/competition_view.dart';
import 'package:base_app/views/edit_profile_view/edit_profile_view.dart';
import 'package:base_app/views/home_view/home_view.dart';
import 'package:base_app/views/login_pop_up_view/login_pop_up_view.dart';
import 'package:base_app/views/login_view/login_view.dart';
import 'package:base_app/views/myProfile_view/myProfile_view.dart';
import 'package:base_app/views/pick_location_via_map_view/pick_location_via_map_view.dart';
import 'package:base_app/views/settings_view/settings_view.dart';
import 'package:base_app/views/signup_view/signup_view.dart';
import 'package:base_app/views/start_view/start_view.dart';
import 'package:base_app/views/top_view/compeition_top_view.dart';
import 'package:base_app/views/top_view/select_top_view.dart';
import 'package:flutter/material.dart';
import 'package:sailor/sailor.dart';

class Routes {
  static final sailor = Sailor();

  static void createRoutes() {
    sailor.addRoute(
      SailorRoute(
          name: "/start_view",
          builder: (context, args, params) {
            return StartView();
          },
          defaultTransitionDuration: Duration(milliseconds: 200),
          defaultTransitionCurve: Curves.ease,
          defaultTransitions: [SailorTransition.fade_in]),
    );

    sailor.addRoute(
      SailorRoute(
          name: "/azan_draw_over",
          builder: (context, args, params) {
            return AzanDrawOverView();
          },
          defaultTransitionDuration: Duration(milliseconds: 200),
          defaultTransitionCurve: Curves.ease,
          defaultTransitions: [SailorTransition.fade_in]),
    );

    sailor.addRoute(
      SailorRoute(
          name: "/adjust_battery_view",
          builder: (context, args, params) {
            return AdjustBatteryView();
          },
          defaultTransitionDuration: Duration(milliseconds: 300),
          defaultTransitionCurve: Curves.ease,
          defaultTransitions: [SailorTransition.slide_from_right]),
    );

    sailor.addRoute(
      SailorRoute(
          name: "/pick_country_view",
          builder: (context, args, params) {
            return PickCountryView();
          },
          defaultTransitionDuration: Duration(milliseconds: 300),
          defaultTransitionCurve: Curves.ease,
          defaultTransitions: [SailorTransition.slide_from_right]),
    );

    sailor.addRoute(
      SailorRoute(
          name: "/competition_start_view",
          builder: (context, args, params) {
            return CompetitionStartView();
          },
          defaultTransitionDuration: Duration(milliseconds: 300),
          defaultTransitionCurve: Curves.ease,
          defaultTransitions: [SailorTransition.slide_from_bottom]),
    );

    sailor.addRoute(
      SailorRoute(
          name: "/pick_location_via_map_view",
          builder: (context, args, params) {
            return PickLocationViaMapView();
          },
          defaultTransitionDuration: Duration(milliseconds: 300),
          defaultTransitionCurve: Curves.ease,
          defaultTransitions: [SailorTransition.slide_from_bottom]),
    );

    sailor.addRoute(
      SailorRoute(
          name: "/pick_azan_method_view",
          builder: (context, args, params) {
            return PickAzanMethodView();
          },
          defaultTransitionDuration: Duration(milliseconds: 300),
          defaultTransitionCurve: Curves.ease,
          defaultTransitions: [SailorTransition.slide_from_right]),
    );
    sailor.addRoute(
      SailorRoute(
          name: "/signup_view",
          builder: (context, args, params) {
            return SignupView();
          },
          defaultTransitionDuration: Duration(milliseconds: 300),
          defaultTransitionCurve: Curves.ease,
          defaultTransitions: [SailorTransition.slide_from_right]),
    );
    sailor.addRoute(
      SailorRoute(
          name: "/edit_profile_view",
          builder: (context, args, params) {
            return EditProfileView();
          },
          defaultTransitionDuration: Duration(milliseconds: 300),
          defaultTransitionCurve: Curves.ease,
          defaultTransitions: [SailorTransition.slide_from_right]),
    );
    sailor.addRoute(
      SailorRoute(
          name: "/changePassword_view",
          builder: (context, args, params) {
            return ChangePasswordView();
          },
          defaultTransitionDuration: Duration(milliseconds: 300),
          defaultTransitionCurve: Curves.ease,
          defaultTransitions: [SailorTransition.slide_from_right]),
    );
    //   sailor.addRoute(
    //    SailorRoute(
    //        name: "/rating_view",
    //        builder: (context, args, params) {
    //          return RatingView();
    //        },
    //        defaultTransitionDuration: Duration(milliseconds: 300),
    //        defaultTransitionCurve: Curves.ease,
    //        defaultTransitions: [SailorTransition.slide_from_right]),
    //  );
    // sailor.addRoute(
    //    SailorRoute(
    //        name: "/competition_view",
    //        builder: (context, args, params) {
    //          return RatingView();
    //        },
    //        defaultTransitionDuration: Duration(milliseconds: 300),
    //        defaultTransitionCurve: Curves.ease,
    //        defaultTransitions: [SailorTransition.slide_from_right]),
    //  );
    sailor.addRoute(
      SailorRoute(
          name: "/myProfile_view",
          builder: (context, args, params) {
            return MyProfileView();
          },
          defaultTransitionDuration: Duration(milliseconds: 300),
          defaultTransitionCurve: Curves.ease,
          defaultTransitions: [SailorTransition.slide_from_right]),
    );    sailor.addRoute(
      SailorRoute(
          name: "/SelectTopView",
          builder: (context, args, params) {
            return SelectTopView();
          },
          defaultTransitionDuration: Duration(milliseconds: 300),
          defaultTransitionCurve: Curves.ease,
          defaultTransitions: [SailorTransition.slide_from_right]),
    );
    sailor.addRoute(
    SailorRoute(
          name: "/AzanView",
          builder: (context, args, params) {
            return AzanView();
          },
          defaultTransitionDuration: Duration(milliseconds: 300),
          defaultTransitionCurve: Curves.ease,
          defaultTransitions: [SailorTransition.slide_from_right]),
    );
    // sailor.addRoute(
    // SailorRoute(
    //       name: "/RamadanView",
    //       builder: (context, args, params) {
    //         return RamadanView();
    //       },
    //       defaultTransitionDuration: Duration(milliseconds: 300),
    //       defaultTransitionCurve: Curves.ease,
    //       defaultTransitions: [SailorTransition.slide_from_right]),
    // );
    sailor.addRoute(
      SailorRoute(
          name: "/login",
          builder: (context, args, params) {
            return LoginView();
          },
          defaultTransitionDuration: Duration(milliseconds: 300),
          defaultTransitionCurve: Curves.ease,
          defaultTransitions: [SailorTransition.slide_from_right]),
    );
    sailor.addRoute(
      SailorRoute(
          name: "/LoginPopUpView",
          builder: (context, args, params) {
            return LoginPopUpView();
          },
          defaultTransitionDuration: Duration(milliseconds: 300),
          defaultTransitionCurve: Curves.ease,
          defaultTransitions: [SailorTransition.slide_from_right]),
    );
    sailor.addRoute(
      SailorRoute(
          name: "/top",
          builder: (context, args, params) {
            return CompetitionTopView();
          },
          defaultTransitionDuration: Duration(milliseconds: 300),
          defaultTransitionCurve: Curves.ease,
          defaultTransitions: [SailorTransition.slide_from_right]),
    );
    sailor.addRoute(
      SailorRoute(
          name: "/settings",
          builder: (context, args, params) {
            return SettingsView();
          },
          defaultTransitionDuration: Duration(milliseconds: 300),
          defaultTransitionCurve: Curves.ease,
          defaultTransitions: [SailorTransition.slide_from_right]),
    );
    sailor.addRoute(
      SailorRoute(
          name: "/suras_view",
          builder: (context, args, params) {
            return QuranView();
          },
          defaultTransitionDuration: Duration(milliseconds: 100),
          defaultTransitionCurve: Curves.ease,
          defaultTransitions: [SailorTransition.slide_from_right]),
    );

    sailor.addRoute(
      SailorRoute(
          name: "/competitions",
          builder: (context, args, params) {
            return CompetitionView();
          },
          defaultTransitionDuration: Duration(milliseconds: 300),
          defaultTransitionCurve: Curves.ease,
          defaultTransitions: [SailorTransition.slide_from_right]),
    );

    sailor.addRoute(
      SailorRoute(
          name: "/home",
          builder: (context, args, params) {
            return HomeView();
          },
          defaultTransitionDuration: Duration(milliseconds: 300),
          defaultTransitionCurve: Curves.ease,
          defaultTransitions: [SailorTransition.slide_from_right]),
    );
  }
}
