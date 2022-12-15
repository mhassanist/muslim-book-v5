class Categories {
  late List<Categore> data;

  Categories({
    this.data = const <Categore>[],
  });

  Categories.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Categore>[];
      json['data'].forEach((v) {
        data.add(new Categore.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categore {
  int? id;
  String? name;
  String? description;

  Categore({this.id, this.name, this.description,});

  Categore.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}
