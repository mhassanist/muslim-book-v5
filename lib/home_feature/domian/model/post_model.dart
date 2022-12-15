class Post {
  int? id;
  String? content;
  int? likes;
  int? userId;
  String? userImage;
  String? userName;
  bool? liked;
  bool? reported;
  int? reports;
  bool? editable;

  Post({
    this.id,
    this.content,
    this.likes,
    this.userId,
    this.userImage,
    this.userName,
    this.liked,
    this.reported,
    this.reports,
    this.editable,
  });

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    likes = json['likes'];
    userId = json['user_id'];
    userImage = json['user_image'];
    userName = json['user_name'];
    liked = json['liked'];
    reported = json['reported'];
    reports = json['reports'];
    editable = json['editable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['likes'] = this.likes;
    data['user_id'] = this.userId;
    data['user_image'] = this.userImage;
    data['user_name'] = this.userName;
    data['liked'] = this.liked;
    data['reported'] = this.reported;
    data['reports'] = this.reports;
    data['editable'] = this.editable;
    return data;
  }
}
