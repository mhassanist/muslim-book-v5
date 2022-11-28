package com.muslim_book.muslim_book.services.azkar;

import static android.content.Context.LAYOUT_INFLATER_SERVICE;
import static android.content.Context.WINDOW_SERVICE;
import static android.content.Intent.FLAG_ACTIVITY_NEW_TASK;
import static com.facebook.ads.CacheFlag.ALL;

import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.graphics.PixelFormat;
import android.media.MediaPlayer;
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
import android.widget.TextView;

import com.facebook.ads.Ad;
import com.facebook.ads.AdError;
import com.facebook.ads.InterstitialAd;
import com.facebook.ads.InterstitialAdListener;
import com.google.firebase.remoteconfig.FirebaseRemoteConfig;
import com.google.firebase.remoteconfig.FirebaseRemoteConfigSettings;
import com.muslim_book.muslim_book.MainActivity;
import com.muslim_book.muslim_book.R;
import com.muslim_book.muslim_book.classes.Constants;

import java.util.Calendar;

import at.markushi.ui.CircleButton;

public class AzkarPopUpService {

  private InterstitialAd interstitialAd;
  private WindowManager mWindowManager;
  private View mView;
  private Context context;
  MediaPlayer mMediaPlayer;

  FirebaseRemoteConfig mFirebaseRemoteConfig = FirebaseRemoteConfig.getInstance();
  public AzkarPopUpService(Context context) {
    mFirebaseRemoteConfig.setConfigSettingsAsync(new FirebaseRemoteConfigSettings.Builder()
        .build());
    this.context = context;
    if (canDrawOverLays()) {

      new Handler(Looper.getMainLooper()).post(this::drawView);
    }
  }


  private boolean canDrawOverLays() {
    if (VERSION.SDK_INT >= VERSION_CODES.M) {
      return Settings.canDrawOverlays(context);
    }
    return true;
  }

  void drawView() {
    mMediaPlayer = MediaPlayer.create(context,
            R.raw.azkar);
    try{
      mMediaPlayer.prepare();
    }catch(Exception e){

    }

    mMediaPlayer.start();
    mMediaPlayer.setOnCompletionListener(mp -> {
      closeService();
    });
    mWindowManager = (WindowManager) context.getSystemService(WINDOW_SERVICE);
    LayoutInflater inflater = (LayoutInflater) context
        .getSystemService(LAYOUT_INFLATER_SERVICE);
    mView = inflater.inflate(R.layout.azkar_pop_up, null);
    Button enter = mView.findViewById(R.id.bt_azkar_enter);
    CircleButton exit = mView.findViewById(R.id.bt_azkar_exit);
    setAzkarName();


    mWindowManager.addView(mView, layoutParams());

    enter.setOnClickListener(v -> {
      closeMediaPlayer();

      Intent intent = new Intent(context, MainActivity.class);
      intent.addFlags(FLAG_ACTIVITY_NEW_TASK);
      intent.putExtra(Constants.DATA_PASSED_AZKAR, "CompetitionService");
      context.startActivity(intent);
      if (mWindowManager != null && mView.getWindowToken() != null) {
        mWindowManager.removeView(mView);
      }
    });
  }

  private void closeService() {
    closeMediaPlayer();
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
  }

  private void setAzkarName() {
    TextView title = mView.findViewById(R.id.tv_azkar_start_your_day);
    TextView content = mView.findViewById(R.id.tv_azkar_name);
    if (Calendar.getInstance().get(Calendar.HOUR_OF_DAY) >= 8 && Calendar.getInstance().get(Calendar.HOUR_OF_DAY) < 17)
    {
      title.setText("إبدأ يومك بذكر الله");
      content.setText("أذكار الصباح");
    } else {
      title.setText("إنهي يومك بذكر الله");
      content.setText("أذكار المساء");
    }
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





  void closeMediaPlayer(){
    try{
      if (mMediaPlayer != null && mMediaPlayer.isPlaying()){
        mMediaPlayer.stop();
        mMediaPlayer.reset();
        mMediaPlayer.release();
        mMediaPlayer = null;
      }
    } catch (Exception e){

    }
  }
}
