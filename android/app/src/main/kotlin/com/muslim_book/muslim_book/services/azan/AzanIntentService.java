package com.muslim_book.muslim_book.services.azan;

import static android.content.Intent.FLAG_ACTIVITY_NEW_TASK;
import static android.media.MediaExtractor.MetricsConstants.FORMAT;
import static com.facebook.ads.CacheFlag.ALL;
import static com.muslim_book.muslim_book.classes.Constants.AZAN_CHANNEL_NAME;
import static com.muslim_book.muslim_book.classes.Constants.AZAN_NOTIFICATION_CHANNEL_ID;
import static com.muslim_book.muslim_book.classes.Constants.AZAN_NOTIFICATION_ID;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.graphics.PixelFormat;
import android.media.AudioManager;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Build;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.CountDownTimer;
import android.os.Handler;
import android.os.IBinder;
import android.provider.Settings;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.RemoteViews;
import android.widget.TextView;
import android.widget.Toast;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import at.markushi.ui.CircleButton;

import com.facebook.ads.Ad;
import com.facebook.ads.AdError;
import com.facebook.ads.InterstitialAd;
import com.facebook.ads.InterstitialAdListener;
import com.google.firebase.remoteconfig.FirebaseRemoteConfig;
import com.google.firebase.remoteconfig.FirebaseRemoteConfigSettings;
import com.muslim_book.muslim_book.MainActivity;
import com.muslim_book.muslim_book.R;
import com.muslim_book.muslim_book.classes.AzanUtils;
import com.muslim_book.muslim_book.classes.Constants;
import com.muslim_book.muslim_book.classes.Prefs;
import com.muslim_book.muslim_book.recievers.azan.AzanReceiver;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.TimeUnit;

import org.joda.time.Days;
import org.joda.time.LocalDate;


public class AzanIntentService extends Service {
    NotificationManager notificationManager;
    NotificationCompat.Builder builder;
    WindowManager mWindowManager;
    MediaPlayer mMediaPlayer;
    MediaPlayer mAfterAzanMediaPlayer;
    private InterstitialAd interstitialAd;
    FirebaseRemoteConfig mFirebaseRemoteConfig = FirebaseRemoteConfig.getInstance();
    private TextView mAzanName;
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
        if (Build.VERSION.SDK_INT >= 26) {
            NotificationChannel channel = new NotificationChannel(
                    AZAN_NOTIFICATION_CHANNEL_ID,
                    AZAN_CHANNEL_NAME,
                    NotificationManager.IMPORTANCE_DEFAULT);
            ((NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE))
                    .createNotificationChannel(channel);
            Notification notification = new
                    NotificationCompat.Builder(
                    this, AZAN_NOTIFICATION_CHANNEL_ID)
                    .setContentTitle("")
                    .setSmallIcon(R.mipmap.launcher_icon)
                    .setContentText("").build();
            startForeground(AZAN_NOTIFICATION_ID, notification);
            stopForeground(true);
        }
        mFirebaseRemoteConfig.setConfigSettingsAsync(new FirebaseRemoteConfigSettings.Builder()
                .build());
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {

        if (intent != null) {
            beforeAzan = intent.getBooleanExtra(Constants.BEFORE_AZAN, false);
            showNotification(
                    intent.getStringExtra(Constants.NEXT_AZAN_KEY));
            playAzan(beforeAzan,
                    intent.getStringExtra(Constants.NEXT_AZAN_KEY));

        }
        return START_STICKY;
    }

