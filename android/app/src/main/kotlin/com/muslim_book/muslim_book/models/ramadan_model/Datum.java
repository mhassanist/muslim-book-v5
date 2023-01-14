package com.muslim_book.muslim_book.models.ramadan_model;

import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

 public class Datum implements Serializable, Parcelable
{

    @SerializedName("gregorian")
    @Expose
    private Gregorian gregorian;
    @SerializedName("hijri")
    @Expose
    private Hijri hijri;
    public final static Creator<Datum> CREATOR = new Creator<Datum>() {


        @SuppressWarnings({
            "unchecked"
        })
        public Datum createFromParcel(android.os.Parcel in) {
            return new Datum(in);
        }

        public Datum[] newArray(int size) {
            return (new Datum[size]);
        }

    }
    ;
    private final static long serialVersionUID = 8254596381067939428L;

    protected Datum(android.os.Parcel in) {
        this.gregorian = ((Gregorian) in.readValue((Gregorian.class.getClassLoader())));
        this.hijri = ((Hijri) in.readValue((Hijri.class.getClassLoader())));
    }

    public Datum() {
    }

    public Gregorian getGregorian() {
        return gregorian;
    }

    public void setGregorian(Gregorian gregorian) {
        this.gregorian = gregorian;
    }

    public Hijri getHijri() {
        return hijri;
    }

    public void setHijri(Hijri hijri) {
        this.hijri = hijri;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(Datum.class.getName()).append('@').append(Integer.toHexString(System.identityHashCode(this))).append('[');
        sb.append("gregorian");
        sb.append('=');
        sb.append(((this.gregorian == null)?"<null>":this.gregorian));
        sb.append(',');
        sb.append("hijri");
        sb.append('=');
        sb.append(((this.hijri == null)?"<null>":this.hijri));
        sb.append(',');
        if (sb.charAt((sb.length()- 1)) == ',') {
            sb.setCharAt((sb.length()- 1), ']');
        } else {
            sb.append(']');
        }
        return sb.toString();
    }

    public void writeToParcel(android.os.Parcel dest, int flags) {
        dest.writeValue(gregorian);
        dest.writeValue(hijri);
    }

    public int describeContents() {
        return  0;
    }

}
