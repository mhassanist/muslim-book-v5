import 'package:base_app/local_storage/local_storage_manager.dart';
import 'package:base_app/locals_utils/app_localizations.dart';
import 'package:base_app/models/azan_sound.dart';
import 'package:base_app/network_utils/azan_apis.dart';
import 'package:base_app/providers/view_state_provider.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/locator.dart';
import 'package:base_app/utils/prefs.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';

class SettingsProvider extends ViewStateProvider {
  BuildContext _context;
  bool _azanAlert,
      _mondaysAndThursdaysFastingAlert,
      _whiteDaysFastingAlert,
      _fajrIbtehal ,
  _isActivatingShaarawiVoice,
  _isRemmberActive
  ;
  bool _saveLocation  = false;
  bool _saveSetting   = false;
  String _countryName;
  String _pickedCountryName;
  String _pickedCityName;
  Map<String, dynamic> _pickedMethod;
  Map<String, dynamic> _pickedMazhab;
  Map<String, dynamic> _latitudeAdjustmentMethod;


  // static Map<String, dynamic> _pickedAzanShiekh;
  static Map<String, dynamic> _pickedAzanShiekhMain ={
    '1':"", '2':"", '3':"", '4':"", '5':"", '6':"",
  };
  static Map<String, dynamic> _pickedFajrAzanShiekh;

  bool alreadyFilledData = false;

  fillTheSettingsData() {

    if (!alreadyFilledData) {
      _isActivatingShaarawiVoice = locator<Prefs>().getActivatingAlShaarawiVoiceFlag() ;
      _isRemmberActive = locator<Prefs>().getVoiceReminderBeforePrayingFlag() ;
      _azanAlert = locator<Prefs>().getAzanOnPrayTimeFlag();
      _fajrIbtehal = locator<Prefs>().getFajrIbtehalFlag();
      _mondaysAndThursdaysFastingAlert =
          locator<Prefs>().getMondaysAndThursdaysFastingAlertFlag() ?? false;
      _whiteDaysFastingAlert =
          locator<Prefs>().getWhiteDaysFastingAlertFlag() ?? false;
      // _pickedCountryName = locator<Prefs>().getCountry() ?? "EG";
      print(_pickedCountryName);
      _pickedCityName = locator<Prefs>().getCity();
       print(locator<Prefs>().getLatitudeAdjustmentMethod());
      if(locator<Prefs>().getLatitudeAdjustmentMethod()!=null) {
        _latitudeAdjustmentMethod = (AppLocalizations.of(_context).isEnglish()
            ? Constants.EN_Latitude_Adjustment_Method
            : Constants.AR_Latitude_Adjustment_Method)[locator<Prefs>()
            .getLatitudeAdjustmentMethod()];
      }
      _pickedMethod = (AppLocalizations.of(_context).isEnglish()
          ? Constants.EN_AZAN_METHODS
          : Constants.AR_AZAN_METHODS)[locator<Prefs>().getAzanMethod() ?? 0];
      _pickedMazhab = (AppLocalizations.of(_context).isEnglish()
          ? Constants.EN_AZAN_Mazhabs
          : Constants.AR_AZAN_Mazhabs)[locator<Prefs>().getAzanMazhab()== null ? 0 :locator<Prefs>().getAzanMazhab() ];
      for (var i = 2; i < 7; i++) {
        String savedShiekLocalJSON =
            locator<Prefs>().getAzanShiekhJSON(i.toString());
        if (savedShiekLocalJSON == null) {
          String savedShiekhId = locator<Prefs>().getAzanShiekh(i.toString());
          if (savedShiekhId != null) {
            for (Map<String, dynamic> shiekh in Constants.SHIEKH_NAMES) {
              if (shiekh["id"] == savedShiekhId) {
                // _pickedAzanShiekh = shiekh;
                _pickedAzanShiekhMain[i.toString()] = shiekh;
                break;
              }
            }
          } else {
            // _pickedAzanShiekh = Constants.SHIEKH_NAMES[0];
            _pickedAzanShiekhMain[i.toString()] = Constants.SHIEKH_NAMES[0];
          }
          alreadyFilledData = true;
        } else {
          _pickedAzanShiekhMain[i.toString()] =
              AzanSound.toMap(savedShiekLocalJSON);
        }
      }

      //fajr part
      String savedFajrShiekLocalJSON = locator<Prefs>().getFajrAzanShiekhJSON();
      if (savedFajrShiekLocalJSON == null) {
        String savedShiekhId = locator<Prefs>().getFajrAzanShiekh();
        if (savedShiekhId != null) {
          for (Map<String, dynamic> shiekh in Constants.SHIEKH_NAMES) {
            if (shiekh["id"] == savedShiekhId) {
              _pickedFajrAzanShiekh = shiekh;
              break;
            }
          }
        } else {
          _pickedFajrAzanShiekh = Constants.FAJR_SHIEKH_NAMES[0];
        }
        alreadyFilledData = true;
      } else {
        _pickedFajrAzanShiekh = AzanSound.toMap(savedFajrShiekLocalJSON);
      }
    }
  }

  Map<String, dynamic> get pickedMethod => _pickedMethod;
  set pickedMethod(Map<String, dynamic> value) {
    _pickedMethod = value;
    notifyListeners();
  }
  Map<String, dynamic> get latitudeAdjustmentMethod => _latitudeAdjustmentMethod;
  set latitudeAdjustmentMethod(Map<String, dynamic> value) {
    _latitudeAdjustmentMethod = value;
    notifyListeners();
  }

  bool get saveLocation => _saveLocation;
  bool get saveSetting => _saveSetting;
  bool get isActivatingShaarawiVoice => _isActivatingShaarawiVoice;
  bool get isRemmberActive => _isRemmberActive;

  set isRemmberActive(bool value) {
    _isRemmberActive = value;
    notifyListeners();
  }
  set isActivatingShaarawiVoice(bool value) {
    _isActivatingShaarawiVoice = value;
    notifyListeners();
  }
  set saveLocation(bool value) {
    _saveLocation = value;
    notifyListeners();
  } set saveSetting(bool value) {
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

  get pickedCountryName => _pickedCountryName;

  get pickedCityName => _pickedCityName;

  get whiteDaysFastingAlert => _whiteDaysFastingAlert;

  get mondaysAndThursdaysFastingAlert => _mondaysAndThursdaysFastingAlert;

  bool get azanAlert => _azanAlert;

  String get countryName => _countryName;

  set countryName(String value) {
    this._countryName = value;
  }

  refreshAzanTimes() async {
    print("hosaaaaaaaaaaaaaaaaaaaaaaaam  3   ");
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
    // if (newVal) await Constants.platform.invokeMethod("fireAzan");
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
    // var response = await LocationUtilities().checkLocationPermission();
    var response;
    if (response != null) {
      countryName = (response as Placemark).country;
      pickedCountryName = (response as Placemark).isoCountryCode;
      String countryCode = (response as Address).countryCode;
      locator<Prefs>().setCountryCode(countryCode);
      locator<Prefs>().setLatitude((response as Placemark).position.latitude);
      locator<Prefs>().setLongtude((response as Placemark).position.longitude);
    }
  }

  Future enableWeeklyFastingAlerts() async {
    await Constants.platform
        .invokeMethod("createOrDeleteFastingMondaysAndThursdaysAlert");
  }
}
