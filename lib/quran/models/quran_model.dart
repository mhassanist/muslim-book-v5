import 'dart:convert';

import 'package:muslim_book/quran/models/reciters_model.dart';
import 'package:hive/hive.dart';

part 'quran_model.g.dart';

@HiveType(typeId: 0)
class QuranModel extends HiveObject {
  QuranModel({
    required this.surahs,
  });

  @HiveField(0)
  List<Surah> surahs;

  factory QuranModel.fromJson(String str) =>
      QuranModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QuranModel.fromMap(Map<String, dynamic> json) => QuranModel(
        surahs: List<Surah>.from(json["surahs"].map((x) => Surah.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "surahs": List<dynamic>.from(surahs.map((x) => x.toMap())),
      };
}

@HiveType(typeId: 1)
class Surah {
  Surah(
      {required this.number,
      required this.name,
      required this.englishName,
      required this.englishNameTranslation,
      required this.revelationType,
      required this.ayahs,
      this.progress});

  @HiveField(0)
  int number;
  @HiveField(1)
  String name;
  @HiveField(2)
  String englishName;
  @HiveField(3)
  String englishNameTranslation;
  @HiveField(4)
  String revelationType;
  @HiveField(5)
  List<Ayah> ayahs;
  @HiveField(6)
  int? progress;

  factory Surah.fromJson(String str) => Surah.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Surah.fromMap(Map<String, dynamic> json) => Surah(
        number: json["number"],
        name: json["name"],
        englishName: json["englishName"],
        englishNameTranslation: json["englishNameTranslation"],
        revelationType: json["revelationType"],
        ayahs: List<Ayah>.from(json["ayahs"].map((x) => Ayah.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "number": number,
        "name": name,
        "englishName": englishName,
        "englishNameTranslation": englishNameTranslation,
        "revelationType": revelationType,
        "ayahs": List<dynamic>.from(ayahs.map((x) => x.toMap())),
      };
}

@HiveType(typeId: 2)
class Ayah {
  Ayah({
    this.number,
    required this.text,
    this.numberInSurah,
    this.juz,
    this.manzil,
    this.page,
    this.ruku,
    this.hizbQuarter,
    this.sajda,
  });

  @HiveField(0)
  int? number;
  @HiveField(1)
  String text;
  @HiveField(2)
  int? numberInSurah;
  @HiveField(3)
  int? juz;
  @HiveField(4)
  int? manzil;
  @HiveField(5)
  int? page;
  @HiveField(6)
  int? ruku;
  @HiveField(7)
  int? hizbQuarter;
  @HiveField(8)
  var sajda;

  factory Ayah.fromJson(String str) => Ayah.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Ayah.fromMap(Map<String, dynamic> json) => Ayah(
        number: json["number"],
        text: json["text"],
        numberInSurah: json["numberInSurah"],
        juz: json["juz"],
        manzil: json["manzil"],
        page: json["page"],
        ruku: json["ruku"],
        hizbQuarter: json["hizbQuarter"],
        sajda: json["sajda"],
      );

  Map<String, dynamic> toMap() => {
        "number": number,
        "text": text,
        "numberInSurah": numberInSurah,
        "juz": juz,
        "manzil": manzil,
        "page": page,
        "ruku": ruku,
        "hizbQuarter": hizbQuarter,
        "sajda": sajda,
      };
}

@HiveType(typeId: 3)
class QuranUserModel extends HiveObject {
  @HiveField(0)
  int? lastReadSurahId;

  @HiveField(1)
  int? lastReadAyahId;

  @HiveField(2)
  QuranTypeData? selectedReciter;

  @HiveField(3)
  bool? allowTranslation;

  @HiveField(4)
  bool? allowTransliteration;

  @HiveField(5)
  String? selectedTranslation;

  @HiveField(6)
  String? selectedTransliteration;

  QuranUserModel({
    this.lastReadAyahId,
    this.lastReadSurahId,
    this.selectedReciter,
    this.allowTranslation,
    this.allowTransliteration,
  });
}
