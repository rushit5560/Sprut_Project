class RechargeModel {
    RechargeModel({
        required this.liqpay,
    });

    final Liqpay liqpay;

    factory RechargeModel.fromJson(Map<String, dynamic> json) => RechargeModel(
        liqpay: Liqpay.fromJson(json["liqpay"]),
    );

    Map<String, dynamic> toJson() => {
        "liqpay": liqpay.toJson(),
    };
}

class Liqpay {
    Liqpay({
        required this.url,
    });

    final String url;

    factory Liqpay.fromJson(Map<String, dynamic> json) => Liqpay(
        url: json["url"],
    );

    Map<String, dynamic> toJson() => {
        "url": url,
    };
}