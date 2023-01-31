import 'package:muslim_book/azan_feature/views/azan_view.dart';
import 'package:muslim_book/quran/views/quran_section_screen.dart';
import 'package:muslim_book/views/azan_settings_views/adjust_battery_view.dart';
import 'package:muslim_book/views/azan_settings_views/azan_draw_over_view.dart';
import 'package:muslim_book/views/azan_settings_views/pick_azan_method_view.dart';
import 'package:muslim_book/views/azan_settings_views/pick_country_view.dart';
import 'package:muslim_book/views/changePassword_view/changePassword_view.dart';
import 'package:muslim_book/views/competition_view/competition_start_view.dart';
import 'package:muslim_book/views/competition_view/competition_view.dart';
import 'package:muslim_book/views/edit_profile_view/edit_profile_view.dart';
import 'package:muslim_book/views/home_view/home_view.dart';
import 'package:muslim_book/views/login_pop_up_view/login_pop_up_view.dart';
import 'package:muslim_book/views/login_view/login_view.dart';
import 'package:muslim_book/views/myProfile_view/myProfile_view.dart';
import 'package:muslim_book/views/pick_location_via_map_view/pick_location_via_map_view.dart';
import 'package:muslim_book/views/settings_view/settings_view.dart';
import 'package:muslim_book/views/signup_view/signup_view.dart';
import 'package:muslim_book/views/start_view/start_view.dart';
import 'package:muslim_book/views/scoreboard_views/quiz_scoreboard_view.dart';
import 'package:muslim_book/views/scoreboard_views/select_top_view.dart';
import 'package:flutter/material.dart';
import 'package:seafarer/seafarer.dart';

class Routes {
  static final sailor = Seafarer();

