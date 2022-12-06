
import 'package:dio/dio.dart';
import 'package:sprut/data/provider/network_provider.dart';
import 'package:sprut/resources/configs/service_locator/service_locator.dart';

class MapsScreenDataProvider {
  NetworkProviderRest networkProvider =
      serviceLocator.get<NetworkProviderRest>();

  Future<dynamic> reverseGeoCoding(
      {required double latitude,
      required double longitude,
      required cityCode}) async {
    try {
      final Response response = await networkProvider.get(
        url: "${NetworkProviderRest.baseUrl}/ukr$cityCode/places/reverse?lat=${latitude}&lon=${longitude}",
      );

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getOsmSuggestion(
      {required String searchTerm, required String cityCode}) async {
    try {
      final Response response = await networkProvider.get(
        url:
            "${NetworkProviderRest.baseUrl}/ukr$cityCode/places/autocomplete?q=${searchTerm}",
      );

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  getCars({required String cityCode}) async {
    try {
      final Response response = await networkProvider.get(
        url: "${NetworkProviderRest.baseUrl}/ukr${cityCode}/cars",
      );

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

   Future<dynamic> updateToken(String token) async {
    try {
      final Response response = await networkProvider
          .put(path: "${NetworkProviderRest.baseUrl}/profile", data: {
        "refreshedToken": token,
      });

      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  //Food Delivery
  //get Active counts
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
