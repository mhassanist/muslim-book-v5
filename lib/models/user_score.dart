import 'dart:convert';

class UserScoreModel {

  UserScoreModel({
    this.id,
    this.email,
    this.image,
    this.name = '',
    this.countryId,
    this.cityId,
    this.points = 0,
    this.flag = '',
    this.country = '',
    this.city,
    this.correctAnswer = 0,
    this.wrongAnswer = 0,
    this.rank = 0,
    this.total
  });

  int? id;
  String? email;
  dynamic image;
  String name;
  int? countryId;
  int? cityId;
  int points;
  String flag;
  String country;
  String? city;
  int correctAnswer;
  int wrongAnswer;
  int rank;
  int? total;


  factory UserScoreModel.fromJson(String str) => UserScoreModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserScoreModel.fromMap(Map<String, dynamic> json) => UserScoreModel(
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
    total: json["total"],
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
