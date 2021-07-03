//package com.muslim_book.muslim_book.services.drawOverlay;
//
//
//
//import android.annotation.SuppressLint;
//import android.app.Dialog;
//import android.app.Notification;
//import android.app.PendingIntent;
//import android.app.Service;
//import android.content.ComponentName;
//import android.content.Context;
//import android.content.DialogInterface;
//import android.content.Intent;
//import android.content.SharedPreferences;
//import android.content.pm.PackageManager;
//import android.graphics.Color;
//import android.os.Build;
//import android.os.Handler;
//import android.os.IBinder;
//import android.os.Looper;
//import android.preference.PreferenceManager;
//import android.provider.Settings;
//import android.util.Log;
//import android.view.Gravity;
//import android.view.Window;
//import android.view.WindowManager;
//import android.widget.TextView;
//import android.widget.Toast;
//
//
//import androidx.appcompat.app.AlertDialog;
//import androidx.core.app.NotificationCompat;
//import androidx.core.app.NotificationManagerCompat;
//
//import com.muslim_book.muslim_book.MainActivity;
//import com.muslim_book.muslim_book.R;
//
//import java.text.SimpleDateFormat;
//import java.util.Calendar;
//import java.util.Timer;
//import java.util.TimerTask;
//
//public class DrawOverlayService  extends Service {
//    private final String TAG = "DrawOverlayService";
//    public static boolean isServiceRunning;
//    private final Handler mHandler = new Handler();
//    private final Timer mTimer = new Timer();
//    public static final long NOTIFY_INTERVAL = 500;
//    Calendar calendar;
//    SimpleDateFormat simpleDateFormat;
//    String strDate;
//
//    public DrawOverlayService() {
//        Log.d(TAG, "constructor called");
//        isServiceRunning = false;
//     }
//
//    @SuppressLint({"CommitPrefEdits", "SimpleDateFormat"})
//    @Override
//    public void onCreate() {
//
//        super.onCreate();
//        Log.d(TAG, "onCreate called");
//         isServiceRunning = true;
//        calendar = Calendar.getInstance();
//        simpleDateFormat = new SimpleDateFormat("HH:mm:ss");
//
//    }
//
//    class TimeDisplayTimerTask extends TimerTask {
//
//        public TimeDisplayTimerTask(Intent intent) {
//        }
//
//        @Override
//        public void run() {
//            mHandler.post(new Runnable() {
//                @SuppressLint("SimpleDateFormat")
//                @Override
//                public void run() {
//                    calendar = Calendar.getInstance();
//                    simpleDateFormat = new SimpleDateFormat("HH:mm:ss");
//                    strDate = simpleDateFormat.format(calendar.getTime());
//                    long millis = System.currentTimeMillis();
//                    int seconds = (int) (millis / 1000);
//                    int minutes = seconds / 60;
//                    seconds = seconds % 60;
//                    Log.e("strDate", strDate);
//                    @SuppressLint("DefaultLocale")
//                    String str_testing = String.format("%d:%02d", minutes, seconds);
//                    Log.e("TIME", str_testing);
//                    lunch();
//                }
//
//            });
//        }
//
//    }
//
//
//
//    private boolean checkDrawOverLays() {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
//            return Settings.canDrawOverlays(this);
//        }
//        return true;
//    }
//
//    public void lunch() {
//        boolean overlayCheck = checkDrawOverLays();
//
//        if (overlayCheck) {
//            mTimer.cancel();
//            mTimer.purge();
//
//
//            Context ctx=this;
//            Intent intent = ctx.getPackageManager().getLaunchIntentForPackage("com.muslim_book.muslim_book");
//            intent.setAction(Intent.ACTION_MAIN);
//            intent.addCategory(Intent.CATEGORY_LAUNCHER);
//            intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//            intent.setFlags(Intent.FLAG_ACTIVITY_REORDER_TO_FRONT);
//            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
//            ctx.startActivity(intent);
//            onDestroy();
//            Log.v(TAG, "Notification sent");
//        }
//    }
//
//    @Override
//    public IBinder onBind(Intent intent) {
//        return null;
//    }
//
//    @Override
//    public int onStartCommand(Intent intent, int flags, int startId) {
//        Log.d(TAG, "onStartCommand called");
//        boolean overlayCheck = checkDrawOverLays();
//        if (!overlayCheck) {
//            mTimer.scheduleAtFixedRate(new TimeDisplayTimerTask(intent), 5, NOTIFY_INTERVAL);
//        }
//        return START_STICKY;
//    }
//
//
//
//
//    @Override
//    public void onDestroy() {
//        Toast.makeText(this, "shaommmmmmmma", Toast.LENGTH_SHORT).show();
//        Log.d(TAG, "onDestroy called");
//        isServiceRunning = false;
//        stopForeground(true);
//        mTimer.cancel();
//        super.onDestroy();
//    }
//
//     @Override
//    public void onTaskRemoved(Intent rootIntent) {
//        Log.d(TAG, "onTaskRemoved called");
//        super.onTaskRemoved(rootIntent);
//    }
//}
