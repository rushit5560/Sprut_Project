class NewsModel {
  NewsModel({
    required this.id,
    required this.userPhoneId,
    required this.clientNewClientNewsId,
    required this.removed,
    required this.createdAt,
    required this.updatedAt,
    required this.clientNewsId,
    required this.clientNewsHeader,
    required this.clientNewsText,
    required this.clientNewsRemoved,
    required this.clientNewsStatus,
    required this.clientNewsSendTo,
    required this.clientNewsCreatedAt,
    required this.clientNewsUpdatedAt,
  });

  final int? id;
  final String? userPhoneId;
  final int? clientNewClientNewsId;
  final dynamic removed;
  final String? createdAt;
  final String? updatedAt;
  final int? clientNewsId;
  final String? clientNewsHeader;
  final String? clientNewsText;
  final dynamic clientNewsRemoved;
  final String? clientNewsStatus;
  final String? clientNewsSendTo;
  final String? clientNewsCreatedAt;
  final String? clientNewsUpdatedAt;

  factory NewsModel.fromJson(Map<String, dynamic> json) => NewsModel(
        id: json["id"] ?? 0,
        userPhoneId: json["userPhoneId"] ?? "",
        clientNewClientNewsId: json["clientNewsId"] ?? 0,
        removed: json["removed"],
        createdAt: json["createdAt"] ?? "",
        updatedAt: json["updatedAt"] ?? "",
        clientNewsId: json["clientNews.id"] ?? 0,
        clientNewsHeader: json["clientNews.header"] ?? "",
        clientNewsText: json["clientNews.text"] ?? "",
        clientNewsRemoved: json["clientNews.removed"],
        clientNewsStatus: json["clientNews.status"] ?? "",
        clientNewsSendTo: json["clientNews.sendTo"] ?? "",
        clientNewsCreatedAt: json["clientNews.createdAt"] ?? "",
        clientNewsUpdatedAt: json["clientNews.updatedAt"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userPhoneId": userPhoneId,
        "clientNewsId": clientNewClientNewsId,
        "removed": removed,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "clientNews.id": clientNewsId,
        "clientNews.header": clientNewsHeader,
        "clientNews.text": clientNewsText,
        "clientNews.removed": clientNewsRemoved,
        "clientNews.status": clientNewsStatus,
        "clientNews.sendTo": clientNewsSendTo,
        "clientNews.createdAt": clientNewsCreatedAt,
        "clientNews.updatedAt": clientNewsUpdatedAt,
      };
}
