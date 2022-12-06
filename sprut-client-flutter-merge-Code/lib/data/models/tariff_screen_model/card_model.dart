class CardModel {
  CardModel({
    this.cards,
  });

  final List<Cards>? cards;

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
        cards: json["cards"] != null
            ? List<Cards>.from(json["cards"].map((x) => Cards.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "cards": cards != null
            ? List<Cards>.from(cards!.map((x) => x.toJson()))
            : [],
      };
}

class Cards {
  Cards({
    this.id,
    this.cardMask,
    this.cardDefault,
  });

  Cards copyWith({int? id, String? cardMask, bool? cardDefault}) {
    return Cards(
        id: id ?? this.id,
        cardMask: cardMask ?? this.cardMask,
        cardDefault: cardDefault ?? this.cardDefault);
  }

  final int? id;
  final String? cardMask;
  final bool? cardDefault;

  factory Cards.fromJson(Map<String, dynamic> json) => Cards(
        id: json["id"] ?? 0,
        cardMask: json["cardMask"] ?? "",
        cardDefault: json["default"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "cardMask": cardMask,
        "default": cardDefault,
      };
}
