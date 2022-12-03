class EditProfileModel {
  dynamic data;
  String? client;
  String? message;
  bool? success;

  EditProfileModel({
    this.data,
    this.client,
    this.message,
    this.success,
  });

  EditProfileModel.fromJson(obj) {
    this.client = obj['client'];
    this.message = obj['message'];
    this.success = obj['success'];
    this.data = obj['data'];
  }
}

class EditProfileModelData {
  int? id;
  String? email;
  String? image;
  String? name;
  int? countryId;
  int? cityId;
  dynamic country;
  dynamic city;
  int? correctAnswer;
  int? wrongAnswer;

  EditProfileModelData({
    this.id,
    this.email,
    this.image,
    this.name,
    this.countryId,
    this.cityId,
    this.country,
    this.city,
    this.correctAnswer,
    this.wrongAnswer,
  });

  EditProfileModelData.fromJson(obj) {
    if (obj != null) {
      this.id = obj['id'];
      this.email = obj['email'];
      this.image = obj['image'];
      this.name = obj['name'];
      this.countryId = obj['country_id'];
      this.cityId = obj['city_id'];
      this.country = obj['country'];
      this.city = obj['city'];
      this.correctAnswer = obj['correct_answer'];
      this.wrongAnswer = obj['wrong_answer'];
    }
  }
}
