// To parse this JSON data, do
//
//     final topModel = topModelFromMap(jsonString);

import 'dart:convert';

import 'package:muslim_book/models/user_score.dart';

class TopModel {
  TopModel({
    required this.data,
    this.userScoreModel
  });

  List<TopModelData> data;
  UserScoreModel? userScoreModel;

  factory TopModel.fromJson(String str) => TopModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TopModel.fromMap(Map<String, dynamic> json) => TopModel(
    data: List<TopModelData>.from(json["data"].map((x) => TopModelData.fromMap(x))),
    userScoreModel: UserScoreModel.fromMap(json["user"])
  );

  Map<String, dynamic> toMap() => {
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
  };
}

class TopModelData {
  TopModelData({
    this.id,
    this.email,
    this.image,
    this.name,
    this.countryId,
    this.cityId,
    this.points,
    this.flag,
    this.country,
    this.city,
    this.correctAnswer,
    this.wrongAnswer,
  });

  int? id;
  String? email;
  String? image;
  String? name;
  int? countryId;
  int? cityId;
  int? points;
  String? flag;
  String? country;
  String? city;
  int? correctAnswer;
  int? wrongAnswer;

  factory TopModelData.fromJson(String str) => TopModelData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TopModelData.fromMap(Map<String, dynamic> json) => TopModelData(
    id: json["id"],
    email: json["email"],
    image: json["image"],
    name: json["name"],
    countryId: json["country_id"],
    cityId: json["city_id"],
    points: json["points"],
    flag: json["flag"],
    country: json["country"],
    city: json["city"],
    correctAnswer: json["correct_answer"],
    wrongAnswer: json["wrong_answer"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "email": email,
    "image": image,
    "name": name,
    "country_id": countryId,
    "city_id": cityId,
    "points": points,
    "flag": flag,
    "country": country,
    "city": city,
    "correct_answer": correctAnswer,
    "wrong_answer": wrongAnswer,
  };
}
