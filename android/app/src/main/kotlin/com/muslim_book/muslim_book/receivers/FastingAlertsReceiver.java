package com.muslim_book.muslim_book.receivers;

import static android.content.Context.NOTIFICATION_SERVICE;
import static com.muslim_book.muslim_book.classes.Constants.WEEKLY_FASTING_CHANNEL_NAME;
import static com.muslim_book.muslim_book.classes.Constants.WEEKLY_FASTING_NOTIFICATION_CHANNEL_ID;
import static com.muslim_book.muslim_book.classes.Constants.WEEKLY_FASTING_NOTIFICATION_ID;

import android.app.AlarmManager;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.media.AudioAttributes;
import android.os.Build;
import android.util.Log;
import android.view.View;
import android.widget.RemoteViews;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import com.muslim_book.muslim_book.R;
import com.muslim_book.muslim_book.classes.Constants;
import com.muslim_book.muslim_book.classes.Prefs;

import java.util.Calendar;

public class FastingAlertsReceiver extends BroadcastReceiver {
    NotificationManager notificationManager;
    NotificationCompat.Builder builder;
    Context mContext;

    @Override
    public void onReceive(Context context, Intent intent) {
        mContext = context;
        if (intent.getBooleanExtra(Constants.NOTIFY_KEY, false)) {
            if(intent.getBooleanExtra(Constants.FASTING_MONDAY_ALERT, false)){
                showNotification(true);
            }else if(intent.getBooleanExtra(Constants.FASTING_THURSDAY_ALERT, false)){
                showNotification(false);
            }
        } else {
            if (new Prefs(context).getFastingMondaysAndThursdaysEnabled()) {
                createWeeklyFastingAlarms(context);
            } else {
                deleteWeeklyFastingAlarms(context);
            }
        }
    }

    private void createWeeklyFastingAlarms(Context context) {
        createMondayFastingAlarm(context);
        createThursdayFastingAlarm(context);
    }

    private void deleteWeeklyFastingAlarms(Context context) {
        deleteMondayFastingAlarm(context);
        deleteThursdayFastingAlarm(context);
    }

    private void deleteMondayFastingAlarm(Context context) {
        AlarmManager alarmMgr = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        Intent intent = new Intent(context, FastingAlertsReceiver.class);
        intent.putExtra(Constants.FASTING_MONDAY_ALERT, true);
        intent.putExtra(Constants.NOTIFY_KEY, true);
        PendingIntent alarmIntent = PendingIntent
                .getBroadcast(context, Constants.FASTING_MONDAY_PENDING_INTENT_REQUEST_CODE, intent,
                PendingIntent.FLAG_UPDATE_CURRENT  | PendingIntent.FLAG_IMMUTABLE);
        alarmMgr.cancel(alarmIntent);
    }

    private void deleteThursdayFastingAlarm(Context context) {
        AlarmManager alarmMgr = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        Intent intent = new Intent(context, FastingAlertsReceiver.class);
        intent.putExtra(Constants.FASTING_THURSDAY_ALERT, true);
        intent.putExtra(Constants.NOTIFY_KEY, true);
        PendingIntent alarmIntent = PendingIntent
                .getBroadcast(context, Constants.FASTING_THURSDAY_PENDING_INTENT_REQUEST_CODE, intent,
                        PendingIntent.FLAG_UPDATE_CURRENT | PendingIntent.FLAG_IMMUTABLE);
        alarmMgr.cancel(alarmIntent);
    }

    private void createMondayFastingAlarm(Context context) {
        AlarmManager alarmMgr = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        Intent intent = new Intent(context, FastingAlertsReceiver.class);
        intent.putExtra(Constants.FASTING_MONDAY_ALERT, true);
        intent.putExtra(Constants.NOTIFY_KEY, true);
        PendingIntent alarmIntent = PendingIntent
                .getBroadcast(context, Constants.FASTING_MONDAY_PENDING_INTENT_REQUEST_CODE, intent,
                PendingIntent.FLAG_UPDATE_CURRENT  | PendingIntent.FLAG_IMMUTABLE);
        Calendar calendar = Calendar.getInstance();
        while (calendar.get(Calendar.DAY_OF_WEEK) != Calendar.SUNDAY) {
            calendar.add(Calendar.DATE, 1);
        }
        calendar.set(Calendar.HOUR_OF_DAY, 21);
        calendar.set(Calendar.MINUTE, 0);
        createWeeklyFastingAlarm(calendar, alarmMgr, alarmIntent);
    }

