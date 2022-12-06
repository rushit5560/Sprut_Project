// To parse this JSON data, do
//
//     final sessionConfigrationResponse = sessionConfigrationResponseFromJson(jsonString);

import 'dart:convert';

SessionConfigrationResponse sessionConfigrationResponseFromJson(String str) =>
    SessionConfigrationResponse.fromJson(json.decode(str));

String sessionConfigrationResponseToJson(SessionConfigrationResponse data) =>
    json.encode(data.toJson());

class SessionConfigrationResponse {
  SessionConfigrationResponse({
    required this.phoneNumber,
    required this.token,
    required this.confirmed,
  });

  String phoneNumber;
  String token;
  bool confirmed;

  factory SessionConfigrationResponse.fromJson(Map<String, dynamic> json) =>
      SessionConfigrationResponse(
        phoneNumber: json["phoneNumber"],
        token: json["token"],
        confirmed: json["confirmed"],
      );

  Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "token": token,
        "confirmed": confirmed,
      };
}
