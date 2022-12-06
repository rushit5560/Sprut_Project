// To parse this JSON data, do
//
//     final messageResponseModel = messageResponseModelFromJson(jsonString);

import 'dart:convert';

MessageResponseModel messageResponseModelFromJson(String str) =>
    MessageResponseModel.fromJson(json.decode(str));

String messageResponseModelToJson(MessageResponseModel data) =>
    json.encode(data.toJson());

class MessageResponseModel {
  MessageResponseModel({
    required this.code,
    required this.message,
  });

  int code;
  String message;

  factory MessageResponseModel.fromJson(Map<String, dynamic> json) =>
      MessageResponseModel(
        code: json["code"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
      };
}
