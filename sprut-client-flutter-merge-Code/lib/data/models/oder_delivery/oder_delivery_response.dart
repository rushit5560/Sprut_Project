// To parse this JSON data, do
//
//     final makeOrderResponse = makeOrderResponseFromJson(jsonString);

import 'dart:convert';

import 'package:sprut/data/models/establishments_all_screen_models/all_sstablishments_list_models.dart';

//new response
// To parse this JSON data, do
//
//     final makeOrderResponse = makeOrderResponseFromJson(jsonString);

// To parse this JSON data, do
//
//     final makeOrderResponse = makeOrderResponseFromJson(jsonString);


MakeOrderResponse makeOrderResponseFromJson(String str) => MakeOrderResponse.fromJson(json.decode(str));

String makeOrderResponseToJson(MakeOrderResponse data) => json.encode(data.toJson());

class MakeOrderResponse {
  MakeOrderResponse({
    this.orderId,
    this.comment,
    this.cancelledBy,
    this.deliveryCancelReason,
    this.createdAt,
    this.arrivesAt,
    this.status,
    this.countOfPersons,
    this.car,
    this.establishment,
    this.paymentStatus,
    this.commentForEstablishment,
    this.modifiers,
    this.paidToMinimalOrder,
    this.cashbackAmount,
    this.summary,
    this.isDelivery,
    this.deliveryStatus,
    this.products,
    this.isSuccessfulOrder,
    this.addresses,
    this.rate,
  });

  String? orderId;
  String? comment;
  dynamic cancelledBy;
  String? deliveryCancelReason;
  DateTime? createdAt;
  dynamic arrivesAt;
  String? status;
  int? countOfPersons;
  CarModel? car;
  Establishment? establishment;
  String? paymentStatus;
  dynamic commentForEstablishment;
  Modifiers? modifiers;
  num? paidToMinimalOrder;
  num? cashbackAmount;
  Summary? summary;
  bool? isDelivery;
  String? deliveryStatus;
  List<ProductElement>? products;
  bool? isSuccessfulOrder;
  List<Address>? addresses;
  Rate? rate;

  factory MakeOrderResponse.fromJson(Map<String, dynamic> json) => MakeOrderResponse(
    orderId: json["orderId"] ?? "",
    comment: json["comment"] ?? "",
    cancelledBy: json["cancelledBy"] ?? "",
    deliveryCancelReason: json["deliveryCancelReason"] == null ? "" : json["deliveryCancelReason"],
    createdAt: DateTime.parse(json["createdAt"]),
    arrivesAt: json["arrivesAt"],
    status: json["status"],
    countOfPersons: json["countOfPersons"],
    car: json["car"] == null ? null : CarModel.fromJson(json["car"]),
    establishment: Establishment.fromJson(json["establishment"]),
    paymentStatus: json["paymentStatus"],
    commentForEstablishment: json["commentForEstablishment"],
    modifiers: Modifiers.fromJson(json["modifiers"]),
    paidToMinimalOrder: json["paidToMinimalOrder"],
    cashbackAmount: json["cashbackAmount"] == null ? 0 : json["cashbackAmount"],
    summary: Summary.fromJson(json["summary"]),
    isDelivery: json["isDelivery"],
    deliveryStatus: json["deliveryStatus"],
    products: List<ProductElement>.from(json["products"].map((x) => ProductElement.fromJson(x))),
    isSuccessfulOrder: json["isSuccessfulOrder"],
    addresses: List<Address>.from(json["addresses"].map((x) => Address.fromJson(x))),
    rate: json["rate"] == null ? null : Rate.fromJson(json["rate"]),
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "comment": comment,
    "cancelledBy": cancelledBy,
    "deliveryCancelReason": deliveryCancelReason,
    "createdAt": createdAt?.toIso8601String(),
    "arrivesAt": arrivesAt,
    "status": status,
    "countOfPersons": countOfPersons,
    "car": car,
    "establishment": establishment?.toJson(),
    "paymentStatus": paymentStatus,
    "commentForEstablishment": commentForEstablishment,
    "modifiers": modifiers?.toJson(),
    "paidToMinimalOrder": paidToMinimalOrder,
    "cashbackAmount": cashbackAmount,
    "summary": summary?.toJson(),
    "isDelivery": isDelivery,
    "deliveryStatus": deliveryStatus,
    "products": List<dynamic>.from(products!.map((x) => x.toJson())),
    "isSuccessfulOrder": isSuccessfulOrder,
    "addresses": List<dynamic>.from(addresses!.map((x) => x.toJson())),
    "rate": rate?.toJson(),
  };
}

class CarModel {
  CarModel({
    required this.year,
    required this.driverName,
    required this.driverPhoneNumber,
    required this.licensePlateNumber,
    required this.lat,
    required this.lon,
    required this.makeRaw,
    required this.modelRaw,
    required this.colorRaw,
    required this.heading,
    required this.rating,
  });

