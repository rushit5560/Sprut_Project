

import 'dart:convert';

DecodedAddress decodedAddressFromJson(String str) =>
    DecodedAddress.fromJson(json.decode(str));

String decodedAddressToJson(DecodedAddress data) => json.encode(data.toJson());

class DecodedAddress {
  DecodedAddress({
   required this.houseNumber,
    required  this.street,
    required  this.city,
    required  this.osmId,
    required  this.name,
    required  this.lat,
    required  this.lon,
  });

  String? houseNumber;
  String? street;
  String? city;
  int? osmId;
  String? name;
  double? lat;
  double? lon;

  factory DecodedAddress.fromJson(Map<String, dynamic> json) => DecodedAddress(
        houseNumber: json["houseNumber"] == null ? null : json["houseNumber"],
        street: json["street"] == null ? null : json["street"],
        city: json["city"] == null ? null : json["city"],
        osmId: json["osmId"] == null ? null : json["osmId"],
        name: json["name"] == null ? null : json["name"],
        lat: json["lat"] == null ? null : json["lat"].toDouble(),
        lon: json["lon"] == null ? null : json["lon"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "houseNumber": houseNumber == null ? null : houseNumber,
        "street": street == null ? null : street,
        "city": city == null ? null : city,
        "osmId": osmId == null ? null : osmId,
        "name": name == null ? null : name,
        "lat": lat == null ? null : lat,
        "lon": lon == null ? null : lon,
      };
}
