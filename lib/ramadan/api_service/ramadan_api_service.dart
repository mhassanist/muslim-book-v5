import 'dart:convert';

import 'package:base_app/ramadan/models/ramadan_data.dart';
import 'package:base_app/singletons/ramadan_singleton.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/locator.dart';
import 'package:base_app/utils/prefs.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:http/http.dart' as http;


class RamadanApiService {
  String baseUrl =  "api.aladhan.com";
  String path = "/v1/hijriCalendar";

  Future getRamadanCalender() async {
    try {
      var map = getParameters();
      var uri = Uri.https(baseUrl, path, map);
      http.Response response =
      await http.get(uri).timeout(Duration(seconds: 30));
       if (response.statusCode ==  200) {
         Map valueMap = json.decode( response.body);
        await locator<Prefs>().setRamadanModel(response.body);
        await locator<RamadanSingleton>().saveRamadanTimes();
        List<RamadanData> model=List<RamadanData>.from( valueMap["data"].map((x) => RamadanData.fromJson(x)));

        return model;

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
    parameters["month"] = "${HijriCalendar.now().hMonth}";
    parameters["year"] = "${HijriCalendar.now().hYear}";


    if (locator<Prefs>().getLatitue() != null &&
        locator<Prefs>().getLongtude() != null) {
      parameters["latitude"] = "${locator<Prefs>().getLatitue()}";
      parameters["longitude"] = "${locator<Prefs>().getLongtude()}";
      // path = "$path/calendar";
    } else {
      parameters = null;
    }
    return parameters;
  }


}
