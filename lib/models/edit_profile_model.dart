import 'package:base_app/models/base_model.dart';

class EditProfileModel with Model {
  dynamic data;
  late String client;
  late String message;
  late bool success;

  EditProfileModel({
    this.data,
    this.client = '',
    this.message = '',
    this.success = false,
  });

  EditProfileModel.fromJson(Map<String, dynamic> json) {
    client = stringFromJson(json, 'client');
    message = stringFromJson(json, 'message');
    success = boolFromJson(json, 'success');
    this.data = json['data'];
  }
}

class EditProfileModelData with Model {
  late int id;
  late String email;
  late String image;
  late String name;
  late int countryId;
  late int cityId;
  dynamic country;
  dynamic city;
  late int correctAnswer;
  late int wrongAnswer;

  EditProfileModelData({
    this.id = -1,
    this.email = '',
    this.image = '',
    this.name = '',
    this.countryId = -1,
    this.cityId = -1,
    this.country,
    this.city,
    this.correctAnswer = -1,
    this.wrongAnswer = -1,
  });

  EditProfileModelData.fromJson(Map<String, dynamic>? json) {
    if (json != null) {
      id = intFromJson(json, 'id');
      email = stringFromJson(json, 'email');
      image = stringFromJson(json, 'image');
      name = stringFromJson(json, 'name');

      countryId = intFromJson(json, 'country_id');
      cityId = intFromJson(json, 'city_id');

      country = json['country'];
      city = json['city'];

      correctAnswer = intFromJson(json, 'correct_answer');
      wrongAnswer = intFromJson(json, 'wrong_answer');
    }
  }
}
