import 'package:geocoding/geocoding.dart';
import 'package:muslim_book/locals_utils/app_localizations.dart';
import 'package:muslim_book/models/azan_sound.dart';
import 'package:muslim_book/network_utils/azan_apis.dart';
import 'package:muslim_book/providers/view_state_provider.dart';
import 'package:muslim_book/utils/Constants.dart';
import 'package:muslim_book/utils/location_utilities.dart';
import 'package:muslim_book/utils/locator.dart';
import 'package:muslim_book/utils/prefs.dart';
import 'package:flutter/material.dart';

class SettingsProvider extends ViewStateProvider {
  late BuildContext _context;
  bool? _azanAlert,
      _mondaysAndThursdaysFastingAlert,
      _whiteDaysFastingAlert,
      _fajrIbtehal,
      _isActivatingShaarawiVoice,
      _isTurnOffPrayerPhone,
      _isSwitchSilentModeAfterResidence,
      _isRemmberActive;

  bool _saveLocation = false;
  bool _saveSetting = false;
  String? _countryName;
  String? _pickedCountryName;
  String? _pickedCityName;
  Map<String, dynamic> _pickedMethod = {};
  Map<String, dynamic> _pickedMazhab = {};
  Map<String, dynamic> _latitudeAdjustmentMethod = {};

  void change() {
    notifyListeners();
  }

  static Map<String, dynamic> _pickedAzanShiekhMain = {};
  static Map<String, dynamic> _pickedFajrAzanShiekh = {};

  bool alreadyFilledData = false;

  fillTheSettingsData() async {
    if (!alreadyFilledData) {
      _isActivatingShaarawiVoice =
          locator<Prefs>().getActivatingAlShaarawiVoiceFlag();
      _isSwitchSilentModeAfterResidence =
          locator<Prefs>().getSwitchSilentModeAfterResidenceFlag();
      _isTurnOffPrayerPhone = locator<Prefs>().getTurnOffPrayerPhoneFlag();
      // SharedPreferences pprefs = await SharedPreferences.getInstance();

      _isRemmberActive = locator<Prefs>().getVoiceReminderBeforePrayingFlag();
      _azanAlert = locator<Prefs>().getAzanOnPrayTimeFlag();
      _fajrIbtehal = locator<Prefs>().getFajrIbtehalFlag();
      _mondaysAndThursdaysFastingAlert =
          locator<Prefs>().getMondaysAndThursdaysFastingAlertFlag() ?? false;
      _whiteDaysFastingAlert =
          locator<Prefs>().getWhiteDaysFastingAlertFlag() ?? false;
      // _pickedCountryName = locator<Prefs>().getCountry() ?? "EG";

      _pickedCityName = locator<Prefs>().getCity();
      if (locator<Prefs>().getLatitudeAdjustmentMethod() != -1) {
        _latitudeAdjustmentMethod = (AppLocalizations.of(_context)!.isEnglish()
                ? Constants.EN_Latitude_Adjustment_Method
                : Constants.AR_Latitude_Adjustment_Method)[
            locator<Prefs>().getLatitudeAdjustmentMethod()];
      }
      _pickedMethod = (AppLocalizations.of(_context)!.isEnglish()
          ? Constants.EN_AZAN_METHODS
          : Constants.AR_AZAN_METHODS)[locator<Prefs>().getAzanMethod()];
      _pickedMazhab = (AppLocalizations.of(_context)!.isEnglish()
          ? Constants.EN_AZAN_Mazhabs
          : Constants.AR_AZAN_Mazhabs)[locator<Prefs>().getAzanMazhab()];

      refreshShiekhNames();
      alreadyFilledData = true;
      notifyListeners();
    }
  }

  /// Shows the sheikhs the azan will actually play, read from the same keys
  /// the native side uses. Prayer 3 stands for "all prayers" in settings.
  void refreshShiekhNames() {
    final prefs = locator<Prefs>();
    final names = AppLocalizations.of(_context)!.isEnglish()
        ? Constants.EN_SHIEKH_NAMES
        : Constants.AR_SHIEKH_NAMES;
    String? name;
    if (prefs.getDownloadedAzanShiekhIdFor("3").isNotEmpty) {
      name = _sheikhNameFromJson(prefs.getAzanShiekhJSON("3"));
    }
    if (name == null) {
      final index = int.tryParse(prefs.getAzanShiekhLocalIdFor("3"));
      // With nothing picked the native side plays sheikh 1
      name = names[index != null && index >= 0 && index < names.length
          ? index
          : 1]["name"];
    }
    _pickedAzanShiekhMain = {"3": name};

    String? fajrName;
    if (prefs.getDownloadedFajrAzanSheikhId().isNotEmpty) {
      fajrName = _sheikhNameFromJson(prefs.getFajrAzanShiekhJSON());
    }
    _pickedFajrAzanShiekh = {
      "name": fajrName ?? Constants.FAJR_SHIEKH_NAMES[0]["name"],
    };
    notifyListeners();
  }

