package com.muslim_book.muslim_book.classes.ramdan;

import static android.content.Context.MODE_PRIVATE;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;

import androidx.core.content.ContextCompat;

import com.google.gson.Gson;
import com.muslim_book.muslim_book.classes.Constants;
import com.muslim_book.muslim_book.classes.Prefs;
import com.muslim_book.muslim_book.models.ramadan_model.RamadanDatum;
import com.muslim_book.muslim_book.models.ramadan_model.RamadanModel;
import com.muslim_book.muslim_book.models.ramadan_model.Timings;
import com.muslim_book.muslim_book.services.ramadan.ramadan_cannon.RamadanCannonService;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;

public class RamadanCannonUtils {

    private Context mContext;
    private SharedPreferences mPreferences;
    private Calendar mCalendar = Calendar.getInstance();
    String pattern = "HH:mm";
    SimpleDateFormat sdf = new SimpleDateFormat(pattern);

    public RamadanCannonUtils(Context context) {
        mContext = context;
        mPreferences = mContext
                .getSharedPreferences(Constants.FLUTTER_SHARED_PREFERENCES, MODE_PRIVATE);
        convertJsonToAzanModel();
    }


    private void convertJsonToAzanModel() {
        if (mPreferences.getString(Constants.FLUTTER_TAG + Constants.RAMADAN_MODEL, null) != null) {
            RamadanModel model = new Gson()
                    .fromJson(mPreferences.getString(Constants.FLUTTER_TAG + Constants.RAMADAN_MODEL, null),
                            RamadanModel.class);

            List<RamadanDatum> datumList = model.getRamadanData();
            RamadanDatum james =findUsingIterator(String.valueOf(mCalendar.get(Calendar.DAY_OF_MONTH) ),datumList);
           if(james !=null )
            pickNextMaghrib(james.getTimings(), model);




        }
    }

    private void pickNextMaghrib(Timings timings, RamadanModel model) {

        try {
            getNextDayMaghrib(model);

        } catch (Exception e) {
            e.printStackTrace();
            // android.widget.Toast.makeText(mContext, "EXception", android.widget.Toast.LENGTH_SHORT).show();
        }

    }

    private void getNextDayMaghrib(RamadanModel model) {
        List<RamadanDatum>  datumList = model.getRamadanData();
        RamadanDatum james =findUsingIterator(String.valueOf(mCalendar.get(Calendar.DAY_OF_MONTH) ),datumList);
         setNextConnan(james.getTimings().getMaghrib().split(" ")[0].split(":")[0] + ":"
                + String.valueOf(Integer.parseInt(james.getTimings().getMaghrib().split(" ")[0].split(":")[1])), "1");
    }

    public RamadanDatum findUsingIterator(
            String name, List<RamadanDatum> customers) {
        Iterator<RamadanDatum> iterator = customers.iterator();
        while (iterator.hasNext()) {
            RamadanDatum customer = iterator.next();
            if (customer.getDate().getGregorian().getDay().equals(name)) {
                return customer;
            }
        }
        return null;
    }



    private void setNextConnan(String time, String key) {
        try {
            mPreferences.edit().putString(Constants.FLUTTER_TAG + Constants.NextRamadan_Cannon_Time, time).apply();
            startAlarmReceiver(time, key);
        } catch (Exception e) {
        }
    }


    private void startAlarmReceiver(String time, String key) {
        if (new Prefs(mContext).getRamadanConnan()) {
            Intent intent = new Intent(mContext, RamadanCannonService.class);
            Bundle extras = new Bundle();
            extras.putString("time", time);
            extras.putString("key", key);
            intent.putExtras(extras);
            Constants.SETBOOTRAMADANCANNONRECIEVER(mContext);
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
