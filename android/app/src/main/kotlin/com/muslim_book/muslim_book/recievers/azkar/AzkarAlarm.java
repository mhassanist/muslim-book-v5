package com.muslim_book.muslim_book.recievers.azkar;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

import com.muslim_book.muslim_book.classes.Constants;
import com.muslim_book.muslim_book.services.azkar.AzkarPopUpService;

import java.util.Calendar;

import io.flutter.Log;

public class AzkarAlarm extends BroadcastReceiver {

  @Override
  public void onReceive(Context context, Intent intent) {
    Log.i("azkarCalender ","azkar calendar 1");

    if (intent != null && intent.getExtras() != null && intent
        .getBooleanExtra(Constants.FIRE_AZKAR_POP_UP, false)) {
      new AzkarPopUpService(context);
    }
    Log.i("azkarCalender ","azkar calendar 2");

    prepareAlarm(context);
  }

  private void prepareAlarm(Context context) {
    Log.i("azkarCalender ","azkar calendar 3");

    AlarmManager alarmMgr = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
    Intent intent = new Intent(context, AzkarAlarm.class);
    intent.addFlags(Intent.FLAG_RECEIVER_FOREGROUND);
    intent.putExtra(Constants.FIRE_AZKAR_POP_UP, true);
    PendingIntent morningIntent = PendingIntent
        .getBroadcast(context, Constants.MORNING_AZKAR_PENDING_INTENT_REQUEST_CODE , intent,
            PendingIntent.FLAG_UPDATE_CURRENT);

    PendingIntent eveningIntent = PendingIntent
        .getBroadcast(context, Constants.EVENING_AZKAR_PENDING_INTENT_REQUEST_CODE , intent,
            PendingIntent.FLAG_UPDATE_CURRENT);

    setMoringAlarm(alarmMgr, morningIntent);
    setEveningAlarm(alarmMgr, eveningIntent);

  }

  public void setMoringAlarm(AlarmManager mgr, PendingIntent pi) {
    Calendar calendar = Calendar.getInstance();
    if (Calendar.getInstance().get(Calendar.HOUR_OF_DAY) >= 8) {
      calendar.add(Calendar.DAY_OF_YEAR, 1);
    }
    calendar.set(Calendar.HOUR_OF_DAY, 8);
    calendar.set(Calendar.MINUTE, 0);
    calendar.set(Calendar.SECOND, 0);
    Log.i("azkarCalender ","azkar calendar morning" + calendar.getTime().toString());

    mgr.setInexactRepeating(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(),
        AlarmManager.INTERVAL_DAY, pi);
  }

  public void setEveningAlarm(AlarmManager mgr, PendingIntent pi) {
    Calendar calendar = Calendar.getInstance();
    if (Calendar.getInstance().get(Calendar.HOUR_OF_DAY) >= 17) {
      calendar.add(Calendar.DAY_OF_YEAR, 1);
    }
    calendar.set(Calendar.HOUR_OF_DAY, 17);
    calendar.set(Calendar.MINUTE, 0);
    calendar.set(Calendar.SECOND, 0);
    Log.i("azkarCalender ","azkar calendar eveing"  + calendar.getTime().toString());
    mgr.setInexactRepeating(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(),
        AlarmManager.INTERVAL_DAY, pi);
  }
}
