import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationUtilities {
  loc.Location location = loc.Location();

  Future checkLocationPermission({bool save = false,}) async {
    if (await Permission.locationWhenInUse.request().isGranted) {
      if (!await location.serviceEnabled()) {
        try {
          // Test if location services are enabled.
          final serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (serviceEnabled) {
            return await getLastKnownLocation(save: save,);
          }
        } catch (e) {}
      } else
        return await getLastKnownLocation(save: save,);
    } else {
      return null;
    }
  }

  Future getLastKnownLocation({bool save = false,}) async {
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
        return getAddress(result.latitude, result.longitude);
      } else {
        return getLocation(loc.LocationAccuracy.low);
      }
    } catch (e) {
      return getLocation(loc.LocationAccuracy.low);
    }
  }

  Future getLocation(loc.LocationAccuracy accuracy) async {
    try {
      location.changeSettings(accuracy: accuracy);
      loc.LocationData locationData = await location.getLocation().timeout(
        Duration(seconds: 3),
        onTimeout: () async {
          return await location.getLocation().timeout(Duration(seconds: 60));
        },
      );
      return await getAddress(locationData.latitude, locationData.longitude);
    } catch (_) {
      return null;
    }
  }

  Future<Placemark?> getAddress(lat, long) async {
    try {
      final placeMarks = await placemarkFromCoordinates(lat, long)
          .timeout(Duration(seconds: 60));
      return placeMarks.isNotEmpty ? placeMarks.first : null;
    } catch (e) {}
    return null;
  }
}
