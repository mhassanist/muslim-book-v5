package com.muslim_book.muslim_book.models.azan_model

import com.google.gson.annotations.Expose
import com.google.gson.annotations.SerializedName

class AzanModelData {
    @SerializedName("timings")
    @Expose
    var timings: Timings? = null
}