  static void createRoutes() {
    sailor.addRoute(
      SeafarerRoute(
        name: "/start_view",
        builder: (context, args, params) {
          return StartView();
        },
        defaultTransitionDuration: Duration(milliseconds: 200),
        defaultTransitionCurve: Curves.ease,
        defaultTransitions: [SeafarerTransition.fade_in],
      ),
    );

    sailor.addRoute(
      SeafarerRoute(
        name: "/azan_draw_over",
        builder: (context, args, params) {
          return AzanDrawOverView();
        },
        defaultTransitionDuration: Duration(milliseconds: 200),
        defaultTransitionCurve: Curves.ease,
        defaultTransitions: [SeafarerTransition.fade_in],
      ),
    );

    sailor.addRoute(
      SeafarerRoute(
        name: "/adjust_battery_view",
        builder: (context, args, params) {
          return AdjustBatteryView();
        },
        defaultTransitionDuration: Duration(milliseconds: 300),
        defaultTransitionCurve: Curves.ease,
        defaultTransitions: [SeafarerTransition.slide_from_right],
      ),
    );

    sailor.addRoute(
      SeafarerRoute(
        name: "/pick_country_view",
        builder: (context, args, params) {
          return PickCountryView();
        },
        defaultTransitionDuration: Duration(milliseconds: 300),
        defaultTransitionCurve: Curves.ease,
        defaultTransitions: [SeafarerTransition.slide_from_right],
      ),
    );

    sailor.addRoute(
      SeafarerRoute(
        name: "/competition_start_view",
        builder: (context, args, params) {
          return CompetitionStartView();
        },
        defaultTransitionDuration: Duration(milliseconds: 300),
        defaultTransitionCurve: Curves.ease,
        defaultTransitions: [SeafarerTransition.slide_from_bottom],
      ),
    );

    sailor.addRoute(
      SeafarerRoute(
        name: "/pick_location_via_map_view",
        builder: (context, args, params) {
          return PickLocationViaMapView();
        },
        defaultTransitionDuration: Duration(milliseconds: 300),
        defaultTransitionCurve: Curves.ease,
        defaultTransitions: [SeafarerTransition.slide_from_bottom],
      ),
    );

    sailor.addRoute(
      SeafarerRoute(
        name: "/pick_azan_method_view",
        builder: (context, args, params) {
          return PickAzanMethodView();
        },
        defaultTransitionDuration: Duration(milliseconds: 300),
        defaultTransitionCurve: Curves.ease,
        defaultTransitions: [SeafarerTransition.slide_from_right],
      ),
    );
    sailor.addRoute(
      SeafarerRoute(
        name: "/signup_view",
        builder: (context, args, params) {
          return SignupView();
        },
        defaultTransitionDuration: Duration(milliseconds: 300),
        defaultTransitionCurve: Curves.ease,
        defaultTransitions: [SeafarerTransition.slide_from_right],
      ),
    );
    sailor.addRoute(
      SeafarerRoute(
        name: "/edit_profile_view",
        builder: (context, args, params) {
          return EditProfileView();
        },
        defaultTransitionDuration: Duration(milliseconds: 300),
        defaultTransitionCurve: Curves.ease,
        defaultTransitions: [SeafarerTransition.slide_from_right],
      ),
    );
    sailor.addRoute(
      SeafarerRoute(
        name: "/changePassword_view",
        builder: (context, args, params) {
          return ChangePasswordView();
        },
        defaultTransitionDuration: Duration(milliseconds: 300),
        defaultTransitionCurve: Curves.ease,
        defaultTransitions: [SeafarerTransition.slide_from_right],
      ),
    );

    /// START Ignore -----------------------------------------------------------
    //   sailor.addRoute(
    //    SeafarerRoute(
    //        name: "/rating_view",
    //        builder: (context, args, params) {
    //          return RatingView();
    //        },
    //        defaultTransitionDuration: Duration(milliseconds: 300),
    //        defaultTransitionCurve: Curves.ease,
    //        defaultTransitions: [SeafarerTransition.slide_from_right],),
    //  );
    // sailor.addRoute(
    //    SeafarerRoute(
    //        name: "/competition_view",
    //        builder: (context, args, params) {
    //          return RatingView();
    //        },
    //        defaultTransitionDuration: Duration(milliseconds: 300),
    //        defaultTransitionCurve: Curves.ease,
    //        defaultTransitions: [SeafarerTransition.slide_from_right],),
    //  );
    /// End Ignore -------------------------------------------------------------

    sailor.addRoute(
      SeafarerRoute(
        name: "/myProfile_view",
        builder: (context, args, params) {
          return MyProfileView();
        },
        defaultTransitionDuration: Duration(milliseconds: 300),
        defaultTransitionCurve: Curves.ease,
        defaultTransitions: [SeafarerTransition.slide_from_right],
      ),
    );
    sailor.addRoute(
      SeafarerRoute(
        name: "/SelectTopView",
        builder: (context, args, params) {
          return SelectTopView();
        },
        defaultTransitionDuration: Duration(milliseconds: 300),
        defaultTransitionCurve: Curves.ease,
        defaultTransitions: [SeafarerTransition.slide_from_right],
      ),
    );
    sailor.addRoute(
      SeafarerRoute(
        name: "/AzanView",
        builder: (context, args, params) {
          return AzanView();
        },
        defaultTransitionDuration: Duration(milliseconds: 300),
        defaultTransitionCurve: Curves.ease,
        defaultTransitions: [SeafarerTransition.slide_from_right],
      ),
    );

    /// START Ignore -----------------------------------------------------------
    // sailor.addRoute(
    // SeafarerRoute(
    //       name: "/RamadanView",
    //       builder: (context, args, params) {
    //         return RamadanView();
    //       },
    //       defaultTransitionDuration: Duration(milliseconds: 300),
    //       defaultTransitionCurve: Curves.ease,
    //       defaultTransitions: [SeafarerTransition.slide_from_right],),
    // );
    /// End Ignore -------------------------------------------------------------

    sailor.addRoute(
      SeafarerRoute(
        name: "/login",
        builder: (context, args, params) {
          return LoginView();
        },
        defaultTransitionDuration: Duration(milliseconds: 300),
        defaultTransitionCurve: Curves.ease,
        defaultTransitions: [SeafarerTransition.slide_from_right],
      ),
    );
    sailor.addRoute(
      SeafarerRoute(
        name: "/LoginPopUpView",
        builder: (context, args, params) {
          return LoginPopUpView();
        },
        defaultTransitionDuration: Duration(milliseconds: 300),
        defaultTransitionCurve: Curves.ease,
        defaultTransitions: [SeafarerTransition.slide_from_right],
      ),
    );
    sailor.addRoute(
      SeafarerRoute(
        name: "/top",
        builder: (context, args, params) {
          return QuizScoreboard();
        },
        defaultTransitionDuration: Duration(milliseconds: 300),
        defaultTransitionCurve: Curves.ease,
        defaultTransitions: [SeafarerTransition.slide_from_right],
      ),
    );
    sailor.addRoute(
      SeafarerRoute(
        name: "/settings",
        builder: (context, args, params) {
          return SettingsView();
        },
        defaultTransitionDuration: Duration(milliseconds: 300),
        defaultTransitionCurve: Curves.ease,
        defaultTransitions: [SeafarerTransition.slide_from_right],
      ),
    );
    sailor.addRoute(
      SeafarerRoute(
        name: "/suras_view",
        builder: (context, args, params) {
          return QuranSectionScreen();
        },
        defaultTransitionDuration: Duration(milliseconds: 100),
        defaultTransitionCurve: Curves.ease,
        defaultTransitions: [SeafarerTransition.slide_from_right],
      ),
    );

    sailor.addRoute(
      SeafarerRoute(
        name: "/competitions",
        builder: (context, args, params) {
          return CompetitionView();
        },
        defaultTransitionDuration: Duration(milliseconds: 300),
        defaultTransitionCurve: Curves.ease,
        defaultTransitions: [SeafarerTransition.slide_from_right],
      ),
    );

    sailor.addRoute(
      SeafarerRoute(
        name: "/home",
        builder: (context, args, params) {
          return HomeView();
        },
        defaultTransitionDuration: Duration(milliseconds: 300),
        defaultTransitionCurve: Curves.ease,
        defaultTransitions: [SeafarerTransition.slide_from_right],
      ),
    );
  }
}
