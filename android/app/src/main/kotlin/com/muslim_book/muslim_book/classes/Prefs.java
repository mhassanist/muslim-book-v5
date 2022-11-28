package com.muslim_book.muslim_book.classes;

import static android.content.Context.MODE_PRIVATE;

import android.content.Context;
import android.content.SharedPreferences;

public class Prefs {

    private SharedPreferences mPreferences;
    private Context mContext;

    public Prefs(Context context) {
        mContext = context;
        mPreferences = mContext
                .getSharedPreferences(Constants.FLUTTER_SHARED_PREFERENCES, MODE_PRIVATE);
    }

    public boolean getAllowAzan() {
        return mPreferences.getBoolean(Constants.AZAN_ON_PRAY_TIME_FLAG, true);
    }   public boolean getRamadanConnan() {
        return mPreferences.getBoolean(Constants.RAMADAN_CONNAN_FLAG, false);
    }
    public boolean getRamadanMshart() {
        return mPreferences.getBoolean(Constants.RAMADAN_MASHRAAT_FLAG, false);
    }


    public boolean getVoiceReminderBeforePraying() {
        return mPreferences.getBoolean(Constants.Voice_Reminder_Before_Praying_FLAG, true);
    } 
    
    public boolean getActivatingAlShaarawiVoice() {
        return mPreferences.getBoolean(Constants.Activating_Al_Shaarawi_Voice_FLAG, true);
    }


    public boolean getAllowAlfajrIbtehal() {
        return mPreferences.getBoolean(Constants.ALLOW_FAJR_IBTEHAL_FLAG, true);
    }

    public boolean getFastingMondaysAndThursdaysEnabled() {
        return mPreferences.getBoolean(Constants.FASTING_MONDAYS_AND_THURSDAYS_ALERT_FLAG, true);
    }

}
