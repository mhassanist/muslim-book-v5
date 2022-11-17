import 'dart:convert';

import 'package:base_app/models/base_model.dart';

class AnswerModel {
  late AnswerModelData data;

  AnswerModel({
    AnswerModelData? data,
  }) {
    this.data = data ?? AnswerModelData();
  }

  factory AnswerModel.fromJson(String str) =>
      AnswerModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AnswerModel.fromMap(Map<String, dynamic> json) => AnswerModel(
        data: AnswerModelData.fromMap(json["data"]),
      );

  Map<String, dynamic> toMap() => {
        "data": data.toMap(),
      };
}

class AnswerModelData with Model {
  AnswerModelData({
    this.result = false,
    this.points = 0,
    this.hasAdditional = false,
    this.rank = 0,
    this.correctAnswer = -1,
    this.wrongAnswer = -1,
  });

  late bool result;
  late int points;
  late bool hasAdditional;
  late int rank;
  late int correctAnswer;
  late int wrongAnswer;

  factory AnswerModelData.fromJson(String str) =>
      AnswerModelData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  AnswerModelData.fromMap(Map<String, dynamic> json) {
    result = boolFromJson(json, 'result');
    points = intFromJson(json, 'points');
    hasAdditional = boolFromJson(json, 'has_additional');
    rank = intFromJson(json, 'rank');
    correctAnswer = intFromJson(json, 'correct_answer');
    wrongAnswer = intFromJson(json, 'wrong_answer');
  }

  Map<String, dynamic> toMap() => {
        "result": result,
        "points": points,
        "has_additional": hasAdditional,
        "rank": rank,
        "correct_answer": correctAnswer,
        "wrong_answer": wrongAnswer,
      };
}
