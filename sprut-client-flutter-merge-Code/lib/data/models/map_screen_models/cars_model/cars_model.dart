//ignore_for_file: file_names
// To parse this JSON data, do
//
//     final car = carFromJson(jsonString);

import 'dart:convert';

Car carFromJson(String str) => Car.fromJson(json.decode(str));

String carToJson(Car data) => json.encode(data.toJson());

class Car {
  Car({
    this.carId,
    this.year,
    this.driverName,
    this.lat,
    this.lon,
    this.makeRaw,
    this.modelRaw,
    this.colorRaw,
    this.heading,
  });

  String? carId;
  int? year;
  String? driverName;
  double? lat;
  double? lon;
  String? makeRaw;
  String? modelRaw;
  String? colorRaw;
  int? heading;

  factory Car.fromJson(Map<String, dynamic> json) => Car(
        carId: json["carId"],
        year: json["year"],
        driverName: json["driverName"],
        lat: json["lat"].toDouble(),
        lon: json["lon"].toDouble(),
        makeRaw: json["make_raw"],
        modelRaw: json["model_raw"],
        colorRaw: json["color_raw"],
        heading: json["heading"],
      );

  Map<String, dynamic> toJson() => {
        "carId": carId,
        "year": year,
        "driverName": driverName,
        "lat": lat,
        "lon": lon,
        "make_raw": makeRaw,
        "model_raw": modelRaw,
        "color_raw": colorRaw,
        "heading": heading,
      };
}
