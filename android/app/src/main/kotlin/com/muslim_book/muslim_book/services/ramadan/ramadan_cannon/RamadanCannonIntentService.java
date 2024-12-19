package com.muslim_book.muslim_book.services.ramadan.ramadan_cannon;

import static android.content.Intent.FLAG_ACTIVITY_NEW_TASK;
import static com.muslim_book.muslim_book.classes.Constants.RAMADAN_CANNON_CHANNEL_NAME;
import static com.muslim_book.muslim_book.classes.Constants.RAMADAN_CANNON_NOTIFICATION_CHANNEL_ID;
import static com.muslim_book.muslim_book.classes.Constants.RAMADAN_CANNON_NOTIFICATION_ID;

import android.Manifest;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.graphics.Color;
import android.graphics.PixelFormat;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Build;
import android.os.Build.VERSION;
import android.os.Handler;
import android.os.IBinder;
import android.provider.Settings;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RemoteViews;
import android.widget.TextView;

import androidx.annotation.Nullable;
import androidx.core.app.ActivityCompat;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

//import com.facebook.ads.InterstitialAd;
import com.google.android.gms.ads.interstitial.InterstitialAd;
import com.google.firebase.remoteconfig.FirebaseRemoteConfig;
import com.google.firebase.remoteconfig.FirebaseRemoteConfigSettings;
import com.muslim_book.muslim_book.MainActivity;
import com.muslim_book.muslim_book.R;
import com.muslim_book.muslim_book.classes.Constants;
import com.muslim_book.muslim_book.classes.ramdan.RamadanCannonUtils;
import com.muslim_book.muslim_book.receivers.ramadan.RamadanCannonReceiver;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;
import java.util.Timer;
import java.util.TimerTask;

import at.markushi.ui.CircleButton;

public class RamadanCannonIntentService extends Service {
    NotificationManager notificationManager;
    NotificationCompat.Builder builder;
    WindowManager mWindowManager;
    MediaPlayer mMediaPlayer;
    MediaPlayer mAfterAzanMediaPlayer;
    private InterstitialAd mInterstitialAd;
    FirebaseRemoteConfig mFirebaseRemoteConfig = FirebaseRemoteConfig.getInstance();
    private TextView mAzanName;
    private TextView title;
    private ImageView mSlider;
    View mView;
    boolean beforeAzan;
    boolean mBeforeCompetition = false;

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {
        return null;
    }

    @Override
    public void onCreate() {
        super.onCreate();
        if (VERSION.SDK_INT >= 26) {
            NotificationChannel channel = new NotificationChannel(
                    RAMADAN_CANNON_NOTIFICATION_CHANNEL_ID, RAMADAN_CANNON_CHANNEL_NAME,
                    NotificationManager.IMPORTANCE_DEFAULT);
            ((NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE))
                    .createNotificationChannel(channel);
            Notification notification = new NotificationCompat.Builder(this
                    , RAMADAN_CANNON_NOTIFICATION_CHANNEL_ID)
                    .setContentTitle("")
                    .setSmallIcon(R.mipmap.ic_launcher)
                    .setContentText("").build();
            startForeground(RAMADAN_CANNON_NOTIFICATION_ID, notification);
            stopForeground(true);
        }
        mFirebaseRemoteConfig.setConfigSettingsAsync(new FirebaseRemoteConfigSettings.Builder()
                .build());
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
         showNotification();
        playConnan();


        return START_STICKY;
    }

    private void playConnan() {

        mMediaPlayer = MediaPlayer.create(this,
                Uri.fromFile(new File(azanSoundUriString())));
        try{
            mMediaPlayer.prepare();
        }catch(Exception e){

        }
        if (mMediaPlayer != null) {
            mMediaPlayer.start();
        }
        if (mMediaPlayer != null) {
            mMediaPlayer.setOnCompletionListener(mPlayer -> {
                onDestroy();
            });
        }
        checkAzanSlider();
    }


