import 'dart:convert';

class Azan {
  Azan({
    this.id,
    this.key,
    this.hours,
    this.title,
    this.volumeEnable,
    this.time,
    this.isha,
    this.minute,
    this.count
  });

  String id;
  String key;
  String hours;
  String title;
  bool volumeEnable;
  String isha;
  String time;
  String minute ;
  int count  ;

  factory Azan.fromJson(String str) => Azan.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Azan.fromMap(Map<String, dynamic> json) => Azan(
        id: json["id"],
        key: json["key"],
        hours: json["hours"],
        title: json["title"],
        volumeEnable: json["volume_enable"],
        time: json["time"],
        isha: json["isha"],
    minute: json["minute"],
    count: json["count"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "key": key,
        "hours": hours,
        "title": title,
        "volume_enable": volumeEnable,
        "isha": isha,
        "minute": minute,
        "count": count,
      };
}
