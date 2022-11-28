package com.muslim_book.muslim_book;

import android.content.Context;

import androidx.annotation.NonNull;
import androidx.multidex.MultiDex;

import com.facebook.ads.AudienceNetworkAds;
import com.google.firebase.FirebaseApp;
import com.google.firebase.remoteconfig.FirebaseRemoteConfig;
import com.google.firebase.remoteconfig.FirebaseRemoteConfigSettings;

import net.danlew.android.joda.JodaTimeAndroid;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.PluginRegistrantCallback;

public class Application extends FlutterApplication implements PluginRegistrantCallback {
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
        mFirebaseRemoteConfig.setConfigSettingsAsync(
                new FirebaseRemoteConfigSettings.Builder()
                .build());
        //AppEventsLogger.activateApp(this);
        //AppEventsLogger logger = AppEventsLogger.newLogger(this);
        //logger.logEvent(AppEventsConstants.EVENT_NAME_ACTIVATED_APP);
        JodaTimeAndroid.init(this);
//        FlutterFirebaseMessagingService.setPluginRegistrant(this);
    }

    @Override
    public void registerWith(@NonNull PluginRegistry registry) {
//        FirebaseMessagingPlugin.registerWith(registry.registrarFor("io.flutter.plugins.firebasemessaging.FirebaseMessagingPlugin"));
//        FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
    }
}
