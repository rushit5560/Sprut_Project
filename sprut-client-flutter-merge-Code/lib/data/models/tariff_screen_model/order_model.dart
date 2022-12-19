import 'package:sprut/data/models/tariff_screen_model/service_model.dart';

class OrderModel {
  OrderModel(
      {required this.orderId,
      required this.comment,
      required this.cancelledBy,
      required this.createdAt,
      required this.arrivesAt,
      required this.status,
      required this.summary,
      required this.addresses,
      required this.rate,
      required this.options,
      required this.car,
      required this.coords,
      required this.payment,
      required this.isCardPay,
      required this.paymentType,
      required this.paymentCardMask,
      required this.preOrderTime,
      //Food Delivery
      required this.isDelivery,
      required this.deliveryStatus,
      required this.paymentStatus,
      required this.deliveryCancelReason,
      required this.isSuccessfulOrder,
      required this.countOfPersons,
      required this.establishmentId,
      required this.establishment,
      required this.products});

  final String? orderId;
  final String? comment;
  final String? cancelledBy;
  final String? createdAt;
  final String? arrivesAt;
  final String? status;
  final SummaryModel? summary;
  final List<AddressModel>? addresses;
  final ServiceModel? rate;
  final List<ServiceModel>? options;
  final CarModel? car;
  final List<CoordModel>? coords;
  final PaymentModel? payment;
  final bool? isCardPay;
  final String? paymentType;
  final String? paymentCardMask;
  final String? preOrderTime;

  //Food Delivery
  final int? countOfPersons;
  final int? establishmentId;
  final bool? isDelivery;
  final String? deliveryStatus;
  final String? paymentStatus;
  final String? deliveryCancelReason;
  final bool? isSuccessfulOrder;

  final Establishment? establishment;
  final List<Product>? products;

  //End

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        orderId: json["orderId"] ?? "",
        comment: json["comment"] ?? "",
        cancelledBy: json["cancelledBy"] ?? "",
        createdAt: json["createdAt"] ?? "",
        arrivesAt: json["arrivesAt"] ?? "",
        status: json["status"] ?? "",
        summary: json["summary"] == null
            ? null
            : SummaryModel.fromJson(json["summary"]),
        addresses: json["addresses"] == null
            ? []
            : List<AddressModel>.from(
                json["addresses"].map((x) => AddressModel.fromJson(x))),
        rate: json["rate"] == null ? null : ServiceModel.fromJson(json["rate"]),
        options: json["options"] == null
            ? []
            : List<ServiceModel>.from(
                json["options"].map((x) => ServiceModel.fromJson(x))),
        car: json["car"] == null ? null : CarModel.fromJson(json["car"]),
        coords: json["coords"] == null
            ? null
            : List<CoordModel>.from(
                json["coords"].map((x) => CoordModel.fromJson(x))),
        payment: json["payment"] == null
            ? null
            : PaymentModel.fromJson(json["payment"]),
        isCardPay: json["isCardPay"] ?? false,
        paymentType: json["paymentType"] ?? "",
        paymentCardMask: json["paymentCardMask"] ?? "",
        preOrderTime: json["preOrderTime"] ?? "",
        //Food delivery
        isDelivery: json['isDelivery'] == null ? null : json['isDelivery'],
        deliveryStatus:
            json['deliveryStatus'] == null ? null : json['deliveryStatus'],
        paymentStatus:
            json['paymentStatus'] == null ? null : json['paymentStatus'],
        deliveryCancelReason: json['deliveryCancelReason'] == null
            ? null
            : json['deliveryCancelReason'],
        isSuccessfulOrder: json['isSuccessfulOrder'] == null
            ? null
            : json['isSuccessfulOrder'],
        countOfPersons:
            json['countOfPersons'] == null ? null : json['countOfPersons'],
        establishmentId:
            json['establishmentId'] == null ? null : json['establishmentId'],
        establishment: json["establishment"] == null
            ? null
            : Establishment.fromJson(json["establishment"]),
        products: json["products"] == null
            ? []
            : List<Product>.from(
                json["products"].map((x) => Product.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "comment": comment,
        "cancelledBy": cancelledBy,
        "createdAt": createdAt,
        "arrivesAt": arrivesAt,
        "status": status,
        "summary": summary?.toJson(),
        "addresses": List<dynamic>.from(addresses!.map((x) => x.toJson())),
        "rate": rate?.toJson(),
        "options": options != null
            ? List<dynamic>.from(options!.map((x) => x.toJson()))
            : [],
        "car": car?.toJson(),
        "coords": coords != null
            ? List<dynamic>.from(coords!.map((x) => x.toJson()))
            : [],
        "payment": payment?.toJson(),
        "isCardPay": isCardPay,
        "paymentType": paymentType,
        "paymentCardMask": paymentCardMask,
        "preOrderTime": preOrderTime,
        "establishment": establishment?.toJson(), //Food Delivery
      };
}

class AddressModel {
  AddressModel({
    required this.name,
    required this.houseNumber,
    required this.street,
    required this.city,
    required this.lat,
    required this.lon,
  });

