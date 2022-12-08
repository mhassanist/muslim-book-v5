import 'dart:convert';
import 'package:muslim_book/models/city_model.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:http/http.dart' as http;

class SettingsApis {
  Future<bool> getAppVersion() async {

    try {
      http.Response response = await http
          .get(Uri.https('${Constants.BASE_URL}version',))
          .timeout(Duration(seconds: 25));
      if (int.parse(json.decode(response.body)["client"]) > Constants.VERSION_NUMBER) {
        return true;
      }
    } catch (_) {}
    return false;
  }

  static Future<CountryCities?> getAllCitiesOfCountry(String countryCode) {
//    print("URL :: ${Constants.CITIES_OF_COUNTRY_URL}${countryCode.toLowerCase()}/all/?key=${Constants.GET_CITIES_API_KEY}");
    return http
        .get(Uri.https('${Constants.CITIES_OF_COUNTRY_URL}$countryCode/all/?key=${Constants.GET_CITIES_API_KEY2}'))
        .then((response) {
      final statusCode = response.statusCode;
      final body = response.body;

      print(statusCode);
      print(body);

      try {
        final decodeBody = json.decode(body);
        return CountryCities.fromMap(decodeBody);
      } catch (ex) {
        print(ex);
        return null;
      }
    });
  }
}
