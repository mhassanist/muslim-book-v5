package com.muslim_book.muslim_book.models.ramadan_model;

import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

 public class Weekday implements Serializable, Parcelable
{

    @SerializedName("en")
    @Expose
    private String en;
    @SerializedName("ar")
    @Expose
    private String ar;
    public final static Creator<Weekday> CREATOR = new Creator<Weekday>() {


        @SuppressWarnings({
            "unchecked"
        })
        public Weekday createFromParcel(android.os.Parcel in) {
            return new Weekday(in);
        }

        public Weekday[] newArray(int size) {
            return (new Weekday[size]);
        }

    }
    ;
    private final static long serialVersionUID = 1219253394843772379L;

    protected Weekday(android.os.Parcel in) {
        this.en = ((String) in.readValue((String.class.getClassLoader())));
        this.ar = ((String) in.readValue((String.class.getClassLoader())));
    }

    public Weekday() {
    }

    public String getEn() {
        return en;
    }

    public void setEn(String en) {
        this.en = en;
    }

    public String getAr() {
        return ar;
    }

    public void setAr(String ar) {
        this.ar = ar;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(Weekday.class.getName()).append('@').append(Integer.toHexString(System.identityHashCode(this))).append('[');
        sb.append("en");
        sb.append('=');
        sb.append(((this.en == null)?"<null>":this.en));
        sb.append(',');
        sb.append("ar");
        sb.append('=');
        sb.append(((this.ar == null)?"<null>":this.ar));
        sb.append(',');
        if (sb.charAt((sb.length()- 1)) == ',') {
            sb.setCharAt((sb.length()- 1), ']');
        } else {
            sb.append(']');
        }
        return sb.toString();
    }

    public void writeToParcel(android.os.Parcel dest, int flags) {
        dest.writeValue(en);
        dest.writeValue(ar);
    }

    public int describeContents() {
        return  0;
    }

}
