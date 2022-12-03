// import 'dart:convert';
//
// class PushNotificationModel {
//   Notification _notification;
//   NotificationData _data;
//
//   PushNotificationModel({Notification notification, NotificationData data}) {
//     this._notification = notification;
//     this._data = data;
//   }
//
//   Notification get notification => _notification;
//   set notification(Notification notification) => _notification = notification;
//   NotificationData get data => _data;
//   set data(NotificationData data) => _data = data;
//
//   PushNotificationModel.fromJson(Map<String, dynamic> json) {
//     // _notification = json['notification'] != null
//     //     ?  Notification.fromJson(json['notification'])
//     //     : null;
//     _data = json['data'] != null
//         ?  NotificationData.fromJson(json['data'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this._notification != null) {
//       data['notification'] = this._notification.toJson();
//     }
//     if (this._data != null) {
//       data['data'] = this._data.toJson();
//     }
//     return data;
//   }
// }
//
// class Notification {
//   late String _title;
//   late String _body;
//
//   Notification({required String title, required String body,}) {
//     this._title = title;
//     this._body = body;
//   }
//
//   String get title => _title;
//   set title(String title) => _title = title;
//   String get body => _body;
//   set body(String body) => _body = body;
//
//   Notification.fromJson(Map<String, dynamic> json) {
//     _title = json['title'];
//     _body = json['body'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['title'] = this._title;
//     data['body'] = this._body;
//     return data;
//   }
// }
//
// class NotificationData extends Object{
//   String _postId;
//   String _body;
//   String _title;
//   String _catId;
//   String _catName;
//
//   NotificationData({String postId, String body, String title, String catId, String catName}) {
//     this._postId = postId;
//     this._body = body;
//     this._title = title;
//     this._catId = catId;
//     this._catName = catName;
//   }
//
//   @override
//   String toString() {
//     Map<String,String>data = {
//       "post_id" : "$_postId",
//       "cat_name" : "$_catName",
//       "cat_id" : "$_catId"
//     };
//     var json = jsonEncode(data);
//     return json.toString();
//   }
//
//   String get postId => _postId;
//   set postId(String postId) => _postId = postId;
//   String get body => _body;
//   set body(String body) => _body = body;
//   String get title => _title;
//   set title(String title) => _title = title;
//   String get catId => _catId;
//   set catId(String catId) => _catId = catId;
//   String get catName => _catName;
//   set catName(String catName) => _catName = catName;
//
//   NotificationData.fromJson(Map<String, dynamic> json) {
//     _postId = json['post_id'];
//     _body = json['body'];
//     _title = json['title'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['post_id'] = this._postId;
//     data['body'] = this._body;
//     data['title'] = this._title;
//     return data;
//   }
// }
