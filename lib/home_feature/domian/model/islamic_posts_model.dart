class IslamicPosts {
  Data _data;
  String _client;
  String _message;
  bool _success;
  Links _links;
  Meta _meta;

  IslamicPosts(
      {Data data,
        String client,
        String message,
        bool success,
        Links links,
        Meta meta}) {
    this._data = data;
    this._client = client;
    this._message = message;
    this._success = success;
    this._links = links;
    this._meta = meta;
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
    _data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    _client = json['client'];
    _message = json['message'];
    _success = json['success'];
    _links = json['links'] != null ? new Links.fromJson(json['links']) : null;
    _meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._data != null) {
      data['data'] = this._data.toJson();
    }
    data['client'] = this._client;
    data['message'] = this._message;
    data['success'] = this._success;
    if (this._links != null) {
      data['links'] = this._links.toJson();
    }
    if (this._meta != null) {
      data['meta'] = this._meta.toJson();
    }
    return data;
  }
}

class Data {
  int _id;
  String _name;
  String _description;
  List<PostsOfIslamic> _posts;

  Data({int id, String name, String description, List<PostsOfIslamic> posts}) {
    this._id = id;
    this._name = name;
    this._description = description;
    this._posts = posts;
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
    if (json['posts'] != null) {
      _posts = new List<PostsOfIslamic>();
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
    if (this._posts != null) {
      data['posts'] = this._posts.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostsOfIslamic {
  int _id;
  String _type;
  String _name;
  String _description;
  String _content;
  int _likes;
  int _categoryId;
  bool _liked;
  String _featured;
  List<Media> _media;

  PostsOfIslamic(
      {int id,
        String type,
        String name,
        String description,
        String content,
        int likes,
        int categoryId,
        bool liked,
        String featured,
        List<Media> media}) {
    this._id = id;
    this._type = type;
    this._name = name;
    this._description = description;
    this._content = content;
    this._likes = likes;
    this._categoryId = categoryId;
    this._liked = liked;
    this._featured = featured;
    this._media = media;
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
    if (json['media'] != null) {
      _media = new List<Media>();
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
    if (this._media != null) {
      data['media'] = this._media.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Media {
  int _id;
  String _name;
  String _fileName;
  String _mimeType;
  String _extension;
  int _size;
  List<Null> _responsiveImages;
  int _order;
  String _url;
  String _thumb;

  Media(
      {int id,
        String name,
        String fileName,
        String mimeType,
        String extension,
        int size,
        List<Null> responsiveImages,
        int order,
        String url,
        String thumb}) {
    this._id = id;
    this._name = name;
    this._fileName = fileName;
    this._mimeType = mimeType;
    this._extension = extension;
    this._size = size;
    this._responsiveImages = responsiveImages;
    this._order = order;
    this._url = url;
    this._thumb = thumb;
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
  String _first;
  String _last;
  String _next;

  Links({String first, String last, String next}) {
    this._first = first;
    this._last = last;
    this._next = next;
  }

  String get first => _first;
  set first(String first) => _first = first;
  String get last => _last;
  set last(String last) => _last = last;
  String get next => _next;
  set next(String next) => _next = next;

  Links.fromJson(Map<String, dynamic> json) {
    _first = json['first'];
    _last = json['last'];
    _next = json['next'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first'] = this._first;
    data['last'] = this._last;
    data['next'] = this._next;
    return data;
  }
}

class Meta {
  int _currentPage;
  int _from;
  int _lastPage;
  String _path;
  int _perPage;
  int _to;
  int _total;

  Meta(
      {int currentPage,
        int from,
        int lastPage,
        String path,
        int perPage,
        int to,
        int total}) {
    this._currentPage = currentPage;
    this._from = from;
    this._lastPage = lastPage;
    this._path = path;
    this._perPage = perPage;
    this._to = to;
    this._total = total;
  }

  int get currentPage => _currentPage;
  set currentPage(int currentPage) => _currentPage = currentPage;
  int get from => _from;
  set from(int from) => _from = from;
  int get lastPage => _lastPage;
  set lastPage(int lastPage) => _lastPage = lastPage;
  String get path => _path;
  set path(String path) => _path = path;
  int get perPage => _perPage;
  set perPage(int perPage) => _perPage = perPage;
  int get to => _to;
  set to(int to) => _to = to;
  int get total => _total;
  set total(int total) => _total = total;

  Meta.fromJson(Map<String, dynamic> json) {
    _currentPage = json['current_page'];
    _from = json['from'];
    _lastPage = json['last_page'];
    _path = json['path'];
    _perPage = json['per_page'];
    _to = json['to'];
    _total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this._currentPage;
    data['from'] = this._from;
    data['last_page'] = this._lastPage;
    data['path'] = this._path;
    data['per_page'] = this._perPage;
    data['to'] = this._to;
    data['total'] = this._total;
    return data;
  }
}