  String? _sheikhNameFromJson(String json) {
    try {
      return AzanSound.toMap(json)['name'] as String?;
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> get pickedMethod => _pickedMethod;

  set pickedMethod(Map<String, dynamic> value) {
    _pickedMethod = value;
    notifyListeners();
  }

  Map<String, dynamic> get latitudeAdjustmentMethod =>
      _latitudeAdjustmentMethod;

  set latitudeAdjustmentMethod(Map<String, dynamic> value) {
    _latitudeAdjustmentMethod = value;
    notifyListeners();
  }

  bool get saveLocation => _saveLocation;

  bool get saveSetting => _saveSetting;

  bool get isActivatingShaarawiVoice => _isActivatingShaarawiVoice ?? false;

  bool get isSwitchSilentModeAfterResidence =>
      _isSwitchSilentModeAfterResidence ?? false;

  bool get isTurnOffPrayerPhone => _isTurnOffPrayerPhone ?? false;

  bool get isRemmberActive => _isRemmberActive ?? false;

  set isRemmberActive(bool value) {
    _isRemmberActive = value;
    notifyListeners();
  }

  set isActivatingShaarawiVoice(bool value) {
    _isActivatingShaarawiVoice = value;
    notifyListeners();
  }

  set isSwitchSilentModeAfterResidence(bool value) {
    _isSwitchSilentModeAfterResidence = value;
    notifyListeners();
  }

  set isTurnOffPrayerPhone(bool value) {
    _isTurnOffPrayerPhone = value;
    notifyListeners();
  }

  set saveLocation(bool value) {
    _saveLocation = value;
    notifyListeners();
  }

  set saveSetting(bool value) {
    _saveLocation = value;
    notifyListeners();
  }

  Map<String, dynamic> get pickedAzanShiekhMain => _pickedAzanShiekhMain;

  set pickedAzanShiekhMain(Map<String, dynamic> value) {
    _pickedAzanShiekhMain = value;
    notifyListeners();
  }

  Map<String, dynamic> get pickedFajrAzanShiekh => _pickedFajrAzanShiekh;

  set pickedFajrAzanShiekh(Map<String, dynamic> value) {
    _pickedFajrAzanShiekh = value;
    notifyListeners();
  }

  Map<String, dynamic> get pickedMazhab => _pickedMazhab;

  set pickedMazhab(Map<String, dynamic> value) {
    _pickedMazhab = value;
    notifyListeners();
  }

  set context(BuildContext value) {
    _context = value;
  }

  set pickedCountryName(String s) {
    _pickedCountryName = s;
    locator<Prefs>().setCountry(s);
    notifyListeners();
  }

  set pickedCityName(String s) {
    _pickedCityName = s;
    locator<Prefs>().setCity(s);
    notifyListeners();
  }

  get fajrIbtehal => _fajrIbtehal;

  String get pickedCountryName => _pickedCountryName ?? '';

  String get pickedCityName => _pickedCityName ?? '';

  get whiteDaysFastingAlert => _whiteDaysFastingAlert;

  get mondaysAndThursdaysFastingAlert => _mondaysAndThursdaysFastingAlert;

  bool get azanAlert => _azanAlert ?? false;

  String get countryName => _countryName ?? '';

  set countryName(String value) {
    this._countryName = value;
  }

  refreshAzanTimes() async {
    await AzanApis().getAzan();
  }

  azanAlertFlagChanged(bool newVal) async {
    _azanAlert = newVal;
    locator<Prefs>().setAzanOnPrayTimeFlag(newVal);
    notifyListeners();
    if (newVal) await Constants.platform.invokeMethod("fireAzan");
  }

  isActivatingShaarawiVoiceFlagChanged(bool newVal) async {
    _isActivatingShaarawiVoice = newVal;
    locator<Prefs>().setActivatingAlShaarawiVoiceFlag(newVal);
    notifyListeners();
  }

  isSwitchSilentModeAfterResidenceChanged(bool newVal) async {
    _isSwitchSilentModeAfterResidence = newVal;
    locator<Prefs>().setSwitchSilentModeAfterResidenceFlag(newVal);
    await Constants.platform.invokeMethod("AllowPhoneState");

    notifyListeners();
  }

  isTurnOffPrayerPhoneChanged(bool newVal) async {
    _isTurnOffPrayerPhone = newVal;
    locator<Prefs>().setTurnOffPrayerPhoneFlag(newVal);
    await Constants.platform.invokeMethod("AllowPhoneState");
    notifyListeners();
  }

  isRemmberActiveFlagChanged(bool newVal) async {
    _isRemmberActive = newVal;
    locator<Prefs>().setVoiceReminderBeforePrayingFlag(newVal);
    notifyListeners();
    // if (newVal) await Constants.platform.invokeMethod("fireAzan");
  }

  mondaysAndThursdaysFastingAlertFlagChanged(bool newVal) {
    _mondaysAndThursdaysFastingAlert = newVal;
    locator<Prefs>().setMondaysAndThursdaysFastingAlertFlag(newVal);
    notifyListeners();
    enableWeeklyFastingAlerts();
  }

  whiteDaysFastingAlertFlagChanged(bool newVal) {
    _whiteDaysFastingAlert = newVal;
    locator<Prefs>().setWhiteDaysFastingAlertFlag(newVal);
    notifyListeners();
  }

  fajrIbtehalFlagChanged(bool newVal) {
    _fajrIbtehal = newVal;
    locator<Prefs>().setAllowFajrIbtehal(newVal);
    notifyListeners();
  }

  Future getLocation() async {
    var response = await LocationUtilities().checkLocationPermission();
    if (response != null) {
      countryName = (response as Placemark).country ?? '';
      pickedCountryName = response.isoCountryCode ?? '';
      // String countryCode = (response as Address).countryCode;
      String countryCode = response.isoCountryCode ?? '';
      locator<Prefs>().setCountryCode(countryCode);
      // locator<Prefs>().setLatitude(response.latitude);
      // locator<Prefs>().setLongtude(response.longitude);
    }
  }

  Future enableWeeklyFastingAlerts() async {
    await Constants.platform
        .invokeMethod("createOrDeleteFastingMondaysAndThursdaysAlert");
  }
}
