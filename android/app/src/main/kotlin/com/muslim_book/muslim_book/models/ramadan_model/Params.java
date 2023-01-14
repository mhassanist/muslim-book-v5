package com.muslim_book.muslim_book.models.ramadan_model;

import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

 public class Params implements Serializable, Parcelable
{

    @SerializedName("Fajr")
    @Expose
    private Integer fajr;
    @SerializedName("Isha")
    @Expose
    private Integer isha;
    public final static Creator<Params> CREATOR = new Creator<Params>() {


        @SuppressWarnings({
            "unchecked"
        })
        public Params createFromParcel(android.os.Parcel in) {
            return new Params(in);
        }

        public Params[] newArray(int size) {
            return (new Params[size]);
        }

    }
    ;
    private final static long serialVersionUID = 5854098317277731044L;

    protected Params(android.os.Parcel in) {
        this.fajr = ((Integer) in.readValue((Integer.class.getClassLoader())));
        this.isha = ((Integer) in.readValue((Integer.class.getClassLoader())));
    }

    public Params() {
    }

    public Integer getFajr() {
        return fajr;
    }

    public void setFajr(Integer fajr) {
        this.fajr = fajr;
    }

    public Integer getIsha() {
        return isha;
    }

    public void setIsha(Integer isha) {
        this.isha = isha;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(Params.class.getName()).append('@').append(Integer.toHexString(System.identityHashCode(this))).append('[');
        sb.append("fajr");
        sb.append('=');
        sb.append(((this.fajr == null)?"<null>":this.fajr));
        sb.append(',');
        sb.append("isha");
        sb.append('=');
        sb.append(((this.isha == null)?"<null>":this.isha));
        sb.append(',');
        if (sb.charAt((sb.length()- 1)) == ',') {
            sb.setCharAt((sb.length()- 1), ']');
        } else {
            sb.append(']');
        }
        return sb.toString();
    }

    public void writeToParcel(android.os.Parcel dest, int flags) {
        dest.writeValue(fajr);
        dest.writeValue(isha);
    }

    public int describeContents() {
        return  0;
    }

}
