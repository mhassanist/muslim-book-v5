import 'package:geocoder/geocoder.dart';
import 'package:geolocation/geolocation.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class LocationUtilities {
  loc.Location location = loc.Location();

  Future checkLocationPermission() async {
    if (await Permission.locationWhenInUse.request().isGranted) {
      if (!await location.serviceEnabled()) {
        try {
          GeolocationResult result = await Geolocation.enableLocationServices();
          if (result.isSuccessful) {
            print("result is Successful");
            return await getLastKnownLocation();
          }
        } catch (e) {}
      } else
        return await getLastKnownLocation();
    } else {
      return null;
    }
  }

  Future getLastKnownLocation() async {
    try {
      LocationResult result = await Geolocation.lastKnownLocation()
          .timeout(Duration(seconds: 1), onTimeout: () async {
        return Geolocation.lastKnownLocation().timeout(Duration(seconds: 60));
      });
      if (result != null) {
        return getAddress(result.location.latitude, result.location.longitude);
      } else {
        return getLocation(loc.LocationAccuracy.LOW);
      }
    } catch (e) {
      return getLocation(loc.LocationAccuracy.LOW);
    }
  }

  Future getLocation(loc.LocationAccuracy accuracy) async {
    try {
      location.changeSettings(accuracy: accuracy);
      loc.LocationData locationData = await location
          .getLocation()
          .timeout(Duration(seconds: 3), onTimeout: () async {
        return await location.getLocation().timeout(Duration(seconds: 60));
      });
      if (locationData != null) {
        return await getAddress(locationData.latitude, locationData.longitude);
      } else {
        return null;
      }
    } catch (_) {
      return null;
    }
  }

  Future<Address> getAddress(lat, long) async {
    try {
      final coordinates = new Coordinates(lat, long);
      var addresses = await Geocoder.local
          .findAddressesFromCoordinates(coordinates)
          .timeout(Duration(seconds: 60));
      return addresses[0];
    } catch (e) {}
    return null;
  }
}
