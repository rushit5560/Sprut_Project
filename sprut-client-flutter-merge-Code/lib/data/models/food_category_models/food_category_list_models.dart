// To parse this JSON data, do
//
//     final foodCategoryListModel = foodCategoryListModelFromJson(jsonString);

import 'dart:convert';

FoodCategoryListModel foodCategoryListModelFromJson(String str) => FoodCategoryListModel.fromJson(json.decode(str));

String foodCategoryListModelToJson(FoodCategoryListModel data) => json.encode(data.toJson());

// class FoodCategoryListModel {
//   FoodCategoryListModel({
//     this.count,
//     this.items,
//   });
//
//   int? count;
//   List<FoodCategoryData>? items;
//
//   factory FoodCategoryListModel.fromJson(Map<String, dynamic> json) => FoodCategoryListModel(
//     count: json["count"],
//     items: List<FoodCategoryData>.from(json["items"].map((x) => FoodCategoryData.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "count": count,
//     "items": List<dynamic>.from(items!.map((x) => x.toJson())),
//   };
// }
//
// class FoodCategoryData {
//   FoodCategoryData({
//     this.id,
//     this.name,
//     this.imgUrl,
//     this.enabled,
//     // this.removed,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   int? id;
//   String? name;
//   String? imgUrl;
//   bool? enabled;
//   // String? removed;
//   String? createdAt;
//   String? updatedAt;
//
//   factory FoodCategoryData.fromJson(Map<String, dynamic> json) => FoodCategoryData(
//     id: json["id"],
//     name: json["name"],
//     imgUrl: json["imgUrl"],
//     enabled: json["enabled"],
//     // removed: json["removed"] == null ? json["removed"],
//     createdAt: json["createdAt"],
//     updatedAt: json["updatedAt"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "imgUrl": imgUrl,
//     "enabled": enabled,
//     // "removed": removed,
//     "createdAt": createdAt,
//     "updatedAt": updatedAt,
//   };
// }















class FoodCategoryListModel {
  int? count;
  List<FoodCategoryData>? items;

  FoodCategoryListModel({this.count, this.items});

  FoodCategoryListModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['items'] != null) {
      items = <FoodCategoryData>[];
      json['items'].forEach((v) {
        items!.add(new FoodCategoryData.fromJson(v));
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

class FoodCategoryData {
  int? id;
  String? nameUk;
  String? nameRu;
  String? nameEn;
  String? imgUrl;
  bool? enabled;
  bool? removed;
  int? order;
  String? createdAt;
  String? updatedAt;
  String? name;
  int? establishmentCount;

  FoodCategoryData(
      {this.id,
        this.nameUk,
        this.nameRu,
        this.nameEn,
        this.imgUrl,
        this.enabled,
        this.removed,
        this.order,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.establishmentCount});

  FoodCategoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameUk = json['name:uk'];
    nameRu = json['name:ru'];
    nameEn = json['name:en'];
    imgUrl = json['imgUrl'];
    enabled = json['enabled'];
    removed = json['removed'];
    order = json['order'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    name = json['name'];
    establishmentCount = json['establishmentCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name:uk'] = this.nameUk;
    data['name:ru'] = this.nameRu;
    data['name:en'] = this.nameEn;
    data['imgUrl'] = this.imgUrl;
    data['enabled'] = this.enabled;
    data['removed'] = this.removed;
    data['order'] = this.order;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['name'] = this.name;
    data['establishmentCount'] = this.establishmentCount;
    return data;
  }
}

