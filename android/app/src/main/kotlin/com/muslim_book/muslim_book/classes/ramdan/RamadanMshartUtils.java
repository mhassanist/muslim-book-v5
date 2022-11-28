package com.muslim_book.muslim_book.classes.ramdan;

import static android.content.Context.MODE_PRIVATE;

import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;

import androidx.core.content.ContextCompat;

import com.muslim_book.muslim_book.classes.Constants;
import com.muslim_book.muslim_book.classes.Prefs;
import com.muslim_book.muslim_book.services.ramadan.ramadan_mshart.RamadanMshartService;

public class RamadanMshartUtils {

    private Context mContext;
    private SharedPreferences mPreferences;
  
    public RamadanMshartUtils(Context context) {
        mContext = context;
        mPreferences = mContext
                .getSharedPreferences(Constants.FLUTTER_SHARED_PREFERENCES, MODE_PRIVATE);
        convertJsonToAzanModel();
    }


    private void convertJsonToAzanModel() {
        
         if (mPreferences.getString(Constants.FLUTTER_TAG + Constants.RAMADAN_MASHRAAT_TIME, null) != null) {
            String timeShoar = mPreferences.getString(Constants.FLUTTER_TAG + Constants.RAMADAN_MASHRAAT_TIME, null) ;
             setNextShoar(timeShoar);
 
        }
    }
 

    private void setNextShoar(String time ) {
        try {
             startAlarmReceiver(time);
        } catch (Exception e) {
        }
    }


    private void startAlarmReceiver(String time) {
        if (new Prefs(mContext).getRamadanMshart()) {
            Intent intent = new Intent(mContext, RamadanMshartService.class);
            Bundle extras = new Bundle();
            extras.putString("time", time);
             intent.putExtras(extras);
            Constants.SETBOOTRAMADANRMSHARTECIEVER(mContext);
            ContextCompat.startForegroundService(mContext, intent);
        }


    }

}
