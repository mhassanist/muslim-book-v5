
import 'dart:convert';

class CountriesModel {
  List<CountryModel>? data;
  String? client;
  String? message;
  bool? success;

  CountriesModel({
    this.data,
    this.client,
    this.message,
    this.success,
  });

  factory CountriesModel.fromJson(String str) => CountriesModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CountriesModel.fromMap(Map<String, dynamic> json) => CountriesModel(
    data: List<CountryModel>.from(json["data"].map((x) => CountryModel.fromMap(x))),
    client: json["client"],
    message: json["message"],
    success: json["success"],
  );

  Map<String, dynamic> toMap() => {
    "data": data != null
        ? List<dynamic>.from(data!.map((x) => x.toMap()))
        : '',
    "client": client,
    "message": message,
    "success": success,
  };
}

class CountryModel {
  int? id;
  String? flag;
  String? iso;
  String? name;

  CountryModel({
    this.id,
    this.flag,
    this.iso,
    this.name,
  });

  factory CountryModel.fromJson(String str) => CountryModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory CountryModel.fromMap(Map<String, dynamic> json) => CountryModel(
    id: json["id"],
    flag: json["flag"],
    iso: json["iso"],
    name: json["name"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "flag": flag,
    "iso": iso,
    "name": name,
  };
}
