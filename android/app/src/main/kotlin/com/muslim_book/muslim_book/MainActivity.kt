package com.muslim_book.muslim_book

import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Base64
import android.util.Log
import com.muslim_book.muslim_book.classes.ChannelMethods
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

// For AudioServicePlugin setup
import com.ryanheise.audioservice.AudioServicePlugin;

class MainActivity : FlutterActivity() {

    // For AudioServicePlugin setup
    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        return AudioServicePlugin.getFlutterEngine(context)
    }

    override fun getCachedEngineId(): String {
        AudioServicePlugin.getFlutterEngine(this);
        return AudioServicePlugin.getFlutterEngineId();
    }

    override fun shouldDestroyEngineWithHost(): Boolean {
        return false;
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        printHashKey(applicationContext);
    }
    

//    override fun onNewIntent(intent: Intent) {
//        super.onNewIntent(intent)
//        ChannelMethods(flutterEngine?.dartExecutor, applicationContext, this, intent)
//    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // flutterEngine.plugins.add(GoogleMobileAdsPlugin())
        // flutterEngine.plugins.add(GoogleMobileAdsPlugin())
        // flutterEngine.plugins.add(AndroidAlarmManagerPlugin())
        // flutterEngine.plugins.add(FlutterFirebaseCorePlugin())
        super.configureFlutterEngine(flutterEngine)
        ChannelMethods(flutterEngine.dartExecutor, applicationContext, this, intent)

        // Register the ListTileNativeAdFactory
        GoogleMobileAdsPlugin.registerNativeAdFactory(
                flutterEngine, "listTile", ListTileNativeAdFactory(context))
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
        // Unregister the ListTileNativeAdFactory
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "listTile");
    }

    //  for hash key
    fun printHashKey(pContext: Context) {
        try {
            val info: PackageInfo = pContext.getPackageManager()
                .getPackageInfo(pContext.getPackageName(), PackageManager.GET_SIGNATURES)
            for (signature in info.signatures) {
                val md = MessageDigest.getInstance("SHA")
                md.update(signature.toByteArray())
                val hashKey = Base64.encodeToString(md.digest(), 0)
                Log.i("shimaaaakkkkkaaaa", "here ");
                Log.i(
                    "MainActivity", "import android.content.Context\n" +
                            "\n() Hash Key: $hashKey"
                )
            }
        } catch (e: NoSuchAlgorithmException) {
            Log.e("MainActivity", "printHashKey()", e)
        } catch (e: Exception) {
            Log.e("MainActivity", "printHashKey()", e)
        }
    }
}
