import 'dart:async';

import 'package:muslim_book/ads/ad_manager.dart';
// import 'package:muslim_book/main.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:muslim_book/widgets/loading_pkg/indicator/ball_beat_indicator.dart';
import 'package:muslim_book/widgets/loading_pkg/loading.dart';
import 'package:native_ads_flutter/native_ads.dart';

// import 'package:flutter_native_admob/flutter_native_admob.dart';
// import 'package:flutter_native_admob/native_admob_controller.dart';

// import 'package:flutter_native_admob/native_admob_options.dart';
// import 'package:loading/indicator/ball_beat_indicator.dart';
// import 'package:loading/loading.dart';

class AdMobRectangle extends StatefulWidget {
  final bannerName;
  final banner;

  AdMobRectangle(this.bannerName, {this.banner});

  @override
  _AdMobRectangleState createState() => _AdMobRectangleState();
}

class _AdMobRectangleState extends State<AdMobRectangle> {
  final _nativeAdController = NativeAdmobController();
  StreamSubscription? _subscription;

  late FirebaseRemoteConfig remoteConfig;

  @override
  void initState() {
    _subscription = _nativeAdController.stateChanged.listen(_onStateChanged);
    super.initState();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _nativeAdController.dispose();
    super.dispose();
  }

  void _onStateChanged(AdLoadState state) {
    switch (state) {
      case AdLoadState.loading:
        setState(() {
          // MyApp.loadingAddMobe = true;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
          //   MyApp.loadingAddMobe = false;
        });
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildNativeRect();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Widget _buildNativeRect() {
    return Container(
      height: (MediaQuery.of(context).size.width / 4) * 3,
      child: NativeAdmob(
        loading: Container(
          child: Center(
            child: Loading(
              indicator: BallBeatIndicator(),
              size: 70.0,
              color: Constants.PRIMARY_DARK_COLOR,
            ),
          ),
        ),
        options: NativeAdmobOptions(),
        adUnitID: AdManager.getAdUnitId(this.widget.bannerName),
        controller: _nativeAdController,
        numberAds: 1,
        type: NativeAdmobType.full,
        error: Container(),
      ),
    );
  } //end of build

}