    private void playAzan(boolean beforeAzan, String key) {
        SharedPreferences prefs = getSharedPreferences(Constants.FLUTTER_SHARED_PREFERENCES,
                MODE_PRIVATE);
        String json = prefs.getString(Constants.MUTED_AZAN, null);
        boolean Activating_Al_Shaarawi_Voice_FLAG = prefs.getBoolean(Constants.Activating_Al_Shaarawi_Voice_FLAG, true);
        boolean Switch_Silent_Mode_After_Residence = prefs.getBoolean(Constants.Switch_Silent_Mode_After_Residence, false);
        boolean Turn_Off_The_Call_To_Prayer_On_The_Phone = prefs.getBoolean(Constants.Turn_Off_The_Call_To_Prayer_On_The_Phone, false);
        boolean FASTING_MONDAYS_AND_THURSDAYS_ALERT_FLAG = prefs.getBoolean(Constants.FASTING_MONDAYS_AND_THURSDAYS_ALERT_FLAG, true);


        if (beforeAzan) {
            playBeforeAzanSound(key);
        } else {
            if (key.equalsIgnoreCase("1")) { //fajr prayer , play fajr prayer logic
                mMediaPlayer = MediaPlayer.create(this,
                        Uri.fromFile(new File(getApplicationInfo().dataDir + "/app_flutter/azan_" + getFajrMuazenName() + ".mp3")));
            } else {

                mMediaPlayer = MediaPlayer.create(this,
                        Uri.fromFile(new File(getApplicationInfo().dataDir + "/app_flutter/azan_" + getMuazenName(key) + ".mp3")));
            }

            if (json != null && json.contains(key)) {

                scheduleNext(60 * 3 * 1000); // time in m seconds 10

            } else {

                mAfterAzanMediaPlayer = MediaPlayer.create(this,
                        Uri.fromFile(new File(getApplicationInfo().dataDir + "/app_flutter/after_azan.mp3")));
                boolean _isCallActive = isCallActive(this);
                AudioManager am = (AudioManager) getSystemService(Context.AUDIO_SERVICE);

                switch (am.getMode()) {
                    case AudioManager.MODE_IN_COMMUNICATION:
                        Log.i("MyApp", "Silent mode");
                        break;
                    case AudioManager.MODE_RINGTONE:
                        Log.i("MyApp", "Vibrate mode");

                        break;
                    case AudioManager.MODE_IN_CALL:
                        Log.i("MyApp", "MODE_RINGTONE");
//                        break;
                }
                boolean _isSilentMode = isSilentMode(this);
                Log.i("_isSilentMode", _isSilentMode + "");
                Log.i("MyApp", _isCallActive + "  _isCallActive");
                if (Turn_Off_The_Call_To_Prayer_On_The_Phone) {
                    Log.i("_isSilentMode", "one");
                    if (_isCallActive) {
                        Log.i("_isSilentMode", "_isCallActive");
                        mMediaPlayer.stop();
                    } else {
                        Log.i("_isSilentMode", "!_isCallActive");
                        if (!_isSilentMode) {
                            mMediaPlayer.start();
                        }
                    }
                } else {
                    Log.i("_isSilentMode", "tow");
                    if (!_isSilentMode) {
                        mMediaPlayer.start();
                    }
                }

                mMediaPlayer.setOnCompletionListener(mPlayer -> {
                    if (Activating_Al_Shaarawi_Voice_FLAG) {
                        if (mAfterAzanMediaPlayer != null) {
                            mAfterAzanMediaPlayer.start();
                            mAfterAzanMediaPlayer.setOnCompletionListener(mediaPlayer -> {
                                /// add silent mode after do3aa sound
                                if (Switch_Silent_Mode_After_Residence) {
                                    setSilentMode(true);
                                } else {
                                    onDestroy();
                                }


                            });
                        }
                    } else {
                        if (Switch_Silent_Mode_After_Residence) {
                            setSilentMode(false);
                        }
                    }
                });

            }


            checkAzanSlider(key, Switch_Silent_Mode_After_Residence);
        }
    }

    private void scheduleNext(int time) {

        final Handler handler = new Handler();
        Timer timer = new Timer();
        TimerTask doAsynchronousTask = new TimerTask() {
            @Override
            public void run() {
                handler.post(new Runnable() {
                    public void run() {
                        onDestroy();

                    }
                });
            }
        };
        timer.schedule(doAsynchronousTask, 0, time); //execute in every 10 minutes


    }

    public boolean isCallActive(Context context) {
        AudioManager manager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
        return manager.getMode() == AudioManager.MODE_IN_CALL;
    }

