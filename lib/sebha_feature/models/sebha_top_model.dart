// To parse this JSON data, do
//
//     final sebhaTopModel = sebhaTopModelFromMap(jsonString);

import 'dart:convert';

class SebhaTopModel {
  SebhaTopModel({
    this.list,
    this.client,
    this.message,
    this.success,
  });

  List<SebhaTopModelData> list;
  String client;
  String message;
  bool success;

  factory SebhaTopModel.fromJson(String str) =>
      SebhaTopModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SebhaTopModel.fromMap(Map<String, dynamic> json) => SebhaTopModel(
        list: List<SebhaTopModelData>.from(
            json["data"].map((x) => SebhaTopModelData.fromMap(x))),
        client: json["client"],
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(list.map((x) => x.toMap())),
        "client": client,
        "message": message,
        "success": success,
      };
}

class SebhaTopModelData {
  SebhaTopModelData(
      {this.total,
      this.id,
      this.email,
      this.image,
      this.name,
      this.countryId,
      this.flag,
      this.country,
      this.rank});

  int total;
  int id;
  String email;
  String image;
  String name;
  int countryId;
  String flag;
  String country;
  int rank;
  factory SebhaTopModelData.fromJson(String str) =>
      SebhaTopModelData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SebhaTopModelData.fromMap(Map<String, dynamic> json) =>
      SebhaTopModelData(
        total: json["total"],
        id: json["id"],
        email: json["email"],
        image: json["image"],
        rank: json["rank"],
        name: json["name"],
        countryId: json["country_id"],
        flag: json["flag"],
        country: json["country"],
      );

  Map<String, dynamic> toMap() => {
        "total": total,
        "id": id,
        "email": email,
        "image": image,
        "name": name,
        "country_id": countryId,
        "flag": flag,
        "country": country,
      };
}
