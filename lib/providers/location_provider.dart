import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/providers/pick_azan_methods_provider.dart';
import 'package:muslim_book/providers/view_state_provider.dart';
import 'package:muslim_book/utils/location_utilities.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:flutter/material.dart';

// import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:search_map_place_updated/search_map_place_updated.dart';
// import 'package:search_map_place/search_map_place.dart';

class LocationProvider extends ViewStateProvider {
  String _countryName = '';
  double? _latitude;
  double? _longitude;
  bool _enablePicker = false;
  String _pickedCountryName = "EG";
  late Place _place;

  void setPlace(Place value) async {
    _place = value;
    _countryName = _place.description ?? '';
    Geolocation? geoLocation = await value.geolocation;
    if (geoLocation != null) {
      double lat = (geoLocation.coordinates as LatLng).latitude;
      double long = (geoLocation.coordinates as LatLng).longitude;
      // final coordinates = Coordinates(lat, long);
      // var addresses = await Geocoder.google(Constants.GOOGLE_API_KEY,
      //         language: locator<Prefs>().getLang())
      //     .findAddressesFromCoordinates(coordinates);
      // pickedCountryName = addresses[0].countryCode;

      final placeMarks = await placemarkFromCoordinates(lat, long);
      pickedCountryName = placeMarks[0].isoCountryCode ?? '';
      setLatLing(lat, long);
    }
  }

  void setLatLing(double lat, double long) {
    _latitude = lat;
    _longitude = long;
    locator<Prefs>().setLatitude(lat);
    locator<Prefs>().setLongtude(long);
    notifyListeners();
  }

  Place get place => _place;

  set countryName(String s) {
    _countryName = s;
    notifyListeners();
  }

  String get countryName => _countryName;

  set enablePicker(bool val) {
    _enablePicker = val;
    notifyListeners();
  }

  bool get enablePicker => _enablePicker;

  set pickedCountryName(String s) {
    _pickedCountryName = s;
    locator<Prefs>().setCountry(s);
    notifyListeners();
  }

  String get pickedCountryName => _pickedCountryName;

  set latitude(double s) {
    _latitude = s;
    notifyListeners();
  }

  double get latitude => _latitude ?? 0.0;

  set longitude(double s) {
    _longitude = s;
    notifyListeners();
  }

  double get longitude => _longitude ?? 0.0;

  Future getLocation(BuildContext context) async {
    _latitude = null;
    _longitude = null;
    enablePicker = false;
    countryName = AppLocalizations.of(context)!.translate("getting_location");
    var response = await LocationUtilities().checkLocationPermission();
    if (response != null) {
      final place = response as Placemark;
      countryName =
          "${place.country ?? ''} - ${place.administrativeArea ?? ''} - ${place.subAdministrativeArea ?? ''}";
      pickedCountryName = place.country ?? '';
      String countryCode = place.isoCountryCode ?? '';
      locator<Prefs>().setCountryCode(countryCode);

      final position = await Geolocator.getLastKnownPosition();
      if (position != null) {
        setLatLing(position.latitude, position.longitude);
      }
      // saveCountry(context);
    } else {
      setLatLing(30.7930351, 30.964337);
      countryName = AppLocalizations.of(context)!
          .translate("error_while_getting_location");
    }
  }

  void saveCountry(context) async {
    if (_longitude != null && _latitude != null) {
      if (Provider.of<PickAzanMethodsProvider>(context, listen: false)
          .pickedMethod.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            AppLocalizations.of(context)!.translate("mazhab_method_empty"),
          ),
        ));
      } else {
        await saveSettings(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
        Text(AppLocalizations.of(context)!.translate("please_pick_country")),
      ));
    }

    //  Navigator.pushNamed(context, "/pick_azan_method_view");
    // } else

  }

  Future saveSettings(context) async {
    Provider.of<PickAzanMethodsProvider>(context, listen: false)
        .saveSettings(context);
  }
}
