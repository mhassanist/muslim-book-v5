import 'package:base_app/models/month_azan_model.dart';
import 'package:base_app/utils/locator.dart';
import 'package:base_app/utils/prefs.dart';

class AzanSingleton {
  List<AzanModel> getAzanModel() {
    if (locator<Prefs>().getAzanModel() == null) {
      return null;
    } else {
      MonthAzanModel model =
      MonthAzanModel.fromJson(locator<Prefs>().getAzanModel());
      return model.data;
    }
  }

  Future saveAzanTimes() async {
    await locator<Prefs>().saveAzanTimes(
        fajr: getCurrentAzanModel().timings.fajr.split(" ")[0],
        sunRise: getCurrentAzanModel().timings.sunrise.split(" ")[0],
        zuhr: getCurrentAzanModel().timings.dhuhr.split(" ")[0],
        asr: getCurrentAzanModel().timings.asr.split(" ")[0],
        maghreb: getCurrentAzanModel().timings.maghrib.split(" ")[0],
        isha: getCurrentAzanModel().timings.isha.split(" ")[0]);
  }

  AzanModel getCurrentAzanModel() {
    return getAzanModel() == null
        ? null
        : getAzanModel()[DateTime.now().day - 1];
  }
}
