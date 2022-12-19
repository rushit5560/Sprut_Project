class ServiceModel {
  ServiceModel({
    this.optionId,
    this.name,
    this.code,
    this.numberOfSeats,
    this.prices,
  });

  final String? optionId;
  final String? name;
  final String? code;
  final String? numberOfSeats;
  final Prices? prices;

  factory ServiceModel.fromJson(Map<String, dynamic> json) => ServiceModel(
        optionId: json["optionId"] ?? "",
        name: json["name"] ?? "",
        code: json["code"] ?? "",
        numberOfSeats: json["numberOfSeats"] ?? "",
        prices: json["prices"] != null ? Prices.fromJson(json["prices"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "optionId": optionId,
        "name": name,
        "code": code,
        "numberOfSeats": numberOfSeats,
        "prices": prices != null ? prices!.toJson() : null,
      };

  String toIdJson() => "$optionId";
}

class Prices {
  Prices({
    this.start,
    this.moving,
    this.waiting,
    this.minimum,
    this.multiplier,
  });

  final int? start;
  final int? moving;
  final int? waiting;
  final int? minimum;
  final int? multiplier;

  factory Prices.fromJson(Map<String, dynamic> json) => Prices(
        start: json["start"] ?? 0,
        moving: json["moving"] ?? 0,
        waiting: json["waiting"] ?? 0,
        minimum: json["minimum"] ?? 0,
        multiplier: json["multiplier"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "start": start,
        "moving": moving,
        "waiting": waiting,
        "minimum": minimum,
        "multiplier": multiplier,
      };
}
