import 'dart:convert';

class AzanSound {
  int? id;
  int? fajr;
  String? name;
  String? key;
  String fileUrl;
  String? localPath;

  AzanSound({
    this.id,
    this.fajr,
    this.name,
    this.key,
    required this.fileUrl,
    this.localPath,
  });

  factory AzanSound.fromMap(Map<String, dynamic> json) => AzanSound(
        id: json["id"],
        fajr: json["fajr"],
        name: json["name"],
        key: json["key"],
        fileUrl: json["file"],
        localPath: json["local_path"],
      );

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> m = new Map();

    m['id'] = id;
    m['fajr'] = fajr;
    m['name'] = name;
    m['key'] = key;
    m['file'] = fileUrl;
    m['local_path'] = localPath;

    return m;
  }

  static Map<String, dynamic> toMap(String savedShiekLocalJSON) {
    return json.decode(savedShiekLocalJSON);
  }
}

class AzanSoundsList {
  fromJson(response) {
    final soundsList = <AzanSound>[];
    for (var azanSound in response) {
      AzanSound model = AzanSound.fromMap(azanSound);
      soundsList.add(model);
    }
    return soundsList;
  }

  toJSON(List<AzanSound> soundsList) {
    return soundsList.map((item) {
      return item.toJSON();
    }).toList();
  }
}
