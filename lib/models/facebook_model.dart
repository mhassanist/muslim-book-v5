import 'dart:convert';

import 'package:base_app/models/base_model.dart';

class FacebookModel with Model {
  FacebookModel({
    this.name = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.id = '',
  });

  late String name;
  late String firstName;
  late String lastName;
  late String email;
  late String id;
  late String image;

  factory FacebookModel.fromJson(String str) => FacebookModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  FacebookModel.fromMap(Map<String, dynamic> json) {
    name = stringFromJson(json, 'name');
    firstName = stringFromJson(json, 'first_name');
    lastName = stringFromJson(json, 'last_name');
    email = stringFromJson(json, 'email');
    id = stringFromJson(json, 'id');
    image = stringFromJson(json, 'image');
  }

  Map<String, dynamic> toMap() => {
    "name": name,
    "first_name": firstName,
    "last_name": lastName,
    "email": email,
    "id": id,
  };
}
