package com.muslim_book.muslim_book.services.azan;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.os.Build;
import android.os.Handler;
import android.os.IBinder;
import android.provider.Settings;
import android.util.Log;

import androidx.core.app.NotificationCompat;

import com.muslim_book.muslim_book.MainActivity;
import com.muslim_book.muslim_book.R;

import java.util.Timer;
import java.util.TimerTask;

/// Waits (as a foreground service) for the user to grant the "draw over other apps"
/// permission, then brings the app back to the front.
public class OverLayService extends Service {
    private String TAG = "MyService";
    public static boolean isServiceRunning;
    private String CHANNEL_ID = "NOTIFICATION_CHANNEL";
    private Handler mHandler = new Handler();

    private Timer mTimer = null;
    public static final long NOTIFY_INTERVAL = 500;

    public OverLayService() {
        Log.d(TAG, "constructor called");
        isServiceRunning = false;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        Log.d(TAG, "onCreate called");
        createNotificationChannel();
        isServiceRunning = true;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.d(TAG, "onStartCommand called");

        // Must run on every start: after startForegroundService() Android kills the
        // app if startForeground() isn't called within a few seconds.
        try {
            startForeground(1, buildNotification());
        } catch (Exception e) {
            Log.v(TAG, "Could not start in foreground");
            e.printStackTrace();
            stopSelf();
            return START_NOT_STICKY;
        }

        // Already granted (e.g. started on boot): nothing to wait for
        if (checkDrawOverLays()) {
            stopSelf();
            return START_NOT_STICKY;
        }

        if (mTimer == null) {
            mTimer = new Timer();
            mTimer.scheduleAtFixedRate(new PermissionCheckTask(), 0, NOTIFY_INTERVAL);
        }
        return START_NOT_STICKY;
    }

    class PermissionCheckTask extends TimerTask {

        @Override
        public void run() {
            mHandler.post(new Runnable() {
                @Override
                public void run() {
                    if (checkDrawOverLays()) {
                        bringAppToFront();
                    }
                }
            });
        }

    }

    private boolean checkDrawOverLays() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            return Settings.canDrawOverlays(this);
        }
        return true;
    }

    private Notification buildNotification() {
        Intent notificationIntent = new Intent(this, MainActivity.class);
        PendingIntent pendingIntent = PendingIntent.getActivity(this,
                0, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT  | PendingIntent.FLAG_IMMUTABLE);
        return new NotificationCompat.Builder(this, CHANNEL_ID)
                .setContentTitle("جاري إعداد تطبيق مسلم بوك")
                .setSmallIcon(R.drawable.ic_wallpaper_black_24dp)
                .setContentIntent(pendingIntent)
                .setColor(getResources().getColor(R.color.colorPrimary))
                .build();
    }

    private void bringAppToFront() {
        if (mTimer != null) {
            mTimer.cancel();
            mTimer.purge();
            mTimer = null;
        }
        Log.d(TAG, "====Bringging com.muslim_book.muslim_book.Application to Front====");
        Intent intent = new Intent(this, MainActivity.class);
        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
        PendingIntent pendingIntent = PendingIntent.getActivity(this, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT  | PendingIntent.FLAG_IMMUTABLE);
        try {
            pendingIntent.send();
        } catch (PendingIntent.CanceledException e) {
            e.printStackTrace();
        }
        stopSelf();
    }

    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            String appName = getString(R.string.app_name);
            NotificationChannel serviceChannel = new NotificationChannel(
                    CHANNEL_ID,
                    appName,
                    NotificationManager.IMPORTANCE_DEFAULT
            );
            serviceChannel.setSound(null, null);
            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(serviceChannel);
        }
    }

    @Override
    public void onDestroy() {
        Log.d(TAG, "onDestroy called");
        isServiceRunning = false;
        stopForeground(true);


        // cancel the timer
        if (mTimer != null) {
            mTimer.cancel();
            mTimer = null;
        }



        super.onDestroy();
    }

    // Not getting called on Xiaomi Redmi Note 7S even when autostart permission is granted
    @Override
    public void onTaskRemoved(Intent rootIntent) {
        Log.d(TAG, "onTaskRemoved called");
        super.onTaskRemoved(rootIntent);
    }
}