    private void createThursdayFastingAlarm(Context context) {
        AlarmManager alarmMgr = (AlarmManager) context.getSystemService(Context.ALARM_SERVICE);
        Intent intent = new Intent(context, FastingAlertsReceiver.class);
        intent.putExtra(Constants.FASTING_THURSDAY_ALERT, true);
        intent.putExtra(Constants.NOTIFY_KEY, true);
        PendingIntent alarmIntent = PendingIntent
                .getBroadcast(context, Constants.FASTING_THURSDAY_PENDING_INTENT_REQUEST_CODE, intent,
                PendingIntent.FLAG_UPDATE_CURRENT  | PendingIntent.FLAG_IMMUTABLE);
        Calendar calendar = Calendar.getInstance();
        while (calendar.get(Calendar.DAY_OF_WEEK) != Calendar.WEDNESDAY) {
            calendar.add(Calendar.DATE, 1);
        }
        calendar.set(Calendar.HOUR_OF_DAY, 21);
        calendar.set(Calendar.MINUTE, 0);
        createWeeklyFastingAlarm(calendar, alarmMgr, alarmIntent);
    }

    private void createWeeklyFastingAlarm(Calendar calendar, AlarmManager alarmMgr, PendingIntent alarmIntent) {
        Log.i("Calendar", calendar.getTime().toString());
        alarmMgr.setRepeating(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis()
                , AlarmManager.INTERVAL_DAY * 7, alarmIntent);
    }

    private void showNotification(boolean monday) {
        notificationManager = (NotificationManager) mContext.getSystemService(
                NOTIFICATION_SERVICE);
        setNotificationChannel();
        setNotificationBuilder(monday);
        Notification notification = builder.build();
        NotificationManagerCompat notificationManagerCompat = NotificationManagerCompat.from(mContext);
        notificationManagerCompat.notify(WEEKLY_FASTING_NOTIFICATION_ID, notification);
    }

    private void setNotificationBuilder(boolean monday) {
        String contentText = mContext.getResources().getString(R.string.fasting_tomorrow);
        String contentTitle = mContext.getString(
                mContext.getResources().getIdentifier(monday ? "monday" : "thursday", "string", mContext.getPackageName()));
        builder = new NotificationCompat.Builder(mContext, WEEKLY_FASTING_NOTIFICATION_CHANNEL_ID);
        builder.setContentTitle(contentTitle);
        builder.setContentText(contentText);
        builder.setSmallIcon(R.mipmap.ic_launcher);
        //        builder.setAutoCancel(true);
        builder.setPriority(NotificationCompat.PRIORITY_MAX);
        builder.setVibrate(new long[]{
                500,
                500,
                500,
                500
        });
        builder.setVisibility(NotificationCompat.VISIBILITY_PUBLIC);

        RemoteViews collapsedView = new RemoteViews(mContext.getPackageName(),
                R.layout.custom_notification_layout_collapsed);
        collapsedView.setTextViewText(R.id.app_name_notification_time, "مسلم بوك . ");
        collapsedView.setTextViewText(R.id.azan_notification_type_text, contentText);
        collapsedView.setTextViewText(R.id.azan_name, contentTitle);

        RemoteViews expandedView = new RemoteViews(mContext.getPackageName(),
                R.layout.custom_notification_layout);
        expandedView.setTextViewText(R.id.app_name_notification_time, "مسلم بوك . ");
        expandedView.setTextViewText(R.id.azan_notification_type_text, contentText);
        expandedView.setTextViewText(R.id.azan_name, contentTitle);
        expandedView.setViewVisibility(R.id.tap_to_close, View.GONE);
        expandedView.setViewVisibility(R.id.azan_icon, View.INVISIBLE);

        builder.setCustomContentView(collapsedView);
        builder.setCustomBigContentView(expandedView);
    }

    private void setNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel notificationChannel = new NotificationChannel(
                    WEEKLY_FASTING_NOTIFICATION_CHANNEL_ID, WEEKLY_FASTING_CHANNEL_NAME,
                    NotificationManager.IMPORTANCE_DEFAULT);

            notificationChannel.enableLights(true);
            notificationChannel.enableVibration(true);
            notificationChannel.setLightColor(Color.GREEN);
            AudioAttributes audioAttributes = new AudioAttributes.Builder()
                    .setContentType(AudioAttributes.CONTENT_TYPE_SONIFICATION)
                    .setUsage(AudioAttributes.USAGE_ALARM)
                    .build();
            //notificationChannel.setSound(Settings.System.DEFAULT_NOTIFICATION_URI, audioAttributes);
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

    }
}
