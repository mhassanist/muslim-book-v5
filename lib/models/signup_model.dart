class SignUpModel {
  dynamic data;
  String? client;
  String? message;
  bool? success;

  SignUpModel({
    this.data,
    this.client,
    this.message,
    this.success,
  });
   SignUpModel.fromJson(obj) {
    this.client = obj['client'];
    this.message = obj['message'];
    this.success = obj['success'];
    this.data = obj['data'];
  }
}

class SignUpModelData {
  String? email;
  int? id;
  String? image;
  String? name;
  String? countryId;
  String? flag;
  String? cityId;
  String? country;
  String? city;
  String? apiToken;

  SignUpModelData.fromJson(obj){
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
