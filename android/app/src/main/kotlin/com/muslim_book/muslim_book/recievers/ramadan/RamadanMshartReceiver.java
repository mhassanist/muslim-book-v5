package com.muslim_book.muslim_book.recievers.ramadan;

import static com.muslim_book.muslim_book.classes.Constants.FLUTTER_SHARED_PREFERENCES;

import android.app.AlarmManager;
import android.app.AlarmManager.AlarmClockInfo;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Build;

import androidx.core.content.ContextCompat;

import com.muslim_book.muslim_book.classes.Constants;
import com.muslim_book.muslim_book.classes.Prefs;
import com.muslim_book.muslim_book.services.ramadan.ramadan_mshart.RamadanMshartIntentService;

import java.util.Calendar;

import io.flutter.Log;

public class RamadanMshartReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        if (new Prefs(context).getRamadanMshart()) {
        if (intent.getBooleanExtra(Constants.CLOSE_RAMADAN_MSHART, false)) {
            closeCannon(context);
        } else if (intent.getBooleanExtra(Constants.START_RAMADAN_MSHARAT, false)) {
            openRamadan(context, intent);
        } else {
            startAzanAlarm(context, intent);
        }}
    }

    private void startAzanAlarm(Context context, Intent intent) {
        String time;
          if (intent.getAction() != null && intent.getAction()
                .equals("android.intent.action.BOOT_COMPLETED")) {
            SharedPreferences mPrefs = context
                    .getSharedPreferences(FLUTTER_SHARED_PREFERENCES,
                            Context.MODE_PRIVATE);
            time = mPrefs.getString(Constants.FLUTTER_TAG +
                    Constants.RAMADAN_MASHRAAT_TIME, null);


        } else {
            time = intent.getStringExtra("time");

        }
        prepareAlarm(context, time );
    }

    private void openRamadan(Context context, Intent intent) {
        Intent serviceIntent = new Intent(context, RamadanMshartIntentService.class);
         if (Constants.CHECKSERVICERUNNUNG(RamadanMshartIntentService.class, context)) {
            context.stopService(new Intent(context, RamadanMshartIntentService.class));
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            ContextCompat.startForegroundService(context, serviceIntent);
        } else {
            context.startService(serviceIntent);
        }
    }


    public void closeCannon(Context context) {
        Intent stopService = new Intent(context, RamadanMshartIntentService.class);
        context.stopService(stopService);

    }

    private void prepareAlarm(Context context, String time  ) {
        if (time != null) {
            AlarmManager alarmMgr = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
            Intent intent = new Intent(context, RamadanMshartReceiver.class);
            intent.putExtra(Constants.START_RAMADAN_MSHARAT, true);
             intent.addFlags(Intent.FLAG_RECEIVER_FOREGROUND);
            PendingIntent alarmIntent = PendingIntent
                    .getBroadcast(context,
                            Constants.RAMADAN_MSHART_PENDING_INTENT_REQUEST_CODE, intent,
                            PendingIntent.FLAG_UPDATE_CURRENT|PendingIntent.FLAG_IMMUTABLE);
            Calendar calendar = Calendar.getInstance();
            calendar.set(Calendar.HOUR_OF_DAY, Integer.parseInt(time.split(":")[0]));
            calendar.set(Calendar.MINUTE, Integer.parseInt(time.split(":")[1]));
             calendar.set(Calendar.SECOND, 0);


      if (System.currentTimeMillis() > calendar.getTimeInMillis()) {
          calendar.add(Calendar.DATE, 1);

  }

            Log.i("mshart_time", "         " + calendar.getTime().toString());

            setAlarm(calendar, alarmMgr, alarmIntent);
         }
    }


    private void setAlarm(Calendar calendar, AlarmManager alarmMgr, PendingIntent alarmIntent) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
         AlarmClockInfo info = new AlarmClockInfo(calendar.getTimeInMillis(), alarmIntent);
            alarmMgr.setAlarmClock(info
                    , alarmIntent);

        } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            alarmMgr.setExact(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), alarmIntent);
        } else {
            alarmMgr.set(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), alarmIntent);
        }

    }

}
