package com.muslim_book.muslim_book.classes;

import static android.content.Context.MODE_PRIVATE;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;

import androidx.core.content.ContextCompat;

import com.muslim_book.muslim_book.models.azan_model.AzanModel;
import com.muslim_book.muslim_book.models.azan_model.AzanModelData;
import com.muslim_book.muslim_book.models.azan_model.Timings;
import com.google.gson.Gson;
import com.muslim_book.muslim_book.services.azan.AzanService;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class AzanUtils {

    private Context mContext;
    private SharedPreferences mPreferences;
    private Calendar mCalendar = Calendar.getInstance();
    String pattern = "HH:mm";
    SimpleDateFormat sdf = new SimpleDateFormat(pattern);

    public AzanUtils(Context context) {
        mContext = context;
        mPreferences = mContext
                .getSharedPreferences(Constants.FLUTTER_SHARED_PREFERENCES, MODE_PRIVATE);
        convertJsonToAzanModel();
    }


    private void convertJsonToAzanModel() {
        if (mPreferences.getString(Constants.FLUTTER_TAG + Constants.AZAN_MODEL, null) != null) {
            AzanModel model = new Gson()
                    .fromJson(mPreferences.getString(Constants.FLUTTER_TAG + Constants.AZAN_MODEL, null),
                            AzanModel.class);
            AzanModelData azanOfDay = model.getData().get(mCalendar.get(Calendar.DAY_OF_MONTH) - 1);

            pickNextAzan(azanOfDay.getTimings(), model);
        }
    }

    private void pickNextAzan(Timings timings, AzanModel model) {

        try {
            Date now = sdf
                    .parse(mCalendar.get(Calendar.HOUR_OF_DAY) + ":" + mCalendar.get(Calendar.MINUTE));
            if (now.before(sdf.parse(timings.getFajr().split(" ")[0].split(":")[0] + ":"
                    + String.valueOf(Integer.parseInt(timings.getFajr().split(" ")[0].split(":")[1])
                    + Integer.parseInt(mPreferences.getString(Constants.FLUTTER_TAG + "update1", "0")))

            ))) {

                setNextAzan(
                        timings.getFajr().split(" ")[0].split(":")[0] + ":"
                                + String.valueOf(Integer.parseInt(timings.getFajr().split(" ")[0].split(":")[1])
                                + Integer.parseInt(mPreferences.getString(Constants.FLUTTER_TAG + "update1", "0")))
                        , "1"

                );
            } else if (now.before(
                    sdf.parse(
                    timings.getDhuhr().split(" ")[0].split(":")[0] + ":"
                            + String.valueOf(Integer.parseInt(timings.getDhuhr().split(" ")[0].split(":")[1])
                            + Integer.parseInt(mPreferences.getString(Constants.FLUTTER_TAG + "update3", "0")))
                    )






            )) {

                setNextAzan(

                        timings.getDhuhr().split(" ")[0].split(":")[0] + ":"
                                + String.valueOf(Integer.parseInt(timings.getDhuhr().split(" ")[0].split(":")[1])
                                + Integer.parseInt(mPreferences.getString(Constants.FLUTTER_TAG + "update3", "0"))), "3");

            } else if (now.before(sdf.parse(

                    timings.getAsr().split(" ")[0].split(":")[0] + ":"
                            + String.valueOf(Integer.parseInt(timings.getAsr().split(" ")[0].split(":")[1])
                            + Integer.parseInt(mPreferences.getString(Constants.FLUTTER_TAG + "update4", "0")))



            ))) {

                setNextAzan(
                        timings.getAsr().split(" ")[0].split(":")[0] + ":"
                                + String.valueOf(Integer.parseInt(timings.getAsr().split(" ")[0].split(":")[1])
                                + Integer.parseInt(mPreferences.getString(Constants.FLUTTER_TAG + "update4", "0")))
                        , "4");

            } else if (now.before(sdf.parse(

                    timings.getMaghrib().split(" ")[0].split(":")[0] + ":"
                            + String.valueOf(Integer.parseInt(timings.getMaghrib().split(" ")[0].split(":")[1])
                            + Integer.parseInt(mPreferences.getString(Constants.FLUTTER_TAG + "update5", "0")))


            ))) {

                setNextAzan( timings.getMaghrib().split(" ")[0].split(":")[0] + ":"
                        + String.valueOf(Integer.parseInt(timings.getMaghrib().split(" ")[0].split(":")[1])
                        + Integer.parseInt(mPreferences.getString(Constants.FLUTTER_TAG + "update5", "0"))), "5");
            } else if (now.before(sdf.parse(

                    timings.getIsha().split(" ")[0].split(":")[0] + ":"
                            + String.valueOf(Integer.parseInt(timings.getIsha().split(" ")[0].split(":")[1])
                            + Integer.parseInt(mPreferences.getString(Constants.FLUTTER_TAG + "update6", "0")))


            ))) {

                setNextAzan(
                        timings.getIsha().split(" ")[0].split(":")[0] + ":"
                                + String.valueOf(Integer.parseInt(timings.getIsha().split(" ")[0].split(":")[1])
                                + Integer.parseInt(mPreferences.getString(Constants.FLUTTER_TAG + "update6", "0")))

                        ,


                        "6");
            } else {
                getNextDayFajrAzan(model);
            }
        } catch (Exception e) {
            e.printStackTrace();
            android.widget.Toast.makeText(mContext, "EXception", android.widget.Toast.LENGTH_SHORT).show();
        }

    }

    private void getNextDayFajrAzan(AzanModel model) {
        AzanModelData azanOfDay = model.getData().get(mCalendar.get(Calendar.DAY_OF_MONTH));
        setNextAzan(azanOfDay.getTimings().getFajr().split(" ")[0].split(":")[0] + ":"
                + String.valueOf(Integer.parseInt(azanOfDay.getTimings().getFajr().split(" ")[0].split(":")[1])
                + Integer.parseInt(mPreferences.getString(Constants.FLUTTER_TAG + "update1", "0"))), "1");
    }

    private void setNextAzan(String time, String key) {
        try {
            mPreferences.edit().putString(Constants.FLUTTER_TAG + Constants.NEXT_AZAN_TIME, time).apply();
            mPreferences.edit().putString(Constants.FLUTTER_TAG + Constants.NEXT_AZAN_KEY, key).apply();
            startAlarmReceiver(time, key);
        } catch (Exception e) {
        }
    }

    private void startAlarmReceiver(String time, String key) {
        if (new Prefs(mContext).getAllowAzan()) {
            Intent intent = new Intent(mContext, AzanService.class);
            Bundle extras = new Bundle();
            extras.putString("time", time);
            extras.putString("key", key);
            intent.putExtras(extras);
            Constants.SETBOOTAZANRECIEVER(mContext);
            //  if (VERSION.SDK_INT < VERSION_CODES.O)
            //  {
            //        mContext.sendBroadcast(intent);
            //  } else
            //    Constants.sendImplicitBroadcast(mContext,intent);
//            mContext.sendBroadcast(intent);
            ContextCompat.startForegroundService(mContext, intent);
        }


    }

}
