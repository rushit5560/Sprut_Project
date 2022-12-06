// To parse this JSON data, do
//
//     final myAddress = myAddressFromJson(jsonString);

import 'dart:convert';

MyAddress myAddressFromJson(String str) => MyAddress.fromJson(json.decode(str));

String myAddressToJson(MyAddress data) => json.encode(data.toJson());

class MyAddress {
  MyAddress(
      { this.lat,
     this.lon,
     this.name,
     this.street,
     this.houseNo,
     this.city,
     this.cityCode,
     this.type,
     this.timeStamp, this.isSaveAddress});

  double? lat;
  double? lon;
  String? name;

  String? street;
  String? houseNo;
  String? city;
  String? cityCode;
  int? type;
  DateTime? timeStamp;
  //Food Delivery
  bool? isSaveAddress = false;

  factory MyAddress.fromJson(Map<String, dynamic> json) => MyAddress(
        lat: json["lat"] == null ? null : json["lat"].toDouble(),
        lon: json["lon"] == null ? null : json["lon"].toDouble(),
        name: json["name"] == null ? null : json["name"],
        street: json["street"] == null ? null : json["street"],
        houseNo: json["houseNo"] == null ? null : json["houseNo"],
        city: json["city"] == null ? null : json["city"],
        cityCode: json["cityCode"] == null ? null : json["cityCode"],
        type: json["type"] == null ? null : json["type"],
        timeStamp: json["timeStamp"] == null
            ? null
            : DateTime.parse(json["timeStamp"]),
      );

  Map<String, dynamic> toJson() => {
        "lat": lat == null ? null : lat,
        "lon": lon == null ? null : lon,
        "name": name == null ? null : name,
        "street": street == null ? null : street,
        "houseNo": houseNo == null ? null : houseNo,
        "city": city == null ? null : city,
        "cityCode": cityCode == null ? null : cityCode,
        "type": type == null ? null : type,
        "timeStamp": timeStamp == null ? null : timeStamp?.toIso8601String(),
      };
}
