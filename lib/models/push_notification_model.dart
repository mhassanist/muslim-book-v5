import 'dart:convert';

class PushNotificationModel {
  late Notification notification;
  late NotificationData data;

  PushNotificationModel({
    Notification? notification,
    NotificationData? data,
  }) {
    this.notification = notification ?? Notification();
    this.data = data ?? NotificationData();
  }

  PushNotificationModel.fromJson(Map<String, dynamic> json) {
    notification = json.containsKey('notification')
        ? Notification.fromJson(json['notification'])
        : Notification();
    data = json.containsKey('data')
        ? NotificationData.fromJson(json['data'])
        : NotificationData();
  }

  Map<String, dynamic> toJson() => {
        'notification': notification.toJson(),
        'data': data.toJson(),
      };
}

class Notification {
  late String title;
  late String body;

  Notification({
    this.title = '',
    this.body = '',
  });

  Notification.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? '';
    body = json['body'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['body'] = this.body;
    return data;
  }
}

class NotificationData extends Object {
  late String postId;
  late String body;
  late String title;
  late String catId;
  late String catName;

  NotificationData({
    this.postId = '',
    this.body = '',
    this.title = '',
    this.catId = '',
    this.catName = '',
  });

  @override
  String toString() {
    Map<String, String> data = {
      "post_id": postId,
      "cat_name": catName,
      "cat_id": catId,
    };
    var json = jsonEncode(data);
    return json.toString();
  }

  NotificationData.fromJson(Map<String, dynamic> json) {
    postId = json['post_id'];
    body = json['body'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() => {
        'post_id': postId,
        'body': body,
        'title': title,
      };
}
