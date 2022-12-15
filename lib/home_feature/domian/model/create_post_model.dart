import 'package:muslim_book/home_feature/domian/model/post_model.dart';

class ResponseCreateModel {
  Post? data;
  String? client;
  String? message;
  bool? success;

  ResponseCreateModel({
    this.data,
    this.client,
    this.message,
    this.success,
  });

  ResponseCreateModel.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null ? new Post.fromJson(json['data']) : null;
    client = json['client'];
    message = json['message'];
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['client'] = this.client;
    data['message'] = this.message;
    data['success'] = this.success;
    return data;
  }
}
