class ProfileModel {
  ProfileModel({
    this.profile,
  });

  final Profile? profile;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        profile:
            json["profile"] != null ? Profile.fromJson(json["profile"]) : null,
      );

  Map<String, dynamic> toJson() => {
        "profile": profile != null ? profile!.toJson() : null,
      };
}

class Profile {
  Profile({
    this.balance,
    this.paymentType,
    this.useBonuses,
    this.referrerAccountId,
    this.uuid,
    this.firstName,
    this.lastName,
    this.email,
    this.birthday,
  });
  final String? balance;
  final String? paymentType;
  final bool? useBonuses;
  final int? referrerAccountId;
  final String? uuid;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? birthday;

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        balance: json["balance"] ?? "",
        paymentType: json["paymentType"] ?? "",
        useBonuses: json["useBonuses"] ?? false,
        referrerAccountId: json["referrerAccountId"] ?? 0,
        uuid: json["uuid"] ?? "",
        firstName: json["firstName"] ?? "",
        lastName: json["lastName"] ?? "",
        email: json["email"] ?? "",
        birthday: json["birthday"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "balance": balance,
        "paymentType": paymentType,
        "useBonuses": useBonuses,
        "referrerAccountId": referrerAccountId,
        "uuid": uuid,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "birthday": birthday,
      };
}
