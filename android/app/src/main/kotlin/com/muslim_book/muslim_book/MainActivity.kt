package com.muslim_book.muslim_book

//import android.provider.Settings;


import android.content.Context
import android.content.Intent
import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.CountDownTimer
import android.provider.Settings
import android.util.Base64
import android.util.Log
import android.view.View
import android.widget.Toast
import androidx.core.content.ContextCompat
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.PeriodicWorkRequest
import androidx.work.WorkManager
import com.muslim_book.muslim_book.classes.ChannelMethods
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException
import java.util.*
import java.util.concurrent.TimeUnit;


var ACTION_MANAGE_OVERLAY_PERMISSION_REQUEST_CODE = 2323


class MainActivity: FlutterActivity() {
  private val TAG = "MainActivity"
  val COUNTDOWN_BR = "your_package_name.countdown_br"
  var bi = Intent(COUNTDOWN_BR)

  var cdt: CountDownTimer? = null
  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    printHashKey(this@MainActivity)
    startServiceViaWorker();

  }
  fun printHashKey(pContext: Context) {
    try {
      val info: PackageInfo = pContext.getPackageManager().getPackageInfo(pContext.getPackageName(), PackageManager.GET_SIGNATURES)
      for (signature in info.signatures) {
        val md = MessageDigest.getInstance("SHA")
        md.update(signature.toByteArray())
        val hashKey = String(Base64.encode(md.digest(), 0))
        Log.i("shimaaaakkkkkaaaa", "here ");
        Log.i("MainActivity", "import android.content.Context\n" +
                "\n() Hash Key: $hashKey")
      }
    } catch (e: NoSuchAlgorithmException) {
      Log.e("MainActivity", "printHashKey()", e)
    } catch (e: Exception) {
      Log.e("MainActivity", "printHashKey()", e)
    }
  }
  override fun onNewIntent(intent: Intent) {
    super.onNewIntent(intent)
    ChannelMethods(flutterEngine?.dartExecutor, applicationContext, this, intent)



  }
//
//  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
//    if (requestCode == ACTION_MANAGE_OVERLAY_PERMISSION_REQUEST_CODE) {
//      if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M && BuildConfig.DEBUG) {
//        if (Settings.canDrawOverlays(this)) {
//          Toast.makeText(context, "Arrived to  shimaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa", Toast.LENGTH_SHORT).show();
//        }
//        // permission granted...
//      } else {
//        // permission not granted...
//      }
//    }
//  }

  override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
    // Don't check for resultCode == Activity.RESULT_OK because the overlay activity
    // is closed with the back button and so the RESULT_CANCELLED is always received.
    if (requestCode == ACTION_MANAGE_OVERLAY_PERMISSION_REQUEST_CODE) {
      if (drawOverOtherAppsEnabled()) {
        // The permission has been granted.
        // Resend the last command - we have only one, so no additional logic needed.
//        startFloatingService(INTENT_COMMAND_NOTE)
//        finish()
      }
    } else {
      super.onActivityResult(requestCode, resultCode, data)
    }
  }
  fun Context.drawOverOtherAppsEnabled(): Boolean {
    return if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
      true
    } else {
      Settings.canDrawOverlays(this)
    }
  }

  override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)
    ChannelMethods(flutterEngine.dartExecutor, applicationContext, this, intent)

  }

  override fun onPause() {
    super.onPause()

  }
  override fun onResume() {
    super.onResume()
    // It will show a message on the screen
    // then onResume is invoked

    }



  override fun onDestroy() {
    Log.d(TAG, "onDestroy called")
     super.onDestroy()
  }

  fun startService() {
    Log.d(TAG, "startService called")
    if (!MyService.isServiceRunning) {
      val serviceIntent = Intent(this, MyService::class.java)
      ContextCompat.startForegroundService(this, serviceIntent)
    }
  }


  fun startServiceViaWorker() {
    Log.d(TAG, "startServiceViaWorker called")
    val UNIQUE_WORK_NAME = "StartMyServiceViaWorker"
    val workManager = WorkManager.getInstance(this)

    // As per Documentation: The minimum repeat interval that can be defined is 15 minutes
    // (same as the JobScheduler API), but in practice 15 doesn't work. Using 16 here
    val request = PeriodicWorkRequest.Builder(
      MyWorker::class.java,
      16,
      TimeUnit.MINUTES
    )
      .build()

    // to schedule a unique work, no matter how many times app is opened i.e. startServiceViaWorker gets called
    // do check for AutoStart permission
    workManager.enqueueUniquePeriodicWork(
      UNIQUE_WORK_NAME,
      ExistingPeriodicWorkPolicy.KEEP,
      request
    )
  }

}