    private void scheduleNext(int time) {

        final Handler handler = new Handler();
        Timer timer = new Timer();
        TimerTask doAsynchronousTask = new TimerTask() {
            @Override
            public void run() {
                handler.post(new Runnable() {
                    public void run() {
                        try {
                            onDestroy();
                            //your method here
                        } catch (Exception e) {
                        }
                    }
                });
            }
        };
        timer.schedule(doAsynchronousTask, 0, time); //execute in every 10 minutes


    }



    private void checkAzanSlider() {
        if (VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            if (Settings.canDrawOverlays(this)) {
                showAzanSlider();
            }
        } else {
            showAzanSlider();
        }
    }

    private String getRamadanConnanId(String key) {
        SharedPreferences prefs = getSharedPreferences(Constants.FLUTTER_SHARED_PREFERENCES,
                MODE_PRIVATE);


        return prefs.getString(Constants.SELECTED_RAMADAN_CANNON_ID + key, "0");
    }



    @Override
    public void onDestroy() {
        stopAzan();
        super.onDestroy();
    }

    private void showAzanSlider() {
        mWindowManager = (WindowManager) getSystemService(WINDOW_SERVICE);
        LayoutInflater inflater = (LayoutInflater) getSystemService(LAYOUT_INFLATER_SERVICE);
        mView = inflater.inflate(R.layout.azan_slider_view, null);
        mSlider = mView.findViewById(R.id.azan_slider);
        mAzanName = mView.findViewById(R.id.azan_name);
        title = mView.findViewById(R.id.azan_text);
        Button azanDone = mView.findViewById(R.id.bt_azan_done);
        String contentText = "حان الان موعد";
        String contentTitle = "الإفطار";
        mAzanName.setText(contentTitle);
        title.setText(contentText);
        CircleButton close = mView.findViewById(R.id.close_azan_slider);

        mWindowManager.addView(mView, layoutParams());
        azanDone.setOnClickListener(v -> {
            Intent intent = new Intent(this, MainActivity.class);
            intent.addFlags(FLAG_ACTIVITY_NEW_TASK);
            startActivity(intent);
            mBeforeCompetition = true;
            if (mWindowManager != null && mView.getWindowToken() != null) {
                mWindowManager.removeView(mView);
            }
            onDestroy();
        });

    }

    private ViewGroup.LayoutParams layoutParams() {
        WindowManager.LayoutParams lp = new WindowManager.LayoutParams(
                WindowManager.LayoutParams.MATCH_PARENT,
                WindowManager.LayoutParams.MATCH_PARENT,
                VERSION.SDK_INT >= Build.VERSION_CODES.O ?
                        WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
                        : WindowManager.LayoutParams.TYPE_PHONE,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT);
        lp.screenOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT;
        return lp;
    }

    private void stopAzan() {
        stopForeground(true);


        if (mWindowManager != null && mView.getWindowToken() != null) {
            mWindowManager.removeView(mView);
        }

        try {
            notificationManager.cancel(Constants.AZAN_NOTIFICATION_ID);
        } catch (Exception e) {

        }
        try {
            if (mMediaPlayer != null && mMediaPlayer.isPlaying()) {
                mMediaPlayer.stop();
                mMediaPlayer.reset();
                mMediaPlayer.release();
            }
            if (mMediaPlayer != null && mMediaPlayer.isPlaying()) {
                mMediaPlayer.stop();
                mMediaPlayer.reset();
                mMediaPlayer.release();
            }
            if (mAfterAzanMediaPlayer != null && mAfterAzanMediaPlayer.isPlaying()) {
                mAfterAzanMediaPlayer.stop();
                mAfterAzanMediaPlayer.reset();
                mAfterAzanMediaPlayer.release();
            }

        } catch (Exception e) {
        }

        new RamadanCannonUtils(this);

    }


