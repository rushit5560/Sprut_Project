// To parse this JSON data, do
//
//     final suggestionItem = suggestionItemFromJson(jsonString);

import 'dart:convert';

SuggestionItem suggestionItemFromJson(String str) =>
    SuggestionItem.fromJson(json.decode(str));

String suggestionItemToJson(SuggestionItem data) => json.encode(data.toJson());

class SuggestionItem {
  SuggestionItem({
    this.name,
    this.houseNumber,
    this.street,
    this.city,
    this.osmId,
    this.lat,
    this.lon,
  });

  String? name;
  String? houseNumber;
  String? street;
  String? city;
  dynamic osmId;
  double? lat;
  double? lon;

  @override
  bool operator ==(other) {
    return (other is SuggestionItem) &&
        other.name == name &&
        other.houseNumber == houseNumber &&
        other.street == street &&
        other.city == city;
  }

  factory SuggestionItem.fromJson(Map<String, dynamic> json) => SuggestionItem(
        name: json["name"] == null ? null : json["name"],
        houseNumber: json["houseNumber"] == null ? null : json["houseNumber"],
        street: json["street"] == null ? null : json["street"],
        city: json["city"] == null ? null : json["city"],
        osmId: json["osmId"] == null ? null : json["osmId"],
        lat: json["lat"] == null ? null : json["lat"].toDouble(),
        lon: json["lon"] == null ? null : json["lon"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "name": name == null ? null : name,
        "houseNumber": houseNumber == null ? null : houseNumber,
        "street": street == null ? null : street,
        "city": city == null ? null : city,
        "osmId": osmId == null ? null : osmId,
        "lat": lat == null ? null : lat,
        "lon": lon == null ? null : lon,
      };
}
