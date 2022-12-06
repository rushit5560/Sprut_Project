// To parse this JSON data, do
//
//     final foodCategoryListModel = foodCategoryListModelFromJson(jsonString);

import 'dart:convert';

FoodCategoryListModel foodCategoryListModelFromJson(String str) => FoodCategoryListModel.fromJson(json.decode(str));

String foodCategoryListModelToJson(FoodCategoryListModel data) => json.encode(data.toJson());

class FoodCategoryListModel {
  FoodCategoryListModel({
    this.count,
    this.items,
  });

  int? count;
  List<FoodCategoryData>? items;

  factory FoodCategoryListModel.fromJson(Map<String, dynamic> json) => FoodCategoryListModel(
    count: json["count"],
    items: List<FoodCategoryData>.from(json["items"].map((x) => FoodCategoryData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "items": List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class FoodCategoryData {
  FoodCategoryData({
    this.id,
    this.name,
    this.imgUrl,
    this.enabled,
    // this.removed,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? name;
  String? imgUrl;
  bool? enabled;
  // String? removed;
  String? createdAt;
  String? updatedAt;

  factory FoodCategoryData.fromJson(Map<String, dynamic> json) => FoodCategoryData(
    id: json["id"],
    name: json["name"],
    imgUrl: json["imgUrl"],
    enabled: json["enabled"],
    // removed: json["removed"] == null ? json["removed"],
    createdAt: json["createdAt"],
    updatedAt: json["updatedAt"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "imgUrl": imgUrl,
    "enabled": enabled,
    // "removed": removed,
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}
