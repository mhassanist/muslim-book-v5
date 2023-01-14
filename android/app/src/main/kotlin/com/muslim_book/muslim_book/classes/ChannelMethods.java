package com.muslim_book.muslim_book.classes;

import static android.content.Context.MODE_PRIVATE;
import static android.content.Context.POWER_SERVICE;
import static android.content.Intent.FLAG_ACTIVITY_NEW_TASK;

import android.app.Activity;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.media.AudioManager;
import android.net.Uri;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import android.os.PowerManager;
import android.provider.Settings;
import android.util.Log;
import android.view.Gravity;
import android.widget.TextView;

import androidx.appcompat.app.AlertDialog;
import androidx.core.content.ContextCompat;

import com.muslim_book.muslim_book.R;
import com.muslim_book.muslim_book.classes.ramdan.RamadanCannonUtils;
import com.muslim_book.muslim_book.classes.ramdan.RamadanMshartUtils;
import com.muslim_book.muslim_book.recievers.FastingAlertsReceiver;
import com.muslim_book.muslim_book.recievers.azkar.AzkarAlarm;
import com.muslim_book.muslim_book.recievers.competition.CompetitionsAlarmReceiver;
import com.muslim_book.muslim_book.recievers.phoneState.PhoneStateBroadcastReceiver;
import com.muslim_book.muslim_book.services.azan.OverLayService;

import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

import io.flutter.embedding.engine.dart.DartExecutor;
import io.flutter.plugin.common.MethodChannel;

public class ChannelMethods {

    private static final String CHANNEL = "com.muslim_book.muslim_book/channels";
    private DartExecutor flutterEngine;
    private Context mContext;
    private Activity myMainActivity;
    private Intent intent;

    public ChannelMethods(DartExecutor flutterEngine, Context context, Activity activity, Intent intent) {
        this.flutterEngine = flutterEngine;
        mContext = context;
        myMainActivity = activity;
        this.intent = intent;
        setChannelMethods();
    }

    private void setChannelMethods() {
        SharedPreferences prefs = mContext.getSharedPreferences(Constants.FLUTTER_SHARED_PREFERENCES,
                MODE_PRIVATE);
        boolean RAMADAN_CONNAN_FLAG = prefs.getBoolean(Constants.RAMADAN_CONNAN_FLAG, true);
        boolean RAMADAN_MASHRAAT_FLAG = prefs.getBoolean(Constants.RAMADAN_MASHRAAT_FLAG, true);

        new MethodChannel(flutterEngine, CHANNEL).setMethodCallHandler(
                (call, result) -> {
                    switch (call.method) {
                        case "fireCannonRamadan":
                            if (RAMADAN_CONNAN_FLAG) {
                                new RamadanCannonUtils(mContext);
                                result.success(true);
                                break;
                            } else {
                                result.success(false);
                                break;
                            }

                        case "fireMshartRamadan":
                            if (RAMADAN_MASHRAAT_FLAG) {
                                new RamadanMshartUtils(mContext);
                                result.success(true);
                                break;
                            } else {
                                result.success(false);
                                break;
                            }
                        case "readPhoneState":
                            mContext.sendBroadcast(new Intent(mContext, PhoneStateBroadcastReceiver.class));
                            result.success(true);
                            break;
                        case "askOverlay":
                            try {
                                Intent intentOverLayService = new Intent(mContext, OverLayService.class);
                                Constants.SETBOOTAZANRECIEVER(mContext);
                                ContextCompat.startForegroundService(mContext, intentOverLayService);
                                boolean value = canDrawOverLays();
                                result.success(value);
                            } catch (Exception e) {
                            }
                            break;
                        case "checkOverlay":
                            boolean overlayCheck = checkDrawOverLays();
                            result.success(overlayCheck);
                            break;
                        case "allowBatteryEditing":
                            boolean allowBattery = allowBatteryEditing();
                            System.out.println("allowBatteryEditing :: " + allowBattery);
                            result.success(allowBattery);
                            break;
                        case "checkBatteryEditing":
                            boolean checkAllowBattery = checkBatteryEditing();
                            result.success(checkAllowBattery);
                            break;
                        case "openCompetition":
                            result.success(intent.getStringExtra(Constants.DATA_PASSED_COMPETITION));
                            break;
                        case "openAzkar":
                            result.success(intent.getStringExtra(Constants.DATA_PASSED_AZKAR));
                            break;
                        case "fireCompetitionPopUp":
                            mContext.sendBroadcast(new Intent(mContext, CompetitionsAlarmReceiver.class));
                            final List<String> list = new ArrayList<>();
                            list.add("true");
                            list.add(intent.getStringExtra(Constants.DATA_PASSED_COMPETITION));

                            result.success(list);
                            break;
                        case "fireAzan":
                            if (intent != null && intent
                                    .getBooleanExtra(Constants.DONT_SHOW_BEFORE_AZAN, false)) {
                                result.success(false);
                                break;
                            } else {
                                new AzanUtils(mContext);
                                result.success(true);
                                break;
                            }
                        case "createOrDeleteFastingMondaysAndThursdaysAlert":
                            createOrDeleteWeeklyFastingAlerts();
                            result.success(true);
                            break;
                        case "checkIsXiaomi":
                            result.success(checkIsXiaomi());
                            break;
                        case "openXiaomiSettings":
                            openXiaomiSettings();
                            result.success(true);
                            break;
                        case "AllowPhoneState":
                            requestMutePermissions();
                            result.success(true);
                            break;
                        case "fireAzkarPopUp":
                            mContext.sendBroadcast(new Intent(mContext, AzkarAlarm.class));
                            result.success(true);
                            break;
                        default:
                            result.notImplemented();
                            break;
                    }
                });

    }

