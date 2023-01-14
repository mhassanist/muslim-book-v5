package com.muslim_book.muslim_book.models.ramadan_model;

import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

 public class Offset implements Serializable, Parcelable
{

    @SerializedName("Imsak")
    @Expose
    private Integer imsak;
    @SerializedName("Fajr")
    @Expose
    private Integer fajr;
    @SerializedName("Sunrise")
    @Expose
    private Integer sunrise;
    @SerializedName("Dhuhr")
    @Expose
    private Integer dhuhr;
    @SerializedName("Asr")
    @Expose
    private Integer asr;
    @SerializedName("Maghrib")
    @Expose
    private Integer maghrib;
    @SerializedName("Sunset")
    @Expose
    private Integer sunset;
    @SerializedName("Isha")
    @Expose
    private Integer isha;
    @SerializedName("Midnight")
    @Expose
    private Integer midnight;
    public final static Creator<Offset> CREATOR = new Creator<Offset>() {


        @SuppressWarnings({
            "unchecked"
        })
        public Offset createFromParcel(android.os.Parcel in) {
            return new Offset(in);
        }

        public Offset[] newArray(int size) {
            return (new Offset[size]);
        }

    }
    ;
    private final static long serialVersionUID = -1548893923851135500L;

    protected Offset(android.os.Parcel in) {
        this.imsak = ((Integer) in.readValue((Integer.class.getClassLoader())));
        this.fajr = ((Integer) in.readValue((Integer.class.getClassLoader())));
        this.sunrise = ((Integer) in.readValue((Integer.class.getClassLoader())));
        this.dhuhr = ((Integer) in.readValue((Integer.class.getClassLoader())));
        this.asr = ((Integer) in.readValue((Integer.class.getClassLoader())));
        this.maghrib = ((Integer) in.readValue((Integer.class.getClassLoader())));
        this.sunset = ((Integer) in.readValue((Integer.class.getClassLoader())));
        this.isha = ((Integer) in.readValue((Integer.class.getClassLoader())));
        this.midnight = ((Integer) in.readValue((Integer.class.getClassLoader())));
    }

    public Offset() {
    }

    public Integer getImsak() {
        return imsak;
    }

    public void setImsak(Integer imsak) {
        this.imsak = imsak;
    }

    public Integer getFajr() {
        return fajr;
    }

    public void setFajr(Integer fajr) {
        this.fajr = fajr;
    }

    public Integer getSunrise() {
        return sunrise;
    }

    public void setSunrise(Integer sunrise) {
        this.sunrise = sunrise;
    }

    public Integer getDhuhr() {
        return dhuhr;
    }

    public void setDhuhr(Integer dhuhr) {
        this.dhuhr = dhuhr;
    }

    public Integer getAsr() {
        return asr;
    }

    public void setAsr(Integer asr) {
        this.asr = asr;
    }

    public Integer getMaghrib() {
        return maghrib;
    }

    public void setMaghrib(Integer maghrib) {
        this.maghrib = maghrib;
    }

    public Integer getSunset() {
        return sunset;
    }

    public void setSunset(Integer sunset) {
        this.sunset = sunset;
    }

    public Integer getIsha() {
        return isha;
    }

    public void setIsha(Integer isha) {
        this.isha = isha;
    }

    public Integer getMidnight() {
        return midnight;
    }

    public void setMidnight(Integer midnight) {
        this.midnight = midnight;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(Offset.class.getName()).append('@').append(Integer.toHexString(System.identityHashCode(this))).append('[');
        sb.append("imsak");
        sb.append('=');
        sb.append(((this.imsak == null)?"<null>":this.imsak));
        sb.append(',');
        sb.append("fajr");
        sb.append('=');
        sb.append(((this.fajr == null)?"<null>":this.fajr));
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
        sb.append("maghrib");
        sb.append('=');
        sb.append(((this.maghrib == null)?"<null>":this.maghrib));
        sb.append(',');
        sb.append("sunset");
        sb.append('=');
        sb.append(((this.sunset == null)?"<null>":this.sunset));
        sb.append(',');
        sb.append("isha");
        sb.append('=');
        sb.append(((this.isha == null)?"<null>":this.isha));
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
        dest.writeValue(imsak);
        dest.writeValue(fajr);
        dest.writeValue(sunrise);
        dest.writeValue(dhuhr);
        dest.writeValue(asr);
        dest.writeValue(maghrib);
        dest.writeValue(sunset);
        dest.writeValue(isha);
        dest.writeValue(midnight);
    }

    public int describeContents() {
        return  0;
    }

}
