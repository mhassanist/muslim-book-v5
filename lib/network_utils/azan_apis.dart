import 'package:muslim_book/singletons/azan_singleton.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:http/http.dart' as http;
// import 'package:fluttertoast/fluttertoast.dart';

class AzanApis {
  String baseUrl = "api.aladhan.com";
  String path = "/v1";

  Future getAzan() async {
    try {
      var map = getParameters();
      var uri = Uri.https(baseUrl, path, map);
      http.Response response =
          await http.get(uri).timeout(Duration(seconds: 300));

      if (response.statusCode == 200) {
        await locator<Prefs>().setAzanModel(response.body);
        await locator<AzanSingleton>().saveAzanTimes();
      }
    } catch (_) {
      print("error is ${_.toString()}");
      return null;
    }
  }

  Map<String, String>? getParameters() {
    Map<String, String>? parameters = {};
    parameters["method"] =
        "${Constants.AR_AZAN_METHODS[locator<Prefs>().getAzanMethod()]["id"]}";
    if (locator<Prefs>().getLatitudeAdjustmentMethod() != -1 &&
        locator<Prefs>().getLatitudeAdjustmentMethod() != 0) {
      parameters["latitudeAdjustmentMethod"] =
          "${Constants.AR_Latitude_Adjustment_Method[locator<Prefs>().getLatitudeAdjustmentMethod()]["id"]}";
    }

    parameters["school"] =
        "${Constants.AR_AZAN_Mazhabs[locator<Prefs>().getAzanMazhab()]["id"]}";
    parameters["month"] = "${DateTime.now().month}";
    parameters["year"] = "${DateTime.now().year}";

    if (locator<Prefs>().getLatitude() != null &&
        locator<Prefs>().getLongitude() != null) {
      parameters["latitude"] = "${locator<Prefs>().getLatitude()}";
      parameters["longitude"] = "${locator<Prefs>().getLongitude()}";
      path = "$path/calendar";
    } else {
      parameters = null;
    }
    return parameters;
  }
}
