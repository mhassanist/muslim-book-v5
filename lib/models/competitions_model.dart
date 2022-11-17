import 'dart:convert';

import 'package:base_app/models/base_model.dart';

class QuestionsModel with Model {
  late List<QuestionModel> data;
  late String client;
  late String message;
  late bool success;
  late String now;
  late String startDate;
  late String competitionCycle;
  late int days;
  late int hours;
  late int remaining;
  late Links links;
  late Meta meta;

  QuestionsModel({
    List<QuestionModel>? data,
    this.client = '',
    this.message = '',
    this.success = false,
    this.now = '',
    this.startDate = '',
    this.competitionCycle = '',
    this.days = -1,
    this.hours = -1,
    this.remaining = -1,
    Links? links,
    Meta? meta,
    t,
  }) {
    this.data = data ?? <QuestionModel>[];
    this.links = links ?? Links();
    this.meta = meta ?? Meta();
  }

  factory QuestionsModel.fromJson(String str) =>
      QuestionsModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  QuestionsModel.fromMap(Map<String, dynamic> json) {
    data = listFromJson(json, 'data', (v) => QuestionModel.fromMap(v));
    client = stringFromJson(json, 'client');
    message = stringFromJson(json, 'message');
    success = boolFromJson(json, 'success');
    now = stringFromJson(json, 'now');
    startDate = stringFromJson(json, 'start_date');
    competitionCycle = stringFromJson(json, 'competition_cycle');
    days = intFromJson(json, 'days');
    hours = intFromJson(json, 'hours');
    remaining = intFromJson(json, 'remaining');
    links = objectFromJson(
      json,
      'links',
      (v) => Links.fromMap(v),
      defaultValue: Links(),
    );
    meta = objectFromJson(
      json,
      'meta',
      (v) => Meta.fromMap(v),
      defaultValue: Meta(),
    );
  }

  Map<String, dynamic> toMap() => {
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
        "client": client,
        "message": message,
        "success": success,
        "now": now,
        "start_date": startDate,
        "competition_cycle": competitionCycle,
        "days": days,
        "hours": hours,
        "remaining": remaining,
        "links": links.toMap(),
        "meta": meta.toMap(),
      };
}

class QuestionModel with Model {
  late int id;
  late String question;
  late List<AnswerModel> answers;

  QuestionModel({
    this.id = -1,
    this.question = '',
    List<AnswerModel>? answers,
  }) {
    this.answers = answers ?? <AnswerModel>[];
  }

  factory QuestionModel.fromJson(String str) =>
      QuestionModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  QuestionModel.fromMap(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    question = stringFromJson(json, 'question');
    answers = listFromJson(json, 'answers', (v) => AnswerModel.fromMap(v));
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "question": question,
        "answers": List<dynamic>.from(answers.map((x) => x.toMap())),
      };
}

class AnswerModel with Model {
  late int id;
  late String answers;
  int? result;

  AnswerModel({
    this.id = -1,
    this.answers = '',
    this.result,
  });

  factory AnswerModel.fromJson(String str) =>
      AnswerModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  AnswerModel.fromMap(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    answers = stringFromJson(json, 'answers');
    result = intFromJson(json, 'result');
  }

  Map<String, dynamic> toMap() => {
        "id": id,
        "answers": answers,
        "result": result,
      };

  @override
  String toString() {
    return "$answers     $result";
  }
}

class Links with Model {
  late String first;
  late String last;
  dynamic prev;
  dynamic next;

  Links({
    this.first = '',
    this.last = '',
    this.prev,
    this.next,
  });

  factory Links.fromJson(String str) => Links.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  Links.fromMap(Map<String, dynamic> json) {
    first = stringFromJson(json, 'first');
    last = stringFromJson(json, 'last');
    prev = json["prev"];
    next = json["next"];
  }

  Map<String, dynamic> toMap() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
      };
}

class Meta with Model {
  late int currentPage;
  late int from;
  late int lastPage;
  late String path;
  late int perPage;
  late int to;
  late int total;

  Meta({
    this.currentPage = -1,
    this.from = -1,
    this.lastPage = -1,
    this.path = '',
    this.perPage = -1,
    this.to = -1,
    this.total = 0,
  });

  factory Meta.fromJson(String str) => Meta.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  Meta.fromMap(Map<String, dynamic> json) {
    currentPage = intFromJson(json, '');
    from = intFromJson(json, 'from');
    lastPage = intFromJson(json, 'last_page');
    perPage = intFromJson(json, 'per_page');
    to = intFromJson(json, 'to');
    total = intFromJson(json, 'total');
    path = stringFromJson(json, 'path');
  }

  Map<String, dynamic> toMap() => {
        "current_page": currentPage,
        "from": from,
        "last_page": lastPage,
        "path": path,
        "per_page": perPage,
        "to": to,
        "total": total,
      };
}
