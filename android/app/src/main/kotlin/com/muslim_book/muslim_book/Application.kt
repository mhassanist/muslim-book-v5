package com.muslim_book.muslim_book

//import com.facebook.ads.AudienceNetworkAds
import androidx.multidex.MultiDex
import androidx.startup.AppInitializer
import com.google.android.gms.ads.MobileAds
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
//        AudienceNetworkAds.initialize(this)
        // Initialize the Google Mobile Ads SDK on a background thread.
        Thread { MobileAds.initialize(this) { } }.start()

        mFirebaseRemoteConfig = FirebaseRemoteConfig.getInstance()
        mFirebaseRemoteConfig!!.setConfigSettingsAsync(
            FirebaseRemoteConfigSettings.Builder()
                .build()
        )
        AppInitializer.getInstance(this).initializeComponent(JodaTimeInitializer::class.java)
    }
}