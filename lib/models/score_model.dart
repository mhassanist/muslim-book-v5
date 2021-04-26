// To parse this JSON data, do
//
//     final scoreModel = scoreModelFromMap(jsonString);

import 'dart:convert';

class ScoreModel {
  ScoreModel({
    this.data,
  });

  ScoreModelData data;

  factory ScoreModel.fromJson(String str) => ScoreModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ScoreModel.fromMap(Map<String, dynamic> json) => ScoreModel(
    data: ScoreModelData.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "data": data.toMap(),
  };
}

class ScoreModelData {
  ScoreModelData({
    this.id,
    this.email,
    this.image,
    this.name,
    this.countryId,
    this.cityId,
    this.points, //points in competition
    this.flag,
    this.country,
    this.city,
    this.correctAnswer,
    this.wrongAnswer,
    this.rank, //rank in competition
    this.reminds, //rank in competition
    this.remindsRank, //rank in competition
  });

  int id;
  String email;
  String image;
  String name;
  int countryId;
  int cityId;
  int points;
  String flag;
  String country;
  String city;
  int correctAnswer;
  int wrongAnswer;
  int rank;
  String reminds;
  int remindsRank;

  factory ScoreModelData.fromJson(String str) => ScoreModelData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ScoreModelData.fromMap(Map<String, dynamic> json) => ScoreModelData(
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
    rank: json["rank"],
    reminds: json["reminds"].toString(),
    remindsRank: json["reminds_rank"],
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
    "rank": rank,
  };
}
