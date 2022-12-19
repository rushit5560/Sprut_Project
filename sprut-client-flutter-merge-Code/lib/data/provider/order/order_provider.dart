import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../resources/app_enums/api_enums.dart';
import '../../../resources/configs/service_locator/service_locator.dart';
import '../network_provider.dart';

class OrderProvider {
  NetworkProviderRest networkProvider =
      serviceLocator.get<NetworkProviderRest>();

  /// For [Listing]
  Future<dynamic> getOrders(String cityCode, String pages) async {
    try {
      Map<String, dynamic>? query = {"page":"$pages"};
      final Response response = await networkProvider.getWithParam(
          url: "${NetworkProviderRest.baseUrl}/ukr${cityCode}/orders-delivery", query: query);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getOrderInfo(String cityCode,String orderID) async {
    try {
      final Response response = await networkProvider.get(
          url: "${NetworkProviderRest.baseUrl}/ukr${cityCode}/orders-delivery/${orderID}");
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> createOrder(
      {required String cityCode, required dynamic data}) async {
    try {
      String body = json.encode(data);
      final Response response = await networkProvider.postWithSessionToken1(
          url: "${NetworkProviderRest.baseUrl}/ukr${cityCode}/order-delivery",
          data: body);
      print("Order Create Response :: ${response.data}");
      ///ukr${cityCode}
      ///url: "${NetworkProviderRest.stagingBaseUrl}/order-delivery",

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> addPaymentOrder(
      {required String cityCode,
        required String orderId,
        required String paymentType}) async {
    try {
      final Response response = await networkProvider.postWithSessionToken(
          url: "${NetworkProviderRest.baseUrl}/ukr${cityCode}/delivery-orders/$orderId",
          data: {"paymentType": paymentType});
///ukr${cityCode}
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> addAgainPaymentOrder(
      {required String cityCode,
        required String orderId,
        required String paymentType}) async {
    try {
      final Response response = await networkProvider.put(
          path: "${NetworkProviderRest.baseUrl}/ukr${cityCode}/delivery-orders/$orderId",
          data: {"paymentType": paymentType});
///ukr${cityCode}
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> payOrderPaymentOrder(
      {required String cityCode,
        required String orderId,
        required String price}) async {
    try {
      final Response response = await networkProvider.postWithNewSessionToken(
          url: "${NetworkProviderRest.baseUrl}/pay-delivery-order/$orderId",
          data: {"price": double.parse(price).round(), "status": "completed"});
///ukr${cityCode}
      ////ukr${cityCode}
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> cancelOrder(
      {required String cityCode,
        required String orderId,required String deliveryStatus}) async {
    try {
      final Response response = await networkProvider.postWithSessionToken(
          url: "${NetworkProviderRest.baseUrl}/ukr${cityCode}/order-delivery/$orderId",
          data: {"deliveryStatus": deliveryStatus});
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> deleteOrder(
      {required String cityCode, required String orderId}) async {
    try {
      final Response response = await networkProvider.deleteRes(
          path: "${NetworkProviderRest.baseUrl}/order-delivery/$orderId",
          // path: "${NetworkProviderRest.stagingBaseUrl}/order-delivery/$orderId",
          query: {"cancelReason": "REASON"});
///ukr${cityCode}
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> updateOrder(
      {required String cityCode, required String orderId}) async {
    try {
      final Response response = await networkProvider.get(
        url: "${NetworkProviderRest.baseUrl}/ukr${cityCode}/orders-delivery/$orderId",
      );
///ukr${cityCode}
      printWrapped("Order Status Api Response ---> ${response.toString()}");

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  //feed back
  Future<dynamic> orderFeedBack(String cityCode,String orderID,bool isSuccessFullOrder) async {
    try {
      final Response response = await networkProvider.postWithSessionToken(
          url: "${NetworkProviderRest.baseUrl}/ukr${cityCode}/feedback-order-delivery/${orderID}",data: {"isSuccessfulOrder": isSuccessFullOrder});
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  //Rating Order
  Future<dynamic> ratingOrders(String cityCode,String orderID,String ratingValue) async {
    try {
      final Response response = await networkProvider.postWithSessionToken(
          url: "${NetworkProviderRest.baseUrl}/ukr${cityCode}/orders/${orderID}/feedback",data: {"rating": ratingValue});
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  //Store Status
  Future<dynamic> storeStatusCheck(String cityCode) async {
    try {
      final Response response = await networkProvider.get(
          url: "${NetworkProviderRest.baseUrl}/ukr${cityCode}/alarm");
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

}
