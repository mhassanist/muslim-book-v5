import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

int userRank = 0;

const localesPath = 'assets/langs';
const fallbackLocale = Locale('ar', 'SA');
const appLocals = {
  'ar': Locale('ar', 'SA'),
  'en': Locale('en', 'US'),
  'fr': Locale('fr', 'FR'),
};


class Constants {
  static const Color ICON_COLOR = Color(0XFF5D9775);
  // static const Color PRIMARY_COLOR = const Color(0XFF037e40);
  static const Color PRIMARY_COLOR = Color(0XFF347D53);
  // static const Color PRIMARY_DARK_COLOR = const Color(0XFF013f37);

  static const Color PRIMARY_DARK_COLOR = Color(0XFF347D53);
  static const Color ACCENT_COLOR = Color(0XFFa7bdca);
  static const Color ACCENT_SECONDARY_COLOR = Color(0XFFfad398);
  static const Color CANVAS_COLOR = Color(0XFFf5f5f5);
  static const Color SCREEN_TITLE_COLOR = Color(0XFFa7bdca);
  static const Color MAIN_TEXT_COLOR = Color(0XFF4d555b);
  static const String ALLOW_REPEAT_AYA = "allow_repeat_ayah";
  static const double KAABA_LAT = 21.4225;
  static const double KAABA_LNG = 39.8262;
  static const int LOGIN_WITH_GOOGLE = 1;
  static const String LOGIN_TYPE = "login_type";
  static const int LOGIN_WITH_FACEBOOK = 2;
  static const int LOGIN_WITH_Email = 3;

  static const int COMPETITIONS_ALARM_ID = 15323;
  static const int COMPETITIONS_ALARM_EVENING_HOUR = 20;
  static const int COMPETITIONS_ALARM_MORNING_HOUR = 12;

  static const String CITIES_OF_COUNTRY_URL =
      "http://battuta.medunes.net/api/region/";
  static const String GET_CITIES_API_KEY = "1649787aa414fa85ffac9de700b2e67f";
  static const String GET_CITIES_API_KEY2 = "4d7baac60715f4805926aa8e1fd8ed4a";

  //Fields
  static const String IS_FIRST_TIME = "is_first_time";
  static const platform =
      MethodChannel('com.muslim_book.muslim_book/channels');
  static const String COUNTRY = "country";
  static const String COUNTRY_CODE = "country_code";
  static const String CITY = "city";
  static const String REPEAT_AYAh_COUNT = "repeat_ayah_count";

  static const String LONGTUDE = "longtude";
  static const String AZAN_METHOD = "azan_method";
  static const String Latitude_Adjustment_Method = "latitudeAdjustmentMethod";

  static const String AZAN_MAZHAB = "azan_mazhab";

  static const String AZAN_SHIEKH = "azan_shiekh";
  static const String FAJR_AZAN_SHIEKH = "fajr_azan_shiekh";

  static const String AZAN_SHIEKH_LOCAL_ID = "AZAN_SHIEKH_LOCAL_ID";

  static const String LATITUDE = "latitude";

  static const String AZAN_ON_PRAY_TIME_FLAG = "azan_on_pray_time";
  static const String RAMADAN_CONNAN_FLAG = "ramadan_connan_flag";
  static const String RAMADAN_MASHRAAT_FLAG = "ramadan_mashraat_flag";
  static const String RAMADAN_MASHRAAT_TIME = "ramadan_mashraat_time";
  static const String Voice_Reminder_Before_Praying_FLAG = "voice_reminder_before_praying";
  static const String Activating_Al_Shaarawi_Voice_FLAG = "activating_al_shaarawi_voice";
  static const String Switch_Silent_Mode_After_Residence = "switch_silent_mode_after_residence";
  static const String Turn_Off_The_Call_To_Prayer_On_The_Phone = "turn_off_the_call_to_prayer_on_the_phone";
  static const String MONDAYS_AND_THURSDAYS_FASTING_ALERT_FLAG =
      "mondays_and_thursdays_fasting_alert";
  static const String WHITE_DAYS_FASTING_ALERT_FLAG =
      "white_days_fasting_alert";

