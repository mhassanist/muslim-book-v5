package com.muslim_book.muslim_book;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.widget.Toast;

public class ScreenLockReceiver extends BroadcastReceiver {

    private String TAG = "ScreenLockReceiver";

    @Override
    public void onReceive(Context context, Intent intent) {
        // This method is called when the BroadcastReceiver is receiving
        // an Intent broadcast.

        String str_time = intent.getStringExtra("time");
        Toast.makeText(context, str_time  +  "  str_time", Toast.LENGTH_SHORT).show();

         String action = intent.getAction();
        if (action.equals(Intent.ACTION_SCREEN_ON)) {
            Log.d(TAG, "onReceive called: screen on");
        } else if (action.equals(Intent.ACTION_SCREEN_OFF)) {
            Log.d(TAG, "onReceive called: screen off");
        } else if (action.equals(Intent.ACTION_USER_PRESENT)) {
            Log.d(TAG, "onReceive called: screen unlocked");
            new Util().setRandomWallpaper(context);
        }
    }
}
