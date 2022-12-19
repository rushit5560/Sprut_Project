// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
  Order({
    this.orderId,
    this.addresses,
    this.comment,
    this.rate,
    this.options,
    this.tipToDriver,
    this.createdAt,
    this.arrivesAt,
    this.status,
    this.car,
    this.summary,
    this.coords,
  });

  String? orderId;
  List<Address>? addresses;
  String? comment;
  Rate? rate;
  List<Rate>? options;
  int? tipToDriver;
  DateTime? createdAt;
  DateTime? arrivesAt;
  String? status;
  Cars? car;
  Summary? summary;
  List<Coord>? coords;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["orderId"] == null ? null : json["orderId"],
        addresses: json["addresses"] == null
            ? null
            : List<Address>.from(
                json["addresses"].map((x) => Address.fromJson(x))),
        comment: json["comment"] == null ? null : json["comment"],
        rate: json["rate"] == null ? null : Rate.fromJson(json["rate"]),
        options: json["options"] == null
            ? null
            : List<Rate>.from(json["options"].map((x) => Rate.fromJson(x))),
        tipToDriver: json["tipToDriver"] == null ? null : json["tipToDriver"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        arrivesAt: json["arrivesAt"] == null
            ? null
            : DateTime.parse(json["arrivesAt"]),
        status: json["status"] == null ? null : json["status"],
        car: json["car"] == null ? null : Cars.fromJson(json["car"]),
        summary:
            json["summary"] == null ? null : Summary.fromJson(json["summary"]),
        coords: json["coords"] == null
            ? null
            : List<Coord>.from(json["coords"].map((x) => Coord.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId == null ? null : orderId,
        "addresses": addresses == null
            ? null
            : List<dynamic>.from(addresses!.map((x) => x.toJson())),
        "comment": comment == null ? null : comment,
        "rate": rate == null ? null : rate!.toJson(),
        "options": options == null
            ? null
            : List<dynamic>.from(options!.map((x) => x.toJson())),
        "tipToDriver": tipToDriver == null ? null : tipToDriver,
        "createdAt": createdAt == null ? null : createdAt!.toIso8601String(),
        "arrivesAt": arrivesAt == null ? null : arrivesAt!.toIso8601String(),
        "status": status == null ? null : status,
        "car": car == null ? null : car!.toJson(),
        "summary": summary == null ? null : summary!.toJson(),
        "coords": coords == null
            ? null
            : List<dynamic>.from(coords!.map((x) => x.toJson())),
      };
}

class Address {
  Address({
    this.street,
    this.houseNumber,
    this.lat,
    this.lon,
    this.name,
  });

  String? street;
  String? houseNumber;
  double? lat;
  double? lon;
  String? name;

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        street: json["street"] == null ? null : json["street"],
        houseNumber: json["houseNumber"] == null ? null : json["houseNumber"],
        lat: json["lat"] == null ? null : json["lat"].toDouble(),
        lon: json["lon"] == null ? null : json["lon"].toDouble(),
        name: json["name"] == null ? null : json["name"],
      );

  Map<String, dynamic> toJson() => {
        "street": street == null ? null : street,
        "houseNumber": houseNumber == null ? null : houseNumber,
        "lat": lat == null ? null : lat,
        "lon": lon == null ? null : lon,
        "name": name == null ? null : name,
      };
}

class Cars {
  Cars({
    this.year,
    this.driverName,
    this.driverPhoneNumber,
    this.licensePlateNumber,
    this.lat,
    this.lon,
    this.makeRaw,
    this.modelRaw,
    this.colorRaw,
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

  factory Cars.fromJson(Map<String, dynamic> json) => Cars(
        year: json["year"] == null ? null : json["year"],
        driverName: json["driverName"] == null ? null : json["driverName"],
        driverPhoneNumber: json["driverPhoneNumber"] == null
            ? null
            : json["driverPhoneNumber"],
        licensePlateNumber: json["licensePlateNumber"] == null
            ? null
            : json["licensePlateNumber"],
        lat: json["lat"] == null ? null : json["lat"].toDouble(),
        lon: json["lon"] == null ? null : json["lon"].toDouble(),
        makeRaw: json["make_raw"] == null ? null : json["make_raw"],
        modelRaw: json["model_raw"] == null ? null : json["model_raw"],
        colorRaw: json["color_raw"] == null ? null : json["color_raw"],
      );

  Map<String, dynamic> toJson() => {
        "year": year == null ? null : year,
        "driverName": driverName == null ? null : driverName,
        "driverPhoneNumber":
            driverPhoneNumber == null ? null : driverPhoneNumber,
        "licensePlateNumber":
            licensePlateNumber == null ? null : licensePlateNumber,
        "lat": lat == null ? null : lat,
        "lon": lon == null ? null : lon,
        "make_raw": makeRaw == null ? null : makeRaw,
        "model_raw": modelRaw == null ? null : modelRaw,
        "color_raw": colorRaw == null ? null : colorRaw,
      };
}

class Coord {
  Coord({
    this.at,
    this.lat,
    this.lon,
  });

  DateTime? at;
  double? lat;
  double? lon;

  factory Coord.fromJson(Map<String, dynamic> json) => Coord(
        at: json["at"] == null ? null : DateTime.parse(json["at"]),
        lat: json["lat"] == null ? null : json["lat"].toDouble(),
        lon: json["lon"] == null ? null : json["lon"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "at": at == null ? null : at!.toIso8601String(),
        "lat": lat == null ? null : lat,
        "lon": lon == null ? null : lon,
      };
}

class Rate {
  Rate({
    this.optionId,
    this.name,
    this.prices,
    this.code,
  });

  String? optionId;
  String? name;
  Prices? prices;
  String? code;

  factory Rate.fromJson(Map<String, dynamic> json) => Rate(
        optionId: json["optionId"] == null ? null : json["optionId"],
        name: json["name"] == null ? null : json["name"],
        prices: json["prices"] == null ? null : Prices.fromJson(json["prices"]),
        code: json["code"] == null ? null : json["code"],
      );

  Map<String, dynamic> toJson() => {
        "optionId": optionId == null ? null : optionId,
        "name": name == null ? null : name,
        "prices": prices == null ? null : prices!.toJson(),
        "code": code == null ? null : code,
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
  double? multiplier;

  factory Prices.fromJson(Map<String, dynamic> json) => Prices(
        start: json["start"] == null ? null : json["start"],
        moving: json["moving"] == null ? null : json["moving"],
        waiting: json["waiting"] == null ? null : json["waiting"],
        minimum: json["minimum"] == null ? null : json["minimum"],
        multiplier:
            json["multiplier"] == null ? null : json["multiplier"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "start": start == null ? null : start,
        "moving": moving == null ? null : moving,
        "waiting": waiting == null ? null : waiting,
        "minimum": minimum == null ? null : minimum,
        "multiplier": multiplier == null ? null : multiplier,
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
        distanceTravelled: json["distanceTravelled"] == null
            ? null
            : json["distanceTravelled"],
        waitingTime: json["waitingTime"] == null ? null : json["waitingTime"],
        tripCost: json["tripCost"] == null ? null : json["tripCost"],
      );

  Map<String, dynamic> toJson() => {
        "distanceTravelled":
            distanceTravelled == null ? null : distanceTravelled,
        "waitingTime": waitingTime == null ? null : waitingTime,
        "tripCost": tripCost == null ? null : tripCost,
      };
}
