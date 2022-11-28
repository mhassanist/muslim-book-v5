package com.muslim_book.muslim_book.services.ramadan.ramadan_mshart;

import static com.muslim_book.muslim_book.classes.Constants.RAMADAN_MSHART_NOTIFICATION_ID;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.Nullable;


public class RamadanMshartService extends Service {

    private RamadanMshartServiceUtils ramadanServiceUtils;

    private static final String TAG_FOREGROUND_SERVICE = "FOREGROUND_SERVICE";

    public RamadanMshartService() {
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        ramadanServiceUtils = new RamadanMshartServiceUtils(this);

    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.i("arrived Ramadan mshart", "onStartCommand");

 
        startForeground(RAMADAN_MSHART_NOTIFICATION_ID + 10, ramadanServiceUtils.createForeGroundNotification(intent));
        return START_REDELIVER_INTENT;
    }

}
