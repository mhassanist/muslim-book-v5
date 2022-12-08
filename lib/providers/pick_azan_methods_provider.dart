import 'package:muslim_book/azan_feature/controllers/azan_controller.dart';
import 'package:muslim_book/enums/view_state_enum.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/providers/view_state_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/network_utils/azan_apis.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:muslim_book/views/azan_settings_views/adjust_battery_view.dart';
import 'package:get/get.dart';

class PickAzanMethodsProvider extends ViewStateProvider {
  Map<String, dynamic> _pickedMazhab = {};
  Map<String, dynamic> _pickedMethod= {};
  Map<String, dynamic> get pickedMazhab => _pickedMazhab;

  Map<String, dynamic> get pickedMethod => _pickedMethod;

  Map<String, dynamic> _pickedAzanShiekh = {};
  Map<String, dynamic> _pickedFajrAzanShiekh = {};

  Map<String, dynamic> get pickedFajrAzanShiekh => _pickedFajrAzanShiekh;

  set pickedFajrAzanShiekh(Map<String, dynamic> value) {
    _pickedFajrAzanShiekh = value;
    notifyListeners();

  } // bool _azanAlert = true,
  //     _mondaysAndThursdaysFastingAlert = true,
  //     _whiteDaysFastingAlert = true,
  //     _fajrIbtehal = true;

  bool _fajrIbtehal = false;

  get fajrIbtehal => _fajrIbtehal;

  Map<String, dynamic> get pickedAzanShiekh => _pickedAzanShiekh;

  set pickedAzanShiekh(Map<String, dynamic> value) {
    _pickedAzanShiekh = value;
    notifyListeners();
  }

  // get whiteDaysFastingAlert => _whiteDaysFastingAlert;

  // get mondaysAndThursdaysFastingAlert => _mondaysAndThursdaysFastingAlert;

  // bool get azanAlert => _azanAlert;

  // azanAlertFlagChanged(bool newVal) async {
  //   _azanAlert = newVal;
  //   notifyListeners();
  // }

  // mondaysAndThursdaysFastingAlertFlagChanged(bool newVal) {
  //   _mondaysAndThursdaysFastingAlert = newVal;
  //   notifyListeners();
  // }

  // whiteDaysFastingAlertFlagChanged(bool newVal) {
  //   _whiteDaysFastingAlert = newVal;
  //   notifyListeners();
  // }

  fajrIbtehalFlagChanged(bool newVal) {
    _fajrIbtehal = newVal;
    notifyListeners();
  }

  set pickedMazhab(Map<String, dynamic> value) {
    _pickedMazhab = value;
    notifyListeners();
  }

  set pickedMethod(Map<String, dynamic> value) {
    _pickedMethod = value;
    notifyListeners();
  }

  Future saveSettings(context) async {
    setViewState(ViewState.Loading);
    locator<Prefs>().setAzanOnPrayTimeFlag(true);
    // if (_azanAlert)
    locator<Prefs>().setMondaysAndThursdaysFastingAlertFlag(true);

    locator<Prefs>().setWhiteDaysFastingAlertFlag(true);

    locator<Prefs>().setAllowFajrIbtehal(_fajrIbtehal);

    locator<Prefs>().setAzanMethod(_pickedMethod.isNotEmpty ?  (AppLocalizations.of(context)!.isEnglish()
            ? Constants.EN_AZAN_METHODS
            : Constants.AR_AZAN_METHODS)
        .indexOf( _pickedMethod ) :1 );

    locator<Prefs>().setAzanMazhab(_pickedMazhab.isNotEmpty ?(AppLocalizations.of(context)!.isEnglish()
            ? Constants.EN_AZAN_Mazhabs
            : Constants.AR_AZAN_Mazhabs)
        .indexOf( _pickedMazhab ): 0);

    enableWeeklyFastingAlerts();
     await AzanApis().getAzan();
    await Constants.platform.invokeMethod("fireAzan");
    await Constants.platform.invokeMethod("fireCannonRamadan");
    await Constants.platform.invokeMethod("fireMshartRamadan");
    Get.find<AzanController>().setNextSalah();
    setViewState(ViewState.Idle);
    locator<Prefs>().setShowSettings(true);
    var checkBattery =
        await Constants.platform.invokeMethod("checkBatteryEditing");
    if (!checkBattery)
      Get.dialog(AdjustBatteryView(isStart: true ));
    else {
      locator<Prefs>().setShowSettings(true);
      locator<Prefs>().setIsFirstTime(false);
      Get.offAllNamed("/start_view");
    }
  }

  Future enableWeeklyFastingAlerts() async {
    await Constants.platform
        .invokeMethod("createOrDeleteFastingMondaysAndThursdaysAlert");
  }

