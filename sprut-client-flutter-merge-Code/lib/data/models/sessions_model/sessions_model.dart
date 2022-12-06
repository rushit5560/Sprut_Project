
import 'dart:convert';

InitSessionModel initSessionModelFromJson(String str) => InitSessionModel.fromJson(json.decode(str));

String initSessionModelToJson(InitSessionModel data) => json.encode(data.toJson());

class InitSessionModel {
    InitSessionModel({
       required this.phoneNumber,
         required   this.token,
         required   this.confirmed,
         required   this.confirmCodeFormatLength,
         required   this.confirmCodeFormatAllowedChars,
    });

    String phoneNumber;
    String token;
    bool confirmed;
    int confirmCodeFormatLength;
    String confirmCodeFormatAllowedChars;

    factory InitSessionModel.fromJson(Map<String, dynamic> json) => InitSessionModel(
        phoneNumber: json["phoneNumber"],
        token: json["token"],
        confirmed: json["confirmed"],
        confirmCodeFormatLength: json["confirmCodeFormat.length"],
        confirmCodeFormatAllowedChars: json["confirmCodeFormat.allowedChars"],
    );

    Map<String, dynamic> toJson() => {
        "phoneNumber": phoneNumber,
        "token": token,
        "confirmed": confirmed,
        "confirmCodeFormat.length": confirmCodeFormatLength,
        "confirmCodeFormat.allowedChars": confirmCodeFormatAllowedChars,
    };
}