  final String? name;
  final String? houseNumber;
  final String? street;
  final String? city;
  final double? lat;
  final double? lon;

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        name: json["name"] ?? "",
        houseNumber: json["houseNumber"] ?? "",
        street: json["street"] ?? "",
        city: json["city"] ?? "",
        lat: json["lat"] != null && json["lat"] != ""
            ? json["lat"].toDouble()
            : 0.0,
        lon: json["lon"] != null && json["lon"] != ""
            ? json["lon"].toDouble()
            : 0.0,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "houseNumber": houseNumber,
        "street": street,
        "city": city,
        "lat": lat,
        "lon": lon,
      };
}

class SummaryModel {
  SummaryModel({
    required this.distanceTravelled,
    required this.waitingTime,
    required this.tripCost,
  });

  final int? distanceTravelled;
  final int? waitingTime;
  final int? tripCost;

  factory SummaryModel.fromJson(Map<String, dynamic> json) => SummaryModel(
        distanceTravelled: json["distanceTravelled"] ?? 0,
        waitingTime: json["waitingTime"] ?? 0,
        tripCost: json["tripCost"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "distanceTravelled": distanceTravelled,
        "waitingTime": waitingTime,
        "tripCost": tripCost,
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
  final double? rating;

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
        rating: json["rating"] != null && json["rating"] != ""
            ? double.parse(json["rating"].toString())
            : 5.0,
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

class CoordModel {
  CoordModel({
    required this.at,
    required this.lat,
    required this.lon,
  });

  final String? at;
  final double? lat;
  final double? lon;

  factory CoordModel.fromJson(Map<String, dynamic> json) => CoordModel(
        at: json["at"] ?? "",
        lat: json["lat"].toDouble() ?? 0.0,
        lon: json["lon"].toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "at": at,
        "lat": lat,
        "lon": lon,
      };
}

class PaymentModel {
  PaymentModel({
    required this.type,
    required this.status,
  });

  final String? type;
  final String? status;

  factory PaymentModel.fromJson(Map<String, dynamic> json) => PaymentModel(
        type: json["type"] ?? "",
        status: json["status"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "status": status,
      };
}

//Food Delivery
//food delivery
class Establishment {
  Establishment({
    this.id,
    this.name,
    this.nameUk,
    this.nameRu,
    this.nameEn,
    this.descriptionUk,
    this.descriptionRu,
    this.descriptionEn,
    this.imgUrl,
    this.enabled,
    this.description,
    this.minimalPrice,
    this.cookTime,
    this.removed,
    this.managerPhoneNumber,
    this.createdAt,
    this.updatedAt,
    this.categoryId,
    this.brandId,
    this.addresses,
  });

  int? id;
  String? name;
  String? nameUk;
  String? nameRu;
  String? nameEn;
  String? descriptionUk;
  String? descriptionRu;
  String? descriptionEn;
  String? imgUrl;
  bool? enabled;
  dynamic description;
  String? minimalPrice;
  String? cookTime;
  dynamic removed;
  String? managerPhoneNumber;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? categoryId;
  int? brandId;
  List<EstablishmentAddress>? addresses;

  factory Establishment.fromJson(Map<String, dynamic> json) => Establishment(
        id: json["id"],
        name: json["name"],
        nameUk: json['name:uk'],
        nameRu: json['name:ru'],
        nameEn: json['name:en'],
        descriptionUk: json['description:uk'],
        descriptionRu: json['description:ru'],
        descriptionEn: json['description:en'],
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
        addresses: List<EstablishmentAddress>.from(
            json["addresses"].map((x) => EstablishmentAddress.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "name:uk": nameUk,
        "name:ru": nameRu,
        "name:en": nameEn,
        "description:uk": descriptionUk,
        "description:ru": descriptionRu,
        "description:en": descriptionEn,
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

  factory EstablishmentAddress.fromJson(Map<String, dynamic> json) =>
      EstablishmentAddress(
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
        street: json["street"],
        houseNumber: json["houseNumber"],
        name: json["name"],
        city: json["city"],
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

class Modifiers {
  Modifiers({
    this.tariff,
    this.options,
  });

  Tariff? tariff;
  List<dynamic>? options;

  factory Modifiers.fromJson(Map<String, dynamic> json) => Modifiers(
        tariff: Tariff.fromJson(json["tariff"]),
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

class Product {
  Product(
      {this.id,
      this.orderId,
      this.productId,
      this.price,
      this.quantity,
      this.createdAt,
      this.updatedAt,
      this.productData});

  int? id;
  int? orderId;
  int? productId;
  String? price;
  String? quantity;
  DateTime? createdAt;
  DateTime? updatedAt;
  ProductProduct? productData;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        orderId: json["orderId"],
        productId: json["productId"],
        price: json["price"],
        quantity: json["quantity"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        productData: json["product"] == null
            ? null
            : ProductProduct.fromJson(json["product"]),
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
    this.quantityType,
    this.price,
    this.imgUrl,
    this.shortDescription,
    this.detailedDescription,
    this.nameUk,
    this.nameRu,
    this.nameEn,
    this.shortDescriptionUk,
    this.shortDescriptionRu,
    this.shortDescriptionEn,
    this.detailedDescriptionUk,
    this.detailedDescriptionRu,
    this.detailedDescriptionEn,
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
  String? quantityType;
  String? price;
  String? imgUrl;
  String? nameUk;
  String? nameRu;
  String? nameEn;
  String? shortDescriptionUk;
  String? shortDescriptionRu;
  String? shortDescriptionEn;
  String? detailedDescriptionUk;
  String? detailedDescriptionRu;
  String? detailedDescriptionEn;
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
        quantityType : json['quantityType'],
        price: json["price"],
        imgUrl: json["imgUrl"],
        shortDescription: json["shortDescription"],
        detailedDescription: json["detailedDescription"],
        nameUk: json['name:uk'],
        nameRu: json['name:ru'],
        nameEn: json['name:en'],
        shortDescriptionUk: json['shortDescription:uk'],
        shortDescriptionRu: json['shortDescription:ru'],
        shortDescriptionEn: json['shortDescription:en'],
        detailedDescriptionUk: json['detailedDescription:uk'],
        detailedDescriptionRu: json['detailedDescription:ru'],
        detailedDescriptionEn: json['detailedDescription:en'],
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
        "quantityType,": quantityType,
        "price": price,
        "imgUrl": imgUrl,
        "shortDescription": shortDescription,
        "detailedDescription": detailedDescription,
        "name:uk": nameUk,
        "name:ru": nameRu,
        "name:en": nameEn,
        "shortDescription:uk": shortDescriptionUk,
        "shortDescription:ru": shortDescriptionRu,
        "shortDescription:en": shortDescriptionEn,
        "detailedDescription:uk": detailedDescriptionUk,
        "detailedDescription:ru": detailedDescriptionRu,
        "detailedDescription:en": detailedDescriptionEn,
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
//End
