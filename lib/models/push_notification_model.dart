class PushNotificationModel {
  Notification _notification;
  Data _data;

  PushNotificationModel({Notification notification, Data data}) {
    this._notification = notification;
    this._data = data;
  }

  Notification get notification => _notification;
  set notification(Notification notification) => _notification = notification;
  Data get data => _data;
  set data(Data data) => _data = data;

  PushNotificationModel.fromJson(Map<String, dynamic> json) {
    // _notification = json['notification'] != null
    //     ?  Notification.fromJson(json['notification'])
    //     : null;
    _data = json['data'] != null
        ?  Data.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._notification != null) {
      data['notification'] = this._notification.toJson();
    }
    if (this._data != null) {
      data['data'] = this._data.toJson();
    }
    return data;
  }
}

class Notification {
  String _title;
  String _body;

  Notification({String title, String body}) {
    this._title = title;
    this._body = body;
  }

  String get title => _title;
  set title(String title) => _title = title;
  String get body => _body;
  set body(String body) => _body = body;

  Notification.fromJson(Map<String, dynamic> json) {
    _title = json['title'];
    _body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this._title;
    data['body'] = this._body;
    return data;
  }
}

class Data {
  String _postId;
  String _body;
  String _title;

  Data({String postId, String body, String title}) {
    this._postId = postId;
    this._body = body;
    this._title = title;
  }

  String get postId => _postId;
  set postId(String postId) => _postId = postId;
  String get body => _body;
  set body(String body) => _body = body;
  String get title => _title;
  set title(String title) => _title = title;

  Data.fromJson(Map<String, dynamic> json) {
    _postId = json['post_id'];
    _body = json['body'];
    _title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['post_id'] = this._postId;
    data['body'] = this._body;
    data['title'] = this._title;
    return data;
  }
}
