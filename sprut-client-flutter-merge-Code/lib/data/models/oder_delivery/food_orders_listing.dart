// To parse this JSON data, do
//
//     final foodsOrdersList = foodsOrdersListFromJson(jsonString);

import 'dart:convert';

List<FoodsOrdersList> foodsOrdersListFromJson(String str) => List<FoodsOrdersList>.from(json.decode(str).map((x) => FoodsOrdersList.fromJson(x)));

String foodsOrdersListToJson(List<FoodsOrdersList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodsOrdersList {
  FoodsOrdersList({
    this.orderId,
    this.comment,
    this.cancelledBy,
    this.isDelivery,
    this.deliveryStatus,
    this.createdAt,
    this.arrivesAt,
    this.status,
    this.car,
    this.summary,
    this.addresses,
    this.rate,
  });

  String? orderId;
  String? comment;
  dynamic cancelledBy;
  dynamic isDelivery;
  dynamic deliveryStatus;
  DateTime? createdAt;
  DateTime? arrivesAt;
  String? status;
  Car? car;
  Summary? summary;
  List<Address>? addresses;
  Rate? rate;

  factory FoodsOrdersList.fromJson(Map<String, dynamic> json) => FoodsOrdersList(
    orderId: json["orderId"],
    comment: json["comment"],
    cancelledBy: json["cancelledBy"],
    isDelivery: json["isDelivery"],
    deliveryStatus: json["deliveryStatus"],
    createdAt: DateTime.parse(json["createdAt"]),
    arrivesAt: DateTime.parse(json["arrivesAt"]),
    status: json["status"],
    car: Car.fromJson(json["car"]),
    summary: Summary.fromJson(json["summary"]),
    addresses: List<Address>.from(json["addresses"].map((x) => Address.fromJson(x))),
    rate: Rate.fromJson(json["rate"]),
  );

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "comment": comment,
    "cancelledBy": cancelledBy,
    "isDelivery": isDelivery,
    "deliveryStatus": deliveryStatus,
    "createdAt": createdAt?.toIso8601String(),
    "arrivesAt": arrivesAt?.toIso8601String(),
    "status": status,
    "car": car?.toJson(),
    "summary": summary?.toJson(),
    "addresses": List<dynamic>.from(addresses!.map((x) => x.toJson())),
    "rate": rate?.toJson(),
  };
}

class Address {
  Address({
    this.houseNumber,
    this.street,
    this.city,
    this.osmId,
    this.lat,
    this.lon,
    this.name,
  });

  String? houseNumber;
  String? street;
  String? city;
  String? osmId;
  double? lat;
  double? lon;
  String? name;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    houseNumber: json["houseNumber"] == null ? null : json["houseNumber"],
    street: json["street"],
    city: json["city"],
    osmId: json["osmId"],
    lat: json["lat"].toDouble(),
    lon: json["lon"].toDouble(),
    name: json["name"] == null ? null : json["name"],
  );

  Map<String, dynamic> toJson() => {
    "houseNumber": houseNumber == null ? null : houseNumber,
    "street": street,
    "city": city,
    "osmId": osmId,
    "lat": lat,
    "lon": lon,
    "name": name == null ? null : name,
  };
}

class Car {
  Car({
    this.year,
    this.driverName,
    this.driverPhoneNumber,
    this.licensePlateNumber,
    this.lat,
    this.lon,
    this.makeRaw,
    this.modelRaw,
    this.colorRaw,
    this.heading,
  });

  int? year;
  String? driverName;
  String? driverPhoneNumber;
  String? licensePlateNumber;
  double? lat;
  double? lon;
  String? makeRaw;
  String? modelRaw;
  String? colorRaw;
  int? heading;

  factory Car.fromJson(Map<String, dynamic> json) => Car(
    year: json["year"],
    driverName: json["driverName"],
    driverPhoneNumber: json["driverPhoneNumber"],
    licensePlateNumber: json["licensePlateNumber"],
    lat: json["lat"].toDouble(),
    lon: json["lon"].toDouble(),
    makeRaw: json["make_raw"],
    modelRaw: json["model_raw"],
    colorRaw: json["color_raw"],
    heading: json["heading"],
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
  String? numberOfSeats;
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
