// To parse this JSON data, do
//
//     final availableCitiesModel = availableCitiesModelFromJson(jsonString);

import 'dart:convert';

List<AvailableCitiesModel> availableCitiesModelFromJson(String str) =>
    List<AvailableCitiesModel>.from(
        json.decode(str).map((x) => AvailableCitiesModel.fromJson(x)));

String availableCitiesModelToJson(List<AvailableCitiesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AvailableCitiesModel {
  AvailableCitiesModel({
    required this.code,
    required this.name,
    required this.localizedName,
    required this.comment,
    required this.defaultZoom,
    required this.defaultZoomOnMobile,
    required this.coatOfArmsUrl,
    required this.wikipediaArticleUrl,
    required this.officialWebsiteUrl,
    required this.population,
    required this.phoneAreaCode,
    required this.trivia,
    required this.lat,
    required this.lon,
  });

  String code;
  String name;
  String localizedName;
  dynamic comment;
  int defaultZoom;
  int defaultZoomOnMobile;
  dynamic coatOfArmsUrl;
  String wikipediaArticleUrl;
  String officialWebsiteUrl;
  int population;
  String phoneAreaCode;
  dynamic trivia;
  double lat;
  double lon;

  factory AvailableCitiesModel.fromJson(Map<String, dynamic> json) =>
      AvailableCitiesModel(
        code: json["code"],
        name: json["name"],
        localizedName: json["localizedName"],
        comment: json["comment"],
        defaultZoom: json["defaultZoom"],
        defaultZoomOnMobile: json["defaultZoomOnMobile"],
        coatOfArmsUrl: json["coatOfArmsUrl"],
        wikipediaArticleUrl: json["wikipediaArticleUrl"],
        officialWebsiteUrl: json["officialWebsiteUrl"],
        population: json["population"],
        phoneAreaCode: json["phoneAreaCode"],
        trivia: json["trivia"],
        lat: json["lat"].toDouble(),
        lon: json["lon"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "name": name,
        "localizedName": localizedName,
        "comment": comment,
        "defaultZoom": defaultZoom,
        "defaultZoomOnMobile": defaultZoomOnMobile,
        "coatOfArmsUrl": coatOfArmsUrl,
        "wikipediaArticleUrl": wikipediaArticleUrl,
        "officialWebsiteUrl": officialWebsiteUrl,
        "population": population,
        "phoneAreaCode": phoneAreaCode,
        "trivia": trivia,
        "lat": lat,
        "lon": lon,
      };
}
