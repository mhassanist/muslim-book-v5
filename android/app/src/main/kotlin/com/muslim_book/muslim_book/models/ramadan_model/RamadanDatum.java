
package com.muslim_book.muslim_book.models.ramadan_model;

import java.io.Serializable;
 import android.os.Parcelable;
  import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

 public class RamadanDatum implements Serializable, Parcelable
{

    @SerializedName("timings")
    @Expose
    private Timings timings;
    @SerializedName("date")
    @Expose
    private Date date;

    public final static Creator<RamadanDatum> CREATOR = new Creator<RamadanDatum>() {


        @SuppressWarnings({
            "unchecked"
        })
        public RamadanDatum createFromParcel(android.os.Parcel in) {
            return new RamadanDatum(in);
        }

        public RamadanDatum[] newArray(int size) {
            return (new RamadanDatum[size]);
        }

    }
    ;
    private final static long serialVersionUID = -1832979610330822358L;

    protected RamadanDatum(android.os.Parcel in) {
        this.timings = ((Timings) in.readValue((Timings.class.getClassLoader())));
        this.date = ((Date) in.readValue((Date.class.getClassLoader())));
     }

    public RamadanDatum() {
    }

    public Timings getTimings() {
        return timings;
    }

    public void setTimings(Timings timings) {
        this.timings = timings;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }



    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(RamadanDatum.class.getName()).append('@').append(Integer.toHexString(System.identityHashCode(this))).append('[');
        sb.append("timings");
        sb.append('=');
        sb.append(((this.timings == null)?"<null>":this.timings));
        sb.append(',');
        sb.append("date");
        sb.append('=');
        sb.append(((this.date == null)?"<null>":this.date));
        sb.append(',');
        sb.append("meta");
        sb.append('=');
         sb.append(',');
        if (sb.charAt((sb.length()- 1)) == ',') {
            sb.setCharAt((sb.length()- 1), ']');
        } else {
            sb.append(']');
        }
        return sb.toString();
    }

    public void writeToParcel(android.os.Parcel dest, int flags) {
        dest.writeValue(timings);
        dest.writeValue(date);
     }

    public int describeContents() {
        return  0;
    }

}
