package com.muslim_book.muslim_book.singletons

import android.annotation.SuppressLint
import android.content.Context
import android.media.MediaPlayer

class AzanPlayerSingleton {
    @Volatile
    private var INSTANCE: AzanPlayerSingleton? = null
    private var mAzanPlayer: MediaPlayer? = null


    fun getInstance(): AzanPlayerSingleton? {
        if (INSTANCE == null) {
            synchronized(Any()) {
                if (INSTANCE == null) {
                    INSTANCE = AzanPlayerSingleton()
                }
            }
        }
        return INSTANCE
    }

    @SuppressLint("DiscouragedApi")
    fun playMediaPlayer(context: Context): MediaPlayer? {
        if (mAzanPlayer == null) {
            mAzanPlayer = MediaPlayer.create(
                context,
                context.resources.getIdentifier(
                    "azan_",
                    "raw",
                    context.packageName
                )
            )
            mAzanPlayer?.start()
        }
        return mAzanPlayer
    }

    fun releaseMediaPlayer() {
        if (mAzanPlayer != null) {
            if (mAzanPlayer?.isPlaying == true) {
                mAzanPlayer?.stop()
            }
            mAzanPlayer?.release()
            mAzanPlayer = null
        }
    }
}