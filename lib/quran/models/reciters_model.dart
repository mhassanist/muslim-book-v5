import 'dart:convert';

import 'package:hive/hive.dart';

part 'reciters_model.g.dart';

@HiveType(typeId: 4)
class QuranTypeModel {
  QuranTypeModel({
    this.data,
  });

  @HiveField(0)
  List<QuranTypeData> data;

  factory QuranTypeModel.fromJson(String str) =>
      QuranTypeModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QuranTypeModel.fromMap(Map<String, dynamic> json) => QuranTypeModel(
        data: List<QuranTypeData>.from(
            json["data"].map((x) => QuranTypeData.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

@HiveType(typeId: 5)
class QuranTypeData {
  QuranTypeData(
      {this.identifier, this.language, this.name, this.englishName, this.type});

  @HiveField(0)
  String identifier;
  @HiveField(1)
  String language;
  @HiveField(2)
  String name;
  @HiveField(3)
  String englishName;

  @HiveField(4)
  String type;

  factory QuranTypeData.fromJson(String str) =>
      QuranTypeData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QuranTypeData.fromMap(Map<String, dynamic> json) => QuranTypeData(
        identifier: json["identifier"],
        language: json["language"],
        name: json["name"],
        type: json["type"],
        englishName: json["englishName"],
      );

  Map<String, dynamic> toMap() => {
        "identifier": identifier,
        "language": language,
        "name": name,
        "englishName": englishName,
      };
}
