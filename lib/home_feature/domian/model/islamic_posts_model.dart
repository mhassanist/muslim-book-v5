class IslamicPosts {
  late Data _data;
  late String _client;
  late String _message;
  late bool _success;
  late Links _links;
  late Meta _meta;

  IslamicPosts({
    Data? data,
    String? client,
    String? message,
    bool? success,
    Links? links,
    Meta? meta,
  }) {
    this._data = data ?? Data();
    this._client = client ?? '';
    this._message = message ?? '';
    this._success = success ?? false;
    this._links = links ?? Links();
    this._meta = meta ?? Meta();
  }

  Data get data => _data;

  set data(Data data) => _data = data;

  String get client => _client;

  set client(String client) => _client = client;

  String get message => _message;

  set message(String message) => _message = message;

  bool get success => _success;

  set success(bool success) => _success = success;

  Links get links => _links;

  set links(Links links) => _links = links;

  Meta get meta => _meta;

  set meta(Meta meta) => _meta = meta;

  IslamicPosts.fromJson(Map<String, dynamic> json) {
    _data = json['data'] != null ? Data.fromJson(json['data']) : Data();
    _client = json['client'];
    _message = json['message'];
    _success = json['success'];
    _links =
        json['links'] != null ? new Links.fromJson(json['links']) : Links();
    _meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : Meta();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['data'] = this._data.toJson();
    data['client'] = this._client;
    data['message'] = this._message;
    data['success'] = this._success;
    data['links'] = this._links.toJson();
    data['meta'] = this._meta.toJson();
    return data;
  }
}

class Data {
  late int _id;
  late String _name;
  late String _description;
  late List<PostsOfIslamic> _posts;

  Data({
    int? id,
    String? name,
    String? description,
    List<PostsOfIslamic>? posts,
  }) {
    this._id = id ?? -1;
    this._name = name ?? '';
    this._description = description ?? '';
    this._posts = posts ?? <PostsOfIslamic>[];
  }

  int get id => _id;

  set id(int id) => _id = id;

  String get name => _name;

  set name(String name) => _name = name;

  String get description => _description;

  set description(String description) => _description = description;

  List<PostsOfIslamic> get posts => _posts;

  set posts(List<PostsOfIslamic> posts) => _posts = posts;