    void closeMediaPlayer() {
        try {
            if (mMediaPlayer != null && mMediaPlayer.isPlaying()) {
                mMediaPlayer.stop();
                mMediaPlayer.release();
                mMediaPlayer = null;
            }
        } catch (Exception e) {

        }
    }

    private void showNotification() {
        notificationManager = (NotificationManager) getSystemService(
                NOTIFICATION_SERVICE);

        checkNotificationAndDelete();
        setNotificationChannel();
        setNotificationBuilder();

        Notification notification = builder.build();
        NotificationManagerCompat notificationManagerCompat = NotificationManagerCompat.from(this);

        /// TODO: ASLAN check permission
        if (ActivityCompat.checkSelfPermission(this, Manifest.permission.POST_NOTIFICATIONS) != PackageManager.PERMISSION_GRANTED) {
            // TODO: Consider calling
            //    ActivityCompat#requestPermissions
            // here to request the missing permissions, and then overriding
            //   public void onRequestPermissionsResult(int requestCode, String[] permissions,
            //                                          int[] grantResults)
            // to handle the case where the user grants the permission. See the documentation
            // for ActivityCompat#requestPermissions for more details.
            return;
        }
        notificationManagerCompat.notify(RAMADAN_CANNON_NOTIFICATION_ID, notification);
    }

    private void setNotificationChannel() {
        if (VERSION.SDK_INT >= Build.VERSION_CODES.O) {
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
    }

    private void checkNotificationAndDelete() {
        try {
            notificationManager.cancel(Constants.RAMADAN_CANNON_NOTIFICATION_ID);
        } catch (Exception e) {

        }
    }

    private void setNotificationBuilder() {
        SimpleDateFormat dateFormat = new SimpleDateFormat("hh:mm a", Locale.ENGLISH);
        String currentDateFormated = dateFormat.format(Calendar.getInstance().getTime());
        String contentText = "حان الان موعد";
        String contentTitle = "الإفطار";
//        String contentTitle = getString(
//                getResources().getIdentifier("before_azan_" + nextAzanKey, "string", getPackageName()));
//
        builder = new NotificationCompat.Builder(this, RAMADAN_CANNON_NOTIFICATION_CHANNEL_ID);

        builder.setSound(Uri.parse(azanSoundUriString()));
        builder.setOngoing(false);

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

        RemoteViews collapsedView = new RemoteViews(getPackageName(),
                R.layout.custom_notification_layout_collapsed);
        collapsedView
                .setTextViewText(R.id.app_name_notification_time, "مسلم بوك . " + currentDateFormated);
        collapsedView.setTextViewText(R.id.azan_notification_type_text, contentText);
        collapsedView.setTextViewText(R.id.azan_name, contentTitle);

        RemoteViews expandedView = new RemoteViews(getPackageName(),
                R.layout.custom_notification_layout);
        expandedView
                .setTextViewText(R.id.app_name_notification_time, "مسلم بوك . " + currentDateFormated);
        expandedView.setTextViewText(R.id.azan_notification_type_text, contentText);
        expandedView.setTextViewText(R.id.azan_name, contentTitle);
        int drawableId = 1;
        expandedView.setImageViewResource(R.id.azan_icon, drawableId);

        builder.setCustomContentView(collapsedView);
        builder.setCustomBigContentView(expandedView);
        Intent intent = new Intent(this, RamadanCannonReceiver.class);
        intent.putExtra(Constants.CLOSE_RAMADAN_CANNON, true);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(this, RAMADAN_CANNON_NOTIFICATION_ID, intent, PendingIntent.FLAG_UPDATE_CURRENT  | PendingIntent.FLAG_IMMUTABLE);
        builder.setContentIntent(pendingIntent);
        builder.setDeleteIntent(pendingIntent);
    }

    private String azanSoundUriString() {
        return getApplicationInfo().dataDir + "/app_flutter/ramadan_cannonModel_sounds" + getRamadanConnanId("") + ".mp3";
    }


}
