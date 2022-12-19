// To parse this JSON data, do
//
//     final allEstablishments = allEstablishmentsFromJson(jsonString);

import 'dart:convert';
import 'dart:ffi';

/*
AllEstablishments allEstablishmentsFromJson(String str) => AllEstablishments.fromJson(json.decode(str));

String allEstablishmentsToJson(AllEstablishments data) => json.encode(data.toJson());
class AllEstablishments {
  int? count;
  List<Establishments>? items;

  AllEstablishments({this.count, this.items});

  AllEstablishments.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    if (json['items'] != null) {
      items = <Establishments>[];
      json['items'].forEach((v) {
        items!.add(new Establishments.fromJson(v));
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

class Establishments {
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
  List<Types>? types;
  Brand? brand;
  Category? category;
  List<Addresses>? addresses;
  String? name;
  String? description;
  Place? place;
  int? distance;
  int? calculatedPrice;
  double? deliveryTime;
  int? cashbackPercent;

  Establishments({this.id,this.nameUk,this.nameRu,this.nameEn,this.descriptionUk,this.descriptionRu,this.descriptionEn,this.imgUrl,this.openTime,this.closeTime,this.closedOnAlarm,this.enabled,this.minimalPrice,this.commission,this.margin,this.cookTime,this.removed,this.closedRN,this.managerPhoneNumber,this.order,this.createdAt,this.updatedAt,this.categoryId,this.brandId,this.types,this.brand,this.category,this.addresses,this.name,this.description,this.place,this.distance,this.calculatedPrice,this.deliveryTime,this.cashbackPercent});
  String getDistance() {
    if (distance == null) {
      return "0";
    }
    return (distance! / 1000).toStringAsFixed(2);
  }

  double getCashBack(double price) {
    return double.parse((price * (cashbackPercent ?? 0) / 100).toStringAsFixed(2));
  }

  Establishments.fromJson(Map<String, dynamic> json) {
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
    removed = json["removed"] == null ? false : json["removed"];
    closedRN = json['closedRN'];
    managerPhoneNumber = json['managerPhoneNumber'] == null ? 0 : json['managerPhoneNumber'];
    order = json['order'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    categoryId = json['categoryId'];
    brandId = json['brandId'];
    if (json['types'] != null) {
      types = <Types>[];
      json['types'].forEach((v) {
        types!.add(new Types.fromJson(v));
      });
    }
    brand = json['brand'] != null ? new Brand.fromJson(json['brand']) : null;
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
    if (json['addresses'] != null) {
      addresses = <Addresses>[];
      json['addresses'].forEach((v) {
        addresses!.add(new Addresses.fromJson(v));
      });
    }
    name = json['name'];
    description = json['description'];
    place = json['place'] != null ? new Place.fromJson(json['place']) : null;
    distance = json['distance'];
    calculatedPrice = json['calculatedPrice'];
    deliveryTime = json['deliveryTime'];
    cashbackPercent = json['cashbackPercent'];

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
    if (this.types != null) {
      data['types'] = this.types!.map((v) => v.toJson()).toList();
    }
    if (this.brand != null) {
      data['brand'] = this.brand!.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category!.toJson();
    }
    if (this.addresses != null) {
      data['addresses'] = this.addresses!.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    data['description'] = this.description;
    if (this.place != null) {
      data['place'] = this.place!.toJson();
    }
    data['distance'] = this.distance;
    data['calculatedPrice'] = this.calculatedPrice;
    data['deliveryTime'] = this.deliveryTime;
    data['cashbackPercent'] = this.cashbackPercent;
    return data;
  }
}

class Types {
  int? id;
  int? establishmentId;
  int? typeId;
  String? createdAt;
  String? updatedAt;
  Type? type;

  Types(
      {this.id,
        this.establishmentId,
        this.typeId,
        this.createdAt,
        this.updatedAt,
        this.type});

  Types.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    establishmentId = json['establishmentId'];
    typeId = json['typeId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    type = json['type'] != null ? new Type.fromJson(json['type']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['establishmentId'] = this.establishmentId;
    data['typeId'] = this.typeId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.type != null) {
      data['type'] = this.type!.toJson();
    }
    return data;
  }
}

class Type {
  int? id;
  String? nameUk;
  String? nameRu;
  String? nameEn;
  String? descriptionUk;
  String? descriptionRu;
  String? descriptionEn;
  String? imgUrl;
  String? status;
  bool? removed;
  String? createdAt;
  String? updatedAt;

  Type(
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
        this.updatedAt});

  Type.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class Brand {
  int? id;
  String? phoneNumber;
  String? code;
  String? title;
  Null? domain;
  int? tax;
  bool? multipleApi;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;
  Null? defaultOptionId;
  Null? fromCurbOptionId;
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

class Category {
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

  Category(
      {this.id,
        this.nameUk,
        this.nameRu,
        this.nameEn,
        this.imgUrl,
        this.enabled,
        this.removed,
        this.order,
        this.createdAt,
        this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}

class Addresses {
  int? id;
  int? establishmentId;
  int? placeId;
  String? createdAt;
  String? updatedAt;
  Place? place;

  Addresses(
      {this.id,
        this.establishmentId,
        this.placeId,
        this.createdAt,
        this.updatedAt,
        this.place});

  Addresses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    establishmentId = json['establishmentId'];
    placeId = json['placeId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    place = json['place'] != null ? new Place.fromJson(json['place']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['establishmentId'] = this.establishmentId;
    data['placeId'] = this.placeId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    if (this.place != null) {
      data['place'] = this.place!.toJson();
    }
    return data;
  }
}

class Place {
  Coords? coords;
  int? id;
  String? street;
  String? houseNumber;
  String? name;
  String? city;
  String? osmId;
  String? district;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;

  Place(
      {this.coords,
        this.id,
        this.street,
        this.houseNumber,
        this.name,
        this.city,
        this.osmId,
        this.district,
        this.latitude,
        this.longitude,
        this.createdAt,
        this.updatedAt});

  Place.fromJson(Map<String, dynamic> json) {
    coords =
    json['coords'] != null ? new Coords.fromJson(json['coords']) : null;
    id = json['id'];
    street = json['street'];
    houseNumber = json['houseNumber'];
    name = json['name'];
    city = json['city'];
    osmId = json['osmId'];
    district = json['district'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coords != null) {
      data['coords'] = this.coords!.toJson();
    }
    data['id'] = this.id;
    data['street'] = this.street;
    data['houseNumber'] = this.houseNumber;
    data['name'] = this.name;
    data['city'] = this.city;
    data['osmId'] = this.osmId;
    data['district'] = this.district;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class Coords {
  String? latitude;
  String? longitude;

  Coords({this.latitude, this.longitude});

  Coords.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}
*/