  provideDefaultValueToMazhab(context) {
    _pickedMazhab = (AppLocalizations.of(context)!.isEnglish()
        ? Constants.EN_AZAN_Mazhabs
        : Constants.AR_AZAN_Mazhabs)[0];
  }

  provideDefaultValueToMethod(context) {
    String savedCountry = locator<Prefs>().getCountry();
    if (savedCountry.isNotEmpty) {
      switch (savedCountry.toLowerCase()) {
        case "in":
        case "cn":
          _pickedMethod = (AppLocalizations.of(context)!.isEnglish()
              ? Constants.EN_AZAN_METHODS
              : Constants.AR_AZAN_METHODS)[_indexOfInAzanMethods(context, {
            "title": "جامعة العلوم الإسلامية ، كراتشي",
            "id": "1"
          })];
          break;
        case "ca":
        case "mx":
        case "us":
          _pickedMethod = (AppLocalizations.of(context)!.isEnglish()
              ? Constants.EN_AZAN_METHODS
              : Constants.AR_AZAN_METHODS)[_indexOfInAzanMethods(context, {
            "title": 'الجمعية الإسلامية لأمريكا الشمالية',
            "id": "2"
          })];
          break;
        case "sa":
          _pickedMethod = (AppLocalizations.of(context)!.isEnglish()
              ? Constants.EN_AZAN_METHODS
              : Constants
                  .AR_AZAN_METHODS)[_indexOfInAzanMethods(
              context, {"title": 'جامعة أم القرى بمكة المكرمة', "id": "4"})];
          break;
        case "eg":
          _pickedMethod = (AppLocalizations.of(context)!.isEnglish()
              ? Constants.EN_AZAN_METHODS
              : Constants
                  .AR_AZAN_METHODS)[_indexOfInAzanMethods(
              context, {"title": 'الهيئة المصرية العامة للمساحة', "id": "5"})];
          break;
        case "ae":
        case "bh":
          _pickedMethod = (AppLocalizations.of(context)!.isEnglish()
                  ? Constants.EN_AZAN_METHODS
                  : Constants.AR_AZAN_METHODS)[
              _indexOfInAzanMethods(
                  context, {"title": 'منطقة الخليج', "id": "8"})];
          break;
        case "kw":
          _pickedMethod = (AppLocalizations.of(context)!.isEnglish()
                  ? Constants.EN_AZAN_METHODS
                  : Constants.AR_AZAN_METHODS)[
              _indexOfInAzanMethods(
                  context, {"title": 'دولة الكويت', "id": "9"})];
          break;
        case "qa":
          _pickedMethod = (AppLocalizations.of(context)!.isEnglish()
                  ? Constants.EN_AZAN_METHODS
                  : Constants.AR_AZAN_METHODS)[
              _indexOfInAzanMethods(
                  context, {"title": 'دولة قطر', "id": "10"})];
          break;
        case "sg":
          _pickedMethod = (AppLocalizations.of(context)!.isEnglish()
              ? Constants.EN_AZAN_METHODS
              : Constants.AR_AZAN_METHODS)[_indexOfInAzanMethods(context, {
            "title": 'مجلس أوجاما إسلام سنغافورا ، سنغافورة',
            "id": "11"
          })];
          break;
        case "fr":
          _pickedMethod = (AppLocalizations.of(context)!.isEnglish()
              ? Constants.EN_AZAN_METHODS
              : Constants.AR_AZAN_METHODS)[_indexOfInAzanMethods(context, {
            "title": 'منظمة الاتحاد الإسلامي في فرنسا',
            "id": "12"
          })];
          break;
        case "tr":
          _pickedMethod = (AppLocalizations.of(context)!.isEnglish()
              ? Constants.EN_AZAN_METHODS
              : Constants
                  .AR_AZAN_METHODS)[_indexOfInAzanMethods(
              context, {"title": 'رئاسة الشؤون الدينية ، تركيا', "id": "13"})];
          break;
        case "ru":
          _pickedMethod = (AppLocalizations.of(context)!.isEnglish()
              ? Constants.EN_AZAN_METHODS
              : Constants
                  .AR_AZAN_METHODS)[_indexOfInAzanMethods(
              context, {"title": 'الإدارة الروحية لمسلمي روسيا', "id": "14"})];
          break;
      }
    }
  }

  int _indexOfInAzanMethods(context, map) {
    int index = -1;
    List methodsList = (AppLocalizations.of(context)!.isEnglish()
        ? Constants.EN_AZAN_METHODS
        : Constants.AR_AZAN_METHODS);
    for (Map<String, dynamic> method in methodsList) {
      if (method["id"] == map["id"]) {
        index = methodsList.indexOf(method);
        break;
      }
    }
    return index;
  }
  @override
  void dispose() {
     super.dispose();
  }
}
