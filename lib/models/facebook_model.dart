// To parse this JSON data, do
//
//     final facebookModel = facebookModelFromMap(jsonString);

import 'dart:convert';

class FacebookModel {
  FacebookModel({
    this.name,
    this.firstName,
    this.lastName,
    this.email,
    this.id,
  });

  String? name;
  String? firstName;
  String? lastName;
  String? email;
  String? id;
  String? image;

  factory FacebookModel.fromJson(String str) => FacebookModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FacebookModel.fromMap(Map<String, dynamic> json) => FacebookModel(
    name: json["name"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    email: json["email"],
    id: json["id"],
  );

  Map<String, dynamic> toMap() => {
    "name": name,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "id": id,
  };
}
