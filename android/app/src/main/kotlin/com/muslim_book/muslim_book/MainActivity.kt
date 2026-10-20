package com.muslim_book.muslim_book

import android.content.Intent
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.provider.Settings
import com.muslim_book.muslim_book.classes.AzanUtils
import com.muslim_book.muslim_book.classes.ChannelMethods
import com.muslim_book.muslim_book.classes.Constants
import com.muslim_book.muslim_book.receivers.azkar.AzkarAlarm
import com.muslim_book.muslim_book.receivers.competition.CompetitionsAlarmReceiver
import com.ryanheise.audioservice.AudioServiceActivity
import dev.fluttercommunity.plus.androidalarmmanager.AndroidAlarmManagerPlugin
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.firebase.core.FlutterFirebaseCorePlugin
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException


class MainActivity: AudioServiceActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        printHashKey()
//        startFires()
    }

    private fun checkDrawOverLays() {
        Settings.canDrawOverlays(this)
    }

    private fun startFires() {
        // Azan
        if (intent == null ||
            intent.getBooleanExtra(Constants.DONT_SHOW_BEFORE_AZAN, false)) {
            AzanUtils(this)
        }

        // fireCompetitionPopUp
        this.sendBroadcast(Intent(this, CompetitionsAlarmReceiver::class.java))
        val list: MutableList<String?> = ArrayList()
        list.add("true")
        list.add(intent.getStringExtra(Constants.DATA_PASSED_COMPETITION))

        // fireAzkarPopUp
        this.sendBroadcast(Intent(this, AzkarAlarm::class.java))

        // Open_Competition
        intent.getStringExtra(Constants.DATA_PASSED_COMPETITION)

        // open_Azkar
        intent.getStringExtra(Constants.DATA_PASSED_AZKAR)

        // checkOverlay
        checkDrawOverLays()
    }

//    override fun onNewIntent(intent: Intent) {
//        super.onNewIntent(intent)
//        ChannelMethods(flutterEngine?.dartExecutor, applicationContext, this, intent)
//    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
//        flutterEngine.plugins.add(GoogleMobileAdsPlugin())
//    flutterEngine.plugins.add(GoogleMobileAdsPlugin())
//    flutterEngine.plugins.add(AndroidAlarmManagerPlugin())
//    flutterEngine.plugins.add(FlutterFirebaseCorePlugin())
        super.configureFlutterEngine(flutterEngine)
        ChannelMethods(flutterEngine.dartExecutor, applicationContext, this, intent)
    }

    private fun PackageManager.getPackageInfoCompat(packageName: String, flags: Int = 0): PackageInfo =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            getPackageInfo(packageName, PackageManager.PackageInfoFlags.of(flags.toLong()))
        } else {
            @Suppress("DEPRECATION")
            getPackageInfo(packageName, flags)
        }

    //  for hash key
    private fun printHashKey() {
        try {
            val info = packageManager.getPackageInfoCompat(packageName)

//            val info: PackageInfo = pContext.getPackageManager()
//                .getPackageInfo(pContext.getPackageName(), PackageManager.GET_SIGNATURES)

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                val signingInfo = info.signingInfo
                if (signingInfo != null) {
                    for (signature in signingInfo.signingCertificateHistory) {
                        val md = MessageDigest.getInstance("SHA")
                        md.update(signature.toByteArray())
//                        val hashKey = Base64.encodeToString(md.digest(), 0)
//                        Log.i("shima aaa kk kkk aa aa", "here ");
//                        Log.i(
//                            "MainActivity", "import android.content.Context\n" +
//                                    "\n() Hash Key: $hashKey"
//                        )
                    }
                }
            } else {
                @Suppress("DEPRECATION")
                val signatures = info.signatures
                if (signatures != null) {
                    for (signature in signatures) {
                        val md = MessageDigest.getInstance("SHA")
                        md.update(signature.toByteArray())
//                        val hashKey = Base64.encodeToString(md.digest(), 0)
//                        Log.i("shima aaa kk kkk aa aa", "here ");
//                        Log.i(
//                            "MainActivity", "import android.content.Context\n" +
//                                    "\n() Hash Key: $hashKey"
//                        )
                    }
                }
            }
        } catch (e: NoSuchAlgorithmException) {
//            Log.e("MainActivity", "printHashKey()", e)
        } catch (e: Exception) {
//            Log.e("MainActivity", "printHashKey()", e)
        }
    }
}
