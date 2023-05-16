import 'package:hijri/hijri_calendar.dart';
import 'package:muslim_book/ramadan/models/month_ramadan_model.dart';
import 'package:muslim_book/ramadan/models/ramadan_data.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';

class RamadanSingleton {
  List<RamadanData>? getRamadanModel() {
    final model = locator<Prefs>().getRamadanModel();
    if (model == null) {
      return null;
    } else {
      return MonthRamadanModel.fromJson(model).data;
    }
  }

  Future saveRamadanTimes() async {
    final currentRamadan = getCurrentRamadanModel();
    if (currentRamadan != null) {
      await locator<Prefs>().saveAzanTimes(
          fajr: currentRamadan.timings.fajr.split(" ")[0],
          sunRise: currentRamadan.timings.sunrise.split(" ")[0],
          zuhr: currentRamadan.timings.dhuhr.split(" ")[0],
          asr: currentRamadan.timings.asr.split(" ")[0],
          maghreb: currentRamadan.timings.maghrib.split(" ")[0],
          isha: currentRamadan.timings.isha.split(" ")[0]);
    }
  }

  RamadanData? getCurrentRamadanModel() {
    List<RamadanData>? ramadanModel = getRamadanModel();
    int index = HijriCalendar.now().hDay - 1;
    return ramadanModel == null
        ? null
        : ramadanModel[index];
  }
}
