import 'package:base_app/models/base_model.dart';

class LoginModel with Model {
  dynamic data;
  late String client;
  late String message;
  late bool success;

  // List<String> errors;
  LoginModel({
    this.data,
    this.client = '',
    this.message = '',
    this.success = false,
    // this.errors
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    client = stringFromJson(json, 'client');
    message = stringFromJson(json, 'message');
    success = boolFromJson(json, 'success');
    data = json['data'];
  }
}

class LoginModelData with Model {
  late int id;
  late int countryId;
  late int cityId;

  late String email;
  late String image;
  late String name;
  late String flag;
  late String country;
  late String city;
  late String apiToken;

  LoginModelData.fromJson(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    countryId = intFromJson(json, 'country_id');
    cityId = intFromJson(json, 'city_id');

    email = stringFromJson(json, 'email');
    name = stringFromJson(json, 'name');
    image = stringFromJson(json, 'image');
    flag = stringFromJson(json, 'flag');
    city = stringFromJson(json, 'city');
    country = stringFromJson(json, 'country');
    apiToken = stringFromJson(json, 'api_token');
  }
}
