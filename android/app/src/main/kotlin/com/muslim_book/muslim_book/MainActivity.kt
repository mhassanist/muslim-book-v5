package com.muslim_book.muslim_book

import android.content.Context
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import android.util.Base64
import android.util.Log
import androidx.annotation.RequiresApi
import com.muslim_book.muslim_book.classes.ChannelMethods
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException

class MainActivity: FlutterActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        printHashKey(applicationContext);
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

    fun PackageManager.getPackageInfoCompat(packageName: String, flags: Int = 0): PackageInfo =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            getPackageInfo(packageName, PackageManager.PackageInfoFlags.of(flags.toLong()))
        } else {
            @Suppress("DEPRECATION")
            getPackageInfo(packageName, flags)
        }

    //  for hash key
    fun printHashKey(pContext: Context) {
        try {
            val info = packageManager.getPackageInfoCompat(packageName)

//            val info: PackageInfo = pContext.getPackageManager()
//                .getPackageInfo(pContext.getPackageName(), PackageManager.GET_SIGNATURES)

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                if (info.signingInfo != null) {
                    for (signature in info.signingInfo.signingCertificateHistory) {
                        val md = MessageDigest.getInstance("SHA")
                        md.update(signature.toByteArray())
                        val hashKey = Base64.encodeToString(md.digest(), 0)
                        Log.i("shimaaaakkkkkaaaa", "here ");
                        Log.i(
                            "MainActivity", "import android.content.Context\n" +
                                    "\n() Hash Key: $hashKey"
                        )
                    }
                }
            } else {
                @Suppress("DEPRECATION")
                if (info.signatures != null) {
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
                }
            }
        } catch (e: NoSuchAlgorithmException) {
            Log.e("MainActivity", "printHashKey()", e)
        } catch (e: Exception) {
            Log.e("MainActivity", "printHashKey()", e)
        }
    }
}
