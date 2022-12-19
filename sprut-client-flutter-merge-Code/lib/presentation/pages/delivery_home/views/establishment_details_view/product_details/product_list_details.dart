class ProductListDetails {
  int? count;
  List<ProductItems>? items;

  ProductListDetails({this.count, this.items});

  ProductListDetails.fromJson(Map<String, dynamic> json) {
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
  String? createdAt;
  String? updatedAt;
  int? brandId;
  int? establishmentId;
  int? establishmentAddressId;
  int? sectionId;
  ProductSection? section;
  ProductBrand? brand;
  ProductEstablishment? establishment;
  String? name;
  String? shortDescription;
  String? detailedDescription;

  ProductItems(
      {this.id,
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
        this.detailedDescription});

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
    quantityType = json['quantityType'];
    status = json['status'];
    removed = json['removed'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    brandId = json['brandId'];
    establishmentId = json['establishmentId'];
    establishmentAddressId = json['establishmentAddressId'];
    sectionId = json['sectionId'];
    section =
    json['section'] != null ? new ProductSection.fromJson(json['section']) : null;
    brand = json['brand'] != null ? new ProductBrand.fromJson(json['brand']) : null;
    establishment = json['establishment'] != null
        ? new ProductEstablishment.fromJson(json['establishment'])
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

class ProductSection {
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

  ProductSection(
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

  ProductSection.fromJson(Map<String, dynamic> json) {
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
    removed = json['removed'];
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

class ProductBrand {
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

  ProductBrand(
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

  ProductBrand.fromJson(Map<String, dynamic> json) {
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
    defaultOptionId = json['defaultOptionId'];
    fromCurbOptionId = json['fromCurbOptionId'];
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

class ProductEstablishment {
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

  ProductEstablishment(
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

  ProductEstablishment.fromJson(Map<String, dynamic> json) {
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
    removed = json['removed'];
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
