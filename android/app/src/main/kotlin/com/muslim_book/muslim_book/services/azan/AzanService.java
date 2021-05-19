package com.muslim_book.muslim_book.services.azan;

import android.app.Service;
import android.content.Intent;
import android.os.Build;
import android.os.IBinder;
import android.provider.Settings;
import android.util.Log;

import androidx.annotation.Nullable;

import static com.muslim_book.muslim_book.classes.Constants.AZAN_NOTIFICATION_ID;

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
        mAzanUtils = new  AzanServiceUtils(this);

    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.i("arrived Azan","onStartCommand");
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (Settings.canDrawOverlays(this)) {
                Log.i("is_canDrawOverlays","truuuuuuuuuuuuuu");

            }
        }else {
//            Log.i("is_canDrawOverlays","truuuuuuuuuuuuuu");

        }

        startForeground(AZAN_NOTIFICATION_ID + 10, mAzanUtils.createForeGroundNotification(intent));
            return START_REDELIVER_INTENT;
    }

}
