class LoginModel {
  dynamic data;
  String client;
  String message;
  bool success;
  // List<String> errors;
  LoginModel({
    this.data,
    this.client,
    this.message,
    this.success,
    // this.errors
  });
  LoginModel.fromJson(obj) {
    this.client = obj['client'];
    this.message = obj['message'];
    this.success = obj['success'];
    this.data = obj['data'];
    // this.data = obj['errors'];
  }
}

class LoginModelData {
  String email;
  int id;
  String image;
  String name;
  int countryId;
  String flag;
  int cityId;
  String country;
  String city;
  String apiToken;

  LoginModelData.fromJson(obj) {
    this.email = obj['email'];
    this.name = obj['name'];
    this.id = obj['id'];
    this.image = obj['image'];
    this.countryId = obj['country_id'];
    this.flag = obj['flag'];
    this.cityId = obj['city_id'];
    this.city = obj['city'];
    this.country = obj['country'];
    this.apiToken = obj['api_token'];
  }
}
