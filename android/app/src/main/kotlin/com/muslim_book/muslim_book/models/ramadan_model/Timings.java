
package com.muslim_book.muslim_book.models.ramadan_model;

import java.io.Serializable;
 import android.os.Parcelable;
import android.os.Parcelable.Creator;
import android.os.Parcelable.Creator;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

 public class Timings implements Serializable, Parcelable
{
//
//    @SerializedName("Fajr")
//    @Expose
//    private String fajr;
    @SerializedName("Sunrise")
    @Expose
    private String sunrise;
    @SerializedName("Dhuhr")
    @Expose
    private String dhuhr;
    @SerializedName("Asr")
    @Expose
    private String asr;
    @SerializedName("Sunset")
    @Expose
    private String sunset;
    @SerializedName("Maghrib")
    @Expose
    private String maghrib;
    @SerializedName("Isha")
    @Expose
    private String isha;
    @SerializedName("Imsak")
    @Expose
    private String imsak;
    @SerializedName("Midnight")
    @Expose
    private String midnight;
    public final static Creator<Timings> CREATOR = new Creator<Timings>() {


        @SuppressWarnings({
            "unchecked"
        })
        public Timings createFromParcel(android.os.Parcel in) {
            return new Timings(in);
        }

        public Timings[] newArray(int size) {
            return (new Timings[size]);
        }

    }
    ;
    private final static long serialVersionUID = -6748054471963403681L;

    protected Timings(android.os.Parcel in) {
//        this.fajr = ((String) in.readValue((String.class.getClassLoader())));
        this.sunrise = ((String) in.readValue((String.class.getClassLoader())));
        this.dhuhr = ((String) in.readValue((String.class.getClassLoader())));
        this.asr = ((String) in.readValue((String.class.getClassLoader())));
        this.sunset = ((String) in.readValue((String.class.getClassLoader())));
        this.maghrib = ((String) in.readValue((String.class.getClassLoader())));
        this.isha = ((String) in.readValue((String.class.getClassLoader())));
        this.imsak = ((String) in.readValue((String.class.getClassLoader())));
        this.midnight = ((String) in.readValue((String.class.getClassLoader())));
    }

    public Timings() {
    }

//    public String getFajr() {
//        return fajr;
//    }

//    public void setFajr(String fajr) {
//        this.fajr = fajr;
//    }

    public String getSunrise() {
        return sunrise;
    }

    public void setSunrise(String sunrise) {
        this.sunrise = sunrise;
    }

    public String getDhuhr() {
        return dhuhr;
    }

    public void setDhuhr(String dhuhr) {
        this.dhuhr = dhuhr;
    }

    public String getAsr() {
        return asr;
    }

    public void setAsr(String asr) {
        this.asr = asr;
    }

    public String getSunset() {
        return sunset;
    }

    public void setSunset(String sunset) {
        this.sunset = sunset;
    }

    public String getMaghrib() {
        return maghrib;
    }

    public void setMaghrib(String maghrib) {
        this.maghrib = maghrib;
    }

    public String getIsha() {
        return isha;
    }

    public void setIsha(String isha) {
        this.isha = isha;
    }

    public String getImsak() {
        return imsak;
    }

    public void setImsak(String imsak) {
        this.imsak = imsak;
    }

    public String getMidnight() {
        return midnight;
    }

    public void setMidnight(String midnight) {
        this.midnight = midnight;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(Timings.class.getName()).append('@').append(Integer.toHexString(System.identityHashCode(this))).append('[');
        sb.append("fajr");
        sb.append('=');
//        sb.append(((this.fajr == null)?"<null>":this.fajr));
        sb.append(',');
        sb.append("sunrise");
        sb.append('=');
        sb.append(((this.sunrise == null)?"<null>":this.sunrise));
        sb.append(',');
        sb.append("dhuhr");
        sb.append('=');
        sb.append(((this.dhuhr == null)?"<null>":this.dhuhr));
        sb.append(',');
        sb.append("asr");
        sb.append('=');
        sb.append(((this.asr == null)?"<null>":this.asr));
        sb.append(',');
        sb.append("sunset");
        sb.append('=');
        sb.append(((this.sunset == null)?"<null>":this.sunset));
        sb.append(',');
        sb.append("maghrib");
        sb.append('=');
        sb.append(((this.maghrib == null)?"<null>":this.maghrib));
        sb.append(',');
        sb.append("isha");
        sb.append('=');
        sb.append(((this.isha == null)?"<null>":this.isha));
        sb.append(',');
        sb.append("imsak");
        sb.append('=');
        sb.append(((this.imsak == null)?"<null>":this.imsak));
        sb.append(',');
        sb.append("midnight");
        sb.append('=');
        sb.append(((this.midnight == null)?"<null>":this.midnight));
        sb.append(',');
        if (sb.charAt((sb.length()- 1)) == ',') {
            sb.setCharAt((sb.length()- 1), ']');
        } else {
            sb.append(']');
        }
        return sb.toString();
    }

    public void writeToParcel(android.os.Parcel dest, int flags) {
//        dest.writeValue(fajr);
        dest.writeValue(sunrise);
        dest.writeValue(dhuhr);
        dest.writeValue(asr);
        dest.writeValue(sunset);
        dest.writeValue(maghrib);
        dest.writeValue(isha);
        dest.writeValue(imsak);
        dest.writeValue(midnight);
    }

    public int describeContents() {
        return  0;
    }

}
