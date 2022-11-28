
package com.muslim_book.muslim_book.models.ramadan_model;

import android.os.Parcelable;

import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;

import java.io.Serializable;
import java.util.List;

 public class Hijri implements Serializable, Parcelable
{

    @SerializedName("date")
    @Expose
    private String date;
    @SerializedName("format")
    @Expose
    private String format;
    @SerializedName("day")
    @Expose
    private String day;
    @SerializedName("weekday")
    @Expose
    private Weekday weekday;
    @SerializedName("month")
    @Expose
    private Month month;
    @SerializedName("year")
    @Expose
    private String year;
    @SerializedName("designation")
    @Expose
    private Designation designation;
    @SerializedName("holidays")
    @Expose
    private List<String> holidays = null;
    public final static Creator<Hijri> CREATOR = new Creator<Hijri>() {


        @SuppressWarnings({
            "unchecked"
        })
        public Hijri createFromParcel(android.os.Parcel in) {
            return new Hijri(in);
        }

        public Hijri[] newArray(int size) {
            return (new Hijri[size]);
        }

    }
    ;
    private final static long serialVersionUID = 621856334804499229L;

    protected Hijri(android.os.Parcel in) {
        this.date = ((String) in.readValue((String.class.getClassLoader())));
        this.format = ((String) in.readValue((String.class.getClassLoader())));
        this.day = ((String) in.readValue((String.class.getClassLoader())));
        this.weekday = ((Weekday) in.readValue((Weekday.class.getClassLoader())));
        this.month = ((Month) in.readValue((Month.class.getClassLoader())));
        this.year = ((String) in.readValue((String.class.getClassLoader())));
        this.designation = ((Designation) in.readValue((Designation.class.getClassLoader())));
        in.readList(this.holidays, (String.class.getClassLoader()));
    }

    public Hijri() {
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getFormat() {
        return format;
    }

    public void setFormat(String format) {
        this.format = format;
    }

    public String getDay() {
        return day;
    }

    public void setDay(String day) {
        this.day = day;
    }

    public Weekday getWeekday() {
        return weekday;
    }

    public void setWeekday(Weekday weekday) {
        this.weekday = weekday;
    }

    public Month getMonth() {
        return month;
    }

    public void setMonth(Month month) {
        this.month = month;
    }

    public String getYear() {
        return year;
    }

    public void setYear(String year) {
        this.year = year;
    }

    public Designation getDesignation() {
        return designation;
    }

    public void setDesignation(Designation designation) {
        this.designation = designation;
    }

    public List<String> getHolidays() {
        return holidays;
    }

    public void setHolidays(List<String> holidays) {
        this.holidays = holidays;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(Hijri.class.getName()).append('@').append(Integer.toHexString(System.identityHashCode(this))).append('[');
        sb.append("date");
        sb.append('=');
        sb.append(((this.date == null)?"<null>":this.date));
        sb.append(',');
        sb.append("format");
        sb.append('=');
        sb.append(((this.format == null)?"<null>":this.format));
        sb.append(',');
        sb.append("day");
        sb.append('=');
        sb.append(((this.day == null)?"<null>":this.day));
        sb.append(',');
        sb.append("weekday");
        sb.append('=');
        sb.append(((this.weekday == null)?"<null>":this.weekday));
        sb.append(',');
        sb.append("month");
        sb.append('=');
        sb.append(((this.month == null)?"<null>":this.month));
        sb.append(',');
        sb.append("year");
        sb.append('=');
        sb.append(((this.year == null)?"<null>":this.year));
        sb.append(',');
        sb.append("designation");
        sb.append('=');
        sb.append(((this.designation == null)?"<null>":this.designation));
        sb.append(',');
        sb.append("holidays");
        sb.append('=');
        sb.append(((this.holidays == null)?"<null>":this.holidays));
        sb.append(',');
        if (sb.charAt((sb.length()- 1)) == ',') {
            sb.setCharAt((sb.length()- 1), ']');
        } else {
            sb.append(']');
        }
        return sb.toString();
    }

    public void writeToParcel(android.os.Parcel dest, int flags) {
        dest.writeValue(date);
        dest.writeValue(format);
        dest.writeValue(day);
        dest.writeValue(weekday);
        dest.writeValue(month);
        dest.writeValue(year);
        dest.writeValue(designation);
        dest.writeList(holidays);
    }

    public int describeContents() {
        return  0;
    }

}
