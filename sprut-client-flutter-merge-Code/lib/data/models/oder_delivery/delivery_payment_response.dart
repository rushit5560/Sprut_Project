// To parse this JSON data, do
//
//     final deliveryPaymentResponse = deliveryPaymentResponseFromJson(jsonString);

import 'dart:convert';

DeliveryPaymentResponse deliveryPaymentResponseFromJson(String str) => DeliveryPaymentResponse.fromJson(json.decode(str));

String deliveryPaymentResponseToJson(DeliveryPaymentResponse data) => json.encode(data.toJson());

class DeliveryPaymentResponse {
  DeliveryPaymentResponse({this.taxiOrder,});

  TaxiOrder? taxiOrder;

  factory DeliveryPaymentResponse.fromJson(Map<String, dynamic> json) => DeliveryPaymentResponse(
    taxiOrder: TaxiOrder.fromJson(json["taxiOrder"] == null ? null : json["taxiOrder"]),
  );

  Map<String, dynamic> toJson() => {
    "taxiOrder": taxiOrder!.toJson(),
  };
}

class TaxiOrder {
  TaxiOrder({
    this.paymentStatus,
    this.taxiOrderId,
    this.paymentType,
  });

  String? paymentStatus;
  String? taxiOrderId;
  String? paymentType;

  factory TaxiOrder.fromJson(Map<String, dynamic> json) => TaxiOrder(
    paymentStatus: json["paymentStatus"],
    taxiOrderId: json["taxiOrderId"],
    paymentType: json["paymentType"],
  );

  Map<String, dynamic> toJson() => {
    "paymentStatus": paymentStatus,
    "taxiOrderId": taxiOrderId,
    "paymentType": paymentType,
  };
}
