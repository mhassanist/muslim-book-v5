// To parse this JSON data, do
//
//     final azkarModel = azkarModelFromMap(jsonString);

import 'dart:convert';

class AzkarModel {
  AzkarModel({
    this.azkar = const <Zikr>[],
  });

  List<Zikr> azkar;

  factory AzkarModel.fromJson(String str) =>
      AzkarModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AzkarModel.fromMap(Map<String, dynamic> json) => AzkarModel(
        azkar: List<Zikr>.from(json["azkar"].map((x) => Zikr.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "azkar": List<dynamic>.from(azkar.map((x) => x.toMap())),
      };
}

class Zikr {
  Zikr({
    this.content,
    this.counter = 0,
    this.url,
    this.counted = 0,
    this.notes,
  });

  String? content;
  String? notes;
  int counter;
  int counted;
  String? url;

  factory Zikr.fromJson(String str) => Zikr.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Zikr.fromMap(Map<String, dynamic> json) => Zikr(
        content: json["content"],
        notes: json["notes"],
        counter: json["counter"],
        url: json["url"],
      );

  Map<String, dynamic> toMap() => {
        "content": content,
        "counter": counter,
        "url": url,
      };
}
