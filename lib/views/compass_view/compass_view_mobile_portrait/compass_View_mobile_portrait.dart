import 'dart:math' as math;

import 'package:base_app/ads/admob_rectangle.dart';
import 'package:base_app/ads/load_ui_with_add.dart';
import 'package:base_app/home_feature/controllers/home_controller.dart';
import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/models/banner_names_enum.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/location_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocation/geolocation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors/sensors.dart';

class CompassViewMobilePortrait extends StatefulWidget {
  @override
  _CompassViewMobilePortraitState createState() =>
      _CompassViewMobilePortraitState();
}

class _CompassViewMobilePortraitState extends State<CompassViewMobilePortrait> {
  bool _hasPermissions = false;
  String currentLocLatLong;
  double currentLocLat, currentLocLng;
  double degToKaabaBaring = 0;
  bool _gettingLocation;

  @override
  void initState() {

    super.initState();
    _fetchPermissionStatus();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      accelerometerEvents.listen((AccelerometerEvent event) {
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  getCurrentLocation() async {
    _gettingLocation = true;
    LocationUtilities().getLocation(loc.LocationAccuracy.HIGH).then((response) {
      if (response != null) {
        if (mounted) {
          setState(() {
            currentLocLat = (response as Address).coordinates.latitude;
            currentLocLng = (response as Address).coordinates.longitude;
            currentLocLatLong = "${(response as Address).addressLine}";
            _gettingLocation = false;
          });
        }
      }
    }).catchError((e) {
      print("arrived here to location 2 $e}");
    });
  }

  @override
  Widget build(BuildContext context) {
    double unitSize = MediaQuery.of(context).size.height * 1 / 100;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,

          leading:
          InkWell(
            child: Container(
              margin: EdgeInsetsDirectional.only(start: 10),
              padding: EdgeInsets.all(5),
              height: 20,
              width: 20,
              child: SvgPicture.asset(
                "assets/icons/iconappbar.svg",
                color: Theme.of(context).primaryColor
              ),
            ),
            onTap: () {
              Get.find<HomeController>().scaffoldKey.currentState.openDrawer();
            },
          ),
          backgroundColor:
          Colors.white24

        ),
        backgroundColor: Constants.CANVAS_COLOR,
        body: Container(
          height: unitSize * 100,
          // height: MediaQuery.of(context).size.height,
          // padding: EdgeInsets.only(top: kToolbarHeight + (unitSize * 3)),
          child: ListView(
            children: <Widget>[
              _buildCompass(unitSize),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompass(double unitSize) {

    return StreamBuilder<double>(
      stream: FlutterCompass.events,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
//          return Text('Error reading heading: ${snapshot.error}');
          return Text(AppLocalizations.of(context).translate("error_direction"));
        }

        if (!snapshot.hasData) {
          print("${snapshot.data}");
          return Center(
            child: Container(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (currentLocLat != null && currentLocLng != null) {
          Geolocator()
              .bearingBetween(currentLocLat, currentLocLng, Constants.KAABA_LAT,
                  Constants.KAABA_LNG)
              .then((bearing) {
//            print("Bearing :: $bearing");

            if (mounted) {
              setState(() {
                degToKaabaBaring = bearing;
              });
            }
          });
        }

        double direction = snapshot.data;
//
//        Permission.locationWhenInUse.request().then((status) {
//          if (status.isGranted)
//            _fetchPermissionStatus();
//        });
//  print( "_hasPermissions   $_hasPermissions    currentLocLatLong   $currentLocLatLong    " );
        return Container(

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    AppLocalizations.of(context).translate("Calibrate_your_compass"),
                    style: TextStyle(fontSize: unitSize * 2),
                  ),
                ),
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(left: 20, right: 20),
                  height: unitSize * 40,
                  child: Transform.rotate(
                    angle: currentLocLatLong != null
                        ? ((degToKaabaBaring - direction) * (math.pi / 180))
                        : 0,
//                angle: (((direction ?? 0) * (math.pi / 180) * -1) + (degToKaabaBaring ?? 0)) % 360,
//                angle: ((direction ?? 0) * (math.pi / 180) * -1),
                    child: Image.asset('assets/images/general/compass.png'),
                  ),
                ),
                _hasPermissions
                    ? AnimatedCrossFade(
                        firstChild: AdMobRectangle(BannerName.BOSLA ),
                        secondChild: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(5),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Constants.PRIMARY_COLOR),
                          ),
                        ),
                        crossFadeState:
                            _gettingLocation != null && _gettingLocation
                                ? CrossFadeState.showSecond
                                : CrossFadeState.showFirst,
                        duration: Duration(milliseconds: 200),
                      )
                  : Container(),
                if(!snapshot.hasData)
                if ( !_hasPermissions || currentLocLatLong == null )
                  Column(
                    children: <Widget>[

                      LoadUiWithAdd(
                        mainView: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                AppLocalizations.of(context).translate("give_Gps_perm"),
                                style: TextStyle(fontSize: unitSize * 2),
                              ),
                            ),
                            Container(
                              height: unitSize * 7,
                              child: FlatButton(
                                onPressed: () async {
                                  _fetchPermissionStatus();
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(5))),
                                color: Theme.of(context).primaryColor,
                                child: Text(
                                  AppLocalizations.of(context).translate("give_perm"),
                                  style: TextStyle(
                                      color: Constants.CANVAS_COLOR,
                                      fontSize: unitSize * 3),
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            AdMobRectangle(BannerName.BOSLA )

                          ],
                        ),
                      )
                    ],
                  )
              ],
            ),
        );
      },
    );
  }

  void _fetchPermissionStatus() {
    Permission.locationWhenInUse.request().then((status) async {
      if (status.isGranted) {
        if (await loc.Location().serviceEnabled()) {
          if (mounted) {
            setState(
                () => _hasPermissions = status == PermissionStatus.granted);
            getCurrentLocation();
          }
        } else {
          try{
            GeolocationResult result = await Geolocation.enableLocationServices();
            if (result.isSuccessful) {
              _fetchPermissionStatus();
            }

          } catch(e){

          }
        }
      }
    });
  }
}