    public boolean isSilentMode(Context context) {
        AudioManager manager = (AudioManager) context.getSystemService(Context.AUDIO_SERVICE);
        return manager.getRingerMode() == AudioManager.RINGER_MODE_SILENT;
    }

    private void setSilentMode(boolean onDestroy) {

        try {
            AudioManager mgr = (AudioManager) getSystemService(Context.AUDIO_SERVICE);
            int streamType = AudioManager.STREAM_SYSTEM;
            mgr.setStreamSolo(streamType, true);
            mgr.setRingerMode(AudioManager.RINGER_MODE_SILENT);
            mgr.setStreamMute(streamType, true);


            new CountDownTimer(300000, 1000) {

                public void onTick(long millisUntilFinished) {
                    String tttt = "" + String.format("%02d:%02d:%02d",
                            TimeUnit.MILLISECONDS.toHours(millisUntilFinished),
                            TimeUnit.MILLISECONDS.toMinutes(millisUntilFinished) - TimeUnit.HOURS.toMinutes(
                                    TimeUnit.MILLISECONDS.toHours(millisUntilFinished)),
                            TimeUnit.MILLISECONDS.toSeconds(millisUntilFinished) - TimeUnit.MINUTES.toSeconds(
                                    TimeUnit.MILLISECONDS.toMinutes(millisUntilFinished)));
                    Log.i("Seconds_remaining: ", tttt + "");

                }

                public void onFinish() {
                    int streamType = AudioManager.STREAM_SYSTEM;
                    mgr.setStreamSolo(streamType, false);
                    mgr.setRingerMode(AudioManager.RINGER_MODE_NORMAL);
                    mgr.setStreamMute(streamType, false);
                    if (onDestroy) {
                        onDestroy();
                    }
                }

            }.start();
        } catch (Exception ex) {
            //no need to log any error
            //if crashed while setting mode to silent, that means the permission is not set
        }

    }

    private void showAdsThenDestroyTheService() {
    }
//  private void showAdsThenDestroyTheService() {
//    try {
//      long installed =
//          getPackageManager().getPackageInfo(getPackageName(), 0).firstInstallTime;
//      if (getIsDaysMoreThanSeven(installed))
//      {
//
//      }
//
//    } catch (NameNotFoundException e) {
//      showAd();
//      e.printStackTrace();
//    }
//
//
//  }

    private void showAd() {
        interstitialAd = new InterstitialAd(this, mFirebaseRemoteConfig.getString("after_azan_pop_up"));

        interstitialAd.loadAd(interstitialAd.buildLoadAdConfig()
                .withAdListener(new InterstitialAdListener() {
                    @Override
                    public void onInterstitialDisplayed(Ad ad) {
                    }

                    @Override
                    public void onInterstitialDismissed(Ad ad) {

                    }

                    @Override
                    public void onError(Ad ad, AdError adError) {
                    }

                    @Override
                    public void onAdLoaded(Ad ad) {
                        interstitialAd.show();
                    }

                    @Override
                    public void onAdClicked(Ad ad) {

                    }

                    @Override
                    public void onLoggingImpression(Ad ad) {

                    }
                })
                .withCacheFlags(ALL)
                .build());
    }

    private String azanSoundUriString(String nextAzanKey) {
        return getApplicationInfo().dataDir + "/app_flutter/azan_" + getMuazenName(nextAzanKey) + ".mp3";
    }

    private String beforeAzanSoundUriString(String key) {
        String uri;
        if (key.equalsIgnoreCase("1") && new Prefs(this).getAllowAlfajrIbtehal()) {
            uri = getApplicationInfo().dataDir + "/app_flutter/korsi_ayat.mp3";
            //uri = getApplicationInfo().dataDir + "/app_flutter/fajr_ebtehal.mp3";

        } else {
            uri = getApplicationInfo().dataDir + "/app_flutter/before_" + key + ".mp3";
        }

        return uri;
    }