  final int? year;
  final String? driverName;
  final String? driverPhoneNumber;
  final String? licensePlateNumber;
  final double? lat;
  final double? lon;
  final String? makeRaw;
  final String? modelRaw;
  final String? colorRaw;
  final int? heading;
  final num? rating;

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
    year: json["year"] ?? 0,
    driverName: json["driverName"] ?? "",
    driverPhoneNumber: json["driverPhoneNumber"] ?? "",
    licensePlateNumber: json["licensePlateNumber"] ?? "",
    lat: json["lat"].toDouble() ?? 0.0,
    lon: json["lon"].toDouble() ?? 0.0,
    makeRaw: json["make_raw"] ?? "",
    modelRaw: json["model_raw"] ?? "",
    colorRaw: json["color_raw"] ?? "",
    heading: json["heading"] ?? 0,
    rating: json["rating"] ?? 5.0,
  );

  Map<String, dynamic> toJson() => {
    "year": year,
    "driverName": driverName,
    "driverPhoneNumber": driverPhoneNumber,
    "licensePlateNumber": licensePlateNumber,
    "lat": lat,
    "lon": lon,
    "make_raw": makeRaw,
    "model_raw": modelRaw,
    "color_raw": colorRaw,
    "heading": heading,
    "rating": rating,
  };
}

class Establishment {
  Establishment({
    this.id,
    this.name,
    this.nameUk,
    this.nameRu,
    this.imgUrl,
    this.enabled,
    this.description,
    this.descriptionUk,
    this.descriptionRu,
    this.minimalPrice,
    this.cookTime,
    this.removed,
    this.managerPhoneNumber,
    this.createdAt,
    this.updatedAt,
    this.categoryId,
    this.brandId,
    this.addresses,
    this.distance,
    this.calculatedPrice,
    this.deliveryTime,
    this.cashbackPercent
  });

  int? id;
  // String? name;
  String? nameUk;
  String? nameRu;
  String? name;
  String? descriptionUk;
  String? descriptionRu;
  String? description;
  String? imgUrl;
  bool? enabled;
  // dynamic description;
  String? minimalPrice;
  String? cookTime;
  dynamic removed;
  String? managerPhoneNumber;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? categoryId;
  int? brandId;
  List<EstablishmentAddress>? addresses;
  num? distance;
  num? calculatedPrice;
  num? deliveryTime;
  int? cashbackPercent;

  String getDistance() {
    if (distance == null) {
      return "0";
    }
    return (distance! / 1000).toStringAsFixed(2);
  }

  double getCashBack(double price) {
    return double.parse((price * (cashbackPercent ?? 0) / 100).toStringAsFixed(2));
  }


