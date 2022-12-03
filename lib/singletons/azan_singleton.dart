import 'package:muslim_book/models/month_azan_model.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';

class AzanSingleton {
  List<AzanModel>? getAzanModel() {
    if (locator<Prefs>().getAzanModel().isEmpty) {
      return null;
    } else {
      final model = MonthAzanModel.fromJson(locator<Prefs>().getAzanModel());
      return model.data;
    }
  }

  Future saveAzanTimes() async {
    final azanModel = getCurrentAzanModel();
    if (azanModel == null) return;
    await locator<Prefs>().saveAzanTimes(
        fajr: azanModel.timings.fajr.split(" ")[0],
        sunRise: azanModel.timings.sunrise.split(" ")[0],
        zuhr: azanModel.timings.dhuhr.split(" ")[0],
        asr: azanModel.timings.asr.split(" ")[0],
        maghreb: azanModel.timings.maghrib.split(" ")[0],
        isha: azanModel.timings.isha.split(" ")[0]);
  }

  AzanModel? getCurrentAzanModel() {
    return getAzanModel() == null
        ? null
        : getAzanModel()![DateTime.now().day - 1];
  }
}
