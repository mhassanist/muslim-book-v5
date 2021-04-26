package com.muslim_book.muslim_book.services.ramadan.ramadan_cannon;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;
import android.util.Log;

import androidx.annotation.Nullable;

import static com.muslim_book.muslim_book.classes.Constants.RAMADAN_CANNON_NOTIFICATION_ID;


public class RamadanCannonService extends Service {

    private  RamadanCannonServiceUtils ramadanServiceUtils;

    private static final String TAG_FOREGROUND_SERVICE = "FOREGROUND_SERVICE";

    public RamadanCannonService() {
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        ramadanServiceUtils = new  RamadanCannonServiceUtils(this);

    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.i("arrived Ramadan","onStartCommand");

        startForeground(RAMADAN_CANNON_NOTIFICATION_ID + 10, ramadanServiceUtils.createForeGroundNotification(intent));
            return START_REDELIVER_INTENT;
    }

}
