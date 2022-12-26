import 'dart:convert';

class QuestionsModel {
  List<QuestionModel> data;
  String? client;
  String? message;
  bool? success;
  String? now;
  String? startDate;
  String? competitionCycle;
  int? days;
  int? hours;
  int? remaining;
  Links links;
  Meta meta;

  QuestionsModel({
    required this.data,
    this.client,
    this.message,
    this.success,
    this.now,
    this.startDate,
    this.competitionCycle,
    this.days,
    this.hours,
    this.remaining,
    required this.links,
    required this.meta,
    t,
  });

  factory QuestionsModel.fromJson(String str) =>
      QuestionsModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QuestionsModel.fromMap(Map<String, dynamic> json) => QuestionsModel(
        data: List<QuestionModel>.from(
            json["data"].map((x) => QuestionModel.fromMap(x))),
        client: json["client"],
        message: json["message"],
        success: json["success"],
        now: json["now"],
        startDate: json["start_date"],
        competitionCycle: json["competition_cycle"],
        days: json["days"],
        hours: json["hours"],
        remaining: json["remaining"],
        links: Links.fromMap(json["links"]),
        meta: Meta.fromMap(json["meta"]),
      );

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

class QuestionModel {
  int? id;
  String? question;
  List<AnswerModel> answers;

  QuestionModel({
    this.id,
    this.question,
    required this.answers,
  });

  factory QuestionModel.fromJson(String str) =>
      QuestionModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory QuestionModel.fromMap(Map<String, dynamic> json) => QuestionModel(
        id: json["id"],
        question: json["question"],
        answers: List<AnswerModel>.from(
            json["answers"].map((x) => AnswerModel.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "question": question,
        "answers": List<dynamic>.from(answers.map((x) => x.toMap())),
      };
}

class AnswerModel {
  int? id;
  String? answers;
  int? result;

  AnswerModel({
    this.id,
    this.answers,
    this.result,
  });

  factory AnswerModel.fromJson(String str) =>
      AnswerModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory AnswerModel.fromMap(Map<String, dynamic> json) => AnswerModel(
        id: json["id"],
        answers: json["answers"],
        result: json["result"] == null ? null : json["result"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "answers": answers,
        "result": result == null ? null : result,
      };

  @override
  String toString() {
    return "$answers     $result";
  }
}

class Links {
  String? first;
  String? last;
  dynamic prev;
  dynamic next;

  Links({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  factory Links.fromJson(String str) => Links.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Links.fromMap(Map<String, dynamic> json) => Links(
        first: json["first"],
        last: json["last"],
        prev: json["prev"],
        next: json["next"],
      );

  Map<String, dynamic> toMap() => {
        "first": first,
        "last": last,
        "prev": prev,
        "next": next,
      };
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  String? path;
  int? perPage;
  int? to;
  int total;

  Meta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.path,
    this.perPage,
    this.to,
    this.total = 0,
  });

  factory Meta.fromJson(String str) => Meta.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Meta.fromMap(Map<String, dynamic> json) => Meta(
        currentPage: json["current_page"],
        from: json["from"],
        lastPage: json["last_page"],
        path: json["path"],
        perPage: json["per_page"],
        to: json["to"],
        total: json["total"],
      );

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
