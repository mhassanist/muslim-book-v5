
import 'dart:convert';

import 'package:base_app/ramadan/models/ramadan_data.dart';


class MonthRamadanModel {
  int code;
  String status;
  List<RamadanData> data;

  MonthRamadanModel({
    this.code,
    this.status,
    this.data,
  });

  factory MonthRamadanModel.fromJson(String str) =>
      MonthRamadanModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory MonthRamadanModel.fromMap(Map<String, dynamic> json) => MonthRamadanModel(
        code: json["code"],
        status: json["status"],
        data:
            List<RamadanData>.from(json["data"].map((x) => RamadanData.fromJson(x))),
      );

  Map<String, dynamic> toMap() => {
        "code": code,
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}


