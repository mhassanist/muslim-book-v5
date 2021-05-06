import 'dart:math' as math;

import 'package:base_app/ads/admob_rectangle.dart';
import 'package:base_app/home_feature/controllers/home_controller.dart';
import 'package:base_app/models/banner_names_enum.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/location_utilities.dart';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
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
          iconTheme: IconThemeData(
            color: Theme.of(context).primaryColor,
          ),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Get
                  .find<HomeController>()
                  .scaffoldKey.currentState.openDrawer();
            },
          ),
          backgroundColor:
          Colors.white24

        ),
        backgroundColor: Constants.CANVAS_COLOR,
        body: Container(
          height: unitSize * 100,
          // height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: kToolbarHeight + (unitSize * 3)),
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
          return Text('حدث خطأ في إيجاد الإتجاه');
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

        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                margin: EdgeInsets.only(left: 20, right: 20),
                height: unitSize * 45,
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
                      firstChild: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: unitSize * 2),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "${currentLocLatLong != null ? currentLocLatLong : ""}",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColorDark,
                                  fontSize: unitSize * 2,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: unitSize * 2),
                          ),
                          Text(
                            "القبلة",
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: unitSize * 2),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: unitSize * 1),
                          ),
                          Text(
                            "من الشمال",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: unitSize * 2),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: unitSize * 1),
                          ),
                          Text(
                            "${degToKaabaBaring.toStringAsFixed(3)}",
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: unitSize * 3,
                                fontWeight: FontWeight.w800),
                          ),
                          AdMobRectangle(BannerName.BOSLA)],
                      ),
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
              if (!_hasPermissions || currentLocLatLong == null)
                Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "يجب إعطاء الصلاحية لل GPS لإيجاد اتجاه القبلة",
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
                          "إعطاء الصلاحية",
                          style: TextStyle(
                              color: Constants.CANVAS_COLOR,
                              fontSize: unitSize * 3),
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    AdMobRectangle(BannerName.BOSLA)
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
