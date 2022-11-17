import 'package:base_app/models/base_model.dart';

class AnswerResultModel with Model {
  late dynamic data;
  late String client;
  late String message;
  late bool success;

  AnswerResultModel({
    this.data,
    this.client = '',
    this.message = '',
    this.success = false,
  });

  AnswerResultModel.fromJson(json) {
    data = json['data'];
    client = stringFromJson(json, 'client');
    message = stringFromJson(json, 'message');
    success = boolFromJson(json, 'success');
  }
}

class AnswerResultModelData with Model {
  late bool result;
  late int points;
  late bool hasAdditional;
  late dynamic additional;

  AnswerResultModelData({
    this.result = false,
    this.points = 0,
    this.hasAdditional = false,
    this.additional,
  });

  AnswerResultModelData.fromJson(json) {
    result = boolFromJson(json, 'result');
    points = intFromJson(json, 'points');
    hasAdditional = boolFromJson(json, 'has_additional');
    additional = json['additional'];
  }
}

// class AnswerResultModelAdditional {
//   int rank;
//   int points;
//   int correctAnswer;
//   int wrongAnswer;

//   AnswerResultModelAdditional({
//     this.rank,
//     this.points,
//     this.correctAnswer,
//     this.wrongAnswer,
//   });
//   AnswerResultModelAdditional.fromJson(obj) {
//     this.rank = obj['result'];
//     this.points = obj['points'];
//     this.correctAnswer = obj['hasAdditional'];
//     this.wrongAnswer = obj['additional'];
//   }
// }
