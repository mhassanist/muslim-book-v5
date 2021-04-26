
import 'dart:convert';

class UserModel {
  UserModel({
    this.email,
    this.id,
    this.image,
    this.name,
    this.countryId,
    this.flag,
    this.cityId,
    this.country,
    this.city,
    this.apiToken,
  });

  String email;
  int id;
  String image;
  String name;
  var countryId;
  String flag;
  var cityId;
  String country;
  String city;
  String apiToken;

  factory UserModel.fromJson(String str) => UserModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
    email: json["email"],
    id: json["id"],
    image: json["image"],
    name: json["name"],
    countryId: json["country_id"],
    flag: json["flag"],
    cityId: json["city_id"],
    country: json["country"],
    city: json["city"],
    apiToken: json["api_token"],
  );

  Map<String, dynamic> toMap() => {
    "email": email,
    "id": id,
    "image": image,
    "name": name,
    "country_id": countryId,
    "flag": flag,
    "city_id": cityId,
    "country": country,
    "city": city,
    "api_token": apiToken,
  };
}