class AllEstablishments {
  AllEstablishments({
    this.count,
    this.items,
  });

  int? count;
  List<Establishments>? items;

  factory AllEstablishments.fromJson(Map<String, dynamic> json) =>
      AllEstablishments(
        count: json["count"],
        items: List<Establishments>.from(
            json["items"].map((x) => Establishments.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "items": List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class Establishments {
  Establishments(
      {this.id,
      this.name,
      this.nameUk,
      this.nameRu,
      this.nameEn,
      this.descriptionUk,
      this.descriptionRu,
      this.descriptionEn,
      this.imgUrl,
      this.openTime,
      this.closeTime,
      this.enabled,
      this.closedOnAlarm,
      this.description,
      this.minimalPrice,
      this.cookTime,
      this.removed,
      this.managerPhoneNumber,
      this.createdAt,
      this.updatedAt,
      this.categoryId,
      this.brandId,
      this.types,
      this.brand,
      this.category,
      this.addresses,
      this.place,
      this.distance,
      this.calculatedPrice,
      this.deliveryTime,
      this.cashbackPercent});

  int? id;
  String? name;
  String? nameUk;
  String? nameRu;
  String? nameEn;
  String? descriptionUk;
  String? descriptionRu;
  String? descriptionEn;
  String? imgUrl;
  String? openTime;
  String? closeTime;
  bool? enabled;
  bool? closedOnAlarm;
  String? description;
  String? minimalPrice;
  String? cookTime;
  bool? removed;
  String? managerPhoneNumber;
  String? createdAt;
  String? updatedAt;
  int? categoryId;
  int? brandId;
  List<Type>? types;
  Brand? brand;
  Category? category;
  List<Address>? addresses;
  Place? place;
  num? distance;
  num? calculatedPrice;
  num? deliveryTime;
  num? cashbackPercent;

  String getDistance() {
    if (distance == null) {
      return "0";
    }
    return (distance! / 1000).toStringAsFixed(2);
  }

  double getCashBack(double price) {
    return double.parse(
        (price * (cashbackPercent ?? 0) / 100).toStringAsFixed(2));
  }

  factory Establishments.fromJson(Map<String, dynamic> json) => Establishments(
        id: json["id"],
        name: json["name"],
        nameUk: json['name:uk'],
        nameRu: json['name:ru'],
        nameEn: json['name:en'],
        descriptionUk: json['description:uk'],
        descriptionRu: json['description:ru'],
        descriptionEn: json['description:en'],
        imgUrl: json["imgUrl"],
        openTime: json["openTime"],
        closeTime: json["closeTime"],
        enabled: json["enabled"],
        closedOnAlarm: json["closedOnAlarm"],
        description: json["description"] == null ? null : json["description"],
        minimalPrice: json["minimalPrice"],
        cookTime: json["cookTime"],
        removed: json["removed"] == null ? null : json["removed"],
        managerPhoneNumber: json["managerPhoneNumber"] == null
            ? null
            : json["managerPhoneNumber"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        categoryId: json["categoryId"],
        brandId: json["brandId"],
        types: List<Type>.from(json["types"].map((x) => Type.fromJson(x))),
        brand: Brand.fromJson(json["brand"]),
        category: Category.fromJson(json["category"]),
        addresses: List<Address>.from(
            json["addresses"].map((x) => Address.fromJson(x))),
        place: Place.fromJson(json["place"]),
        distance: json["distance"] == null ? 0.0 : json["distance"],
        calculatedPrice:
            json["calculatedPrice"] == null ? 0 : json["calculatedPrice"],
        deliveryTime: json["deliveryTime"] == null ? 0.0 : json["deliveryTime"],
        cashbackPercent:
            json["cashbackPercent"] == null ? 0 : json["cashbackPercent"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imgUrl": imgUrl,
        "openTime": openTime,
        "closeTime": closeTime,
        "enabled": enabled,
        "closedOnAlarm": closedOnAlarm,
        "description": description == null ? null : description,
        "minimalPrice": minimalPrice,
        "cookTime": cookTime,
        "removed": removed == null ? null : removed,
        "managerPhoneNumber":
            managerPhoneNumber == null ? null : managerPhoneNumber,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "categoryId": categoryId,
        "brandId": brandId,
        "types": List<dynamic>.from(types!.map((x) => x.toJson())),
        "brand": brand?.toJson(),
        "category": category?.toJson(),
        "addresses": List<dynamic>.from(addresses!.map((x) => x.toJson())),
        "place": place?.toJson(),
        "distance": distance,
        "calculatedPrice": calculatedPrice,
        "deliveryTime": deliveryTime,
        "cashbackPercent": cashbackPercent,
      };
}

class Address {
  Address({
    this.id,
    this.establishmentId,
    this.placeId,
    this.createdAt,
    this.updatedAt,
    this.place,
  });

  int? id;
  int? establishmentId;
  int? placeId;
  String? createdAt;
  String? updatedAt;
  Place? place;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        id: json["id"],
        establishmentId: json["establishmentId"],
        placeId: json["placeId"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        place: Place.fromJson(json["place"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "establishmentId": establishmentId,
        "placeId": placeId,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "place": place?.toJson(),
      };
}

class Place {
  Place({
    this.coords,
    this.id,
    this.street,
    this.houseNumber,
    this.name,
    this.city,
    this.osmId,
    this.district,
    this.latitude,
    this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  Coords? coords;
  int? id;
  String? street;
  String? houseNumber;
  String? name;
  String? city;
  String? osmId;
  String? district;
  String? latitude;
  String? longitude;
  String? createdAt;
  String? updatedAt;

  factory Place.fromJson(Map<String, dynamic> json) => Place(
        coords: Coords.fromJson(json["coords"]),
        id: json["id"],
        street: json["street"],
        houseNumber: json["houseNumber"],
        name: json["name"],
        city: json["city"],
        osmId: json["osmId"],
        district: json["district"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "coords": coords,
        "id": id,
        "street": street,
        "houseNumber": houseNumber,
        "name": name,
        "city": city,
        "osmId": osmId,
        "district": district,
        "latitude": latitude,
        "longitude": longitude,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}

class Coords {
  Coords({
    this.latitude,
    this.longitude,
  });

  String? latitude;
  String? longitude;

  factory Coords.fromJson(Map<String, dynamic> json) => Coords(
        latitude: json["latitude"],
        longitude: json["longitude"],
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
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
  dynamic domain;
  int? tax;
  bool? multipleApi;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  dynamic defaultOptionId;
  dynamic fromCurbOptionId;
  int? accountId;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
        id: json["id"],
        phoneNumber: json["phoneNumber"],
        code: json["code"],
        title: json["title"],
        domain: json["domain"],
        tax: json["tax"],
        multipleApi: json["multipleApi"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        deletedAt: json["deletedAt"],
        defaultOptionId: json["defaultOptionId"],
        fromCurbOptionId: json["fromCurbOptionId"],
        accountId: json["accountId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "phoneNumber": phoneNumber,
        "code": code,
        "title": title,
        "domain": domain,
        "tax": tax,
        "multipleApi": multipleApi,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "deletedAt": deletedAt,
        "defaultOptionId": defaultOptionId,
        "fromCurbOptionId": fromCurbOptionId,
        "accountId": accountId,
      };
}


class Category {
  Category({
    this.id,
    this.name,
    this.imgUrl,
    this.enabled,
    this.removed,
    this.createdAt,
    this.updatedAt,
    this.description,
    this.status,
  });

  int? id;
  String? name;
  String? imgUrl;
  bool? enabled;
  bool? removed;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? description;
  String? status;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
        imgUrl: json["imgUrl"],
        enabled: json["enabled"] == null ? null : json["enabled"],
        removed: json["removed"] == null ? null : json["removed"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        description: json["description"] == null ? null : json["description"],
        status: json["status"] == null ? null : json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imgUrl": imgUrl,
        "enabled": enabled == null ? null : enabled,
        "removed": removed == null ? null : removed,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "description": description == null ? null : description,
        "status": status == null ? null : status,
      };
}

class Type {
  Type({
    this.id,
    this.establishmentId,
    this.typeId,
    this.createdAt,
    this.updatedAt,
    this.type,
  });

  int? id;
  int? establishmentId;
  int? typeId;
  DateTime? createdAt;
  DateTime? updatedAt;
  Category? type;

  factory Type.fromJson(Map<String, dynamic> json) => Type(
        id: json["id"],
        establishmentId: json["establishmentId"],
        typeId: json["typeId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        type: Category.fromJson(json["type"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "establishmentId": establishmentId,
        "typeId": typeId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "type": type?.toJson(),
      };
}