    private void openXiaomiSettings() {
        Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        Uri uri = Uri.fromParts("package", mContext.getPackageName(), null);
        intent.setData(uri);
        mContext.startActivity(intent);
    }

    public void Info() {
        AlertDialog.Builder builder = new AlertDialog.Builder(mContext);
        builder.setTitle("Info Aplikasi");
        builder.setIcon(R.drawable.azan_icon1);
        builder.setMessage("Jakarta Hospital");
        builder.setCancelable(false);
        builder.setPositiveButton("Exit", null);
        AlertDialog dialog = builder.show();
        TextView messageView = (TextView) dialog.findViewById(android.R.id.message);
        messageView.setGravity(Gravity.CENTER);
    }

    private boolean checkIsXiaomi() {
        try {
            Class<?> c = Class.forName("android.os.SystemProperties");
            Method get = c.getMethod("get", String.class);
            String miui = (String) get.invoke(c, "ro.miui.ui.version.name");
            return miui != null && miui.contains("11");
        } catch (Exception e) {
        }
        return false;
    }

    private void createOrDeleteWeeklyFastingAlerts() {
        Constants.SETBOOTAZANRECIEVER(mContext);
        mContext.sendBroadcast(new Intent(mContext, FastingAlertsReceiver.class));
    }

    private boolean canDrawOverLays() {


        if (VERSION.SDK_INT >= VERSION_CODES.M) {
            if (!Settings.canDrawOverlays(mContext)) {
//                Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
//                        Uri.parse("package:" + mContext.getPackageName()));
//                intent.setFlags(FLAG_ACTIVITY_NEW_TASK);
//
//                mContext.startActivity(intent);
                RequestPermission();
                return Settings.canDrawOverlays(mContext);
            }
        }
        return true;
    }


    private void RequestPermission() {
        // Check if Android M or higher
        if (VERSION.SDK_INT >= VERSION_CODES.M) {
            // Show alert dialog to the user saying a separate permission is needed
            // Launch the settings activity if the user prefers

            Intent intent = new Intent(Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                    Uri.parse("package:" + mContext.getPackageName()));
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            intent.addFlags(Intent.FLAG_ACTIVITY_NO_HISTORY);
            intent.addFlags(Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS);
            intent.addFlags(Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS);
            myMainActivity.startActivityForResult(intent, 2323);


        }
    }

    private boolean checkDrawOverLays() {
        if (VERSION.SDK_INT >= VERSION_CODES.M) {
            return Settings.canDrawOverlays(mContext);
        }
        return true;
    }

    private void requestMutePermissions() {
        requestForDoNotDisturbPermissionOrSetDoNotDisturbForApi23AndUp();
//        try {
//            if (Build.VERSION.SDK_INT < 23) {
//                AudioManager audioManager = (AudioManager)mContext.getSystemService(Context.AUDIO_SERVICE);
//                audioManager.setRingerMode(AudioManager.RINGER_MODE_SILENT);
//            } else if( Build.VERSION.SDK_INT >= 23 ) {
//                this.requestForDoNotDisturbPermissionOrSetDoNotDisturbForApi23AndUp();
//            }
//        } catch ( SecurityException e ) {
//
//        }
    }

    private void requestForDoNotDisturbPermissionOrSetDoNotDisturbForApi23AndUp() {

        NotificationManager notificationManager = (NotificationManager) mContext.getSystemService(Context.NOTIFICATION_SERVICE);
        // if user granted access else ask for permission
        if (VERSION.SDK_INT >= VERSION_CODES.M) {
            if (notificationManager.isNotificationPolicyAccessGranted()) {
                AudioManager audioManager = (AudioManager) mContext.getSystemService(Context.AUDIO_SERVICE);
                audioManager.setRingerMode(AudioManager.RINGER_MODE_SILENT);
            } else {
                // Open Setting screen to ask for permisssion
                Intent intent = new Intent(Settings.ACTION_NOTIFICATION_POLICY_ACCESS_SETTINGS);
                myMainActivity.startActivityForResult(intent, 9098);
            }
        }
    }

    private boolean allowBatteryEditing() {

        if (VERSION.SDK_INT >= VERSION_CODES.M) {
            PowerManager pm = (PowerManager) mContext.getSystemService(POWER_SERVICE);
            String packageName = mContext.getPackageName();
            if (!pm.isIgnoringBatteryOptimizations(packageName)) {
                Intent intent = new Intent();
                intent.setAction(Settings.ACTION_REQUEST_IGNORE_BATTERY_OPTIMIZATIONS);
                intent.setFlags(FLAG_ACTIVITY_NEW_TASK);
                intent.setData(Uri.parse("package:" + packageName));
                mContext.startActivity(intent);
                return false;
            }
        }
        return true;
    }

    private boolean checkBatteryEditing() {
        if (VERSION.SDK_INT >= VERSION_CODES.M) {
            PowerManager pm = (PowerManager) mContext.getSystemService(POWER_SERVICE);
            String packageName = mContext.getPackageName();
            return pm.isIgnoringBatteryOptimizations(packageName);
        }
        return true;
    }
}
