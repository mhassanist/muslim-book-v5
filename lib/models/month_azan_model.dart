// To parse this JSON data, do
//
//     final monthAzanModel = monthAzanModelFromJson(jsonString);

import 'dart:convert';

import 'dart:ffi';

import 'package:base_app/models/base_model.dart';

MonthAzanModel monthAzanModelFromJson(String str) => MonthAzanModel.fromJson(json.decode(str));

String monthAzanModelToJson(MonthAzanModel data) => json.encode(data.toJson());

class MonthAzanModel with Model {
  MonthAzanModel({
    this.code = -1,
    this.status = '',
    List<AzanModel>? data,
  }) {
    this.data = data ?? <AzanModel>[];
  }

  late int code;
  late String status;
  late List<AzanModel> data;

  factory MonthAzanModel.fromJson(String str) =>
      MonthAzanModel.fromMap(json.decode(str));

  MonthAzanModel.fromMap(Map<String, dynamic> json) {
    code = intFromJson(json, 'code');
    status = stringFromJson(json, 'status');
    data = listFromJson(json, 'data', (v) => AzanModel.fromJson(v));
  }

  Map<String, dynamic> toJson() => {
    "code": code,
    "status": status,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class AzanModel with Model {
  AzanModel({
    this.timings,
    this.date,
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

class Date with Model {
  Date({
    this.readable,
    this.timestamp,
    this.gregorian,
    this.hijri,
  });

  String readable;
  String timestamp;
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

class Gregorian with Model {
  Gregorian({
    this.date,
    this.format,
    this.day,
    this.weekday,
    this.month,
    this.year,
    this.designation,
  });

  String date;
  Format format;
  String day;
  GregorianWeekday weekday;
  GregorianMonth month;
  String year;
  Designation designation;

  factory Gregorian.fromJson(Map<String, dynamic> json) => Gregorian(
    date: json["date"],
    format: formatValues.map[json["format"]],
    day: json["day"],
    weekday: GregorianWeekday.fromJson(json["weekday"]),
    month: GregorianMonth.fromJson(json["month"]),
    year: json["year"],
    designation: Designation.fromJson(json["designation"]),
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "format": formatValues.reverse[format],
    "day": day,
    "weekday": weekday.toJson(),
    "month": month.toJson(),
    "year": year,
    "designation": designation.toJson(),
  };
}

class Designation with Model {
  Designation({
    this.abbreviated,
    this.expanded,
  });

  Abbreviated abbreviated;
  Expanded expanded;

  factory Designation.fromJson(Map<String, dynamic> json) => Designation(
    abbreviated: abbreviatedValues.map[json["abbreviated"]],
    expanded: expandedValues.map[json["expanded"]],
  );

  Map<String, dynamic> toJson() => {
    "abbreviated": abbreviatedValues.reverse[abbreviated],
    "expanded": expandedValues.reverse[expanded],
  };
}

enum Abbreviated { AD, AH }

final abbreviatedValues = EnumValues({
  "AD": Abbreviated.AD,
  "AH": Abbreviated.AH
});

enum Expanded { ANNO_DOMINI, ANNO_HEGIRAE }

final expandedValues = EnumValues({
  "Anno Domini": Expanded.ANNO_DOMINI,
  "Anno Hegirae": Expanded.ANNO_HEGIRAE
});

enum Format { DD_MM_YYYY }

final formatValues = EnumValues({
  "DD-MM-YYYY": Format.DD_MM_YYYY
});

class GregorianMonth with Model {
  GregorianMonth({
    this.number,
    this.en,
  });

  int number;
  PurpleEn en;

  factory GregorianMonth.fromJson(Map<String, dynamic> json) => GregorianMonth(
    number: json["number"],
    en: purpleEnValues.map[json["en"]],
  );

  Map<String, dynamic> toJson() => {
    "number": number,
    "en": purpleEnValues.reverse[en],
  };
}

enum PurpleEn { APRIL }

final purpleEnValues = EnumValues({
  "April": PurpleEn.APRIL
});

class GregorianWeekday with Model {
  GregorianWeekday({
    this.en,
  });

  String en;

  factory GregorianWeekday.fromJson(Map<String, dynamic> json) => GregorianWeekday(
    en: json["en"],
  );

  Map<String, dynamic> toJson() => {
    "en": en,
  };
}

class Hijri with Model {
  Hijri({
    this.date,
    this.format,
    this.day,
    this.weekday,
    this.month,
    this.year,
    this.designation,
    this.holidays,
  });

  String date;
  Format format;
  String day;
  HijriWeekday weekday;
  HijriMonth month;
  String year;
  Designation designation;
  List<String> holidays;

  factory Hijri.fromJson(Map<String, dynamic> json) => Hijri(
    date: json["date"],
    format: formatValues.map[json["format"]],
    day: json["day"],
    weekday: HijriWeekday.fromJson(json["weekday"]),
    month: HijriMonth.fromJson(json["month"]),
    year: json["year"],
    designation: Designation.fromJson(json["designation"]),
    holidays: List<String>.from(json["holidays"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "date": date,
    "format": formatValues.reverse[format],
    "day": day,
    "weekday": weekday.toJson(),
    "month": month.toJson(),
    "year": year,
    "designation": designation.toJson(),
    "holidays": List<dynamic>.from(holidays.map((x) => x)),
  };
}

class HijriMonth with Model {
  HijriMonth({
    this.number,
    this.en,
    this.ar,
  });

  int number;
  FluffyEn en;
  Ar ar;

  factory HijriMonth.fromJson(Map<String, dynamic> json) => HijriMonth(
    number: json["number"],
    en: fluffyEnValues.map[json["en"]],
    ar: arValues.map[json["ar"]],
  );

  Map<String, dynamic> toJson() => {
    "number": number,
    "en": fluffyEnValues.reverse[en],
    "ar": arValues.reverse[ar],
  };
}

enum Ar { EMPTY, AR }

final arValues = EnumValues({
  "رَمَضان": Ar.AR,
  "شَعْبان": Ar.EMPTY
});

enum FluffyEn { SHA_BN, RAMAN }

final fluffyEnValues = EnumValues({
  "Ramaḍān": FluffyEn.RAMAN,
  "Shaʿbān": FluffyEn.SHA_BN
});

class HijriWeekday with Model {
  HijriWeekday({
    this.en,
    this.ar,
  });

  String en;
  String ar;

  factory HijriWeekday.fromJson(Map<String, dynamic> json) => HijriWeekday(
    en: json["en"],
    ar: json["ar"],
  );

  Map<String, dynamic> toJson() => {
    "en": en,
    "ar": ar,
  };
}

class Meta with Model {
  Meta({
    this.latitude,
    this.longitude,
    this.timezone,
    this.method,
    this.latitudeAdjustmentMethod,
    this.midnightMode,
    this.school,
    this.offset,
  });

  double latitude;
  double longitude;
  Timezone timezone;
  Method method;
  LatitudeAdjustmentMethod latitudeAdjustmentMethod;
  MidnightMode midnightMode;
  MidnightMode school;
  Map<String, int> offset;

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    timezone: timezoneValues.map[json["timezone"]],
    method: Method.fromJson(json["method"]),
    latitudeAdjustmentMethod: latitudeAdjustmentMethodValues.map[json["latitudeAdjustmentMethod"]],
    midnightMode: midnightModeValues.map[json["midnightMode"]],
    school: midnightModeValues.map[json["school"]],
    offset: Map.from(json["offset"]).map((k, v) => MapEntry<String, int>(k, v)),
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "timezone": timezoneValues.reverse[timezone],
    "method": method.toJson(),
    "latitudeAdjustmentMethod": latitudeAdjustmentMethodValues.reverse[latitudeAdjustmentMethod],
    "midnightMode": midnightModeValues.reverse[midnightMode],
    "school": midnightModeValues.reverse[school],
    "offset": Map.from(offset).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}

enum LatitudeAdjustmentMethod { ANGLE_BASED }

final latitudeAdjustmentMethodValues = EnumValues({
  "ANGLE_BASED": LatitudeAdjustmentMethod.ANGLE_BASED
});

class Method with Model {
  Method({
    this.id,
    this.name,
    this.params,
  });

  late int id;
  late Name name;
  late Params params;

  // Method.fromJson(Map<String, dynamic> json) {
  //   id = intFromJson(json, 'id');
  //   name = nameValues.map[stringFromJson(json, 'name')];
  // }

  factory Method.fromJson(Map<String, dynamic> json) => Method(
    id: json[""],
    name: nameValues.map[json["name"]],
    params: Params.fromJson(json["params"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": nameValues.reverse[name],
    "params": params.toJson(),
  };
}

enum Name { EGYPTIAN_GENERAL_AUTHORITY_OF_SURVEY }

final nameValues = EnumValues({
  "Egyptian General Authority of Survey": Name.EGYPTIAN_GENERAL_AUTHORITY_OF_SURVEY
});

class Params with Model {
  Params({
    this.fajr = '',
    this.isha = '',
  });

  late String fajr;
  late String isha;
  Params.fromJson(Map<String, dynamic> json) {
    fajr= stringFromJson(json, 'Fajr');
    isha= stringFromJson(json, 'Isha');
  }


  Map<String, dynamic> toJson() => {
    "Fajr": fajr,
    "Isha": isha,
  };
}

enum MidnightMode { STANDARD }

final midnightModeValues = EnumValues({
  "STANDARD": MidnightMode.STANDARD
});

enum Timezone with Model { AFRICA_CAIRO }

final timezoneValues = EnumValues({
  "Africa/Cairo": Timezone.AFRICA_CAIRO
});

class Timings with Model {
  Timings({
    this.fajr = '',
    this.sunrise = '',
    this.dhuhr = '',
    this.asr = '',
    this.sunset = '',
    this.maghrib = '',
    this.isha = '',
    this.imsak = '',
    this.midnight = '',
  });

  late String fajr;
  late String sunrise;
  late String dhuhr;
  late String asr;
  late String sunset;
  late String maghrib;
  late String isha;
  late String imsak;
  late String midnight;

  Timings.fromJson(Map<String, dynamic> json) {
    fajr= stringFromJson(json, 'Fajr');
    sunrise= stringFromJson(json, 'Sunrise');
    dhuhr= stringFromJson(json, 'Dhuhr');
    asr= stringFromJson(json, 'Asr');
    sunset= stringFromJson(json, 'Sunset');
    maghrib= stringFromJson(json, 'Maghrib');
    isha= stringFromJson(json, 'Isha');
    imsak= stringFromJson(json, 'Imsak');
    midnight= stringFromJson(json, 'Midnight');
  }

  Map<String, dynamic> toJson() => {
    "Fajr": fajr,
    "Sunrise": sunrise,
    "Dhuhr": dhuhr,
    "Asr": asrValues.reverse[asr],
    "Sunset": sunset,
    "Maghrib": maghrib,
    "Isha": isha,
    "Imsak": imsak,
    "Midnight": midnight,
  };
}

enum Asr { THE_1531_EET }

final asrValues = EnumValues({
  "15:31 (EET)": Asr.THE_1531_EET
});

class EnumValues<T> with Model {
  late Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map,);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap ?? map.map((k, v) => new MapEntry(v, k));
  }
}




//
// import 'dart:convert';
//
// class MonthAzanModel {
//   int code;
//   String status;
//   List<AzanModel> data;
//
//   MonthAzanModel({
//     this.code,
//     this.status,
//     this.data,
//   });
//
//   factory MonthAzanModel.fromJson(String str) =>
//       MonthAzanModel.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory MonthAzanModel.fromMap(Map<String, dynamic> json) => MonthAzanModel(
//         code: json["code"],
//         status: json["status"],
//         data:
//             List<AzanModel>.from(json["data"].map((x) => AzanModel.fromMap(x))),
//       );
//
//   Map<String, dynamic> toMap() => {
//         "code": code,
//         "status": status,
//         "data": List<dynamic>.from(data.map((x) => x.toMap())),
//       };
// }
//
// class AzanModel {
//   AzanTimes timings;
//   MonthData monthData;
//
//   AzanModel({
//     this.timings,
//     this.monthData
//   });
//
//   factory AzanModel.fromJson(String str) => AzanModel.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory AzanModel.fromMap(Map<String, dynamic> json) => AzanModel(
//         timings: AzanTimes.fromMap(json["timings"]),
//     monthData: MonthData.fromMap(json["date"]),
//
//       );
//
//   Map<String, dynamic> toMap() => {
//         "timings": timings.toMap(),
//
//       };
// }
//
// class AzanTimes {
//   String fajr;
//   String sunrise;
//   String dhuhr;
//   String asr;
//   String sunset;
//   String maghrib;
//   String isha;
//   String imsak;
//   String midnight;
//
//   AzanTimes({
//     this.fajr,
//     this.sunrise,
//     this.dhuhr,
//     this.asr,
//     this.sunset,
//     this.maghrib,
//     this.isha,
//     this.imsak,
//     this.midnight,
//   });
//
//   factory AzanTimes.fromJson(String str) => AzanTimes.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory AzanTimes.fromMap(Map<String, dynamic> json) => AzanTimes(
//         fajr: json["Fajr"],
//         sunrise: json["Sunrise"],
//         dhuhr: json["Dhuhr"],
//         asr: json["Asr"],
//         sunset: json["Sunset"],
//         maghrib: json["Maghrib"],
//         isha: json["Isha"],
//         imsak: json["Imsak"],
//         midnight: json["Midnight"],
//       );
//
//   Map<String, dynamic> toMap() => {
//         "Fajr": fajr,
//         "Sunrise": sunrise,
//         "Dhuhr": dhuhr,
//         "Asr": asr,
//         "Sunset": sunset,
//         "Maghrib": maghrib,
//         "Isha": isha,
//         "Imsak": imsak,
//         "Midnight": midnight,
//       };
// }
//
// class MonthData {
//   MonthData({
//     this.gregorian,
//   });
//
//   Gregorian gregorian;
//
//   factory MonthData.fromJson(String str) => MonthData.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory MonthData.fromMap(Map<String, dynamic> json) => MonthData(
//     gregorian: Gregorian.fromMap(json["gregorian"]),
//   );
//
//   Map<String, dynamic> toMap() => {
//     "gregorian": gregorian.toMap(),
//   };
// }
//
// class Gregorian {
//   Gregorian({
//     this.month,
//   });
//
//   Month month;
//
//   factory Gregorian.fromJson(String str) => Gregorian.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory Gregorian.fromMap(Map<String, dynamic> json) => Gregorian(
//     month: Month.fromMap(json["month"]),
//   );
//
//   Map<String, dynamic> toMap() => {
//     "month": month.toMap(),
//   };
// }
//
// class Month {
//   Month({
//     this.number,
//   });
//
//   int number;
//
//   factory Month.fromJson(String str) => Month.fromMap(json.decode(str));
//
//   String toJson() => json.encode(toMap());
//
//   factory Month.fromMap(Map<String, dynamic> json) => Month(
//     number: json["number"],
//   );
//
//   Map<String, dynamic> toMap() => {
//     "number": number,
//   };
// }
