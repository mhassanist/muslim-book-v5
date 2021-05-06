import 'package:base_app/models/month_azan_model.dart';
import 'package:base_app/ramadan/models/month_ramadan_model.dart';
import 'package:base_app/ramadan/models/ramadan_data.dart';
import 'package:base_app/utils/locator.dart';
import 'package:base_app/utils/prefs.dart';

class RamadanSingleton {
  List<RamadanData> getRamadanModel() {
    if (locator<Prefs>().getRamadanModel() == null) {
      return null;
    } else {
      MonthRamadanModel model =
      MonthRamadanModel.fromJson(locator<Prefs>().getRamadanModel());
      return model.data;
    }
  }

  Future saveRamadanTimes() async {
    await locator<Prefs>().saveAzanTimes(
        fajr: getCurrentRamadanModel().timings.fajr.split(" ")[0],
        sunRise: getCurrentRamadanModel().timings.sunrise.split(" ")[0],
        zuhr: getCurrentRamadanModel().timings.dhuhr.split(" ")[0],
        asr: getCurrentRamadanModel().timings.asr.split(" ")[0],
        maghreb: getCurrentRamadanModel().timings.maghrib.split(" ")[0],
        isha: getCurrentRamadanModel().timings.isha.split(" ")[0]);
  }

  RamadanData getCurrentRamadanModel() {
    return getRamadanModel() == null
        ? null
        : getRamadanModel()[DateTime.now().day - 1];
  }
}
