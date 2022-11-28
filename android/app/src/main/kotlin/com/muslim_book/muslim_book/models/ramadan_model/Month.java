
package com.muslim_book.muslim_book.models.ramadan_model;

import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

 public class Month implements Serializable, Parcelable
{

    @SerializedName("number")
    @Expose
    private Integer number;
    @SerializedName("en")
    @Expose
    private String en;
    @SerializedName("ar")
    @Expose
    private String ar;
    public final static Creator<Month> CREATOR = new Creator<Month>() {


        @SuppressWarnings({
            "unchecked"
        })
        public Month createFromParcel(android.os.Parcel in) {
            return new Month(in);
        }

        public Month [] newArray(int size) {
            return (new Month[size]);
        }

    }
    ;
    private final static long serialVersionUID = 5118187658845863819L;

    protected Month(android.os.Parcel in) {
        this.number = ((Integer) in.readValue((Integer.class.getClassLoader())));
        this.en = ((String) in.readValue((String.class.getClassLoader())));
        this.ar = ((String) in.readValue((String.class.getClassLoader())));
    }

    public Month() {
    }

    public Integer getNumber() {
        return number;
    }

    public void setNumber(Integer number) {
        this.number = number;
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
        sb.append(Month .class.getName()).append('@').append(Integer.toHexString(System.identityHashCode(this))).append('[');
        sb.append("number");
        sb.append('=');
        sb.append(((this.number == null)?"<null>":this.number));
        sb.append(',');
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
        dest.writeValue(number);
        dest.writeValue(en);
        dest.writeValue(ar);
    }

    public int describeContents() {
        return  0;
    }

}
