// To parse this JSON data, do
//
//     final productListResponse = productListResponseFromJson(jsonString);

import 'dart:convert';

ProductListResponse productListResponseFromJson(String str) =>
    ProductListResponse.fromJson(json.decode(str));

String productListResponseToJson(ProductListResponse data) =>
    json.encode(data.toJson());

/*class ProductListResponse {
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
}*/

/*class ProductItems {
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
    this.quantityType,
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
  String? quantityType;

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
    quantity: json["quantity"] == null ? 0 : json["quantity"],
    quantityType: json['quantityType']==null?'null': json['quantityType']
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
    "quantity" : quantity,
    "quantityType": quantityType,
  };
}*/

/*class Brand {
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
}*/

/*class Section {
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
}*/

class ProductListResponse {
  int? count;
  List<ProductItems>? items;

  ProductListResponse({this.count, this.items});

  ProductListResponse.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['items'] != null) {
      items = <ProductItems>[];
      json['items'].forEach((v) {
        items!.add(new ProductItems.fromJson(v));
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

class ProductItems {
  int? id;
  String? nameUk;
  String? nameRu;
  String? nameEn;
  String? shortDescriptionUk;
  String? shortDescriptionRu;
  String? shortDescriptionEn;
  String? detailedDescriptionUk;
  String? detailedDescriptionRu;
  String? detailedDescriptionEn;
  String? weight;
  String? price;
  String? imgUrl;
  String? quantityType;
  String? status;
  bool? removed;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? brandId;
  int? establishmentId;
  int? establishmentAddressId;
  int? sectionId;
  Section? section;
  Brand? brand;
  Establishment? establishment;
  String? name;
  String? shortDescription;
  String? detailedDescription;
  int? quantity;

  ProductItems({
    this.id,
    this.nameUk,
    this.nameRu,
    this.nameEn,
    this.shortDescriptionUk,
    this.shortDescriptionRu,
    this.shortDescriptionEn,
    this.detailedDescriptionUk,
    this.detailedDescriptionRu,
    this.detailedDescriptionEn,
    this.weight,
    this.price,
    this.imgUrl,
    this.quantityType,
    this.status,
    this.removed,
    this.createdAt,
    this.updatedAt,
    this.brandId,
    this.establishmentId,
    this.establishmentAddressId,
    this.sectionId,
    this.section,
    this.brand,
    this.establishment,
    this.name,
    this.shortDescription,
    this.detailedDescription,
    this.quantity = 0,
  });

  ProductItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameUk = json['name:uk'];
    nameRu = json['name:ru'];
    nameEn = json['name:en'];
    shortDescriptionUk = json['shortDescription:uk'];
    shortDescriptionRu = json['shortDescription:ru'];
    shortDescriptionEn = json['shortDescription:en'];
    detailedDescriptionUk = json['detailedDescription:uk'];
    detailedDescriptionRu = json['detailedDescription:ru'];
    detailedDescriptionEn = json['detailedDescription:en'];
    weight = json['weight'];
    price = json['price'];
    imgUrl = json['imgUrl'];
    quantity = json["quantity"] == null ? 0 : json["quantity"];
    quantityType = json['quantityType'];
    status = json['status'];
    removed = json['removed'];
    createdAt = DateTime.parse(json["createdAt"]);
    updatedAt = DateTime.parse(json["updatedAt"]);
    brandId = json['brandId'];
    establishmentId = json['establishmentId'];
    establishmentAddressId = json['establishmentAddressId'];
    sectionId = json['sectionId'];
    section =
        json['section'] != null ? new Section.fromJson(json['section']) : null;
    brand = json['brand'] != null ? new Brand.fromJson(json['brand']) : null;
    establishment = json['establishment'] != null
        ? new Establishment.fromJson(json['establishment'])
        : null;
    name = json['name'];
    shortDescription = json['shortDescription'];
    detailedDescription = json['detailedDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name:uk'] = this.nameUk;
    data['name:ru'] = this.nameRu;
    data['name:en'] = this.nameEn;
    data['shortDescription:uk'] = this.shortDescriptionUk;
    data['shortDescription:ru'] = this.shortDescriptionRu;
    data['shortDescription:en'] = this.shortDescriptionEn;
    data['detailedDescription:uk'] = this.detailedDescriptionUk;
    data['detailedDescription:ru'] = this.detailedDescriptionRu;
    data['detailedDescription:en'] = this.detailedDescriptionEn;
    data['weight'] = this.weight;
    data['price'] = this.price;
    data['imgUrl'] = this.imgUrl;
    data['quantityType'] = this.quantityType;
    data['status'] = this.status;
    data['removed'] = this.removed;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['brandId'] = this.brandId;
    data['establishmentId'] = this.establishmentId;
    data['establishmentAddressId'] = this.establishmentAddressId;
    data['sectionId'] = this.sectionId;
    if (this.section != null) {
      data['section'] = this.section!.toJson();
    }
    if (this.brand != null) {
      data['brand'] = this.brand!.toJson();
    }
    if (this.establishment != null) {
      data['establishment'] = this.establishment!.toJson();
    }
    data['name'] = this.name;
    data['shortDescription'] = this.shortDescription;
    data['detailedDescription'] = this.detailedDescription;
    return data;
  }
}

class Section {
  int? id;
  String? nameUk;
  String? nameRu;
  String? nameEn;
  String? descriptionUk;
  String? descriptionRu;
  String? descriptionEn;
  String? status;
  String? margin;
  int? order;
  bool? removed;
  String? createdAt;
  String? updatedAt;
  int? brandId;
  int? establishmentId;
  String? name;

  Section(
      {this.id,
      this.nameUk,
      this.nameRu,
      this.nameEn,
      this.descriptionUk,
      this.descriptionRu,
      this.descriptionEn,
      this.status,
      this.margin,
      this.order,
      this.removed,
      this.createdAt,
      this.updatedAt,
      this.brandId,
      this.establishmentId,
      this.name});

  Section.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameUk = json['name:uk'];
    nameRu = json['name:ru'];
    nameEn = json['name:en'];
    descriptionUk = json['description:uk'];
    descriptionRu = json['description:ru'];
    descriptionEn = json['description:en'];
    status = json['status'];
    margin = json['margin'];
    order = json['order'];
    removed = json['removed'] == null ? false : json['removed'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    brandId = json['brandId'];
    establishmentId = json['establishmentId'];
    name = json['name'];
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
    data['status'] = this.status;
    data['margin'] = this.margin;
    data['order'] = this.order;
    data['removed'] = this.removed;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['brandId'] = this.brandId;
    data['establishmentId'] = this.establishmentId;
    data['name'] = this.name;
    return data;
  }
}

class Brand {
  int? id;
  String? phoneNumber;
  String? code;
  String? title;
  String? domain;
  int? tax;
  bool? multipleApi;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? defaultOptionId;
  int? fromCurbOptionId;
  int? accountId;

  Brand(
      {this.id,
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
      this.accountId});

  Brand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    phoneNumber = json['phoneNumber'];
    code = json['code'];
    title = json['title'];
    domain = json['domain'];
    tax = json['tax'];
    multipleApi = json['multipleApi'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
    defaultOptionId =
        json['defaultOptionId'] == null ? 0 : json['defaultOptionId'];
    fromCurbOptionId =
        json['fromCurbOptionId'] == null ? 0 : json['fromCurbOptionId'];
    accountId = json['accountId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phoneNumber'] = this.phoneNumber;
    data['code'] = this.code;
    data['title'] = this.title;
    data['domain'] = this.domain;
    data['tax'] = this.tax;
    data['multipleApi'] = this.multipleApi;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    data['defaultOptionId'] = this.defaultOptionId;
    data['fromCurbOptionId'] = this.fromCurbOptionId;
    data['accountId'] = this.accountId;
    return data;
  }
}

class Establishment {
  int? id;
  String? nameUk;
  String? nameRu;
  String? nameEn;
  String? descriptionUk;
  String? descriptionRu;
  String? descriptionEn;
  String? imgUrl;
  String? openTime;
  String? closeTime;
  bool? closedOnAlarm;
  bool? enabled;
  String? minimalPrice;
  String? commission;
  String? margin;
  String? cookTime;
  bool? removed;
  bool? closedRN;
  String? managerPhoneNumber;
  int? order;
  String? createdAt;
  String? updatedAt;
  int? categoryId;
  int? brandId;

  Establishment(
      {this.id,
      this.nameUk,
      this.nameRu,
      this.nameEn,
      this.descriptionUk,
      this.descriptionRu,
      this.descriptionEn,
      this.imgUrl,
      this.openTime,
      this.closeTime,
      this.closedOnAlarm,
      this.enabled,
      this.minimalPrice,
      this.commission,
      this.margin,
      this.cookTime,
      this.removed,
      this.closedRN,
      this.managerPhoneNumber,
      this.order,
      this.createdAt,
      this.updatedAt,
      this.categoryId,
      this.brandId});

  Establishment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nameUk = json['name:uk'];
    nameRu = json['name:ru'];
    nameEn = json['name:en'];
    descriptionUk = json['description:uk'];
    descriptionRu = json['description:ru'];
    descriptionEn = json['description:en'];
    imgUrl = json['imgUrl'];
    openTime = json['openTime'];
    closeTime = json['closeTime'];
    closedOnAlarm = json['closedOnAlarm'];
    enabled = json['enabled'];
    minimalPrice = json['minimalPrice'];
    commission = json['commission'];
    margin = json['margin'];
    cookTime = json['cookTime'];
    removed = json['removed'] == null ? false : json['removed'];
    closedRN = json['closedRN'];
    managerPhoneNumber = json['managerPhoneNumber'];
    order = json['order'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    categoryId = json['categoryId'];
    brandId = json['brandId'];
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
    data['openTime'] = this.openTime;
    data['closeTime'] = this.closeTime;
    data['closedOnAlarm'] = this.closedOnAlarm;
    data['enabled'] = this.enabled;
    data['minimalPrice'] = this.minimalPrice;
    data['commission'] = this.commission;
    data['margin'] = this.margin;
    data['cookTime'] = this.cookTime;
    data['removed'] = this.removed;
    data['closedRN'] = this.closedRN;
    data['managerPhoneNumber'] = this.managerPhoneNumber;
    data['order'] = this.order;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['categoryId'] = this.categoryId;
    data['brandId'] = this.brandId;
    return data;
  }
}
