
package com.muslim_book.muslim_book.classes;

import android.app.ActivityManager;
import android.content.ComponentName;
import android.content.Context;
import android.content.pm.PackageManager;

import com.muslim_book.muslim_book.recievers.azan.AzanReceiver;
import com.muslim_book.muslim_book.recievers.ramadan.RamadanCannonReceiver;
import com.muslim_book.muslim_book.recievers.ramadan.RamadanMshartReceiver;
  
public class Constants {

  public static final String NextRamadan_Cannon_Time = "ramadanCannonTime";
//   public static final String RAMADAN_KEY = "ramadanKEY";
  public static final String RAMADAN_MASHRAAT_TIME = "ramadan_mashraat_time";
  public static final String NEXT_AZAN_TIME = "nextAzanTime";
  public static final String NEXT_AZAN_KEY = "nextAzanKEY";
  public static final String FLUTTER_SHARED_PREFERENCES = "FlutterSharedPreferences";
  public static final String AZAN_MODEL= "azanModel";
  public static final String RAMADAN_MODEL= "ramadanModel";
   public static final String FLUTTER_TAG= "flutter.";
  public static final String AZAN_ON_PRAY_TIME_FLAG = "flutter.azan_on_pray_time";
   public static final String Voice_Reminder_Before_Praying_FLAG = "flutter.voice_reminder_before_praying";
  public static final String Activating_Al_Shaarawi_Voice_FLAG = "flutter.activating_al_shaarawi_voice";
  public static final String Switch_Silent_Mode_After_Residence = "flutter.switch_silent_mode_after_residence";
  public static final String Turn_Off_The_Call_To_Prayer_On_The_Phone = "flutter.turn_off_the_call_to_prayer_on_the_phone";
  public static final String RAMADAN_CONNAN_FLAG = "flutter.ramadan_connan_flag";
  public static final String RAMADAN_MASHRAAT_FLAG = "flutter.ramadan_mashraat_flag";
  public static final String FASTING_MONDAYS_AND_THURSDAYS_ALERT_FLAG = "flutter.mondays_and_thursdays_fasting_alert";

  public static final String AZAN_BROAD_CAST_RECEIVER = "AZAN_RECEIVER";
  public static final int AZAN_PENDING_INTENT_REQUEST_CODE = 3423;
  public static final int RAMADAN_CANNON_PENDING_INTENT_REQUEST_CODE = 3422;
  public static final int RAMADAN_MSHART_PENDING_INTENT_REQUEST_CODE = 3421;
  public static final int BEFORE_AZAN_PENDING_INTENT_REQUEST_CODE = 412;
  public static final int BEFORE_RAMADAN_PENDING_INTENT_REQUEST_CODE = 411;
  public static final int FASTING_MONDAY_PENDING_INTENT_REQUEST_CODE = 3434;
  public static final int FASTING_THURSDAY_PENDING_INTENT_REQUEST_CODE = 4552;

  public static final int MORNING_Competition_PENDING_INTENT_REQUEST_CODE = 524353;
  public static final int EVENING_Competition_PENDING_INTENT_REQUEST_CODE = 52433;
  public static final int EVENING_RAMADAN_CONNAN_PENDING_INTENT_REQUEST_CODE = 524333;
  public static final int MORNING_RAMADAN_MASHARAAT_PENDING_INTENT_REQUEST_CODE = 5243533;

  public static final int MORNING_AZKAR_PENDING_INTENT_REQUEST_CODE = 4510;
  public static final int EVENING_AZKAR_PENDING_INTENT_REQUEST_CODE = 4511;

