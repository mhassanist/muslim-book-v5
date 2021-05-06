import 'package:base_app/main.dart';
import 'package:base_app/singletons/azan_singleton.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/locator.dart';
import 'package:base_app/utils/prefs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          await http.get(uri).timeout(Duration(seconds: 300)) ;

      if (response.statusCode == 200) {
        print("shaimaaaaaaaaaaaaaaaa "+ response.body.toString());
        await locator<Prefs>().setAzanModel(response.body);
        await locator<AzanSingleton>().saveAzanTimes();
      }
    } catch (_) {
      print("error is ${_.toString()}");
      return null;
    }
  }

  Map<String, String> getParameters() {
    Map<String, String> parameters = {};
    parameters["method"] =
        "${Constants.AR_AZAN_METHODS[locator<Prefs>().getAzanMethod()]["id"]}";
    if(locator<Prefs>().getLatitudeAdjustmentMethod()!=null&&locator<Prefs>().getLatitudeAdjustmentMethod()!=0){
      parameters["latitudeAdjustmentMethod"] =
      "${Constants.AR_Latitude_Adjustment_Method[locator<Prefs>().getLatitudeAdjustmentMethod()]["id"]}";
    }

    parameters["school"] =
        "${Constants.AR_AZAN_Mazhabs[locator<Prefs>().getAzanMazhab()]["id"]}";
    parameters["month"] = "${DateTime.now().month}";
    parameters["year"] = "${DateTime.now().year}";

    if (locator<Prefs>().getLatitue() != null &&
        locator<Prefs>().getLongtude() != null) {
      parameters["latitude"] = "${locator<Prefs>().getLatitue()}";
      parameters["longitude"] = "${locator<Prefs>().getLongtude()}";
      path = "$path/calendar";
    } else {
      parameters = null;
    }
    return parameters;
  }
}
