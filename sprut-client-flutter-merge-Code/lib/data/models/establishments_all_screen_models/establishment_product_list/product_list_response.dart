// To parse this JSON data, do
//
//     final productListResponse = productListResponseFromJson(jsonString);

import 'dart:convert';

ProductListResponse productListResponseFromJson(String str) => ProductListResponse.fromJson(json.decode(str));

String productListResponseToJson(ProductListResponse data) => json.encode(data.toJson());

class ProductListResponse {
  ProductListResponse({
    this.count,
    this.items,
  });

  int? count;
  List<ProductItems>? items;

  factory ProductListResponse.fromJson(Map<String, dynamic> json) => ProductListResponse(
    count: json["count"],
    items: List<ProductItems>.from(json["items"].map((x) => ProductItems.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "count": count,
    "items": List<dynamic>.from(items!.map((x) => x.toJson())),
  };
}

class ProductItems {
  ProductItems({
    this.id,
    this.name,
    this.weight,
    this.price,
    this.imgUrl,
    this.shortDescription,
    this.detailedDescription,
    this.status,
    this.removed,
    this.createdAt,
    this.updatedAt,
    this.brandId,
    this.sectionId,
    this.section,
    this.brand,
    this.quantity = 0,
  });

  int? id;
  String? name;
  String? weight;
  String? price;
  String? imgUrl;
  String? shortDescription;
  String? detailedDescription;
  String? status;
  bool? removed;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? brandId;
  int? sectionId;
  Section? section;
  Brand? brand;
  int? quantity;

  factory ProductItems.fromJson(Map<String, dynamic> json) => ProductItems(
    id: json["id"],
    name: json["name"],
    weight: json["weight"],
    price: json["price"],
    imgUrl: json["imgUrl"],
    shortDescription: json["shortDescription"] == null ? null : json["shortDescription"],
    detailedDescription: json["detailedDescription"] == null ? null : json["detailedDescription"],
    status: json["status"],
    removed: json["removed"] == null ? null : json["removed"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    brandId: json["brandId"],
    sectionId: json["sectionId"],
    section: Section.fromJson(json["section"]),
    brand: Brand.fromJson(json["brand"]),
    quantity: json["quantity"] == null ? 0 : json["quantity"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "weight": weight,
    "price": price,
    "imgUrl": imgUrl,
    "shortDescription": shortDescription == null ? null : shortDescription,
    "detailedDescription": detailedDescription == null ? null : detailedDescription,
    "status": status,
    "removed": removed == null ? null : removed,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "brandId": brandId,
    "sectionId": sectionId,
    "section": section?.toJson(),
    "brand": brand?.toJson(),
    "quantity" : quantity
  };
}

class Brand {
  Brand({
    this.id,
    this.phoneNumber,
    this.code,
    this.title,
    this.domain,
    this.tax,
    this.multipleApi,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.defaultOptionId,
    this.fromCurbOptionId,
    this.accountId,
  });

  int? id;
  String? phoneNumber;
  String? code;
  String? title;
  String? domain;
  int? tax;
  bool? multipleApi;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? defaultOptionId;
  int? fromCurbOptionId;
  int? accountId;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json["id"],
    phoneNumber: json["phoneNumber"],
    code: json["code"],
    title: json["title"],
    domain: json["domain"] == null ? null : json["domain"],
    tax: json["tax"],
    multipleApi: json["multipleApi"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    deletedAt: json["deletedAt"],
    defaultOptionId: json["defaultOptionId"] == null ? null : json["defaultOptionId"],
    fromCurbOptionId: json["fromCurbOptionId"] == null ? null : json["fromCurbOptionId"],
    accountId: json["accountId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "phoneNumber": phoneNumber,
    "code": code,
    "title": title,
    "domain": domain == null ? null : domain,
    "tax": tax,
    "multipleApi": multipleApi,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "deletedAt": deletedAt,
    "defaultOptionId": defaultOptionId == null ? null : defaultOptionId,
    "fromCurbOptionId": fromCurbOptionId == null ? null : fromCurbOptionId,
    "accountId": accountId,
  };
}

class Section {
  Section({
    this.id,
    this.name,
    this.status,
    this.description,
    this.removed,
    this.createdAt,
    this.updatedAt,
    this.brandId,
  });

  int? id;
  String? name;
  String? status;
  String? description;
  bool? removed;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? brandId;

  factory Section.fromJson(Map<String, dynamic> json) => Section(
    id: json["id"],
    name: json["name"],
    status: json["status"],
    description: json["description"] == null ? null : json["description"],
    removed: json["removed"] == null ? null : json["removed"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    brandId: json["brandId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "status": status,
    "description": description == null ? null : description,
    "removed": removed == null ? null : removed,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "brandId": brandId,
  };
}
