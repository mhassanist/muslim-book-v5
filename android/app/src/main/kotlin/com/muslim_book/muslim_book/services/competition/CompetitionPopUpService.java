package com.muslim_book.muslim_book.services.competition;

import static android.content.Context.LAYOUT_INFLATER_SERVICE;
import static android.content.Context.NOTIFICATION_SERVICE;
import static android.content.Context.WINDOW_SERVICE;
import static android.content.Intent.FLAG_ACTIVITY_NEW_TASK;
import static com.facebook.ads.CacheFlag.ALL;
import static com.muslim_book.muslim_book.classes.Constants.AZAN_CHANNEL_NAME;
import static com.muslim_book.muslim_book.classes.Constants.AZAN_NOTIFICATION_CHANNEL_ID;
import static com.muslim_book.muslim_book.classes.Constants.AZAN_NOTIFICATION_ID;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.graphics.Color;
import android.graphics.PixelFormat;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.Handler;
import android.os.Looper;
import android.provider.Settings;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.RemoteViews;

import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import com.facebook.ads.Ad;
import com.facebook.ads.AdError;
import com.facebook.ads.InterstitialAd;
import com.facebook.ads.InterstitialAdListener;
import com.google.firebase.remoteconfig.FirebaseRemoteConfig;
import com.google.firebase.remoteconfig.FirebaseRemoteConfigSettings;
import com.muslim_book.muslim_book.MainActivity;
import com.muslim_book.muslim_book.R;
import com.muslim_book.muslim_book.classes.Constants;

import at.markushi.ui.CircleButton;

public class CompetitionPopUpService {

  private InterstitialAd interstitialAd;
  private WindowManager mWindowManager;
  private View mView;
  private Context context;
  FirebaseRemoteConfig mFirebaseRemoteConfig = FirebaseRemoteConfig.getInstance();
  NotificationManager notificationManager;
  NotificationCompat.Builder builder;
//  private MediaPlayer mp;
  public CompetitionPopUpService(Context context) {
    mFirebaseRemoteConfig.setConfigSettingsAsync(new FirebaseRemoteConfigSettings.Builder()
        .build());
    this.context = context;
//    mp = MediaPlayer.create(context, R.raw.new_questions);
//    mp.start();
    if (canDrawOverLays()) {
      new Handler(Looper.getMainLooper()).post(this::drawView);
    } else
      showNotification();
  }

  private void showNotification() {
    notificationManager = (NotificationManager) context.getSystemService(
        NOTIFICATION_SERVICE);
      setNotificationChannel();
    setNotificationBuilder();
    Notification notification = builder.build();
    NotificationManagerCompat notificationManagerCompat = NotificationManagerCompat.from(context);
    notificationManagerCompat.notify( AZAN_NOTIFICATION_ID +  100 +  100, notification);
  }

  private void setNotificationBuilder() {
    String contentText = "من الممكن أن يكون لديك أسئلة جديدة";
    String contentTitle = "مسلم بوك";
    builder = new NotificationCompat.Builder(context, AZAN_NOTIFICATION_CHANNEL_ID);
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

    RemoteViews collapsedView = new RemoteViews(context.getPackageName(),
        R.layout.custom_notification_layout_collapsed);
    collapsedView
        .setTextViewText(R.id.app_name_notification_time, "مسلم بوك");
    collapsedView.setTextViewText(R.id.azan_notification_type_text, contentText);
    collapsedView.setTextViewText(R.id.azan_name, "");

    RemoteViews expandedView = new RemoteViews(context.getPackageName(),
        R.layout.custom_notification_layout);
    expandedView
        .setTextViewText(R.id.app_name_notification_time, "مسلم بوك . ");
    expandedView.setTextViewText(R.id.azan_notification_type_text, contentText);

    expandedView.setTextViewText(R.id.azan_name, "");

    builder.setCustomContentView(collapsedView);
    builder.setCustomBigContentView(expandedView);
    Intent intent = new Intent(context, MainActivity.class);
    intent.addFlags(FLAG_ACTIVITY_NEW_TASK);
    PendingIntent pendingIntent = PendingIntent.getActivity(context, AZAN_NOTIFICATION_ID +  100 +  100, intent, 0);
    builder.setContentIntent(pendingIntent);
    builder.setDeleteIntent(pendingIntent);
  }

  private void setNotificationChannel() {
    if (VERSION.SDK_INT >= VERSION_CODES.O) {
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

  private boolean canDrawOverLays() {
    if (VERSION.SDK_INT >= VERSION_CODES.M) {
      return Settings.canDrawOverlays(context);
    }
    return true;
  }

  void drawView() {
    mWindowManager = (WindowManager) context.getSystemService(WINDOW_SERVICE);
    LayoutInflater inflater = (LayoutInflater) context
        .getSystemService(LAYOUT_INFLATER_SERVICE);
    mView = inflater.inflate(R.layout.competition_pop_up, null);
    Button enter = mView.findViewById(R.id.bt_competition_pop_up_enter);
    CircleButton exit = mView.findViewById(R.id.bt_competition_pop_up_exit);
////    AdView adView = new AdView(context,
////        mFirebaseRemoteConfig.getString("competition_pop_up_native_android"),
////        AdSize.BANNER_HEIGHT_90);
//    LinearLayout adContainer = mView.findViewById(R.id.banner_container);
////    adContainer.addView(adView);
////    adView.loadAd();

    mWindowManager.addView(mView, layoutParams());
    exit.setOnClickListener(v -> {
      if (mWindowManager != null && mView.getWindowToken() != null) {
        mWindowManager.removeView(mView);
      }
      interstitialAd = new InterstitialAd(context,
          mFirebaseRemoteConfig.getString("after_azan_pop_up"));
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

    });

    enter.setOnClickListener(v -> {
      Intent intent = new Intent(context, MainActivity.class);
      intent.putExtra(Constants.DATA_PASSED_COMPETITION, "CompetitionService");
      intent.addFlags(FLAG_ACTIVITY_NEW_TASK);
      context.startActivity(intent);
      if (mWindowManager != null && mView.getWindowToken() != null) {
        mWindowManager.removeView(mView);
      }
    });
  }

  private LayoutParams layoutParams() {
    WindowManager.LayoutParams lp = new WindowManager.LayoutParams(
        WindowManager.LayoutParams.MATCH_PARENT,
        WindowManager.LayoutParams.MATCH_PARENT,
        VERSION.SDK_INT >= VERSION_CODES.O ?
            WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY
            : WindowManager.LayoutParams.TYPE_PHONE,
        WindowManager.LayoutParams.FLAG_NOT_FOCUSABLE,
        PixelFormat.TRANSLUCENT);
    lp.screenOrientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT;
    return lp;

  }
}
