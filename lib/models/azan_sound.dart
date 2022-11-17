import 'dart:convert';

import 'package:base_app/models/base_model.dart';

class AzanSound with Model {
  late int id;
  late int fajr;
  late String name;
  late String key;
  late String fileUrl;
  late String localPath;

  AzanSound({
    this.id = -1,
    this.fajr = 0,
    this.name = '',
    this.key = '',
    this.fileUrl = '',
    this.localPath = '',
  });

  AzanSound.fromMap(Map<String, dynamic> json) {
    id = intFromJson(json, 'id');
    fajr = intFromJson(json, 'fajr');
    name = stringFromJson(json, 'name');
    key = stringFromJson(json, 'key');
    fileUrl = stringFromJson(json, 'file');
    localPath = stringFromJson(json, 'local_path');
  }

  Map<String, dynamic> toJSON() => {
        'id': id,
        'fajr': fajr,
        'name': name,
        'key': key,
        'file': fileUrl,
        'local_path': localPath,
      };

  static Map<String, dynamic> toMap(String savedShiekLocalJSON) {
    return json.decode(savedShiekLocalJSON);
  }
}

class AzanSoundsList with Model {
  fromJson(response) {
    final soundsList = <AzanSound>[];
    for (final azanSound in response) {
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
