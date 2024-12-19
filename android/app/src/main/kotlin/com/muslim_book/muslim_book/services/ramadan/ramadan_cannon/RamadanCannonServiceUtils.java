package com.muslim_book.muslim_book.services.ramadan.ramadan_cannon;

import static android.content.Context.NOTIFICATION_SERVICE;
import static com.muslim_book.muslim_book.classes.Constants.FLUTTER_SHARED_PREFERENCES;
import static com.muslim_book.muslim_book.classes.Constants.RAMADAN_CANNON_CHANNEL_NAME;
import static com.muslim_book.muslim_book.classes.Constants.RAMADAN_CANNON_NOTIFICATION_CHANNEL_ID;
import static com.muslim_book.muslim_book.classes.Constants.RAMADAN_CANNON_NOTIFICATION_ID;

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

import com.muslim_book.muslim_book.R;
import com.muslim_book.muslim_book.classes.Constants;
import com.muslim_book.muslim_book.classes.Prefs;
import com.muslim_book.muslim_book.receivers.ramadan.RamadanCannonReceiver;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;


public class RamadanCannonServiceUtils {
    private  Context mContext;
    private  String time;
     private NotificationCompat.Builder builder;
    private NotificationManager notificationManager;

    public RamadanCannonServiceUtils(Context mContext) {
        this.mContext = mContext;
    }


    public void settingTimeAndKey(Intent intent){
        Log.i("arrived Ramadan","1");
        if (intent != null)
        {
            Log.i("arrived Ramadan","2");

            if ( intent.getAction() != null && intent.getAction()
                    .equals("android.intent.action.BOOT_COMPLETED")) {
                Log.i("arrived Ramadan","3");

                SharedPreferences mPrefs = mContext
                        .getSharedPreferences(FLUTTER_SHARED_PREFERENCES, Context.MODE_PRIVATE);
                time = mPrefs.getString(Constants.FLUTTER_TAG + Constants.NextRamadan_Cannon_Time, null);
             } else {
                Log.i("arrived Ramadan","4  " + intent.getStringExtra("time") + intent.getStringExtra("key"));
                time = intent.getStringExtra("time");
             }
        } else {
            Log.i("arrived Ramadan","5");

            SharedPreferences mPrefs = mContext
                    .getSharedPreferences(FLUTTER_SHARED_PREFERENCES, Context.MODE_PRIVATE);
            time = mPrefs.getString(Constants.FLUTTER_TAG + Constants.NextRamadan_Cannon_Time, null);
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
            NotificationChannel notificationChannel = new NotificationChannel(
                    RAMADAN_CANNON_NOTIFICATION_CHANNEL_ID, RAMADAN_CANNON_CHANNEL_NAME,
                    NotificationManager.IMPORTANCE_DEFAULT);
            notificationChannel.enableLights(true);
            notificationChannel.enableVibration(true);
            notificationChannel.setLightColor(Color.GREEN);
            notificationChannel.setVibrationPattern(new long[]{
                    500,
                    500,
                    500,
                    500,
                    500
            });
            notificationChannel.setLockscreenVisibility(Notification.VISIBILITY_PUBLIC);
            notificationManager.createNotificationChannel(notificationChannel);
        }
    };
    private void setNotificationBuilder() {
        String contentText;
        String contentTitle;

        if(time != null)
        {
           contentText =  "في تمام الساعة "+ time;
            contentTitle = mContext.getString(
                    mContext.getResources().getIdentifier("Ramadan_Iftar_time" , "string", mContext.getPackageName()));
            try {
                final SimpleDateFormat sdf = new SimpleDateFormat("H:mm");
                final Date dateObj = sdf.parse(time);

                String  show  =new SimpleDateFormat("hh:mm a" , new Locale("ar")).format(dateObj);
                contentText =  "في تمام الساعة "+  show;
                contentTitle = mContext.getString(
                        mContext.getResources().getIdentifier("Ramadan_Iftar_time" , "string", mContext.getPackageName()));
            } catch (final ParseException e) {
                e.printStackTrace();
            }
        }
        else {
            contentText = "قريبا";
            contentTitle = "موعد إفطار رمضان";
        }
         builder = new NotificationCompat.Builder(mContext, RAMADAN_CANNON_NOTIFICATION_CHANNEL_ID);
            builder.setOngoing(true);
        builder.setContentTitle(contentTitle);
        builder.setContentText(contentText);
        builder.setSmallIcon(R.mipmap.ic_launcher);
        builder.setAutoCancel(true);
        builder.setPriority(NotificationCompat.PRIORITY_MAX);
        builder.setVibrate(new long[]{
                500,
                500,
                500,
                500
        });
        builder.setVisibility(NotificationCompat.VISIBILITY_PUBLIC);




        Intent intent = new Intent(mContext, RamadanCannonReceiver.class);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(mContext, RAMADAN_CANNON_NOTIFICATION_ID, intent, PendingIntent.FLAG_UPDATE_CURRENT  | PendingIntent.FLAG_IMMUTABLE);
        builder.setContentIntent(pendingIntent);
    }

    private void startAlarmReceiver() {
        if (new Prefs(mContext).getRamadanConnan()){
            Intent intent = new Intent(mContext, RamadanCannonReceiver.class);
            Bundle extras = new Bundle();
            extras.putString("time", time);
             intent.putExtras(extras);
            Constants.SETBOOTRAMADANCANNONRECIEVER(mContext);
     
            mContext.sendBroadcast(intent);
         }
}
}
