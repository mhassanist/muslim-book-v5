import 'dart:async';

import 'package:muslim_book/ads/ad_manager.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:muslim_book/main.dart';
import 'package:native_ads_flutter/native_ads.dart';

// import 'package:flutter_native_admob/flutter_native_admob.dart';
// import 'package:flutter_native_admob/native_admob_controller.dart';
// import 'package:flutter_native_admob/native_admob_options.dart';

class AdMobRectangleSmall extends StatefulWidget {
  final bannerName;
  final banner;

  AdMobRectangleSmall(this.bannerName, {this.banner});

  @override
  _AdMobRectangleSmallState createState() => _AdMobRectangleSmallState();
}

class _AdMobRectangleSmallState extends State<AdMobRectangleSmall> {
  final _nativeAdController = NativeAdmobController();
  StreamSubscription? _subscription;
  FirebaseRemoteConfig? remoteConfig;

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
          MyApp.loadingAddMobe = true;
        });
        break;

      case AdLoadState.loadCompleted:
        setState(() {
            MyApp.loadingAddMobe = false;
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
      height: (MediaQuery.of(context).size.width / 4) * 2.5,
      child: NativeAdmob(
        loading: Container(
          child: Center(
            child: CircularProgressIndicator(),
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
