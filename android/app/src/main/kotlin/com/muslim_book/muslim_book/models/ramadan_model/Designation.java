
package com.muslim_book.muslim_book.models.ramadan_model;

import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;

 public class Designation implements Serializable, Parcelable
{

    @SerializedName("abbreviated")
    @Expose
    private String abbreviated;
    @SerializedName("expanded")
    @Expose
    private String expanded;
    public final static Creator<Designation> CREATOR = new Creator<Designation>() {


        @SuppressWarnings({
            "unchecked"
        })
        public Designation createFromParcel(android.os.Parcel in) {
            return new Designation(in);
        }

        public Designation[] newArray(int size) {
            return (new Designation[size]);
        }

    }
    ;
    private final static long serialVersionUID = -155769518114919504L;

    protected Designation(android.os.Parcel in) {
        this.abbreviated = ((String) in.readValue((String.class.getClassLoader())));
        this.expanded = ((String) in.readValue((String.class.getClassLoader())));
    }

    public Designation() {
    }

    public String getAbbreviated() {
        return abbreviated;
    }

    public void setAbbreviated(String abbreviated) {
        this.abbreviated = abbreviated;
    }

    public String getExpanded() {
        return expanded;
    }

    public void setExpanded(String expanded) {
        this.expanded = expanded;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(Designation.class.getName()).append('@').append(Integer.toHexString(System.identityHashCode(this))).append('[');
        sb.append("abbreviated");
        sb.append('=');
        sb.append(((this.abbreviated == null)?"<null>":this.abbreviated));
        sb.append(',');
        sb.append("expanded");
        sb.append('=');
        sb.append(((this.expanded == null)?"<null>":this.expanded));
        sb.append(',');
        if (sb.charAt((sb.length()- 1)) == ',') {
            sb.setCharAt((sb.length()- 1), ']');
        } else {
            sb.append(']');
        }
        return sb.toString();
    }

    public void writeToParcel(android.os.Parcel dest, int flags) {
        dest.writeValue(abbreviated);
        dest.writeValue(expanded);
    }

    public int describeContents() {
        return  0;
    }

}
