import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:flutter/material.dart';
// import 'package:search_map_place/search_map_place.dart';
// import 'package:search_map_place_updated/search_map_place_updated.dart';

/// TODO: Fix place lib
class PickLocationViaMapView extends StatefulWidget {
  @override
  _PickLocationViaMapViewState createState() => _PickLocationViaMapViewState();
}

class _PickLocationViaMapViewState extends State<PickLocationViaMapView> {
//  final Completer<GoogleMapController> _controller = Completer();
//   Place? place;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight ),
          child: AppBar(
            title: Text(
              AppLocalizations.of(context)!
                  .translate("select_location_manually"),
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: Text(
                  AppLocalizations.of(context)!.translate("save"),
                  style: TextStyle(color: Constants.CANVAS_COLOR),
                ),
                onPressed: () {
                  // if (place != null) {
                  //   Navigator.pop(context, place);
                  // }
                },
              )
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
//            GoogleMap(
//              mapType: MapType.normal,
//              initialCameraPosition: _egyptPosition,
//              onMapCreated: (GoogleMapController controller) {
//                _controller.complete(controller);
//              },
//            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                child: SingleChildScrollView(
                  // child: SearchMapPlaceWidget(
                  //   iconColor: Theme.of(context).primaryColor,
                  //   placeholder:
                  //       AppLocalizations.of(context)!.translate("search"),
                  //   apiKey: "${Constants.GOOGLE_API_KEY}",
                  //   language: locator<Prefs>().getLang(),
                  //   onSelected: (Place place) async {
                  //     this.place = place;
                  //   },
                  // ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // final CameraPosition _egyptPosition = CameraPosition(
  //   target: LatLng(26.8206, 30.8025),
  //   zoom: 14.4746,
  // );
}
