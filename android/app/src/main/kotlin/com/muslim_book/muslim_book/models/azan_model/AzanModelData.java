
package com.muslim_book.muslim_book.models.azan_model;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

public class AzanModelData {

    @SerializedName("timings")
    @Expose
    private Timings timings;

    public Timings getTimings() {
        return timings;
    }

    public void setTimings(Timings timings) {
        this.timings = timings;
    }


}
