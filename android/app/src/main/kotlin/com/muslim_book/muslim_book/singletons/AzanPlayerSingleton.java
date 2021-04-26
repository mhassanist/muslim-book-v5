package com.muslim_book.muslim_book.singletons;

import android.content.Context;
import android.media.MediaPlayer;

public class AzanPlayerSingleton {

  private static volatile AzanPlayerSingleton INSTANCE;
  private MediaPlayer mAzanPlayer;


  public static AzanPlayerSingleton getInstance() {
    if (INSTANCE == null) {
      synchronized (new Object()) {
        if (INSTANCE == null) {
          INSTANCE = new AzanPlayerSingleton();
        }
      }
    }
    return INSTANCE;
  }


  public MediaPlayer playMediaPlayer(Context context) {
    if (mAzanPlayer == null) {
      mAzanPlayer = MediaPlayer.create(context,
          context.getResources().getIdentifier("azan_",
              "raw", context.getPackageName()));
      mAzanPlayer.start();
    }
    return mAzanPlayer;
  }




  public void releaseMediaPlayer() {

    if (mAzanPlayer != null) {
      if (mAzanPlayer.isPlaying()) {
        mAzanPlayer.stop();
      }
      mAzanPlayer.release();
      mAzanPlayer = null;
    }
  }

}