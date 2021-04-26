import 'dart:convert';

import 'package:base_app/singletons/azan_singleton.dart';
import 'package:base_app/singletons/ramadan_singleton.dart';
import 'package:base_app/utils/Constants.dart';
import 'package:base_app/utils/locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  SharedPreferences prefs;

  Future setSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void setIsFirstTime(bool value) async {
    await prefs.setBool(Constants.IS_FIRST_TIME, value);
  }

  bool getIsFirstTime() => prefs.getBool(Constants.IS_FIRST_TIME) == null;

  void setCountry(String value) async {
    await prefs.setString(Constants.COUNTRY, value);
  }

  String getCountry() => prefs.getString(Constants.COUNTRY);

  void setId(String value) async {
    await prefs.setString(Constants.ID, value);
  }

  String getId() => prefs.getString(Constants.ID);

  void setCountryCode(String value) async {
    await prefs.setString(Constants.COUNTRY_CODE, value);
  }

  String getCountryCode() => prefs.getString(Constants.COUNTRY_CODE);

  void setCity(String value) async {
    await prefs.setString(Constants.CITY, value);
  }

  String getCity() => prefs.getString(Constants.CITY);

  void setLatitude(double value) async =>
      await prefs.setDouble(Constants.LATITUDE, value);

  double getLatitue() => prefs.getDouble(Constants.LATITUDE);

  void setLongtude(double value) async =>
      await prefs.setDouble(Constants.LONGTUDE, value);

  double getLongtude() => prefs.getDouble(Constants.LONGTUDE);

  int getAzanMethod() => prefs.getInt(Constants.AZAN_METHOD);

  void setAzanMethod(int value) async {
    await prefs.setInt(Constants.AZAN_METHOD, value);
  }

  int getLatitudeAdjustmentMethod() =>
      prefs.getInt(Constants.Latitude_Adjustment_Method);

  void setLatitudeAdjustmentMethod(int value) async {
    await prefs.setInt(Constants.Latitude_Adjustment_Method, value);
  }

  int get loginType => prefs.getInt(Constants.LOGIN_TYPE);

  void setLoginType(int value) async {
    await prefs.setInt(Constants.LOGIN_TYPE, value);
  }

  int getAzanMazhab() => prefs.getInt(Constants.AZAN_MAZHAB);

  void setAzanMazhab(int value) async {
    await prefs.setInt(Constants.AZAN_MAZHAB, value);
  }

  String getAzanShiekh(String azanId) {
    return prefs.getString('${Constants.AZAN_SHIEKH}$azanId');
  }

  String getFajrAzanShiekh() => prefs.getString(Constants.FAJR_AZAN_SHIEKH);

  void setAzanShiekh(String value, String azanId) async {
    String values = '${Constants.AZAN_SHIEKH}$azanId';

    await prefs.setString(values, value);
    // await prefs.setString(Constants.AZAN_SHIEKH, value);
  }

  void setFajrAzanShiekhIdAsset(String value) async {
    await prefs.setString(Constants.FAJR_AZAN_SHIEKH, value);
  }

  void setAzanShiekhLocalId(int id) async {
    await prefs.setInt(Constants.AZAN_SHIEKH_LOCAL_ID, id);
  }

  String getAzanModel() => prefs.getString(Constants.AZAN_MODEL);

  String getRamadanModel() => prefs.getString(Constants.RAMADAN_MODEL);

  Future setAzanModel(String value) async {
    await prefs.setString(Constants.AZAN_MODEL, value);
    locator<AzanSingleton>().getAzanModel();
  }

  Future setRamadanModel(String value) async {
    await prefs.setString(Constants.RAMADAN_MODEL, value);
    locator<RamadanSingleton>().getRamadanModel();
  }

  Future saveAzanTimes(
      {String fajr,
      String zuhr,
      String asr,
      String maghreb,
      String isha,
      String sunRise}) async {
    await prefs.setString("1", fajr);
    await prefs.setString("2", sunRise);
    await prefs.setString("3", zuhr);
    await prefs.setString("4", asr);
    await prefs.setString("5", maghreb);
    await prefs.setString("6", isha);
  }

  // Future saveAzanTimesView(
  //     {String fajr,
  //       String zuhr,
  //       String asr,
  //       String maghreb,
  //       String isha,
  //       String sunRise}) async {
  //   await prefs.setString("fajr", fajr);
  //   await prefs.setString("sunRise", sunRise);
  //   await prefs.setString("zuhr", zuhr);
  //   await prefs.setString("asr", asr);
  //   await prefs.setString("maghreb", maghreb);
  //   await prefs.setString("isha", isha);
  // }
  updateString(String key, String value) async {
    await prefs.setString(key, value);
  }

  String getAssalahTime(value) {
    return prefs.getString(value);
  }

  void setAzanOnPrayTimeFlag(bool value) async {
    await prefs.setBool(Constants.AZAN_ON_PRAY_TIME_FLAG, value);
  }

  bool getAzanOnPrayTimeFlag() =>
      prefs.getBool(Constants.AZAN_ON_PRAY_TIME_FLAG) == null ||
      prefs.getBool(Constants.AZAN_ON_PRAY_TIME_FLAG);

  bool getRamadanConnanFlag() => prefs.getBool(Constants.RAMADAN_CONNAN_FLAG);

  void setRamadanConnanFlag(bool value) async {
    await prefs.setBool(Constants.RAMADAN_CONNAN_FLAG, value);
  }

  void setRamadanMashartTime(String value) async {
    await prefs.setString(Constants.RAMADAN_MASHRAAT_TIME, value);
  }

  String getRamadanMashartTime() {
    return prefs.getString(Constants.RAMADAN_MASHRAAT_TIME);
  }

  bool getRamadanMashraatFlag() =>
      prefs.getBool(Constants.RAMADAN_MASHRAAT_FLAG);

  void setRamadanMashraatFlag(bool value) async {
    await prefs.setBool(Constants.RAMADAN_MASHRAAT_FLAG, value);
  }

  void setVoiceReminderBeforePrayingFlag(bool value) async {
    await prefs.setBool(Constants.Voice_Reminder_Before_Praying_FLAG, value);
  }

  bool getVoiceReminderBeforePrayingFlag() =>
      prefs.getBool(Constants.Voice_Reminder_Before_Praying_FLAG) == null ||
      prefs.getBool(Constants.Voice_Reminder_Before_Praying_FLAG);

  void setActivatingAlShaarawiVoiceFlag(bool value) async {
    await prefs.setBool(Constants.Activating_Al_Shaarawi_Voice_FLAG, value);
  }

  bool getActivatingAlShaarawiVoiceFlag() =>
      prefs.getBool(Constants.Activating_Al_Shaarawi_Voice_FLAG) == null ||
      prefs.getBool(Constants.Activating_Al_Shaarawi_Voice_FLAG);

  void setMondaysAndThursdaysFastingAlertFlag(bool value) async {
    await prefs.setBool(
        Constants.MONDAYS_AND_THURSDAYS_FASTING_ALERT_FLAG, value);
  }

  bool getMondaysAndThursdaysFastingAlertFlag() =>
      prefs.getBool(Constants.MONDAYS_AND_THURSDAYS_FASTING_ALERT_FLAG);

  void setWhiteDaysFastingAlertFlag(bool value) async {
    await prefs.setBool(Constants.WHITE_DAYS_FASTING_ALERT_FLAG, value);
  }

  bool getWhiteDaysFastingAlertFlag() =>
      prefs.getBool(Constants.WHITE_DAYS_FASTING_ALERT_FLAG);

  bool get getIsAzanUrlValid => (getAzanMazhab() != null &&
      getAzanMethod() != null &&
      ((getLatitue() != null && getLatitue() != null) || getCountry() != null));

  void setAllowFajrIbtehal(bool value) async {
    await prefs.setBool(Constants.ALFAJR_IBTEHAL_ALERT_FLAG, value);
  }

  bool getFajrIbtehalFlag() =>
      prefs.getBool(Constants.ALFAJR_IBTEHAL_ALERT_FLAG) == null ||
      prefs.getBool(Constants.ALFAJR_IBTEHAL_ALERT_FLAG);

  String getLang() => prefs.getString(Constants.LANG) == null
      ? "ar"
      : prefs.getString(Constants.LANG);

  // String getLoginSignupData() =>
  //     prefs.getString(Constants.LOGIN_SIGNUP_DATA) == null
  //         ? '{"email":"", "id":0, "image":"", "name":"", "api_token":""}'
  //         : prefs.getString(Constants.LOGIN_SIGNUP_DATA);

  // void setLoginSignupData(String value) async {
  //   await prefs.setString(Constants.LOGIN_SIGNUP_DATA, value);
  //}

  bool getIsLogged() => prefs.getBool(Constants.IS_LOGGED) == null
      ? false
      : prefs.getBool(Constants.IS_LOGGED);

  void setIsLogged(bool value) async {
    await prefs.setBool(Constants.IS_LOGGED, value);
  }

  bool getShowSettings() => prefs.getBool(Constants.SHOW_SETTINGS) == null
      ? false
      : prefs.getBool(Constants.SHOW_SETTINGS);

  void setShowSettings(bool value) async {
    await prefs.setBool(Constants.SHOW_SETTINGS, value);
  }

  void setName(String value) async {
    await prefs.setString(Constants.NAME, value);
  }

  String getName() => prefs.getString(Constants.NAME) == null
      ? ''
      : prefs.getString(Constants.NAME);

  void setFlag(String value) async {
    await prefs.setString(Constants.FLAG, value);
  }

  String getFlag() => prefs.getString(Constants.FLAG) == null
      ? ''
      : prefs.getString(Constants.FLAG);

  void setPhone(String value) async {
    await prefs.setString(Constants.PHONE, value);
  }

  String getPhone() => prefs.getString(Constants.PHONE) == null
      ? ''
      : prefs.getString(Constants.PHONE);

  void setCountryName(String value) async {
    await prefs.setString(Constants.COUNTRYNAME, value);
  }

  String getCountryName() => prefs.getString(Constants.COUNTRYNAME) == null
      ? ''
      : prefs.getString(Constants.COUNTRYNAME);

  void setEmail(String value) async {
    await prefs.setString(Constants.EMAIL, value);
  }

  void setPassword(String value) async {
    await prefs.setString(Constants.PASSWORD, value);
  }

  String getEmail() => prefs.getString(Constants.EMAIL) == null
      ? ''
      : prefs.getString(Constants.EMAIL);

  String getPassword() => prefs.getString(Constants.PASSWORD) == null
      ? ''
      : prefs.getString(Constants.PASSWORD);

  void setImageUrl(String value) async {
    await prefs.setString(Constants.IMAGE_URL, value);
  }

  String getImageUrl() => prefs.getString(Constants.IMAGE_URL);

  void setAyahRepeetCount(int val) async {
    await prefs.setInt(Constants.REPEAT_AYAh_COUNT, val);
  }

  int get ayahRepeatCount => prefs.getInt(Constants.REPEAT_AYAh_COUNT) ?? 2;

  void setAllowRepeatingAyah(bool val) async {
    await prefs.setBool(Constants.ALLOW_REPEAT_AYA, val);
  }

  bool get allowRepeatingAyah =>
      prefs.getBool(Constants.ALLOW_REPEAT_AYA) ?? false;

  bool get allowTasbeehClickSound =>
      prefs.getBool("allowTasbeehClickVoice") ?? false;

  void setTasbeehClickSound(bool val) async {
    await prefs.setBool("allowTasbeehClickVoice", val);
  }

  String get lastUpdatedTasbeehDate =>
      prefs.getString("lastUpdatedTasbeehDate");

  void setLastUpdatedTasbeehDate(String val) async {
    await prefs.setString("lastUpdatedTasbeehDate", val);
  }

  Future setSebhaCount(int total) async {
    await prefs.setInt("sebhaCount", total);
  }

  int get sebhaCount => prefs.getInt("sebhaCount") ?? 0;

  String get lastUpdatedShowShareDialogTap =>
      prefs.getString("lastUpdatedShowShareDialogTap");

  void setLastUpdatedShowShareDialogTap(String val) async {
    await prefs.setString("lastUpdatedShowShareDialogTap", val);
  }

  setAzanShiekhJSON(Map<String, dynamic> sheikhJson, String azanId) async {
    await setAzanShiekhIdFromJSON(sheikhJson['id'].toString(), azanId);
    await prefs.setString(
        '${Constants.SELECTED_SHEIKH_JSON}$azanId', json.encode(sheikhJson));
    // await prefs.setString(Constants.SELECTED_SHEIKH_JSON, json.encode(sheikhJson));
  }

  setRamadanCannonJSON(Map<String, dynamic> soundJson, String azanId) async {
    await setRamadanCannonSoundJSON(soundJson['id'].toString(), azanId);
    await prefs.setString('${Constants.SELECTED_RAMADAN_CANNON_JSON}$azanId',
        json.encode(soundJson));
  }

  setRamadanMashraatJSON(Map<String, dynamic> soundJson, String azanId) async {
    await setRamadanMashraatSoundJSON(soundJson['id'].toString(), azanId);
    await prefs.setString('${Constants.SELECTED_RAMADAN_MASHRaAAT_JSON}$azanId',
        json.encode(soundJson));
  }

  setFajrAzanShiekhJSON(Map<String, dynamic> sheikhJson) async {
    await setDownloadedFajrAzanSheikhID(sheikhJson['id'].toString());
    await prefs.setString(
        Constants.SELECTED_FAJR_SHEIKH_JSON, json.encode(sheikhJson));
  }

  setAzanShiekhIdFromJSON(String id, String azanId) async {
    await prefs.setString('${Constants.DOWNLOADED_SHEIKH_ID}$azanId', id);
  }

  setRamadanCannonSoundJSON(String id, String azanId) async {
    print("setRamadanCannonSoundJSON  " + id);
    await prefs.setString('${Constants.SELECTED_RAMADAN_CANNON_ID}$azanId', id);
  }

  setRamadanMashraatSoundJSON(String id, String azanId) async {
    await prefs.setString(
        '${Constants.SELECTED_RAMADAN_MASHRAAT_ID}$azanId', id);
  }

  getAzanShiekhJSON(String azanId) {
    String sheihkJson =
        prefs.getString('${Constants.SELECTED_SHEIKH_JSON}$azanId');
    return sheihkJson;
  }

  getRamadanCannonJSON(String soundCannon) {
    String ramadanCannonJson = prefs
        .getString('${Constants.SELECTED_RAMADAN_CANNON_JSON}$soundCannon');
    return ramadanCannonJson;
  }

  getRamadanMashraatJSON(String soundCannon) {
    String ramadanCannonJson = prefs
        .getString('${Constants.SELECTED_RAMADAN_MASHRaAAT_JSON}$soundCannon');
    return ramadanCannonJson;
  }

  String getDownloadedAzanShiekhId() {
    return prefs.getString(Constants.DOWNLOADED_SHEIKH_ID);
  }

  String getDownloadSelectedRamadanConnanID(String azanId) {
    return prefs.getString('${Constants.SELECTED_RAMADAN_CANNON_ID}$azanId');
  }

  String getDownloadSelectedRamadanMshartID(String azanId) {
    return prefs.getString('${Constants.SELECTED_RAMADAN_MASHRAAT_ID}$azanId');
  }

  setDownloadedFajrAzanSheikhID(String id) async {
    await prefs.setString(Constants.DOWNLOADED_FAJR_SHEIKH_ID, id);
  }

  setSelectedMashraatRepetitionsId(String id) async {
    await prefs.setString(Constants.SELECTED_MASHRAAT_REPETITION_ID, id);
  }  setCHECKREPETITIONRepetitionsId(String id) async {
    await prefs.setString(Constants.CHECK_REPETITION, id);
  }

  String getSelectedMashraatRepetitionsId() =>
      prefs.getString(Constants.SELECTED_MASHRAAT_REPETITION_ID);

  String getFajrAzanShiekhJSON() {
    return prefs.getString(Constants.SELECTED_FAJR_SHEIKH_JSON);
  }

  saveMutedAzanList(String mutedAzanList) async {
    prefs.remove(Constants.MUTED_AZAN);
    prefs.setString(Constants.MUTED_AZAN, mutedAzanList);
  }

  String getMutedAzanList() {
    return prefs.getString(Constants.MUTED_AZAN);
  }

// Future<void> saveFilter() async {
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   final String entriesJson =
//   json.encode(filter.map((entry) => entry.toMap()).toList());
//   prefs.setString('filter', entriesJson);
// }
}