    private void playBeforeAzanSound(String key) {
        if (key.equalsIgnoreCase("1") && new Prefs(this).getAllowAlfajrIbtehal()) {
            mMediaPlayer = MediaPlayer.create(this,
                    Uri.fromFile(new File(getApplicationInfo().dataDir + "/app_flutter/korsi_ayat.mp3")));
            //Uri.fromFile(new File(getApplicationInfo().dataDir + "/app_flutter/fajr_ebtehal.mp3")));
            mMediaPlayer.start();
            final int[] count = {1};
            int maxCount = 3;
            mMediaPlayer.setOnCompletionListener(mediaPlayer -> {
                if (count[0] < maxCount) {
                    count[0]++;
                    mediaPlayer.seekTo(0);
                    mediaPlayer.start();
                } else {
                    onDestroy();
                }

            });

        } else {
            stopForeground(true);
            mMediaPlayer = MediaPlayer.create(this,
                    Uri.fromFile(
                            new File(getApplicationInfo().dataDir + "/app_flutter/before_" + key + ".mp3")));
            mMediaPlayer.start();
            mMediaPlayer.setOnCompletionListener(mediaPlayer -> {
                onDestroy();
            });
        }

    }

    private void checkAzanSlider(String key, boolean Switch_Silent_Mode_After_Residence) {
        if (VERSION.SDK_INT >= VERSION_CODES.M) {
            if (Settings.canDrawOverlays(this)) {
                showAzanSlider(key, Switch_Silent_Mode_After_Residence);
            }
        } else {
            showAzanSlider(key, Switch_Silent_Mode_After_Residence);
        }
    }

    private String getFajrMuazenName() {
        SharedPreferences prefs = getSharedPreferences(Constants.FLUTTER_SHARED_PREFERENCES,
                MODE_PRIVATE);
        String moazanNameId = prefs.getString(Constants.SELECTED_FAJR_SHEIKH_JSON, null);
        // var filename = "azan_sound${sound.id}.mp3"; //in dart
        if (moazanNameId != null) {
            Log.d("MBOOK", moazanNameId);
            return "sound" + moazanNameId;
        }
        return "mshary_fajr";
    }

    private String getMuazenName(String key) {
        SharedPreferences prefs = getSharedPreferences(Constants.FLUTTER_SHARED_PREFERENCES,
                MODE_PRIVATE);
        String moazanNameId = prefs.getString(Constants.SELECTED_SHEIKH_NAME_JSON + key, null);
        //name = azan_sound_$id
        if (moazanNameId != null) {
            Log.d("MBOOK", moazanNameId);
            return "sound" + moazanNameId;
        }
        return prefs.getString(Constants.MUAZEN_KEY + key, "1");
    }