  Data.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _posts = <PostsOfIslamic>[];
    if (json['posts'] != null) {
      json['posts'].forEach((v) {
        _posts.add(new PostsOfIslamic.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['description'] = this._description;
    data['posts'] = this._posts.map((v) => v.toJson()).toList();
    return data;
  }
}

class PostsOfIslamic {
  late int _id;
  late String _type;
  late String _name;
  late String _description;
  late String _content;
  late int _likes;
  late int _categoryId;
  late bool _liked;
  late String _featured;
  late List<Media> _media;

  PostsOfIslamic({
    int? id,
    String? type,
    String? name,
    String? description,
    String? content,
    int? likes,
    int? categoryId,
    bool? liked,
    String? featured,
    List<Media>? media,
  }) {
    this._id = id ?? -1;
    this._type = type ?? '';
    this._name = name ?? '';
    this._description = description ?? '';
    this._content = content ?? '';
    this._likes = likes ?? 0;
    this._categoryId = categoryId ?? -1;
    this._liked = liked ?? false;
    this._featured = featured ?? '';
    this._media = media ?? <Media>[];
  }

  int get id => _id;

  set id(int id) => _id = id;

  String get type => _type;

  set type(String type) => _type = type;

  String get name => _name;

  set name(String name) => _name = name;

  String get description => _description;

  set description(String description) => _description = description;

  String get content => _content;

  set content(String content) => _content = content;

  int get likes => _likes;

  set likes(int likes) => _likes = likes;

  int get categoryId => _categoryId;

  set categoryId(int categoryId) => _categoryId = categoryId;

  bool get liked => _liked;

  set liked(bool liked) => _liked = liked;

  String get featured => _featured;

  set featured(String featured) => _featured = featured;

  List<Media> get media => _media;

  set media(List<Media> media) => _media = media;

  PostsOfIslamic.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _type = json['type'];
    _name = json['name'];
    _description = json['description'];
    _content = json['content'];
    _likes = json['likes'];
    _categoryId = json['category_id'];
    _liked = json['liked'];
    _featured = json['featured'];
    _media = <Media>[];
    if (json['media'] != null) {
      json['media'].forEach((v) {
        _media.add(new Media.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['type'] = this._type;
    data['name'] = this._name;
    data['description'] = this._description;
    data['content'] = this._content;
    data['likes'] = this._likes;
    data['category_id'] = this._categoryId;
    data['liked'] = this._liked;
    data['featured'] = this._featured;
    data['media'] = this._media.map((v) => v.toJson()).toList();
    return data;
  }
}

class Media {
  late int _id;
  late String _name;
  late String _fileName;
  late String _mimeType;
  late String _extension;
  late int _size;
  late List<Null> _responsiveImages;
  late int _order;
  late String _url;
  late String _thumb;

  Media({
    int? id,
    String? name,
    String? fileName,
    String? mimeType,
    String? extension,
    int? size,
    List<Null>? responsiveImages,
    int? order,
    String? url,
    String? thumb,
  }) {
    this._id = id ?? -1;
    this._name = name ?? '';
    this._fileName = fileName ?? '';
    this._mimeType = mimeType ?? '';
    this._extension = extension ?? '';
    this._size = size ?? 0;
    this._responsiveImages = responsiveImages ?? <Null>[];
    this._order = order ?? -1;
    this._url = url ?? '';
    this._thumb = thumb ?? '';
  }

  int get id => _id;

  set id(int id) => _id = id;

  String get name => _name;

  set name(String name) => _name = name;

  String get fileName => _fileName;

  set fileName(String fileName) => _fileName = fileName;

  String get mimeType => _mimeType;

  set mimeType(String mimeType) => _mimeType = mimeType;

  String get extension => _extension;

  set extension(String extension) => _extension = extension;

  int get size => _size;

  set size(int size) => _size = size;

  List<Null> get responsiveImages => _responsiveImages;

  set responsiveImages(List<Null> responsiveImages) =>
      _responsiveImages = responsiveImages;

  int get order => _order;

  set order(int order) => _order = order;

  String get url => _url;

  set url(String url) => _url = url;

  String get thumb => _thumb;

  set thumb(String thumb) => _thumb = thumb;

  Media.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _fileName = json['file_name'];
    _mimeType = json['mime_type'];
    _extension = json['extension'];
    _size = json['size'];
    _order = json['order'];
    _url = json['url'];
    _thumb = json['thumb'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['file_name'] = this._fileName;
    data['mime_type'] = this._mimeType;
    data['extension'] = this._extension;
    data['size'] = this._size;
    data['order'] = this._order;
    data['url'] = this._url;
    data['thumb'] = this._thumb;
    return data;
  }
}

class Links {
  String? first;
  String? last;
  String? next;

  Links({
    String? first,
    String? last,
    String? next,
  }) {
    this.first = first ?? '';
    this.last = last ?? '';
    this.next = next ?? '';
  }

  Links.fromJson(Map<String, dynamic> json) {
    first = json['first'];
    last = json['last'];
    next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this.first;
    data['last'] = this.last;
    data['next'] = this.next;
    return data;
  }
}

class Meta {
  int? currentPage;
  int? from;
  int? lastPage;
  String? path;
  int? perPage;
  int? to;
  int? total;

  Meta({
    int? currentPage,
    int? from,
    int? lastPage,
    String? path,
    int? perPage,
    int? to,
    int? total,
  }) {
    this.currentPage = currentPage ?? 0;
    this.from = from ?? 0;
    this.lastPage = lastPage ?? 0;
    this.path = path ?? '';
    this.perPage = perPage ?? 1;
    this.to = to ?? 0;
    this.total = total ?? 0;
  }

  Meta.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    from = json['from'];
    lastPage = json['last_page'];
    path = json['path'];
    perPage = json['per_page'];
    to = json['to'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this.currentPage;
    data['from'] = this.from;
    data['last_page'] = this.lastPage;
    data['path'] = this.path;
    data['per_page'] = this.perPage;
    data['to'] = this.to;
    data['total'] = this.total;
    return data;
  }
}
