package com.muslim_book.muslim_book

import androidx.multidex.MultiDex
import androidx.startup.AppInitializer
import com.facebook.ads.AudienceNetworkAds
import com.google.firebase.FirebaseApp
import com.google.firebase.remoteconfig.FirebaseRemoteConfig
import com.google.firebase.remoteconfig.FirebaseRemoteConfigSettings
import io.flutter.app.FlutterApplication
import net.danlew.android.joda.JodaTimeInitializer

class Application: FlutterApplication() {
    private var mFirebaseRemoteConfig: FirebaseRemoteConfig? = null
    override fun onCreate() {
        super.onCreate()
        MultiDex.install(this)

        FirebaseApp.initializeApp(this)
        AudienceNetworkAds.initialize(this)
        mFirebaseRemoteConfig = FirebaseRemoteConfig.getInstance()
        mFirebaseRemoteConfig!!.setConfigSettingsAsync(
            FirebaseRemoteConfigSettings.Builder()
                .build()
        )
        AppInitializer.getInstance(this).initializeComponent(JodaTimeInitializer::class.java)
    }
}