  factory Establishment.fromJson(Map<String, dynamic> json) => Establishment(
    id: json["id"],
    name: json["name"],
    nameUk: json["name:uk"],
    nameRu: json["name:ru"],
    descriptionUk: json["description:uk"],
    descriptionRu: json["description:ru"],
    imgUrl: json["imgUrl"],
    enabled: json["enabled"],
    description: json["description"],
    minimalPrice: json["minimalPrice"],
    cookTime: json["cookTime"],
    removed: json["removed"],
    managerPhoneNumber: json["managerPhoneNumber"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    categoryId: json["categoryId"],
    brandId: json["brandId"],
    addresses: List<EstablishmentAddress>.from(json["addresses"].map((x) => EstablishmentAddress.fromJson(x))),
    distance: json["distance"] == null ? 0 : json["distance"],
    calculatedPrice: json["calculatedPrice"] == null ? 0 : json["calculatedPrice"],
    deliveryTime: json["deliveryTime"] == null ? 0 : json["deliveryTime"],
    cashbackPercent: json["cashbackPercent"] == null ? 0 : json["cashbackPercent"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "name:uk": nameUk,
    "name:ru": nameRu,
    "description:uk": descriptionUk,
    "description:ru": descriptionRu,
    "imgUrl": imgUrl,
    "enabled": enabled,
    "description": description,
    "minimalPrice": minimalPrice,
    "cookTime": cookTime,
    "removed": removed,
    "managerPhoneNumber": managerPhoneNumber,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "categoryId": categoryId,
    "brandId": brandId,
    "addresses": List<dynamic>.from(addresses!.map((x) => x.toJson())),
    "distance" : distance,
    "calculatedPrice" : calculatedPrice,
    "deliveryTime": deliveryTime
  };
}

class EstablishmentAddress {
  EstablishmentAddress({
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
  DateTime? createdAt;
  DateTime? updatedAt;
  Place? place;

  factory EstablishmentAddress.fromJson(Map<String, dynamic> json) => EstablishmentAddress(
    id: json["id"],
    establishmentId: json["establishmentId"],
    placeId: json["placeId"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    place: Place.fromJson(json["place"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "establishmentId": establishmentId,
    "placeId": placeId,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
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
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    coords: Coords.fromJson(json["coords"]),
    id: json["id"],
    street: json["street"] ?? "",
    houseNumber: json["houseNumber"] ?? "",
    name: json["name"] ?? "",
    city: json["city"] ?? "",
    osmId: json["osmId"],
    district: json["district"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "coords": coords?.toJson(),
    "id": id,
    "street": street,
    "houseNumber": houseNumber,
    "name": name,
    "city": city,
    "osmId": osmId,
    "district": district,
    "latitude": latitude,
    "longitude": longitude,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
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

class Address {
  Address({
    this.houseNumber,
    this.street,
    this.lat,
    this.lon,
    this.city,
    this.osmId,
  });

  String? houseNumber;
  String? street;
  double? lat;
  double? lon;
  String? city;
  String? osmId;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    houseNumber: json["houseNumber"] == null ? "" : json["houseNumber"],
    street: json["street"] == null ? "" : json["street"],
    lat: json["lat"].toDouble(),
    lon: json["lon"].toDouble(),
    city: json["city"] == null ? "" : json["city"],
    osmId: json["osmId"] == null ? "" : json["osmId"],
  );

  Map<String, dynamic> toJson() => {
    "houseNumber": houseNumber == null ? "" : houseNumber,
    "street": street == null ? "" : street,
    "lat": lat,
    "lon": lon,
    "city": city == null ? "" : city,
    "osmId": osmId == null ? "" : osmId,
  };
}

class Modifiers {
  Modifiers({
    this.tariff,
    this.options,
  });

  Tariff? tariff;
  List<dynamic>? options;

  factory Modifiers.fromJson(Map<String, dynamic> json) => Modifiers(
    tariff: json["tariff"] == null ? null : Tariff.fromJson(json["tariff"]),
    options: List<dynamic>.from(json["options"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "tariff": tariff?.toJson(),
    "options": List<dynamic>.from(options!.map((x) => x)),
  };
}

class Tariff {
  Tariff({
    this.id,
    this.name,
    this.type,
    this.price,
    this.numberOfSits,
  });

  int? id;
  String? name;
  String? type;
  Price? price;
  dynamic numberOfSits;

  factory Tariff.fromJson(Map<String, dynamic> json) => Tariff(
    id: json["id"],
    name: json["name"],
    type: json["type"],
    price: Price.fromJson(json["price"]),
    numberOfSits: json["numberOfSits"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "type": type,
    "price": price?.toJson(),
    "numberOfSits": numberOfSits,
  };
}

class Price {
  Price({
    this.start,
    this.drive,
    this.wait,
    this.min,
    this.multiplier,
  });

  int? start;
  int? drive;
  int? wait;
  int? min;
  int? multiplier;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
    start: json["start"],
    drive: json["drive"],
    wait: json["wait"],
    min: json["min"],
    multiplier: json["multiplier"],
  );

  Map<String, dynamic> toJson() => {
    "start": start,
    "drive": drive,
    "wait": wait,
    "min": min,
    "multiplier": multiplier,
  };
}

class ProductElement {
  ProductElement({
    this.id,
    this.orderId,
    this.productId,
    this.price,
    this.quantity,
    this.createdAt,
    this.updatedAt,
    this.productData,
  });

  int? id;
  int? orderId;
  int? productId;
  String? price;
  String? quantity;
  DateTime? createdAt;
  DateTime? updatedAt;
  ProductProduct? productData;

  factory ProductElement.fromJson(Map<String, dynamic> json) => ProductElement(
    id: json["id"],
    orderId: json["orderId"],
    productId: json["productId"],
    price: json["price"],
    quantity: json["quantity"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    productData: ProductProduct.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "orderId": orderId,
    "productId": productId,
    "price": price,
    "quantity": quantity,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "product": productData?.toJson(),
  };
}

class ProductProduct {
  ProductProduct({
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
  });

  int? id;
  String? name;
  String? weight;
  String? price;
  String? imgUrl;
  String? shortDescription;
  String? detailedDescription;
  String? status;
  dynamic removed;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? brandId;
  int? sectionId;

  factory ProductProduct.fromJson(Map<String, dynamic> json) => ProductProduct(
    id: json["id"],
    name: json["name"],
    weight: json["weight"],
    price: json["price"],
    imgUrl: json["imgUrl"],
    shortDescription: json["shortDescription"],
    detailedDescription: json["detailedDescription"],
    status: json["status"],
    removed: json["removed"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    brandId: json["brandId"],
    sectionId: json["sectionId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "weight": weight,
    "price": price,
    "imgUrl": imgUrl,
    "shortDescription": shortDescription,
    "detailedDescription": detailedDescription,
    "status": status,
    "removed": removed,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "brandId": brandId,
    "sectionId": sectionId,
  };
}

class Rate {
  Rate({
    this.optionId,
    this.name,
    this.code,
    this.numberOfSeats,
    this.prices,
  });

  String? optionId;
  String? name;
  String? code;
  dynamic numberOfSeats;
  Prices? prices;

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
    optionId: json["optionId"],
    name: json["name"],
    code: json["code"],
    numberOfSeats: json["numberOfSeats"],
    prices: Prices.fromJson(json["prices"]),
  );

  Map<String, dynamic> toJson() => {
    "optionId": optionId,
    "name": name,
    "code": code,
    "numberOfSeats": numberOfSeats,
    "prices": prices?.toJson(),
  };
}

class Prices {
  Prices({
    this.start,
    this.moving,
    this.waiting,
    this.minimum,
    this.multiplier,
  });

  int? start;
  int? moving;
  int? waiting;
  int? minimum;
  int? multiplier;

  factory Prices.fromJson(Map<String, dynamic> json) => Prices(
    start: json["start"],
    moving: json["moving"],
    waiting: json["waiting"],
    minimum: json["minimum"],
    multiplier: json["multiplier"],
  );

  Map<String, dynamic> toJson() => {
    "start": start,
    "moving": moving,
    "waiting": waiting,
    "minimum": minimum,
    "multiplier": multiplier,
  };
}

class Summary {
  Summary({
    this.distanceTravelled,
    this.waitingTime,
    this.tripCost,
  });

  int? distanceTravelled;
  int? waitingTime;
  int? tripCost;

  factory Summary.fromJson(Map<String, dynamic> json) => Summary(
    distanceTravelled: json["distanceTravelled"],
    waitingTime: json["waitingTime"],
    tripCost: json["tripCost"],
  );

  Map<String, dynamic> toJson() => {
    "distanceTravelled": distanceTravelled,
    "waitingTime": waitingTime,
    "tripCost": tripCost,
  };
}


// MakeOrderResponse makeOrderResponseFromJson(String str) => MakeOrderResponse.fromJson(json.decode(str));
//
// String makeOrderResponseToJson(MakeOrderResponse data) => json.encode(data.toJson());
//
// class MakeOrderResponse {
//   MakeOrderResponse({
//     this.orderId,
//     this.comment,
//     this.cancelledBy,
//     this.createdAt,
//     this.arrivesAt,
//     this.status,
//     this.countOfPersons,
//     this.establishment,
//     this.paymentStatus,
//     this.commentForEstablishment,
//     this.modifiers,
//     this.paidToMinimalOrder,
//     this.cashbackAmount,
//     this.summary,
//     this.isDelivery,
//     this.deliveryStatus,
//     this.deliveryCancelReason,
//     this.products,
//     this.isSuccessfulOrder,
//     this.addresses,
//     this.rate,
//   });
//
//   String? orderId;
//   String? comment;
//   dynamic cancelledBy;
//   DateTime? createdAt;
//   dynamic arrivesAt;
//   String? status;
//   int? countOfPersons;
//   Establishment? establishment;
//   String? paymentStatus;
//   String? commentForEstablishment;
//   Modifiers? modifiers;
//   num? paidToMinimalOrder;
//   dynamic cashbackAmount;
//   Summary? summary;
//   bool? isDelivery;
//   String? deliveryStatus;
//   String? deliveryCancelReason;
//   List<Product>? products;
//   bool? isSuccessfulOrder;
//   List<MakeOrderResponseAddress>? addresses;
//   Rate? rate;
//
//   factory MakeOrderResponse.fromJson(Map<String, dynamic> json) => MakeOrderResponse(
//     orderId: json["orderId"],
//     comment: json["comment"],
//     cancelledBy: json["cancelledBy"],
//     createdAt: DateTime.parse(json["createdAt"]),
//     arrivesAt: json["arrivesAt"],
//     status: json["status"],
//     countOfPersons: json["countOfPersons"],
//     establishment: Establishment.fromJson(json["establishment"]),
//     paymentStatus: json["paymentStatus"],
//     commentForEstablishment: json["commentForEstablishment"],
//     modifiers: Modifiers.fromJson(json["modifiers"]),
//     paidToMinimalOrder: json["paidToMinimalOrder"],
//     cashbackAmount: json["cashbackAmount"],
//     summary: Summary.fromJson(json["summary"]),
//     isDelivery: json["isDelivery"],
//     deliveryStatus: json["deliveryStatus"],
//     deliveryCancelReason: json["deliveryCancelReason"],
//     products: List<Product>.from(json["products"].map((x) => Product.fromJson(x))),
//     isSuccessfulOrder: json["isSuccessfulOrder"],
//     addresses: List<MakeOrderResponseAddress>.from(json["addresses"].map((x) => MakeOrderResponseAddress.fromJson(x))),
//     rate: Rate.fromJson(json["rate"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "orderId": orderId,
//     "comment": comment,
//     "cancelledBy": cancelledBy,
//     "createdAt": createdAt?.toIso8601String(),
//     "arrivesAt": arrivesAt,
//     "status": status,
//     "countOfPersons": countOfPersons,
//     "establishment": establishment?.toJson(),
//     "paymentStatus": paymentStatus,
//     "commentForEstablishment": commentForEstablishment,
//     "modifiers": modifiers?.toJson(),
//     "paidToMinimalOrder": paidToMinimalOrder,
//     "cashbackAmount": cashbackAmount,
//     "summary": summary?.toJson(),
//     "isDelivery": isDelivery,
//     "deliveryStatus": deliveryStatus,
//     "deliveryCancelReason": deliveryCancelReason,
//     "products": List<dynamic>.from(products!.map((x) => x.toJson())),
//     "isSuccessfulOrder": isSuccessfulOrder,
//     "addresses": List<dynamic>.from(addresses!.map((x) => x.toJson())),
//     "rate": rate?.toJson(),
//   };
// }
//
// class MakeOrderResponseAddress {
//   MakeOrderResponseAddress({
//     this.name,
//     this.houseNumber,
//     this.street,
//     this.city,
//     this.osmId,
//     this.lat,
//     this.lon,
//   });
//
//   String? name;
//   String? houseNumber;
//   String? street;
//   String? city;
//   String? osmId;
//   double? lat;
//   double? lon;
//
//   factory MakeOrderResponseAddress.fromJson(Map<String, dynamic> json) => MakeOrderResponseAddress(
//     name: json["name"] == null ? null : json["name"],
//     houseNumber: json["houseNumber"] == null ? null : json["houseNumber"],
//     street: json["street"] == null ? null : json["street"],
//     city: json["city"],
//     osmId: json["osmId"],
//     lat: json["lat"].toDouble(),
//     lon: json["lon"].toDouble(),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "name": name == null ? null : name,
//     "houseNumber": houseNumber == null ? null : houseNumber,
//     "street": street == null ? null : street,
//     "city": city,
//     "osmId": osmId,
//     "lat": lat,
//     "lon": lon,
//   };
// }
//
// class Establishment {
//   Establishment({
//     this.id,
//     this.name,
//     this.imgUrl,
//     this.enabled,
//     this.description,
//     this.minimalPrice,
//     this.cookTime,
//     this.removed,
//     this.managerPhoneNumber,
//     this.createdAt,
//     this.updatedAt,
//     this.categoryId,
//     this.brandId,
//     this.addresses,
//   });
//
//   int? id;
//   String? name;
//   String? imgUrl;
//   bool? enabled;
//   dynamic description;
//   String? minimalPrice;
//   String? cookTime;
//   dynamic removed;
//   String? managerPhoneNumber;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   int? categoryId;
//   int? brandId;
//   List<EstablishmentAddress>? addresses;
//
//   factory Establishment.fromJson(Map<String, dynamic> json) => Establishment(
//     id: json["id"],
//     name: json["name"],
//     imgUrl: json["imgUrl"],
//     enabled: json["enabled"],
//     description: json["description"],
//     minimalPrice: json["minimalPrice"],
//     cookTime: json["cookTime"],
//     removed: json["removed"],
//     managerPhoneNumber: json["managerPhoneNumber"],
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//     categoryId: json["categoryId"],
//     brandId: json["brandId"],
//     addresses: List<EstablishmentAddress>.from(json["addresses"].map((x) => EstablishmentAddress.fromJson(x))),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "imgUrl": imgUrl,
//     "enabled": enabled,
//     "description": description,
//     "minimalPrice": minimalPrice,
//     "cookTime": cookTime,
//     "removed": removed,
//     "managerPhoneNumber": managerPhoneNumber,
//     "createdAt": createdAt?.toIso8601String(),
//     "updatedAt": updatedAt?.toIso8601String(),
//     "categoryId": categoryId,
//     "brandId": brandId,
//     "addresses": List<dynamic>.from(addresses!.map((x) => x.toJson())),
//   };
// }
//
// class EstablishmentAddress {
//   EstablishmentAddress({
//     this.id,
//     this.establishmentId,
//     this.placeId,
//     this.createdAt,
//     this.updatedAt,
//     this.place,
//   });
//
//   int? id;
//   int? establishmentId;
//   int? placeId;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   Place? place;
//
//   factory EstablishmentAddress.fromJson(Map<String, dynamic> json) => EstablishmentAddress(
//     id: json["id"],
//     establishmentId: json["establishmentId"],
//     placeId: json["placeId"],
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//     place: Place.fromJson(json["place"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "establishmentId": establishmentId,
//     "placeId": placeId,
//     "createdAt": createdAt?.toIso8601String(),
//     "updatedAt": updatedAt?.toIso8601String(),
//     "place": place?.toJson(),
//   };
// }
//
// class Place {
//   Place({
//     this.coords,
//     this.id,
//     this.street,
//     this.houseNumber,
//     this.name,
//     this.city,
//     this.osmId,
//     this.district,
//     this.latitude,
//     this.longitude,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   Coords? coords;
//   int? id;
//   String? street;
//   String? houseNumber;
//   String? name;
//   String? city;
//   String? osmId;
//   String? district;
//   String? latitude;
//   String? longitude;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//
//   factory Place.fromJson(Map<String, dynamic> json) => Place(
//     coords: Coords.fromJson(json["coords"]),
//     id: json["id"],
//     street: json["street"],
//     houseNumber: json["houseNumber"],
//     name: json["name"],
//     city: json["city"],
//     osmId: json["osmId"],
//     district: json["district"],
//     latitude: json["latitude"],
//     longitude: json["longitude"],
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "coords": coords?.toJson(),
//     "id": id,
//     "street": street,
//     "houseNumber": houseNumber,
//     "name": name,
//     "city": city,
//     "osmId": osmId,
//     "district": district,
//     "latitude": latitude,
//     "longitude": longitude,
//     "createdAt": createdAt?.toIso8601String(),
//     "updatedAt": updatedAt?.toIso8601String(),
//   };
// }

// class Coords {
//   Coords({
//     this.latitude,
//     this.longitude,
//   });
//
//   String? latitude;
//   String? longitude;
//
//   factory Coords.fromJson(Map<String, dynamic> json) => Coords(
//     latitude: json["latitude"],
//     longitude: json["longitude"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "latitude": latitude,
//     "longitude": longitude,
//   };
// }

// class Modifiers {
//   Modifiers({
//     this.tariff,
//     this.options,
//   });
//
//   Tariff? tariff;
//   List<dynamic>? options;
//
//   factory Modifiers.fromJson(Map<String, dynamic> json) => Modifiers(
//     tariff: Tariff.fromJson(json["tariff"]),
//     options: List<dynamic>.from(json["options"].map((x) => x)),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "tariff": tariff?.toJson(),
//     "options": List<dynamic>.from(options!.map((x) => x)),
//   };
// }
//
// class Tariff {
//   Tariff({
//     this.id,
//     this.name,
//     this.type,
//     this.price,
//     this.numberOfSits,
//   });
//
//   int? id;
//   String? name;
//   String? type;
//   Price? price;
//   dynamic numberOfSits;
//
//   factory Tariff.fromJson(Map<String, dynamic> json) => Tariff(
//     id: json["id"],
//     name: json["name"],
//     type: json["type"],
//     price: Price.fromJson(json["price"]),
//     numberOfSits: json["numberOfSits"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "name": name,
//     "type": type,
//     "price": price?.toJson(),
//     "numberOfSits": numberOfSits,
//   };
// }
//
// class Price {
//   Price({
//     this.start,
//     this.drive,
//     this.wait,
//     this.min,
//     this.multiplier,
//   });
//
//   int? start;
//   int? drive;
//   int? wait;
//   int? min;
//   int? multiplier;
//
//   factory Price.fromJson(Map<String, dynamic> json) => Price(
//     start: json["start"],
//     drive: json["drive"],
//     wait: json["wait"],
//     min: json["min"],
//     multiplier: json["multiplier"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "start": start,
//     "drive": drive,
//     "wait": wait,
//     "min": min,
//     "multiplier": multiplier,
//   };
// }
//
// class Product {
//   Product({
//     this.id,
//     this.orderId,
//     this.productId,
//     this.price,
//     this.quantity,
//     this.createdAt,
//     this.updatedAt,
//   });
//
//   int? id;
//   int? orderId;
//   int? productId;
//   String? price;
//   int? quantity;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//
//   factory Product.fromJson(Map<String, dynamic> json) => Product(
//     id: json["id"],
//     orderId: json["orderId"],
//     productId: json["productId"],
//     price: json["price"],
//     quantity: json["quantity"],
//     createdAt: DateTime.parse(json["createdAt"]),
//     updatedAt: DateTime.parse(json["updatedAt"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "id": id,
//     "orderId": orderId,
//     "productId": productId,
//     "price": price,
//     "quantity": quantity,
//     "createdAt": createdAt?.toIso8601String(),
//     "updatedAt": updatedAt?.toIso8601String(),
//   };
// }
//
// class Rate {
//   Rate({
//     this.optionId,
//     this.name,
//     this.code,
//     this.numberOfSeats,
//     this.prices,
//   });
//
//   String? optionId;
//   String? name;
//   String? code;
//   dynamic numberOfSeats;
//   Prices? prices;
//
//   factory Rate.fromJson(Map<String, dynamic> json) => Rate(
//     optionId: json["optionId"],
//     name: json["name"],
//     code: json["code"],
//     numberOfSeats: json["numberOfSeats"],
//     prices: Prices.fromJson(json["prices"]),
//   );
//
//   Map<String, dynamic> toJson() => {
//     "optionId": optionId,
//     "name": name,
//     "code": code,
//     "numberOfSeats": numberOfSeats,
//     "prices": prices?.toJson(),
//   };
// }
//
// class Prices {
//   Prices({
//     this.start,
//     this.moving,
//     this.waiting,
//     this.minimum,
//     this.multiplier,
//   });
//
//   int? start;
//   int? moving;
//   int? waiting;
//   int? minimum;
//   int? multiplier;
//
//   factory Prices.fromJson(Map<String, dynamic> json) => Prices(
//     start: json["start"],
//     moving: json["moving"],
//     waiting: json["waiting"],
//     minimum: json["minimum"],
//     multiplier: json["multiplier"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "start": start,
//     "moving": moving,
//     "waiting": waiting,
//     "minimum": minimum,
//     "multiplier": multiplier,
//   };
// }
//
// class Summary {
//   Summary({
//     this.distanceTravelled,
//     this.waitingTime,
//     this.tripCost,
//   });
//
//   int? distanceTravelled;
//   int? waitingTime;
//   int? tripCost;
//
//   factory Summary.fromJson(Map<String, dynamic> json) => Summary(
//     distanceTravelled: json["distanceTravelled"],
//     waitingTime: json["waitingTime"],
//     tripCost: json["tripCost"],
//   );
//
//   Map<String, dynamic> toJson() => {
//     "distanceTravelled": distanceTravelled,
//     "waitingTime": waitingTime,
//     "tripCost": tripCost,
//   };
// }



//Old Response
/*MakeOrderResponse makeOrderResponseFromJson(String str) => MakeOrderResponse.fromJson(json.decode(str));

String makeOrderResponseToJson(MakeOrderResponse data) => json.encode(data.toJson());

class MakeOrderResponse {
  MakeOrderResponse({
    this.id,
    this.comment,
    this.routeLength,
    this.price,
    this.calculatedPrice,
    this.distanceMeters,
    this.waitStartTime,
    this.stayTime,
    this.arrivalTime,
    this.startSearchTime,
    this.lostTime,
    this.onPlaceTime,
    this.deliveryTime,
    this.bookingTime,
    this.calculatedRoute,
    this.rating,
    this.needsOperatorAttention,
    this.isPreAssign,
    this.preOrderTime,
    this.isActive,
    this.isActiveInEstablishment,
    this.hidden,
    this.isLate,
    this.cancelReason,
    this.cancelledBy,
    this.status,
    this.fromAndroid,
    this.fromInternet,
    this.tips,
    this.isBonusOrder,
    this.callId,
    this.isSos,
    this.isCardPay,
    this.paymentStatus,
    this.forForced,
    this.forForcedByTime,
    this.rejectForced,
    this.reducedTariff,
    this.isDelivery,
    this.deliveryStatus,
    this.deliveryCancelReason,
    this.deliveryCookTime,
    this.countOfPersons,
    this.isSuccessfulOrder,
    this.commentForEstablishment,
    this.createdAt,
    this.updatedAt,
    this.applicationId,
    this.brandId,
    this.clientId,
    this.driverId,
    this.forcedDriverId,
    this.operatorId,
    this.delegatedOperatorId,
    this.establishmentManagerId,
    this.establishmentId,
    this.tariff,
  });

  int? id;
  String? comment;
  dynamic routeLength;
  dynamic price;
  int? calculatedPrice;
  int? distanceMeters;
  DateTime? waitStartTime;
  dynamic stayTime;
  dynamic arrivalTime;
  dynamic startSearchTime;
  dynamic lostTime;
  dynamic onPlaceTime;
  dynamic deliveryTime;
  dynamic bookingTime;
  dynamic calculatedRoute;
  dynamic rating;
  bool? needsOperatorAttention;
  bool? isPreAssign;
  dynamic preOrderTime;
  bool? isActive;
  bool? isActiveInEstablishment;
  bool? hidden;
  bool? isLate;
  dynamic cancelReason;
  dynamic cancelledBy;
  String? status;
  bool? fromAndroid;
  bool? fromInternet;
  dynamic tips;
  dynamic isBonusOrder;
  dynamic callId;
  bool? isSos;
  bool? isCardPay;
  String? paymentStatus;
  bool? forForced;
  bool? forForcedByTime;
  dynamic rejectForced;
  bool? reducedTariff;
  bool? isDelivery;
  String? deliveryStatus;
  dynamic deliveryCancelReason;
  dynamic deliveryCookTime;
  int? countOfPersons;
  bool? isSuccessfulOrder;
  String? commentForEstablishment;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic applicationId;
  int? brandId;
  int? clientId;
  dynamic driverId;
  dynamic forcedDriverId;
  dynamic operatorId;
  dynamic delegatedOperatorId;
  dynamic establishmentManagerId;
  int? establishmentId;
  Tariff? tariff;

  factory MakeOrderResponse.fromJson(Map<String, dynamic> json) => MakeOrderResponse(
    id: json["id"],
    comment: json["comment"],
    routeLength: json["routeLength"],
    price: json["price"],
    calculatedPrice: json["calculatedPrice"],
    distanceMeters: json["distanceMeters"],
    waitStartTime: DateTime.parse(json["waitStartTime"]),
    stayTime: json["stayTime"],
    arrivalTime: json["arrivalTime"],
    startSearchTime: json["startSearchTime"],
    lostTime: json["lostTime"],
    onPlaceTime: json["onPlaceTime"],
    deliveryTime: json["deliveryTime"],
    bookingTime: json["bookingTime"],
    calculatedRoute: json["calculatedRoute"],
    rating: json["rating"],
    needsOperatorAttention: json["needsOperatorAttention"],
    isPreAssign: json["isPreAssign"],
    preOrderTime: json["preOrderTime"],
    isActive: json["isActive"],
    isActiveInEstablishment: json["isActiveInEstablishment"],
    hidden: json["hidden"],
    isLate: json["isLate"],
    cancelReason: json["cancelReason"],
    cancelledBy: json["cancelledBy"],
    status: json["status"],
    fromAndroid: json["fromAndroid"],
    fromInternet: json["fromInternet"],
    tips: json["tips"],
    isBonusOrder: json["isBonusOrder"],
    callId: json["callId"],
    isSos: json["isSos"],
    isCardPay: json["isCardPay"],
    paymentStatus: json["paymentStatus"],
    forForced: json["forForced"],
    forForcedByTime: json["forForcedByTime"],
    rejectForced: json["rejectForced"],
    reducedTariff: json["reducedTariff"],
    isDelivery: json["isDelivery"],
    deliveryStatus: json["deliveryStatus"],
    deliveryCancelReason: json["deliveryCancelReason"],
    deliveryCookTime: json["deliveryCookTime"],
    countOfPersons: json["countOfPersons"],
    isSuccessfulOrder: json["isSuccessfulOrder"],
    commentForEstablishment: json["commentForEstablishment"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    applicationId: json["applicationId"],
    brandId: json["brandId"],
    clientId: json["clientId"],
    driverId: json["driverId"],
    forcedDriverId: json["forcedDriverId"],
    operatorId: json["operatorId"],
    delegatedOperatorId: json["delegatedOperatorId"],
    establishmentManagerId: json["establishmentManagerId"],
    establishmentId: json["establishmentId"],
    tariff: Tariff.fromJson(json["tariff"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "comment": comment,
    "routeLength": routeLength,
    "price": price,
    "calculatedPrice": calculatedPrice,
    "distanceMeters": distanceMeters,
    "waitStartTime": waitStartTime?.toIso8601String(),
    "stayTime": stayTime,
    "arrivalTime": arrivalTime,
    "startSearchTime": startSearchTime,
    "lostTime": lostTime,
    "onPlaceTime": onPlaceTime,
    "deliveryTime": deliveryTime,
    "bookingTime": bookingTime,
    "calculatedRoute": calculatedRoute,
    "rating": rating,
    "needsOperatorAttention": needsOperatorAttention,
    "isPreAssign": isPreAssign,
    "preOrderTime": preOrderTime,
    "isActive": isActive,
    "isActiveInEstablishment": isActiveInEstablishment,
    "hidden": hidden,
    "isLate": isLate,
    "cancelReason": cancelReason,
    "cancelledBy": cancelledBy,
    "status": status,
    "fromAndroid": fromAndroid,
    "fromInternet": fromInternet,
    "tips": tips,
    "isBonusOrder": isBonusOrder,
    "callId": callId,
    "isSos": isSos,
    "isCardPay": isCardPay,
    "paymentStatus": paymentStatus,
    "forForced": forForced,
    "forForcedByTime": forForcedByTime,
    "rejectForced": rejectForced,
    "reducedTariff": reducedTariff,
    "isDelivery": isDelivery,
    "deliveryStatus": deliveryStatus,
    "deliveryCancelReason": deliveryCancelReason,
    "deliveryCookTime": deliveryCookTime,
    "countOfPersons": countOfPersons,
    "isSuccessfulOrder": isSuccessfulOrder,
    "commentForEstablishment": commentForEstablishment,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "applicationId": applicationId,
    "brandId": brandId,
    "clientId": clientId,
    "driverId": driverId,
    "forcedDriverId": forcedDriverId,
    "operatorId": operatorId,
    "delegatedOperatorId": delegatedOperatorId,
    "establishmentManagerId": establishmentManagerId,
    "establishmentId": establishmentId,
    "tariff": tariff?.toJson(),
  };
}

class Tariff {
  Tariff({
    this.id,
    this.optionName,
    this.description,
    this.startPrice,
    this.priceForKm,
    this.priceForWaiting,
    this.minPrice,
    this.multiplier,
    this.defaultOptions,
    this.isRemoved,
    this.calculateWithCounter,
    this.multiplierForDriver,
    this.internal,
    this.hidden,
    this.numberOfSits,
    this.createdAt,
    this.updatedAt,
    this.brandId,
    this.districtId,
    this.optionClassId,
  });

  int? id;
  String? optionName;
  dynamic description;
  String? startPrice;
  String? priceForKm;
  String? priceForWaiting;
  String? minPrice;
  String? multiplier;
  bool? defaultOptions;
  bool? isRemoved;
  bool? calculateWithCounter;
  String? multiplierForDriver;
  bool? internal;
  bool? hidden;
  dynamic numberOfSits;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? brandId;
  dynamic districtId;
  int? optionClassId;

  factory Tariff.fromJson(Map<String, dynamic> json) => Tariff(
    id: json["id"],
    optionName: json["optionName"],
    description: json["description"],
    startPrice: json["startPrice"],
    priceForKm: json["priceForKm"],
    priceForWaiting: json["priceForWaiting"],
    minPrice: json["minPrice"],
    multiplier: json["multiplier"],
    defaultOptions: json["defaultOptions"],
    isRemoved: json["isRemoved"],
    calculateWithCounter: json["calculateWithCounter"],
    multiplierForDriver: json["multiplierForDriver"],
    internal: json["internal"],
    hidden: json["hidden"],
    numberOfSits: json["numberOfSits"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    brandId: json["brandId"],
    districtId: json["districtId"],
    optionClassId: json["optionClassId"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "optionName": optionName,
    "description": description,
    "startPrice": startPrice,
    "priceForKm": priceForKm,
    "priceForWaiting": priceForWaiting,
    "minPrice": minPrice,
    "multiplier": multiplier,
    "defaultOptions": defaultOptions,
    "isRemoved": isRemoved,
    "calculateWithCounter": calculateWithCounter,
    "multiplierForDriver": multiplierForDriver,
    "internal": internal,
    "hidden": hidden,
    "numberOfSits": numberOfSits,
    "createdAt": createdAt?.toIso8601String(),
    "updatedAt": updatedAt?.toIso8601String(),
    "brandId": brandId,
    "districtId": districtId,
    "optionClassId": optionClassId,
  };
}*/
