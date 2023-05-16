package com.muslim_book.muslim_book.recievers.azan;

import static com.muslim_book.muslim_book.classes.Constants.FLUTTER_SHARED_PREFERENCES;

import android.app.AlarmManager;
import android.app.AlarmManager.AlarmClockInfo;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;

import androidx.core.content.ContextCompat;

import com.muslim_book.muslim_book.classes.Constants;
import com.muslim_book.muslim_book.classes.Prefs;
import com.muslim_book.muslim_book.services.azan.AzanIntentService;

import java.util.Calendar;


public class AzanReceiver extends BroadcastReceiver {

  @Override
  public void onReceive(Context context, Intent intent) {

    if (new Prefs(context).getAllowAzan()) {
      if (intent.getBooleanExtra(Constants.CLOSE_AZAN, false)) {
        closeAzan(context);
      } else if (intent.getBooleanExtra(Constants.START_AZAN, false)) {
        openAzan(context, intent);
      } else if (intent.getBooleanExtra(Constants.BEFORE_AZAN, false)) {
        beforeAzan(context, intent);
      } else {
        startAzanAlarm(context, intent);
      }

    }
  }

  private void beforeAzan(Context context, Intent intent) {
    Intent serviceIntent = new Intent(context, AzanIntentService.class);
    serviceIntent.putExtra(Constants.BEFORE_AZAN,   new Prefs(context).getVoiceReminderBeforePraying());
    serviceIntent.putExtra(Constants.NEXT_AZAN_KEY, intent.getStringExtra(Constants.NEXT_AZAN_KEY));
    if (Constants.CHECKSERVICERUNNUNG(AzanIntentService.class, context)) {
      context.stopService(new Intent(context, AzanIntentService.class));
    }
    if (VERSION.SDK_INT >= VERSION_CODES.O) {
      ContextCompat.startForegroundService(context, serviceIntent);
    } else {
      context.startService(serviceIntent);
    }
  }

  private void openAzan(Context context, Intent intent) {
    Intent serviceIntent = new Intent(context, AzanIntentService.class);
    serviceIntent.putExtra(Constants.NEXT_AZAN_KEY, intent.getStringExtra(Constants.NEXT_AZAN_KEY));
    if (Constants.CHECKSERVICERUNNUNG(AzanIntentService.class, context)) {
      context.stopService(new Intent(context, AzanIntentService.class));
    }

    if (VERSION.SDK_INT >= VERSION_CODES.O) {
      ContextCompat.startForegroundService(context, serviceIntent);
    } else {
      context.startService(serviceIntent);
    }
  }

  private void startAzanAlarm(Context context, Intent intent) {
    String time;
    String key;
    if (intent.getAction() != null && intent.getAction()
        .equals("android.intent.action.BOOT_COMPLETED")) {
      SharedPreferences mPrefs = context
          .getSharedPreferences(FLUTTER_SHARED_PREFERENCES, Context.MODE_PRIVATE);
      time = mPrefs.getString(Constants.FLUTTER_TAG +
              Constants.NEXT_AZAN_TIME, null);
      key = mPrefs.getString(Constants.FLUTTER_TAG + Constants.NEXT_AZAN_KEY, null);
    } else {
      time = intent.getStringExtra("time");
      key = intent.getStringExtra("key");
    }
    prepareAlarm(context, time, key);
  }

  public void closeAzan(Context context) {
    Intent stopService = new Intent(context, AzanIntentService.class);
    context.stopService(stopService);

  }


  private void prepareAlarm(Context context, String time, String key) {
    if (time != null) {
      AlarmManager alarmMgr = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
      Intent intent = new Intent(context, AzanReceiver.class);
      intent.putExtra(Constants.START_AZAN, true);
      intent.putExtra(Constants.NEXT_AZAN_KEY, key);
      intent.addFlags(Intent.FLAG_RECEIVER_FOREGROUND);
      PendingIntent alarmIntent = PendingIntent
          .getBroadcast(context, Constants.AZAN_PENDING_INTENT_REQUEST_CODE, intent,
              PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
      Calendar calendar = Calendar.getInstance();
      calendar.set(Calendar.HOUR_OF_DAY, Integer.parseInt(time.split(":")[0]));
      calendar.set(Calendar.MINUTE, Integer.parseInt(time.split(":")[1]));
      calendar.set(Calendar.SECOND, 0);
      if (System.currentTimeMillis() > calendar.getTimeInMillis()) {
        calendar.add(Calendar.DATE, 1);
      }

      setAlarm(calendar, alarmMgr, alarmIntent);
      setBeforeAzanAlarm(calendar, context, key);
    }
  }

  private void setBeforeAzanAlarm(Calendar calendar, Context context, String azanKey) {

    AlarmManager alarmMgr = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
    Intent intent = new Intent(context, AzanReceiver.class);
    intent.putExtra(Constants.BEFORE_AZAN,  new Prefs(context).getVoiceReminderBeforePraying());
    intent.putExtra(Constants.NEXT_AZAN_KEY, azanKey);
    intent.addFlags(Intent.FLAG_RECEIVER_FOREGROUND);
    PendingIntent alarmIntent = PendingIntent
        .getBroadcast(context, Constants.BEFORE_AZAN_PENDING_INTENT_REQUEST_CODE, intent,
        PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
    calendar.add(Calendar.MINUTE, -10);
    setAlarm(calendar, alarmMgr, alarmIntent);

  }

  private void setAlarm(Calendar calendar, AlarmManager alarmMgr, PendingIntent alarmIntent) {
    if (VERSION.SDK_INT >= VERSION_CODES.M) {
//      alarmMgr.setExactAndAllowWhileIdle(AlarmManager.RTC_WAKEUP,
//          calendar.getTimeInMillis(), alarmIntent);

      AlarmClockInfo info = new AlarmClockInfo(calendar.getTimeInMillis(), alarmIntent);
      alarmMgr.setAlarmClock(info
          , alarmIntent);

    } else if (VERSION.SDK_INT >= VERSION_CODES.KITKAT) {
      alarmMgr.setExact(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), alarmIntent);
    } else {
      alarmMgr.set(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), alarmIntent);
    }

  }
}
