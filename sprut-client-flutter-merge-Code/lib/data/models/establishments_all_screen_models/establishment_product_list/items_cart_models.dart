
class ItemsCartModels {
  ItemsCartModels({
    required this.id,
    required this.name,
    required this.weight,
    required this.price,
    required this.imgUrl,
    required this.shortDescription,
    required this.detailedDescription,
    required this.status,
    required this.removed,
    required this.createdAt,
    required this.updatedAt,
    required this.brandId,
    required this.sectionId,
    required this.quantity,
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
  int? quantity;

  factory ItemsCartModels.fromJson(Map<String, dynamic> json) => ItemsCartModels(
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
    "quantity" : quantity
  };

}

class Brand {
  Brand({
    required this.id,
    required this.phoneNumber,
    required this.code,
    required this.title,
    required this.domain,
    required this.tax,
    required this.multipleApi,
    required this.createdAt,
    required this.updatedAt,
    required this.deletedAt,
    required this.defaultOptionId,
    required this.fromCurbOptionId,
    required this.accountId,
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

}

class Section {
  Section({
    required this.id,
    required this.name,
    required this.status,
    required this.description,
    required this.removed,
    required this.createdAt,
    required this.updatedAt,
    required this.brandId,
  });

  int? id;
  String? name;
  String? status;
  String? description;
  bool? removed;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? brandId;

}
