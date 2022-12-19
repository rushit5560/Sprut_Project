import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprut/data/provider/network_provider.dart';
import 'package:sprut/resources/app_enums/api_enums.dart';
import 'package:sprut/resources/configs/service_locator/service_locator.dart';

class UserAuthProvider {
  NetworkProviderRest networkProvider =
      serviceLocator.get<NetworkProviderRest>();

  /// For [Login]
  Future<dynamic> initSession({required String phoneNumber}) async {
    try {
      final Response response = await networkProvider.post(
          url: networkProvider.getApiName(apiName: ApiNames.INIT_SESSION),
          data: {"phoneNumber": phoneNumber});

      return response.data;
    } catch (e) {
      return Future.error(e);
    }
  }

  /// For [Verify Otp]
  Future<dynamic> sessionConfigration({required String code}) async {
    try {
      final dynamic response = await networkProvider.postWithSessionToken(
          url: networkProvider.getApiName(
              apiName: ApiNames.SESSION_CONFIGRATION),
          data: {"confirmation": code});

      return response.data;
    } catch (e) {
      return Future.error(e);
    }
  }

  /// [Get Available Cities]
  Future<dynamic> getAvailableCities() async {
    try {
      final dynamic response = await networkProvider.getRequestWithOutToken(
        url: networkProvider.getApiName(apiName: ApiNames.GET_CITIES),
      );

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getNews({required int page}) async {
    try {
      final dynamic response = await networkProvider.get(
          url: "${NetworkProviderRest.baseUrl}/news-client?page=$page");

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getNewsCount() async {
    try {
      final dynamic response = await networkProvider.get(
          url: "${NetworkProviderRest.baseUrl}/news-client");

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  //Food Delivery
  Future<dynamic> getActiveCounts(String cityCode) async {
    try {
      final dynamic response = await networkProvider.get(
        url: "${NetworkProviderRest.baseUrl}/ukr${cityCode}/orders-delivery/activeCount",
      );
      return response;
    } catch (e) {

      return Future.error(e);
    }
  }
  //End
}
