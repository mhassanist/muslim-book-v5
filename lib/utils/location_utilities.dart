import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:location/location.dart' as loc;
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationUtilities {
  // getLastKnownLocation
  Future checkLocationPermission({
    bool save = false,
  }) async {
    if (await Permission.locationWhenInUse.request().isGranted) {
      final status = await Permission.location.serviceStatus;

      if (!(status.name != 'enabled')) {
        // if (!await location.serviceEnabled()) {
        try {
          // Test if location services are enabled.
          final serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (serviceEnabled) {
            return await getLastKnownLocation(
              save: save,
            );
          }
        } catch (e) {}
      } else {
        return await getLastKnownLocation(
          save: save,
        );
      }
    } else {
      return null;
    }
  }

  // getLocation
  Future getLastKnownLocation({
    bool save = false,
  }) async {
    try {
      Position? result = await Geolocator.getLastKnownPosition().timeout(
        Duration(seconds: 1),
        onTimeout: () async {
          return await Geolocator.getLastKnownPosition().timeout(
            Duration(seconds: 60),
          );
        },
      );
      if (result != null) {
        if (save) {
          locator<Prefs>().setLatitude(result.latitude);
          locator<Prefs>().setLongtude(result.longitude);
        }
        return _getPlacemark(result.latitude, result.longitude);
      } else {
        return getAddress(LocationAccuracy.low);
      }
    } catch (e) {
      return getAddress(LocationAccuracy.low);
    }
  }

  Future getAddress(LocationAccuracy accuracy) async {
    try {
      var locationData = await Geolocator.getCurrentPosition(desiredAccuracy: accuracy);
      return await _getPlacemark(locationData.latitude, locationData.longitude);
    } catch (_) {
      return null;
    }
  }

    Future getCurrentPosition(LocationAccuracy accuracy) async {
    try {
      return await Geolocator.getCurrentPosition(desiredAccuracy: accuracy);
    } catch (_) {
      return null;
    }
  }

  Future<Placemark?> _getPlacemark(lat, long) async {
    try {
      final placeMarks = await placemarkFromCoordinates(lat, long)
          .timeout(Duration(seconds: 60));
      return placeMarks.isNotEmpty ? placeMarks.first : null;
    } catch (e) {}
    return null;
  }
}
