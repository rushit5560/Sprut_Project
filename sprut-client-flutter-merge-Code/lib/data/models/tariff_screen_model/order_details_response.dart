import 'dart:convert';

import 'package:sprut/data/models/tariff_screen_model/order_model.dart';

OrderDetailsResponse orderDetailsResponseFromJson(String str) => OrderDetailsResponse.fromJson(json.decode(str));

String orderDetailsResponseToJson(OrderDetailsResponse data) => json.encode(data.toJson());

class OrderDetailsResponse {
  OrderDetailsResponse({
    this.limit,
    this.page,
    this.totalPages,
    this.count,
    this.orderData,
  });

  int? limit;
  int? page;
  int? totalPages;
  int? count;
  List<OrderModel>? orderData;

  factory OrderDetailsResponse.fromJson(Map<String, dynamic> json) => OrderDetailsResponse(
    limit: json["limit"],
    page: json["page"],
    totalPages: json["totalPages"],
    count: json["count"],
    orderData: List<OrderModel>.from(json["rows"].map((x) => OrderModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "limit": limit,
    "page": page,
    "totalPages": totalPages,
    "count": count,
    "rows": List<dynamic>.from(orderData!.map((x) => x.toJson())),
  };
}