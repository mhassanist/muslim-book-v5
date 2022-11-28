
package com.muslim_book.muslim_book.models.ramadan_model;

import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.List;

 public class RamadanModel implements Serializable, Parcelable
{

    @SerializedName("code")
    @Expose
    private Integer code;
    @SerializedName("status")
    @Expose
    private String status;
    @SerializedName("data")
    @Expose
    private List<RamadanDatum> ramadanData = null;
    public final static Creator<RamadanModel> CREATOR = new Creator<RamadanModel>() {


        @SuppressWarnings({
            "unchecked"
        })
        public RamadanModel createFromParcel(android.os.Parcel in) {
            return new RamadanModel(in);
        }

        public RamadanModel[] newArray(int size) {
            return (new RamadanModel[size]);
        }

    }
    ;
    private final static long serialVersionUID = 1616569323905316747L;

    protected RamadanModel(android.os.Parcel in) {
        this.code = ((Integer) in.readValue((Integer.class.getClassLoader())));
        this.status = ((String) in.readValue((String.class.getClassLoader())));
        in.readList(this.ramadanData, ( RamadanDatum.class.getClassLoader()));
    }

    public RamadanModel() {
    }

    public Integer getCode() {
        return code;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public List<RamadanDatum> getRamadanData() {
        return ramadanData;
    }

    public void setRamadanData(List<RamadanDatum> ramadanData) {
        this.ramadanData = ramadanData;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(RamadanModel.class.getName()).append('@').append(Integer.toHexString(System.identityHashCode(this))).append('[');
        sb.append("code");
        sb.append('=');
        sb.append(((this.code == null)?"<null>":this.code));
        sb.append(',');
        sb.append("status");
        sb.append('=');
        sb.append(((this.status == null)?"<null>":this.status));
        sb.append(',');
        sb.append("ramadanData");
        sb.append('=');
        sb.append(((this.ramadanData == null)?"<null>":this.ramadanData));
        sb.append(',');
        if (sb.charAt((sb.length()- 1)) == ',') {
            sb.setCharAt((sb.length()- 1), ']');
        } else {
            sb.append(']');
        }
        return sb.toString();
    }

    public void writeToParcel(android.os.Parcel dest, int flags) {
        dest.writeValue(code);
        dest.writeValue(status);
        dest.writeList(ramadanData);
    }

    public int describeContents() {
        return  0;
    }

}
