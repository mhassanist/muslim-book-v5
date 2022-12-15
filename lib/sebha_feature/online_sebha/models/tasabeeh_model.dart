// To parse this JSON tasbeehList, do
//
//     final tasabeehModel = tasabeehModelFromMap(jsonString);

import 'dart:convert';

class TasabeehModel {
  TasabeehModel({
    this.tasbeehList,
    this.client,
    this.message,
    this.success,
  });

  List<TasbeehModel> tasbeehList;
  String client;
  String message;
  bool success;

  factory TasabeehModel.fromJson(String str) =>
      TasabeehModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TasabeehModel.fromMap(Map<String, dynamic> json) => TasabeehModel(
        tasbeehList: List<TasbeehModel>.from(
            json["data"].map((x) => TasbeehModel.fromMap(x))),
        client: json["client"],
        message: json["message"],
        success: json["success"],
      );

  Map<String, dynamic> toMap() => {
        "tasbeehList": List<dynamic>.from(tasbeehList.map((x) => x.toMap())),
        "client": client,
        "message": message,
        "success": success,
      };
}

class TasbeehModel {
  TasbeehModel(
      {this.id,
      this.content,
      this.count,
      this.note,
      this.editable,
      this.counted = 0,
      this.totalCounted = 0});

  int id;
  String content;
  int count;
  String note;
  bool editable;
  int counted;
  int totalCounted;

  factory TasbeehModel.fromJson(String str) =>
      TasbeehModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TasbeehModel.fromMap(Map<String, dynamic> json) => TasbeehModel(
        id: json["id"],
        content: json["content"],
        count: int.parse(json["count"]),
        note: json["note"] == null ? "" : json["note"],
        editable: json["editable"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "content": content,
        "count": count,
        "note": note == null ? "" : note,
        "editable": editable,
      };
}
