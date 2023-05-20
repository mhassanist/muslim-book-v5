package com.muslim_book.muslim_book.services.azan;

import static com.muslim_book.muslim_book.classes.Constants.AZAN_NOTIFICATION_ID;

import android.app.Service;
import android.content.Intent;
import android.os.IBinder;

import androidx.annotation.Nullable;

public class AzanService extends Service {

    private AzanServiceUtils mAzanUtils;

    private static final String TAG_FOREGROUND_SERVICE = "FOREGROUND_SERVICE";

    public AzanService() {
    }

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        mAzanUtils = new AzanServiceUtils(this);
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
//        if (Settings.canDrawOverlays(this)) {}
        startForeground(AZAN_NOTIFICATION_ID + 10, mAzanUtils.createForeGroundNotification(intent));
        return START_REDELIVER_INTENT;
    }
}
