package com.muslim_book.muslim_book




 import android.content.Intent

import android.os.Bundle

import com.muslim_book.muslim_book.classes.ChannelMethods
 import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin






class MainActivity: FlutterActivity() {

   override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
   }

  override fun onNewIntent(intent: Intent) {
    super.onNewIntent(intent)
    ChannelMethods(flutterEngine?.dartExecutor, applicationContext, this, intent)

  }


  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
      flutterEngine.plugins.add(GoogleMobileAdsPlugin())

//    flutterEngine.plugins.add(GoogleMobileAdsPlugin())
//    flutterEngine.plugins.add(AndroidAlarmManagerPlugin())
//    flutterEngine.plugins.add(FlutterFirebaseCorePlugin())
    super.configureFlutterEngine(flutterEngine)
    ChannelMethods(flutterEngine.dartExecutor, applicationContext, this, intent)

  }






}

//  for hash key

//  fun printHashKey(pContext: Context) {
//    try {
//      val info: PackageInfo = pContext.getPackageManager().getPackageInfo(pContext.getPackageName(), PackageManager.GET_SIGNATURES)
//      for (signature in info.signatures) {
//        val md = MessageDigest.getInstance("SHA")
//        md.update(signature.toByteArray())
//        val hashKey = String(Base64.encode(md.digest(), 0))
//        Log.i("shimaaaakkkkkaaaa", "here ");
//        Log.i("MainActivity", "import android.content.Context\n" +
//                "\n() Hash Key: $hashKey")
//      }
//    } catch (e: NoSuchAlgorithmException) {
//      Log.e("MainActivity", "printHashKey()", e)
//    } catch (e: Exception) {
//      Log.e("MainActivity", "printHashKey()", e)
//    }
//  }
