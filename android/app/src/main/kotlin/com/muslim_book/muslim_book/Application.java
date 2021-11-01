package com.muslim_book.muslim_book;

import android.content.Context;
import android.content.pm.PackageManager.NameNotFoundException;
import android.text.format.DateFormat;
import android.util.Log;
import androidx.multidex.MultiDex;

//import com.facebook.FacebookSdk;
import com.facebook.ads.AudienceNetworkAds;
//import com.facebook.appevents.AppEventsConstants;
//import com.facebook.appevents.AppEventsLogger;
import com.google.android.gms.tasks.OnSuccessListener;
import com.google.firebase.FirebaseApp;
import com.google.firebase.iid.FirebaseInstanceId;
import com.google.firebase.iid.InstanceIdResult;
import com.google.firebase.remoteconfig.FirebaseRemoteConfig;
import com.google.firebase.remoteconfig.FirebaseRemoteConfigSettings;

//import dev.fluttercommunity.plus.androidalarmmanager.AlarmService;
//import dev.fluttercommunity.plus.androidalarmmanager.AndroidAlarmManagerPlugin;
import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugins.firebasemessaging.FlutterFirebaseMessagingService;

import java.util.Calendar;
import java.util.Locale;
import net.danlew.android.joda.JodaTimeAndroid;
import org.joda.time.Days;
import org.joda.time.LocalDate;
import io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin;
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin;

public class Application extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback {

  FirebaseRemoteConfig mFirebaseRemoteConfig;

  @Override
  protected void attachBaseContext(Context base) {
    super.attachBaseContext(base);
    MultiDex.install(this);
  }

  @Override
  public void onCreate() {
    super.onCreate();
    FirebaseApp.initializeApp(this);
    AudienceNetworkAds.initialize(this);
    mFirebaseRemoteConfig = FirebaseRemoteConfig.getInstance();
    mFirebaseRemoteConfig.setConfigSettingsAsync(new FirebaseRemoteConfigSettings.Builder()
        .build());
    //AppEventsLogger.activateApp(this);
    //AppEventsLogger logger = AppEventsLogger.newLogger(this);
    //logger.logEvent(AppEventsConstants.EVENT_NAME_ACTIVATED_APP);
    JodaTimeAndroid.init(this);
    FlutterFirebaseMessagingService.setPluginRegistrant(this);
   }
  @Override
  public void registerWith(PluginRegistry registry) {
    FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
    FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
  }


}

