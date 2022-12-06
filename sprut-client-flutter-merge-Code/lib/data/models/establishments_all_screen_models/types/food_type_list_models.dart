// To parse this JSON data, do
//
//     final foodTypeModels = foodTypeModelsFromJson(jsonString);

import 'dart:convert';

FoodTypeModels foodTypeModelsFromJson(String str) => FoodTypeModels.fromJson(json.decode(str));

String foodTypeModelsToJson(FoodTypeModels data) => json.encode(data.toJson());

class FoodTypeModels {
  FoodTypeModels({
    this.count,
    this.items,
  });

  int? count;
  List<FoodType>? items;

  factory FoodTypeModels.fromJson(Map<String, dynamic> json) => FoodTypeModels(
    count: json["count"],
    items: List<FoodType>.from(json["items"].map((x) => FoodType.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "items": List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class FoodType {
  FoodType({
    this.id,
    this.name,
    this.description,
    this.imgUrl,
    this.status,
    this.removed,
    this.createdAt,
    this.updatedAt,
    this.isFiltered,
  });

  int? id;
  String? name;
  dynamic description;
  String? imgUrl;
  String? status;
  dynamic removed;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isFiltered = false;

  factory FoodType.fromJson(Map<String, dynamic> json) => FoodType(
    id: json["id"],
    name: json["name"],
    description: json["description"],
    imgUrl: json["imgUrl"],
    status: json["status"],
    removed: json["removed"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "description": description,
    "imgUrl": imgUrl,
    "status": status,
    "removed": removed,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
  };
}
