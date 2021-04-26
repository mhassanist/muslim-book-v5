
package com.muslim_book.muslim_book.models.ramadan_model;

import java.io.Serializable;
 import android.os.Parcelable;
import android.os.Parcelable.Creator;
import android.os.Parcelable.Creator;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

 public class Date implements Serializable, Parcelable
{

    @SerializedName("readable")
    @Expose
    private String readable;
    @SerializedName("timestamp")
    @Expose
    private String timestamp;
    @SerializedName("gregorian")
    @Expose
    private Gregorian gregorian;
    @SerializedName("hijri")
    @Expose
    private Hijri hijri;
    public final static Creator<Date> CREATOR = new Creator<Date>() {


        @SuppressWarnings({
            "unchecked"
        })
        public Date createFromParcel(android.os.Parcel in) {
            return new Date(in);
        }

        public Date[] newArray(int size) {
            return (new Date[size]);
        }

    }
    ;
    private final static long serialVersionUID = 1791348804349073451L;

    protected Date(android.os.Parcel in) {
        this.readable = ((String) in.readValue((String.class.getClassLoader())));
        this.timestamp = ((String) in.readValue((String.class.getClassLoader())));
        this.gregorian = ((Gregorian) in.readValue((Gregorian.class.getClassLoader())));
        this.hijri = ((Hijri) in.readValue((Hijri.class.getClassLoader())));
    }

    public Date() {
    }

    public String getReadable() {
        return readable;
    }

    public void setReadable(String readable) {
        this.readable = readable;
    }

    public String getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(String timestamp) {
        this.timestamp = timestamp;
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
        sb.append(Date.class.getName()).append('@').append(Integer.toHexString(System.identityHashCode(this))).append('[');
        sb.append("readable");
        sb.append('=');
        sb.append(((this.readable == null)?"<null>":this.readable));
        sb.append(',');
        sb.append("timestamp");
        sb.append('=');
        sb.append(((this.timestamp == null)?"<null>":this.timestamp));
        sb.append(',');
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
        dest.writeValue(readable);
        dest.writeValue(timestamp);
        dest.writeValue(gregorian);
        dest.writeValue(hijri);
    }

    public int describeContents() {
        return  0;
    }

}
