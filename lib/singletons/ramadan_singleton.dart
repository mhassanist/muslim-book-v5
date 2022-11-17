import 'package:base_app/ramadan/models/month_ramadan_model.dart';
import 'package:base_app/ramadan/models/ramadan_data.dart';
import 'package:base_app/utils/locator.dart';
import 'package:base_app/utils/prefs.dart';

class RamadanSingleton {
  List<RamadanData>? getRamadanModel() {
    if (locator<Prefs>().getRamadanModel().isEmpty) {
      return null;
    } else {
      MonthRamadanModel model =
          MonthRamadanModel.fromJson(locator<Prefs>().getRamadanModel());
      return model.data;
    }
  }

  Future saveRamadanTimes() async {
    final ramadanData = getCurrentRamadanModel();
    if (ramadanData != null) {
      await locator<Prefs>().saveAzanTimes(
          fajr: ramadanData.timings.fajr.split(" ")[0],
          sunRise: ramadanData.timings.sunrise.split(" ")[0],
          zuhr: ramadanData.timings.dhuhr.split(" ")[0],
          asr: ramadanData.timings.asr.split(" ")[0],
          maghreb: ramadanData.timings.maghrib.split(" ")[0],
          isha: ramadanData.timings.isha.split(" ")[0]);
    }
  }

  RamadanData? getCurrentRamadanModel() {
    return getRamadanModel() == null
        ? null
        : getRamadanModel()![DateTime.now().day - 1];
  }
}