  static const List<Map<String, dynamic>> AR_AZAN_METHODS=[
    {"title": "جامعة العلوم الإسلامية ، كراتشي", "id": "1"},
    {"title": 'الجمعية الإسلامية لأمريكا الشمالية', "id": "2"},
    {"title": 'رابطة العالم الإسلامي', "id": "3"},
    {"title": 'جامعة أم القرى بمكة المكرمة', "id": "4"},
    {"title": 'الهيئة المصرية العامة للمساحة', "id": "5"},
    {"title": 'منطقة الخليج', "id": "8"},
    {"title": 'دولة الكويت', "id": "9"},
    {"title": 'دولة قطر', "id": "10"},
    {"title": 'مجلس أوجاما إسلام سنغافورا ، سنغافورة', "id": "11"},
    {"title": 'منظمة الاتحاد الإسلامي في فرنسا', "id": "12"},
    {"title": 'رئاسة الشؤون الدينية ، تركيا', "id": "13"},
    {"title": 'الإدارة الروحية لمسلمي روسيا', "id": "14"},
  ];
  static const List<Map<String, dynamic>> EN_AZAN_METHODS = [
    {"title": "University of Islamic Sciences, Karachi", "id": "1"},
    {"title": "'Islamic Society of North America'", "id": "2"},
    {"title": 'Islamic world Union', "id": "3"},
    {"title":"Umm Al-Qura University in Makkah Al-Mukarramah" , "id": "4"},
    {"title": 'Egyptian General Authority for Survey', "id": "5"},
    {"title": 'Gulf area', "id": "8"},
    {"title": 'Kuwait', "id": "9"},
    {"title": 'Qatar', "id": "10"},
    {"title": 'Ojama Council of Islam Singapore, Singapore', "id": "11"},
    {"title": 'Organization of the Islamic Union in France', "id": "12"},
    {"title": 'Presidency of Religious Affairs, Turkey', "id": "13"},
    {"title": 'Spiritual management of the Muslims of Russia', "id": "14"},
  ];



  static const List<Map<String, dynamic>> AR_Latitude_Adjustment_Method = [
    {"title": "طريقه منتصف الليل", "id": "1"},
    {"title": 'طريقه ١/٧ من الليل', "id": "2"},
    {"title": 'طريقه حسابات الزوايا', "id": "3"},


  ];
  static const List<Map<String, dynamic>> EN_Latitude_Adjustment_Method = [
    {"title": "Middle of the Night", "id": "1"},
    {"title": 'Seventh of night', "id": "2"},
    {"title": 'Angle Based', "id": "3"},
  ];
  static const List<Map<String, dynamic>> AR_SHIEKH_NAMES = [
    {"name": "عبدالباسط عبدالصمد", "id": "1"},
    {"name": 'مشاري بن راشد العفاسي', "id": "2"},
    {"name": 'الحرم المكي', "id": "3"},
    {"name": 'مصطفي إسماعيل', "id": "4"},
    {"name": 'المسجد الأقصي (ناجي قزاز)', "id": "5"},
  ];

  static const List<Map<String, dynamic>> EN_SHIEKH_NAMES = [
    {"name": "Abdul Basit Abdul Samad", "id": "1"},
    {"name": 'Mishary bin Rashid Al-Afasy', "id": "2"},
    {"name": 'Grand Mosque in Mecca', "id": "3"},
    {"name": 'Mustafa Ismael', "id": "4"},
    {"name": 'Al-Aqsa Mosque (Naji Qazzaz)', "id": "5"},
  ];

  static const List<Map<String, dynamic>> FAJR_SHIEKH_NAMES = [
    {"name": "مشاري بن راشد العفاسي", "id": "1"},
  ];

