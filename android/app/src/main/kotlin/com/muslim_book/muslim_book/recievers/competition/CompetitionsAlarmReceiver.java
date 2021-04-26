package com.muslim_book.muslim_book.recievers.competition;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;

import com.google.gson.Gson;
import com.muslim_book.muslim_book.classes.Constants;
import com.muslim_book.muslim_book.models.azan_model.AzanModel;
import com.muslim_book.muslim_book.models.azan_model.AzanModelData;
import com.muslim_book.muslim_book.services.competition.CompetitionPopUpService;

import io.flutter.Log;

import java.util.Calendar;

import static android.content.Context.MODE_PRIVATE;

public class CompetitionsAlarmReceiver extends BroadcastReceiver {

    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent != null && intent.getExtras() != null && intent
                .getBooleanExtra(Constants.FIRE_COMPETITION_UI, false)) {
            new CompetitionPopUpService(context);
        }
        prepareAlarm(context, intent);
    }
    private void prepareAlarm(Context context, Intent intentReceive) {

        String fajrTime = getFajrTime(context);
        String ishaTime = getIshaTime(context);
        AlarmManager alarmMgr = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        Intent intent = new Intent(context, CompetitionsAlarmReceiver.class);
        intent.addFlags(Intent.FLAG_RECEIVER_FOREGROUND);
        intent.putExtra(Constants.FIRE_COMPETITION_UI, true);
        intent.putExtra(Constants.DATA_PASSED_COMPETITION, "CompetitionService");

        PendingIntent morningIntent = PendingIntent
                .getBroadcast(context, Constants.MORNING_Competition_PENDING_INTENT_REQUEST_CODE, intent,
                        PendingIntent.FLAG_UPDATE_CURRENT);

        PendingIntent eveningIntent = PendingIntent
                .getBroadcast(context, Constants.EVENING_Competition_PENDING_INTENT_REQUEST_CODE, intent,
                        PendingIntent.FLAG_UPDATE_CURRENT);

        setMoringAlarm(alarmMgr, morningIntent, fajrTime);
        setEveningAlarm(alarmMgr, eveningIntent, ishaTime);

    }


    private String getFajrTime(Context context) {
        String time = "";
        Calendar mCalendar = Calendar.getInstance();
        SharedPreferences mPreferences = context.getSharedPreferences(Constants.FLUTTER_SHARED_PREFERENCES, MODE_PRIVATE);
        if (mPreferences.getString(Constants.FLUTTER_TAG + Constants.AZAN_MODEL, null) != null) {
            AzanModel model = new Gson().fromJson(mPreferences.getString(Constants.FLUTTER_TAG + Constants.AZAN_MODEL, null), AzanModel.class);
            AzanModelData azanOfDay = model.getData().get(mCalendar.get(Calendar.DAY_OF_MONTH) - 1);
            time = azanOfDay.getTimings().getFajr().split(" ")[0].split(":")[0] + ":" + String.valueOf(Integer.parseInt(azanOfDay.getTimings().getFajr().split(" ")[0].split(":")[1]) + Integer.parseInt(mPreferences.getString(Constants.FLUTTER_TAG + "update1", "0")));
        }

        return time;

    }


    private String getIshaTime(Context context) {
        String time = "";

        Calendar mCalendar = Calendar.getInstance();

        SharedPreferences mPreferences = context
                .getSharedPreferences(Constants.FLUTTER_SHARED_PREFERENCES, MODE_PRIVATE);
        if (mPreferences.getString(Constants.FLUTTER_TAG + Constants.AZAN_MODEL, null) != null) {
            AzanModel model = new Gson()
                    .fromJson(mPreferences.getString(Constants.FLUTTER_TAG + Constants.AZAN_MODEL, null),
                            AzanModel.class);
            AzanModelData azanOfDay = model.getData().get(mCalendar.get(Calendar.DAY_OF_MONTH) - 1);
            time = azanOfDay.getTimings().getIsha().split(" ")[0].split(":")[0] + ":"
                    + String.valueOf(Integer.parseInt(azanOfDay.getTimings().getIsha().split(" ")[0].split(":")[1])
                    + Integer.parseInt(mPreferences.getString(Constants.FLUTTER_TAG + "update1", "0")));
        }

        return time;

    }


    public void setMoringAlarm(AlarmManager mgr, PendingIntent pi, String fajrTime) {
        Calendar calendar = Calendar.getInstance();

        if (!fajrTime.equals("")) {
            int hours =
                    Integer.parseInt(fajrTime.split(":")[0]) + 1;
            Calendar c1 = Calendar.getInstance();
            c1.set(Calendar.HOUR_OF_DAY, hours);
            c1.set(Calendar.MINUTE, Integer.parseInt(fajrTime.split(":")[1]));
            c1.set(Calendar.SECOND, 0);
            Log.i("CompetitionFire", "         " + c1.getTime().toString());
            Log.i("CompetitionFire", "         " + String.valueOf(calendar.getTime()));
            if (Calendar.getInstance().getTime().after(c1.getTime())) {
                calendar.add(Calendar.DAY_OF_YEAR, 1);
            }

        }else {
            if (Calendar.getInstance().get(Calendar.HOUR_OF_DAY) >= 11) {
                calendar.add(Calendar.DAY_OF_YEAR, 1);
            }

        }



        if (fajrTime.equals("")) {
            calendar.set(Calendar.HOUR_OF_DAY, 11);
            calendar.set(Calendar.MINUTE,0);

        } else {
            calendar.set(Calendar.HOUR_OF_DAY, Integer.parseInt(fajrTime.split(":")[0]) + 1);
            calendar.set(Calendar.MINUTE, Integer.parseInt(fajrTime.split(":")[1]));

        }

        calendar.set(Calendar.SECOND, 0);
        Log.i("CompetitionEvening", "         " + String.valueOf(calendar.getTime()));
        mgr.setInexactRepeating(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(),
                AlarmManager.INTERVAL_DAY, pi);
//        Calendar calendar = Calendar.getInstance();
//        if (Calendar.getInstance().get(Calendar.HOUR_OF_DAY) >= 11) {
//            calendar.add(Calendar.DAY_OF_YEAR, 1);
//        }
//        if (fajrTime == null || fajrTime == "") {
//            calendar.set(Calendar.HOUR_OF_DAY, 11);
//        } else {
//            calendar.set(Calendar.HOUR_OF_DAY, Integer.parseInt(fajrTime.split(":")[0]) + 1);
//
//        }
//        calendar.set(Calendar.MINUTE, 0);
//        calendar.set(Calendar.SECOND, 0);
//        Log.i("CompetitionFire", "arrived 6" + calendar.getTime().toString());
//        mgr.setInexactRepeating(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(),
//                AlarmManager.INTERVAL_DAY, pi);
    }

    public void setEveningAlarm(AlarmManager mgr, PendingIntent pi, String ishaTime) {
        Calendar calendar = Calendar.getInstance();

        if (!ishaTime.equals("")) {
            int hours =
                    Integer.parseInt(ishaTime.split(":")[0]) + 1;
            Calendar c1 = Calendar.getInstance();
            c1.set(Calendar.HOUR_OF_DAY, hours);
            c1.set(Calendar.MINUTE, Integer.parseInt(ishaTime.split(":")[1]));
            c1.set(Calendar.SECOND, 0);
            Log.i("CompetitionEvening", "         " + c1.getTime().toString());
            Log.i("CompetitionEvening", "         " + String.valueOf(calendar.getTime()));
            if (Calendar.getInstance().getTime().after(c1.getTime())) {
                calendar.add(Calendar.DAY_OF_YEAR, 1);
            }

        }else {
            if (Calendar.getInstance().get(Calendar.HOUR_OF_DAY) >= 19) {
                calendar.add(Calendar.DAY_OF_YEAR, 1);
            }

        }



        if (ishaTime.equals("")) {
            calendar.set(Calendar.HOUR_OF_DAY, 19);
            calendar.set(Calendar.MINUTE,0);

        } else {
            calendar.set(Calendar.HOUR_OF_DAY, Integer.parseInt(ishaTime.split(":")[0]) + 1);
            calendar.set(Calendar.MINUTE, Integer.parseInt(ishaTime.split(":")[1]));

        }

        calendar.set(Calendar.SECOND, 0);
        Log.i("CompetitionEvening", "         " + String.valueOf(calendar.getTime()));
        mgr.setInexactRepeating(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(),
                AlarmManager.INTERVAL_DAY, pi);


    }
}
