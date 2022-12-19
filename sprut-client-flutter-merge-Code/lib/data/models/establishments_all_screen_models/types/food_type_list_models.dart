// To parse this JSON data, do
//
//     final foodTypeModels = foodTypeModelsFromJson(jsonString);

import 'dart:convert';

FoodTypeModels foodTypeModelsFromJson(String str) =>
    FoodTypeModels.fromJson(json.decode(str));

String foodTypeModelsToJson(FoodTypeModels data) => json.encode(data.toJson());
//
// class FoodTypeModels {
//   FoodTypeModels({
//     this.count,
//     this.items,
//   });
//
//   int? count;
//   List<FoodType>? items;
//
//   factory FoodTypeModels.fromJson(Map<String, dynamic> json) => FoodTypeModels(
//     count: json["count"],
//     items: List<FoodType>.from(json["items"].map((x) => FoodType.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "count": count,
//     "items": List<dynamic>.from(items!.map((x) => x.toJson())),
//   };
// }
//
// class FoodType {
//   FoodType({
//     this.id,
//     this.name,
//     this.description,
//     this.imgUrl,
//     this.status,
//     this.removed,
//     this.createdAt,
//     this.updatedAt,
//     this.isFiltered,
//   });
//
//   int? id;
//   String? name;
//   dynamic description;
//   String? imgUrl;
//   String? status;
//   dynamic removed;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   bool? isFiltered = false;
//
//   factory FoodType.fromJson(Map<String, dynamic> json) => FoodType(
//     id: json["id"],
//     name: json["name"],
//     description: json["description"],
//     imgUrl: json["imgUrl"],
//     status: json["status"],
//     removed: json["removed"],
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "description": description,
//     "imgUrl": imgUrl,
//     "status": status,
//     "removed": removed,
//     "createdAt": createdAt?.toIso8601String(),
//     "updatedAt": updatedAt?.toIso8601String(),
//   };
// }

class FoodTypeModels {
  int? count;
  List<FoodType>? items;

  FoodTypeModels({this.count, this.items});

  FoodTypeModels.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['items'] != null) {
      items = <FoodType>[];
      json['items'].forEach((v) {
        items!.add(new FoodType.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoodType {
  int? id;
  String? nameUk;
  String? nameRu;
  String? nameEn;
  String? descriptionUk;
  String? descriptionRu;
  String? descriptionEn;
  String? imgUrl;
  String? status;
  dynamic removed;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? description;
  bool? isFiltered = false;

  FoodType(
      {this.id,
      this.nameUk,
      this.nameRu,
      this.nameEn,
      this.descriptionUk,
      this.descriptionRu,
      this.descriptionEn,
      this.imgUrl,
      this.status,
      this.removed,
      this.createdAt,
      this.updatedAt,
      this.name,
      this.description,
      this.isFiltered});

  FoodType.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameUk = json['name:uk'];
    nameRu = json['name:ru'];
    nameEn = json['name:en'];
    descriptionUk = json['description:uk'];
    descriptionRu = json['description:ru'];
    descriptionEn = json['description:en'];
    imgUrl = json['imgUrl'];
    status = json['status'];
    removed = json['removed'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    name = json['name'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name:uk'] = this.nameUk;
    data['name:ru'] = this.nameRu;
    data['name:en'] = this.nameEn;
    data['description:uk'] = this.descriptionUk;
    data['description:ru'] = this.descriptionRu;
    data['description:en'] = this.descriptionEn;
    data['imgUrl'] = this.imgUrl;
    data['status'] = this.status;
    data['removed'] = this.removed;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['name'] = this.name;
    data['description'] = this.description;
    return data;
  }
}
