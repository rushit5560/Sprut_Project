import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:sprut/data/provider/network_provider.dart';
import 'package:sprut/resources/configs/service_locator/service_locator.dart';

class TariffSelectionProvider {
  NetworkProviderRest networkProvider =
      serviceLocator.get<NetworkProviderRest>();

  Future<dynamic> getTariffsOptions({required String cityCode}) async {
    try {
      final dynamic response = await networkProvider.get(
        url: "${NetworkProviderRest.baseUrl}/ukr${cityCode}/rates",
      );

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getProfile() async {
    try {
      final Response response = await networkProvider.get(
        url: "${NetworkProviderRest.baseUrl}/profile",
      );

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> updateProfile(String paymentType) async {
    try {
      final Response response = await networkProvider
          .put(path: "${NetworkProviderRest.baseUrl}/profile", data: {
        "paymentType": paymentType,
      });

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> rechargeBalance(String balance) async {
    try {
      final Response response = await networkProvider.postWithSessionToken(
          url: "${NetworkProviderRest.baseUrl}/recharge-balance",
          data: {"amount": balance, "type": "button"});

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> addCard() async {
    try {
      final Response response = await networkProvider.postWithSessionToken(
          url: "${NetworkProviderRest.baseUrl}/cards",
          data: {"type": "button"});

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getCards() async {
    try {
      final Response response = await networkProvider.get(
        url: "${NetworkProviderRest.baseUrl}/cards",
      );

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> defaultCard(String cardId) async {
    try {
      final Response response = await networkProvider.put(
          path: "${NetworkProviderRest.baseUrl}/cards/$cardId",
          data: {"default": true});

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> deleteCard(String cardId) async {
    try {
      final Response response = await networkProvider.delete(
          path: "${NetworkProviderRest.baseUrl}/cards/$cardId");

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getServices({required String cityCode}) async {
    try {
      final Response response = await networkProvider.get(
        url: "${NetworkProviderRest.baseUrl}/ukr${cityCode}/options",
      );

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> createOrder(
      {required String cityCode, required dynamic data}) async {
    try {
      final Response response = await networkProvider.postWithSessionToken(
          url: "${NetworkProviderRest.baseUrl}/ukr${cityCode}/orders",
          data: data);

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
          url: "${NetworkProviderRest.baseUrl}/ukr${cityCode}/orders/$orderId",
          data: {"paymentType": paymentType});

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> deleteOrder(
      {required String cityCode, required String orderId}) async {
    try {
      final Response response = await networkProvider.deleteRes(
          path: "${NetworkProviderRest.baseUrl}/ukr${cityCode}/orders/$orderId",
          query: {"cancelReason": "REASON"});

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> updateOrder(
      {required String cityCode, required String orderId}) async {
    try {
      final Response response = await networkProvider.get(
        url: "${NetworkProviderRest.baseUrl}/ukr${cityCode}/orders/$orderId",
      );

      // printWrapped(response.toString());

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> orderRating(
      {required String cityCode,
      required String orderId,
      required int rating,
      required String review}) async {
    try {
      Map<String, dynamic> data = {};

      if (review.trim().isEmpty) {
        data = {"rating": rating};
      } else {
        data = {"rating": rating, "review": review.trim()};
      }

      final Response response = await networkProvider.postWithSessionToken(
          url:
              "${NetworkProviderRest.baseUrl}/ukr${cityCode}/orders/$orderId/feedback",
          data: data);

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> orderTip(
      {required String cityCode,
      required String orderId,
      required double tip}) async {
    try {
      final Response response = await networkProvider.postWithSessionToken(
          url:
              "${NetworkProviderRest.baseUrl}/ukr${cityCode}/orders/$orderId/tip",
          data: {"tip": tip});

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getOrderHitory({
    required String cityCode,
    required int page,
  }) async {
    try {
      final dynamic response = await networkProvider.get(
          url:
              "${NetworkProviderRest.baseUrl}/ukr${cityCode}/orders?page=$page");
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}
