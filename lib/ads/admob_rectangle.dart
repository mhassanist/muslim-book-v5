import 'package:base_app/ads/ad_manager.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_admob/flutter_native_admob.dart';
import 'package:flutter_native_admob/native_admob_options.dart';

class AdMobRectangle extends StatefulWidget {
  final bannerName;

  AdMobRectangle(this.bannerName);

  @override
  _AdMobRectangleState createState() => _AdMobRectangleState();
}

class _AdMobRectangleState extends State<AdMobRectangle> {
  RemoteConfig remoteConfig;

  @override
  Widget build(BuildContext context) {
    return _buildNativeRect();
  }
/*
  //can't change background color - admob_flutter
  Widget _buildBannerAdd() {
    return Container(
      color: Colors.red,
      child: AdmobBanner(
        adUnitId: AdManager.getAdUnitId(widget.bannerName),
        adSize: AdmobBannerSize.MEDIUM_RECTANGLE,
        listener: (AdmobAdEvent event,
            Map<String, dynamic> args) {
        },
        onBannerCreated:
            (AdmobBannerController controller) {
          // Dispose is called automatically for you when Flutter removes the banner from the widget tree.
          // Normally you don't need to worry about disposing this yourself, it's handled.
          // If you need direct access to dispose, this is your guy!
          // controller.dispose();
        },
      ),
    );
  }
*/
  //flutter_native_admob , not showing in release mode, background is wrong
  Widget _buildNativeRect() {
    return Container(
      height: (MediaQuery
          .of(context)
          .size
          .width / 4) * 3,
      // width: (MediaQuery
      //     .of(context)
      //     .size
      //     .width / 4) * 3,
      child: NativeAdmob(
        loading: Container(
          // color: Colors.white,
            ),
        options: NativeAdmobOptions(
          // backgroundColor : Color(0xFFFFFFFF),
            ),
        adUnitID: AdManager.getAdUnitId(widget.bannerName),
        numberAds: 3,
        type: NativeAdmobType.full,
      ),
    );
  } //end of build

}