  public static final String RAMADAN_CANNON_NOTIFICATION_CHANNEL_ID = "Muslim_Book_Ramadan_Cannon";
  public static final String RAMADAN_MSHARAT_NOTIFICATION_CHANNEL_ID = "Muslim_Book_Ramadan_Msharat";
  public static final String AZAN_NOTIFICATION_CHANNEL_ID = "Muslim_Book_Azan";
  public static final String WEEKLY_FASTING_NOTIFICATION_CHANNEL_ID = "weekly_fasting_alert";
  public static final int AZAN_NOTIFICATION_ID = 152;
  public static final int RAMADAN_CANNON_NOTIFICATION_ID = 153;
  public static final int RAMADAN_MSHART_NOTIFICATION_ID = 150;
  public static final int WEEKLY_FASTING_NOTIFICATION_ID = 987;
  public static final String AZAN_CHANNEL_NAME = "Muslim Book Azan";
  public static final String RAMADAN_CANNON_CHANNEL_NAME = "Muslim Book Ramadan Cannon";
  public static final String RAMADAN_MSHARAT_CHANNEL_NAME = "Muslim Book Ramadan Msharat";
  public static final String WEEKLY_FASTING_CHANNEL_NAME = "Weekly Fasting Alert";
  public static final String CLOSE_AZAN = "close_azan";
  public static final String CLOSE_RAMADAN_CANNON = "close_ramadan_cannon";
  public static final String CLOSE_RAMADAN_MSHART = "close_ramadan_msharat";
  public static final String START_AZAN = "open_azan";
  public static final String START_RAMADAN_CANNON = "open_ramadan_cannon";
  public static final String START_RAMADAN_MSHARAT = "open_ramadan_msharat";
  public static final String MUAZEN_KEY = "flutter.azan_shiekh";
  public static final String SELECTED_SHEIKH_NAME_JSON = "flutter.SELECTED_SHEIKH_NAME_JSON";
  public static final String SELECTED_FAJR_SHEIKH_JSON = "flutter.DOWNLOADED_FAJR_SHEIKH_ID";
  public static final String SELECTED_RAMADAN_CANNON_ID="flutter.SELECTED_RAMADAN_CANNON_ID";
   public static final String SELECTED_RAMADAN_MASHRAAT_ID="flutter.SELECTED_RAMADAN_MASHRAAT_ID";
  public static final String SELECTED_MASHRAAT_REPETITION_ID="flutter.SELECTED_MASHRAAT_REPETITION_ID";
  public static final String CHECK_REPETITION="flutter.CHECK_REPETITION";

  public static final String MUTED_AZAN = "flutter.MUTED_AZAN";

  public static final String BEFORE_AZAN = "before_azan";

  public static final String FASTING_MONDAY_ALERT = "monday_alert";
  public static final String FASTING_THURSDAY_ALERT = "thursday_alert";

  public static final String NOTIFY_KEY = "notify";

  public static final String ALLOW_FAJR_IBTEHAL_FLAG = "flutter.allow_fajr_ibtehal";
  public static final String DONT_SHOW_BEFORE_AZAN = "dont_show_before_azan";
  public static final String FIRE_COMPETITION_UI = "fire_competition_ui";
  public static final String DATA_PASSED_COMPETITION = "DATA_PASSED_COMPETITION";
  public static final String DATA_PASSED_AZKAR = "DATA_PASSED_AZKAR";
  public static final String FIRE_AZKAR_POP_UP = "fire_azkar_pop_up";

  public static void SETBOOTAZANRECIEVER(Context context) {
    ComponentName azanReceiver = new ComponentName(context, AzanReceiver.class);
    PackageManager packageManager = context.getPackageManager();
    packageManager.setComponentEnabledSetting(azanReceiver, PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
            PackageManager.DONT_KILL_APP);
  }

  public static void SETBOOTRAMADANCANNONRECIEVER(Context context) {
     ComponentName ramadanReceiver = new ComponentName(context, RamadanCannonReceiver.class);
    PackageManager packageManager = context.getPackageManager();
     packageManager.setComponentEnabledSetting(ramadanReceiver, PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
            PackageManager.DONT_KILL_APP);
//    Toast.makeText(context, "Arrived to SETBOOTRAMADANRECIEVER", Toast.LENGTH_SHORT).show();

  }
  public static void SETBOOTRAMADANRMSHARTECIEVER(Context context) {
     ComponentName ramadanReceiver = new ComponentName(context, RamadanMshartReceiver.class);
    PackageManager packageManager = context.getPackageManager();
     packageManager.setComponentEnabledSetting(ramadanReceiver, PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
            PackageManager.DONT_KILL_APP);

  }
  public static boolean  CHECKSERVICERUNNUNG(Class<?> serviceClass , Context context) {
    ActivityManager manager = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
    for (ActivityManager.RunningServiceInfo service : manager.getRunningServices(Integer.MAX_VALUE)) {
      if (serviceClass.getName().equals(service.service.getClassName())) {
        return true;
      }
    }
    return false;
  }


}
