package com.muslim_book.muslim_book.services.azan;

import static android.content.Context.NOTIFICATION_SERVICE;
import static com.muslim_book.muslim_book.classes.Constants.AZAN_CHANNEL_NAME;
import static com.muslim_book.muslim_book.classes.Constants.AZAN_NOTIFICATION_CHANNEL_ID;
import static com.muslim_book.muslim_book.classes.Constants.AZAN_NOTIFICATION_ID;
import static com.muslim_book.muslim_book.classes.Constants.FLUTTER_SHARED_PREFERENCES;

import android.annotation.SuppressLint;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.graphics.Color;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import com.muslim_book.muslim_book.MainActivity;
import com.muslim_book.muslim_book.R;
import com.muslim_book.muslim_book.classes.Constants;
import com.muslim_book.muslim_book.classes.Prefs;
import com.muslim_book.muslim_book.recievers.azan.AzanReceiver;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;


public class AzanServiceUtils {
    private final Context mContext;
    private  String time;
    private  String key;
    private NotificationCompat.Builder builder;
    private NotificationManager notificationManager;

    public AzanServiceUtils(Context mContext) {
        this.mContext = mContext;
    }

    public void settingTimeAndKey(Intent intent){
        Log.i("arrived Azan","1");
        if (intent != null)
        {
            Log.i("arrived Azan","2");

            if ( intent.getAction() != null && intent.getAction()
                    .equals("android.intent.action.BOOT_COMPLETED")) {
                Log.i("arrived Azan","3");

                SharedPreferences mPrefs = mContext
                        .getSharedPreferences(FLUTTER_SHARED_PREFERENCES, Context.MODE_PRIVATE);
                time = mPrefs.getString(Constants.FLUTTER_TAG
                        + Constants.NEXT_AZAN_TIME, null);
                key = mPrefs.getString(Constants.FLUTTER_TAG + Constants.NEXT_AZAN_KEY, null);
            } else {
                Log.i("arrived Azan","4  " + intent.getStringExtra("time") + intent.getStringExtra("key"));
                time = intent.getStringExtra("time");
                key = intent.getStringExtra("key");
            }
        } else {
            Log.i("arrived Azan","5");

            SharedPreferences mPrefs = mContext
                    .getSharedPreferences(FLUTTER_SHARED_PREFERENCES, Context.MODE_PRIVATE);
            time = mPrefs.getString(Constants.FLUTTER_TAG + Constants.NEXT_AZAN_TIME, null);
            key = mPrefs.getString(Constants.FLUTTER_TAG + Constants.NEXT_AZAN_KEY, null);
        }

    }

    public Notification createForeGroundNotification(Intent intent) {
        notificationManager = (NotificationManager) mContext.getSystemService(
                NOTIFICATION_SERVICE);
        settingTimeAndKey(intent);
        setNotificationChannel();
        setNotificationBuilder();

        Notification notification = builder.build();
        NotificationManagerCompat notificationManagerCompat = NotificationManagerCompat.from(mContext);
        startAlarmReceiver();
        return notification;
    }

    private void setNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            NotificationChannel notificationChannel = new NotificationChannel(
//                    AZAN_NOTIFICATION_CHANNEL_ID, AZAN_CHANNEL_NAME,
//                    NotificationManager.IMPORTANCE_DEFAULT);
            NotificationChannel notificationChannel = new NotificationChannel(
                    AZAN_NOTIFICATION_CHANNEL_ID, AZAN_CHANNEL_NAME,
                    NotificationManager.IMPORTANCE_LOW);
//            notificationChannel.enableLights(true);
//            notificationChannel.enableVibration(true);
//            notificationChannel.setLightColor(Color.GREEN);
//            notificationChannel.setVibrationPattern(new long[]{
//                    500,
//                    500,
//                    500,
//                    500,
//                    500
//            });
            notificationChannel.setLockscreenVisibility(Notification.VISIBILITY_PUBLIC);
            notificationManager.createNotificationChannel(notificationChannel);
        }
    };
    @SuppressLint({"SuspiciousIndentation", "DiscouragedApi", "SimpleDateFormat", "LaunchActivityFromNotification"})
    private void setNotificationBuilder() {
        String contentText;
        String contentTitle;

        if (key != null && time != null) {
            contentText = "في تمام الساعة " + time;
            contentTitle = mContext.getString(
                    mContext.getResources().getIdentifier("before_azan_" + key, "string", mContext.getPackageName()));
            try {
                final SimpleDateFormat sdf = new SimpleDateFormat("H:mm");
                final Date dateObj = sdf.parse(time);

                assert dateObj != null;
                String show = new SimpleDateFormat("hh:mm a", new Locale("ar")).format(dateObj);
                contentText = "في تمام الساعة " + show;
                contentTitle = mContext.getString(
                        mContext.getResources().getIdentifier("before_azan_" + key, "string", mContext.getPackageName()));
            } catch (final ParseException e) {
                e.printStackTrace();
            }
        } else {
            contentText = "قريبا";
            contentTitle = "الصلاة";
        }
        builder = new NotificationCompat.Builder(mContext, AZAN_NOTIFICATION_CHANNEL_ID);
        builder.setOngoing(true);
        builder.setContentTitle(contentTitle);
        builder.setContentText(contentText);
        builder.setSmallIcon(R.mipmap.ic_launcher);
        builder.setAutoCancel(true);
//        builder.setPriority(NotificationCompat.PRIORITY_MAX);
        builder.setPriority(NotificationCompat.PRIORITY_LOW);
//        builder.setVibrate(new long[]{
//                500,
//                500,
//                500,
//                500
//        });
        builder.setVisibility(NotificationCompat.VISIBILITY_PUBLIC);

        Intent intent = new Intent(mContext, AzanReceiver.class);
//        PendingIntent pendingIntent = PendingIntent.getBroadcast(mContext,
//                AZAN_NOTIFICATION_ID,
//                intent,
//                PendingIntent.FLAG_IMMUTABLE);
        PendingIntent pendingIntent;
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            pendingIntent = PendingIntent.getBroadcast(
                    mContext,
                    AZAN_NOTIFICATION_ID,
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_MUTABLE);

        } else {
            pendingIntent = PendingIntent.getBroadcast(
                    mContext,
                    AZAN_NOTIFICATION_ID,
                    intent,
                    PendingIntent.FLAG_UPDATE_CURRENT);

        }
        builder.setContentIntent(pendingIntent);
    }

    private void startAlarmReceiver() {
        if (new Prefs(mContext).getAllowAzan()){
            Intent intent = new Intent(mContext, AzanReceiver.class);
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
            mContext.sendBroadcast(intent);
//            ContextCompat.starre(mContext, intent);
        }
    }
}