    private void showAzanSlider(String key, boolean Switch_Silent_Mode_After_Residence) {
        mWindowManager = (WindowManager) getSystemService(WINDOW_SERVICE);
        LayoutInflater inflater = (LayoutInflater) getSystemService(LAYOUT_INFLATER_SERVICE);
        mView = inflater.inflate(R.layout.azan_slider_view, null);
        mSlider = mView.findViewById(R.id.azan_slider);
        mAzanName = mView.findViewById(R.id.azan_name);
        Button azanDone = mView.findViewById(R.id.bt_azan_done);

        String contentTitle = getString(
                getResources().getIdentifier("before_azan_" + key, "string", getPackageName()));
        mAzanName.setText(contentTitle);
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
            mMediaPlayer.stop();
            if (Switch_Silent_Mode_After_Residence) {
                setSilentMode(false);
            }
            //here
            // onDestroy();
        });

    }

    private LayoutParams layoutParams() {
        WindowManager.LayoutParams lp = new WindowManager.LayoutParams(
                WindowManager.LayoutParams.MATCH_PARENT,
                WindowManager.LayoutParams.MATCH_PARENT,
                android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O ?
                        WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
                        : WindowManager.LayoutParams.TYPE_PHONE,
                WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
                PixelFormat.TRANSLUCENT);
        lp.screenOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT;
        return lp;
    }

    private void showNotification(String nextAzanKey) {
        notificationManager = (NotificationManager) getSystemService(
                NOTIFICATION_SERVICE);

        checkNotificationAndDelete();
        setNotificationChannel();
        setNotificationBuilder(nextAzanKey);

        Notification notification = builder.build();
        NotificationManagerCompat notificationManagerCompat = NotificationManagerCompat.from(this);
        notificationManagerCompat.notify(beforeAzan && !(nextAzanKey.equalsIgnoreCase("1")
                && new Prefs(this).getAllowAlfajrIbtehal()) ? AZAN_NOTIFICATION_ID + 1
                : AZAN_NOTIFICATION_ID, notification);
    }

    private boolean getIsDaysMoreThanSeven(long time) {
        Calendar cal = Calendar.getInstance(Locale.ENGLISH);
        cal.setTimeInMillis(time);
        int result = Days.daysBetween(new LocalDate(cal.getTime()), new LocalDate(Calendar.getInstance().getTime())).getDays();
        return result >= 7;
    }

    private void checkNotificationAndDelete() {
        try {
            notificationManager.cancel(Constants.AZAN_NOTIFICATION_ID + 1);
        } catch (Exception e) {

        }
    }

    private void setNotificationBuilder(String nextAzanKey) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("hh:mm a", Locale.ENGLISH);
        String currentDateFormated = dateFormat.format(Calendar.getInstance().getTime());
        String contentText = getResources().getString(R.string.azan_is_now);
        String contentTitle = getString(
                getResources().getIdentifier("before_azan_" + nextAzanKey, "string", getPackageName()));
        if (mAzanName != null)
            mAzanName.setText(contentTitle);
        builder = new NotificationCompat.Builder(this, AZAN_NOTIFICATION_CHANNEL_ID);
        if (beforeAzan) {
            builder.setOngoing(false);
            builder.setSound(Uri.parse(beforeAzanSoundUriString(nextAzanKey)));
            contentText = getString(R.string.azan_is_too_near);
            contentTitle = getString(
                    getResources().getIdentifier("before_azan_" + nextAzanKey, "string", getPackageName()));
        } else {
            builder.setSound(Uri.parse(azanSoundUriString(nextAzanKey)));
            builder.setOngoing(true);
        }
        builder.setContentTitle(contentTitle);
        builder.setContentText(contentText);
        builder.setSmallIcon(R.mipmap.launcher_icon);
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
        switch (nextAzanKey) {
            case "1":
                drawableId = R.drawable.azan_icon1;
                break;
            case "2":
                drawableId = R.drawable.azan_icon2;
                break;
            case "3":
                drawableId = R.drawable.azan_icon3;
                break;
            case "4":
                drawableId = R.drawable.azan_icon4;
                break;
            case "5":
                drawableId = R.drawable.azan_icon5;
                break;
        }
        expandedView.setImageViewResource(R.id.azan_icon, drawableId);

        builder.setCustomContentView(collapsedView);
        builder.setCustomBigContentView(expandedView);
        Intent intent = new Intent(this, AzanReceiver.class);
        intent.putExtra(Constants.CLOSE_AZAN, true);
//        intent.putExtra(Constants.BEFORE_AZAN , beforeAzan);
        PendingIntent pendingIntent = PendingIntent.getBroadcast(this,
                AZAN_NOTIFICATION_ID, intent, 0);
        builder.setContentIntent(pendingIntent);
        builder.setDeleteIntent(pendingIntent);
    }

    private void setNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            NotificationChannel notificationChannel = new NotificationChannel(
                    AZAN_NOTIFICATION_CHANNEL_ID, AZAN_CHANNEL_NAME,
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


    @Override
    public void onDestroy() {
        stopAzan();
        super.onDestroy();
    }

    private void stopAzan() {
        if (!beforeAzan) {
            stopForeground(true);
        }

        if (mWindowManager != null && mView.getWindowToken() != null) {
            mWindowManager.removeView(mView);
            if (!mBeforeCompetition)
                showAd();
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
        if (!beforeAzan) {
            new AzanUtils(this);
        }
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

}
