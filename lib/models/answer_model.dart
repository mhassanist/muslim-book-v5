import 'dart:convert';

class AnswerModel {
  AnswerModel({
    this.data,
  });

  AnswerModelData data;

  factory AnswerModel.fromJson(String str) => AnswerModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AnswerModel.fromMap(Map<String, dynamic> json) => AnswerModel(
    data: AnswerModelData.fromMap(json["data"]),
  );

  Map<String, dynamic> toMap() => {
    "data": data.toMap(),
  };
}

class AnswerModelData {
  AnswerModelData({
    this.result,
    this.points,
    this.hasAdditional,
    this.rank,
    this.correctAnswer,
    this.wrongAnswer,
  });

  bool result;
  int points;
  bool hasAdditional;
  int rank;
  int correctAnswer;
  int wrongAnswer;

  factory AnswerModelData.fromJson(String str) => AnswerModelData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AnswerModelData.fromMap(Map<String, dynamic> json) => AnswerModelData(
    result: json["result"],
    points: json["points"],
    hasAdditional: json["has_additional"],
    rank: json["rank"],
    correctAnswer: json["correct_answer"],
    wrongAnswer: json["wrong_answer"],
  );

  Map<String, dynamic> toMap() => {
    "result": result,
    "points": points,
    "has_additional": hasAdditional,
    "rank": rank,
    "correct_answer": correctAnswer,
    "wrong_answer": wrongAnswer,
  };
}
