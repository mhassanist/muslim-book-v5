class AnswerResultModel {
  dynamic data;
  String? client;
  String? message;
  bool? success;

  AnswerResultModel({
    this.data,
    required this.client,
    required this.message,
    required this.success,
  });

  AnswerResultModel.fromJson(obj) {
    this.client = obj['client'] ?? '';
    this.message = obj['message'] ?? '';
    this.success = obj['success'] ?? false;
    this.data = obj['data'];
  }
}

class AnswerResultModelData {
  bool? result;
  int? points;
  bool? hasAdditional;
  dynamic additional;

  AnswerResultModelData({
    this.result,
    this.points = 0,
    this.hasAdditional,
    this.additional,
  });
  AnswerResultModelData.fromJson(obj) {
    this.result = obj['result'];
    this.points = obj['points'] ?? 0;
    this.hasAdditional = obj['has_additional'];
    this.additional = obj['additional'];
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