  static const List<Map<String, dynamic>> AR_AZAN_Mazhabs = [
    {"title": 'الشافعي - الحنبلي - المالكي', "id": "0"},
    {"title": 'الحنفي', "id": "1"},
  ];

  static const List<Map<String, dynamic>> EN_AZAN_Mazhabs = [
    {"title": "Shafi'i - Hanbali - Maliki", "id": "0"},
    {"title": 'Hanafi', "id": "1"},
  ];

  static const String AZAN_MODEL = "azanModel";
  static const String RAMADAN_MODEL = "ramadanModel";
  static const int NO_CONNECTION_EXCEPTION = 41234;

  static const String BASE_URL = "https://muslim-book.net/api/";

  static const String BASE_API_URL = "www.muslim-book.net";
  static const String BASE_API_PATH = '/api/';
  
  static const int VERSION_NUMBER = 13;

  static const String ALFAJR_IBTEHAL_ALERT_FLAG = "allow_fajr_ibtehal";

  static const String LANG = "lang";

  static const String GOOGLE_API_KEY =
      "AIzaSyAQI_DGah7Xb6pHJq6AJDsvUHQPCTovV9U";

  //static const String LOGIN_SIGNUP_DATA = "login_signup_data";

  static const String IS_LOGGED = 'is_logged';

  static const String NAME = 'name';
  static const String EMAIL = 'email';
  static const String PHONE = 'Phone';
  static const String FLAG = 'flag';
  static const String COUNTRYNAME = 'country_name';
  static const String SHOW_SETTINGS = 'show_settings';

  static const String PASSWORD = 'password';

  static const String FACEBOOK_IOS_BANNER_ID = "";
  static const String FIRE_COMPETITION_POP_UP = "fireCompetitionPopUp";
  static const String Open_Competition = "openCompetition";
  static const String open_Azkar = "openAzkar";

  static const String AR = "ar";
  static const String EN = "en";

  static const String ID = "id";

  static const String IMAGE_URL = "image_url";
  static const String QURAN_BOX = "quran_box";
  static const String QURAN_DATABASE = "quran_database";
  static const String QURAN_USER_DATABASE = "quran_user_database";
  static const String ENGLISH_QURAN_DAO = "en_quran";
  static const String ENGLISH_TRANSLITERATION_DAO = "en_quran_translitration";
  static const int LAST_AYAH_NUMBER = 6236;

  static const String RECITERS_DATABASE = "reciters_database";

  static const String TRANSLATION_TRANSLITERATION_DATABASE =
      "translation_transliteration_database";

  static const String DOWNLOADED_TRANSLATION_DATABASE =
      "downloaded_translation_database";

  static const String MUTED_AZAN='MUTED_AZAN';
  static const String SELECTED_SHEIKH_JSON='SELECTED_SHEIKH_JSON';
  static const String SELECTED_RAMADAN_CANNON_JSON='SELECTED_RAMADAN_CANNON_JSON';
  static const String SELECTED_RAMADAN_MASHRaAAT_JSON='SELECTED_RAMADAN_MASHRaAAT_JSON';
  static const String SELECTED_FAJR_SHEIKH_JSON='SELECTED_FAJR_SHEIKH_JSON';

  static const String DOWNLOADED_SHEIKH_ID='SELECTED_SHEIKH_NAME_JSON';
  static const String SELECTED_RAMADAN_CANNON_ID='SELECTED_RAMADAN_CANNON_ID';
  static const String SELECTED_RAMADAN_MASHRAAT_ID='SELECTED_RAMADAN_MASHRAAT_ID';
  static const String DOWNLOADED_FAJR_SHEIKH_ID='DOWNLOADED_FAJR_SHEIKH_ID';
  static const String SELECTED_MASHRAAT_REPETITION_ID='SELECTED_MASHRAAT_REPETITION_ID';
  static const String CHECK_REPETITION="CHECK_REPETITION";
  static const String USER_TOKEN="USER_TOKEN";

}
