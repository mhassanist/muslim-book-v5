package com.muslim_book.muslim_book.receivers.phoneState;
import android.content.Context;
import android.content.Intent;
import android.telephony.PhoneStateListener;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.widget.Toast;

import com.muslim_book.muslim_book.services.azan.AzanIntentService;

public class CustomPhoneStateListener extends PhoneStateListener {

    //private static final String TAG = "PhoneStateChanged";
    Context context; //Context to make Toast if required 
    public CustomPhoneStateListener(Context context) {
        super();
        this.context = context;
    }

    @Override
    public void onCallStateChanged(int state, String incomingNumber) {
        super.onCallStateChanged(state, incomingNumber);

        switch (state) {
            case TelephonyManager.CALL_STATE_IDLE:
                Log.i("TelephonyManager.CALL" ,TelephonyManager.CALL_STATE_IDLE+"");
                Intent stopService = new Intent(context, AzanIntentService.class);
                context.stopService(stopService);
                //when Idle i.e no call
                Toast.makeText(context, "Phone state Idle", Toast.LENGTH_LONG).show();
                break;
            case TelephonyManager.CALL_STATE_OFFHOOK:
                Log.i("TelephonyManager.CALL" ,TelephonyManager.CALL_STATE_IDLE+"");

                //when Off hook i.e in call
                //Make intent and start your service here
              Toast.makeText(context, "Phone state Off hook", Toast.LENGTH_LONG).show();
                break;
            case TelephonyManager.CALL_STATE_RINGING:
                Log.i("TelephonyManager.CALL" ,TelephonyManager.CALL_STATE_IDLE+"");

                //when Ringing
                Toast.makeText(context, "Phone state Ringing", Toast.LENGTH_LONG).show();
                break;
            default:
                break;
        }
    }
}