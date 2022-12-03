// To parse this JSON data, do
//
//     final ramadanCannonModel = ramadanCannonModelFromJson(jsonString);

import 'dart:convert';

RamadanSoundsModel ramadanCannonModelFromJson(String str) => RamadanSoundsModel.fromJson(json.decode(str));
//
String ramadanCannonModelToJson(RamadanSoundsModel data) => json.encode(data.toJson());

// class RamadanCannonModel {
//   RamadanCannonModel({
//     this.client,
//     this.message,
//     this.success,
//     this.currentPage,
//     this.data,
//     this.firstPageUrl,
//     this.from,
//     this.lastPage,
//     this.lastPageUrl,
//     this.nextPageUrl,
//     this.path,
//     this.perPage,
//     this.prevPageUrl,
//     this.to,
//     this.total,
//     this.localPath
//   });
//
//   String client;
//   String message;
//   bool success;
//   int currentPage;
//   List<Datum> data;
//   String firstPageUrl;
//   int from;
//   int lastPage;
//   String lastPageUrl;
//   dynamic nextPageUrl;
//   String path;
//   int perPage;
//   dynamic prevPageUrl;
//   int to;
//   int total;
//   String localPath;
//
//
//   factory RamadanCannonModel.fromJson(Map<String, dynamic> json) => RamadanCannonModel(
//     client: json["client"],
//     message: json["message"],
//     success: json["success"],
//     currentPage: json["current_page"],
//     data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
//     firstPageUrl: json["first_page_url"],
//     from: json["from"],
//     lastPage: json["last_page"],
//     lastPageUrl: json["last_page_url"],
//     nextPageUrl: json["next_page_url"],
//     path: json["path"],
//     perPage: json["per_page"],
//     prevPageUrl: json["prev_page_url"],
//     to: json["to"],
//     total: json["total"],
//     localPath: json["local_path"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "client": client,
//     "message": message,
//     "success": success,
//     "current_page": currentPage,
//     "data": List<dynamic>.from(data.map((x) => x.toJson())),
//     "first_page_url": firstPageUrl,
//     "from": from,
//     "last_page": lastPage,
//     "last_page_url": lastPageUrl,
//     "next_page_url": nextPageUrl,
//     "path": path,
//     "per_page": perPage,
//     "prev_page_url": prevPageUrl,
//     "to": to,
//     "total": total,
//   };
//   toJSON(List<RamadanCannonModel> soundsList) {
//     return soundsList.map((item) {
//       return item.toJson();
//     }).toList();
//   }
// }

class RamadanSoundsModel {
  RamadanSoundsModel({
    this.id,
    this.name,
    this.file,
    this.localPath
  });

  int? id;
  String? name;
  String? file;
  String? localPath;

  factory RamadanSoundsModel.fromJson(Map<String, dynamic> json) => RamadanSoundsModel(
    id: json["id"],
    name: json["name"],
    file: json["file"],
    localPath: json["local_path"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "file": file,
    "local_path":localPath,
  };
  toJSON(List<RamadanSoundsModel> soundsList) {
    return soundsList.map((item) {
      return item.toJson();
    }).toList();
  }

}
