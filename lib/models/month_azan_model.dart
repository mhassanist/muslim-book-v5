// To parse this JSON data, do
//
//     final monthAzanModel = monthAzanModelFromJson(jsonString);

import 'dart:convert';

import 'package:muslim_book/models/enum/month_azan_enum.dart';

MonthAzanModel monthAzanModelFromJson(String str) =>
    MonthAzanModel.fromJson(json.decode(str));

String monthAzanModelToJson(MonthAzanModel data) => json.encode(data.toJson());

class MonthAzanModel {
  MonthAzanModel({
    this.code,
    this.status,
    required this.data,
  });

  int? code;
  String? status;
  List<AzanModel> data;

  factory MonthAzanModel.fromJson(String str) =>
      MonthAzanModel.fromMap(json.decode(str));

  factory MonthAzanModel.fromMap(Map<String, dynamic> json) => MonthAzanModel(
        code: json["code"],
        status: json["status"],
        data: List<AzanModel>.from(
            json["data"].map((x) => AzanModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class AzanModel {
  AzanModel({
    required this.timings,
    required this.date,
    // this.meta,
  });

  Timings timings;
  Date date;

  // Meta meta;

  factory AzanModel.fromJson(Map<String, dynamic> json) => AzanModel(
        timings: Timings.fromJson(json["timings"]),
        date: Date.fromJson(json["date"]),
        // meta: Meta.fromJson(json["meta"]),
      );

  Map<String, dynamic> toJson() => {
        "timings": timings.toJson(),
        "date": date.toJson(),
        // "meta": meta.toJson(),
      };
}

class Date {
  Date({
    this.readable,
    this.timestamp,
    required this.gregorian,
    required this.hijri,
  });

  String? readable;
  String? timestamp;
  Gregorian gregorian;
  Hijri hijri;

  factory Date.fromJson(Map<String, dynamic> json) => Date(
        readable: json["readable"],
        timestamp: json["timestamp"],
        gregorian: Gregorian.fromJson(json["gregorian"]),
        hijri: Hijri.fromJson(json["hijri"]),
      );

  Map<String, dynamic> toJson() => {
        "readable": readable,
        "timestamp": timestamp,
        "gregorian": gregorian.toJson(),
        "hijri": hijri.toJson(),
      };
}

class Gregorian {
  Gregorian({
    this.date,
    required this.format,
    this.day,
    required this.weekday,
    required this.month,
    this.year,
    required this.designation,
  });

  String? date;
  Format format;
  String? day;
  GregorianWeekday weekday;
  GregorianMonth month;
  String? year;
  Designation designation;

  factory Gregorian.fromJson(Map<String, dynamic> json) => Gregorian(
        date: json["date"],
        // format: formatValues.map[json["format"]],
        format: Format.fromStringValue(json["format"]),
        day: json["day"],
        weekday: GregorianWeekday.fromJson(json["weekday"]),
        month: GregorianMonth.fromJson(json["month"]),
        year: json["year"],
        designation: Designation.fromJson(json["designation"]),
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "format": {Format: format.value}, //formatValues.reverse[format],
        "day": day,
        "weekday": weekday.toJson(),
        "month": month.toJson(),
        "year": year,
        "designation": designation.toJson(),
      };
}

class Designation {
  Designation({
    required this.abbreviated,
    required this.expanded,
  });

  Abbreviated abbreviated;
  Expanded expanded;

  factory Designation.fromJson(Map<String, dynamic> json) => Designation(
        // abbreviated: abbreviatedValues.map[json["abbreviated"]],
        // expanded: expandedValues.map[json["expanded"]],
        // abbreviated: enumFromString(json["abbreviated"], Abbreviated.values),
        // expanded: enumFromString(json['expanded'], Expanded.values),
        abbreviated: Abbreviated.fromStringValue(json["abbreviated"]),
        expanded: Expanded.fromStringValue(json["expanded"]),
      );

  Map<String, dynamic> toJson() => {
        "abbreviated": {Abbreviated: abbreviated.value},
        //abbreviatedValues.reverse[abbreviated],
        "expanded": {Expanded: expanded.value},
        //expandedValues.reverse[expanded],
      };
}

class GregorianMonth {
  GregorianMonth({
    this.number,
    required this.en,
  });

  int? number;
  PurpleEn en;

  factory GregorianMonth.fromJson(Map<String, dynamic> json) => GregorianMonth(
        number: json["number"],
        en: PurpleEn.fromStringValue(json['en']),
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "en": {PurpleEn: en.value}, //purpleEnValues.reverse[en],
      };
}

class GregorianWeekday {
  GregorianWeekday({
    this.en,
  });

  String? en;

  factory GregorianWeekday.fromJson(Map<String, dynamic> json) =>
      GregorianWeekday(
        en: json["en"],
      );

  Map<String, dynamic> toJson() => {
        "en": en,
      };
}

class Hijri {
  Hijri({
    this.date,
    required this.format,
    this.day,
    required this.weekday,
    required this.month,
    this.year,
    required this.designation,
    required this.holidays,
  });

  String? date;
  Format format;
  String? day;
  HijriWeekday weekday;
  HijriMonth month;
  String? year;
  Designation designation;
  List<String> holidays;

  factory Hijri.fromJson(Map<String, dynamic> json) => Hijri(
        date: json["date"],
        // format: formatValues.map[json["format"]],
        format: Format.fromStringValue(json["format"]),
        day: json["day"],
        weekday: HijriWeekday.fromJson(json["weekday"]),
        month: HijriMonth.fromJson(json["month"]),
        year: json["year"],
        designation: Designation.fromJson(json["designation"]),
        holidays: List<String>.from(json["holidays"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "date": date,
        "format": {Format: format.value}, //formatValues.reverse[format],
        "day": day,
        "weekday": weekday.toJson(),
        "month": month.toJson(),
        "year": year,
        "designation": designation.toJson(),
        "holidays": List<dynamic>.from(holidays.map((x) => x)),
      };
}

class HijriMonth {
  HijriMonth({
    this.number,
    required this.en,
    required this.ar,
  });

  int? number;
  FluffyEn en;
  Ar ar;

  factory HijriMonth.fromJson(Map<String, dynamic> json) => HijriMonth(
        number: json["number"],
        // en: fluffyEnValues.map[json["en"]],
        // ar: arValues.map[json["ar"]],
        en: FluffyEn.fromStringValue(json["en"]),
        ar: Ar.fromStringValue(json["ar"]),
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "en": {FluffyEn: en.value}, //fluffyEnValues.reverse[en],
        "ar": {Ar: ar.value}, //arValues.reverse[ar],
      };
}

class HijriWeekday {
  HijriWeekday({
    this.en,
    this.ar,
  });

  String? en;
  String? ar;

  factory HijriWeekday.fromJson(Map<String, dynamic> json) => HijriWeekday(
        en: json["en"],
        ar: json["ar"],
      );

  Map<String, dynamic> toJson() => {
        "en": en,
        "ar": ar,
      };
}

class Meta {
  Meta({
    this.latitude,
    this.longitude,
    required this.timezone,
    required this.method,
    required this.latitudeAdjustmentMethod,
    required this.midnightMode,
    required this.school,
    required this.offset,
  });

  double? latitude;
  double? longitude;
  Timezone timezone;
  Method method;
  LatitudeAdjustmentMethod latitudeAdjustmentMethod;
  MidnightMode midnightMode;
  MidnightMode school;
  Map<String, int> offset;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        latitude: json["latitude"].toDouble(),
        longitude: json["longitude"].toDouble(),
        timezone: Timezone.fromStringValue(json["timezone"]),
        method: Method.fromJson(json["method"]),
        latitudeAdjustmentMethod: LatitudeAdjustmentMethod.fromStringValue(
            json["latitudeAdjustmentMethod"]),
        midnightMode: MidnightMode.fromStringValue(json["midnightMode"]),
        school: MidnightMode.fromStringValue(json["school"]),
        offset:
            Map.from(json["offset"]).map((k, v) => MapEntry<String, int>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "timezone": {Timezone: timezone.value},
        "method": method.toJson(),
        "latitudeAdjustmentMethod": {
          LatitudeAdjustmentMethod: latitudeAdjustmentMethod.value
        },
        "midnightMode": {MidnightMode: midnightMode},
        "school": {MidnightMode: school},
        "offset":
            Map.from(offset).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}

class Method {
  Method({
    this.id,
    required this.name,
    required this.params,
  });

  int? id;
  Name name;
  Params params;

  factory Method.fromJson(Map<String, dynamic> json) => Method(
        id: json["id"],
        name: Name.fromStringValue(json["name"]),
        params: Params.fromJson(json["params"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": {Name: name.value},
        "params": params.toJson(),
      };
}

class Params {
  Params({
    this.fajr,
    this.isha,
  });

  String? fajr;
  String? isha;

  factory Params.fromJson(Map<String, dynamic> json) => Params(
        fajr: json["Fajr"].toString(),
        isha: json["Isha"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "Fajr": fajr,
        "Isha": isha,
      };
}

class Timings {
  Timings({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.sunset,
    required this.maghrib,
    required this.isha,
    this.imsak,
    this.midnight,
  });

  String fajr;
  String sunrise;
  String dhuhr;
  String asr;
  String sunset;
  String maghrib;
  String isha;
  String? imsak;
  String? midnight;

  factory Timings.fromJson(Map<String, dynamic> json) => Timings(
        fajr: json["Fajr"],
        sunrise: json["Sunrise"],
        dhuhr: json["Dhuhr"],
        asr: json["Asr"],
        sunset: json["Sunset"],
        maghrib: json["Maghrib"],
        isha: json["Isha"],
        imsak: json["Imsak"],
        midnight: json["Midnight"],
      );

  Map<String, dynamic> toJson() => {
        "Fajr": fajr,
        "Sunrise": sunrise,
        "Dhuhr": dhuhr,
        "Asr": {Asr: Asr.the1531EET},
        "Sunset": sunset,
        "Maghrib": maghrib,
        "Isha": isha,
        "Imsak": imsak,
        "Midnight": midnight,
      };
}

// class EnumValues<T> {
//   Map<String, T> map;
//
//   EnumValues(this.map);
//
//   Map<T, String> get reverse {
//     return map.map((k, v) => MapEntry(v, k));
//   }
// }
