// To parse this JSON data, do
//
//     final tariffOption = tariffOptionFromJson(jsonString);

import 'dart:convert';

TariffOption tariffOptionFromJson(String str) =>
    TariffOption.fromJson(json.decode(str));

String tariffOptionToJson(TariffOption data) => json.encode(data.toJson());

class TariffOption {
  TariffOption({
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

  factory TariffOption.fromJson(Map<String, dynamic> json) => TariffOption(
        optionId: json["optionId"] == null ? null : json["optionId"],
        name: json["name"] == null ? null : json["name"],
        code: json["code"] == null ? null : json["code"],
        numberOfSeats:
            json["numberOfSeats"] == null ? null : json["numberOfSeats"],
        prices: json["prices"] == null ? null : Prices.fromJson(json["prices"]),
      );

  Map<String, dynamic> toJson() => {
        "optionId": optionId == null ? null : optionId,
        "name": name == null ? null : name,
        "code": code == null ? null : code,
        "numberOfSeats": numberOfSeats == null ? null : numberOfSeats,
        "prices": prices == null ? null : prices!.toJson(),
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
        start: json["start"] == null ? null : json["start"],
        moving: json["moving"] == null ? null : json["moving"],
        waiting: json["waiting"] == null ? null : json["waiting"],
        minimum: json["minimum"] == null ? null : json["minimum"],
        multiplier: json["multiplier"] == null ? null : json["multiplier"],
      );

  Map<String, dynamic> toJson() => {
        "start": start == null ? null : start,
        "moving": moving == null ? null : moving,
        "waiting": waiting == null ? null : waiting,
        "minimum": minimum == null ? null : minimum,
        "multiplier": multiplier == null ? null : multiplier,
      };
}
