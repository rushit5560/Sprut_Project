import 'package:dio/dio.dart';

import '../../../resources/app_enums/api_enums.dart';
import '../../../resources/configs/service_locator/service_locator.dart';
import '../network_provider.dart';


class FoodCategoryProvider{

  NetworkProviderRest networkProvider = serviceLocator.get<NetworkProviderRest>();

  /// For [Listing]
  Future<dynamic> getCategoryListing() async {
    try {
      final Response response = await networkProvider.get(
          url: networkProvider.getApiName(apiName: ApiNames.GET_FOOD_CATEGORY));
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  /// For [Establishment Listing]
  Future<dynamic> getEstablishmentListing(String catID, double latitude, double longitude) async {
    try {
      String endPoint = networkProvider.getApiName(apiName: ApiNames.GET_ALL_ESTABLISHMENT_LIST);
      final requestData = {
        'latitude':'49.2130524',
        'longitude':'28.3899292'
      };

      String dd = "{\"latitude\":\"$latitude\",\"longitude\":\"$longitude\"}";

      final Response response = await networkProvider.get(url: endPoint+"?categoryId=$catID&address=${dd}",);

      //+"?categoryId=$catID"
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  /// For [Food Type Listing]
  Future<dynamic> getFoodTypeListing(String catID) async {
    try {

      String endPoint = networkProvider.getApiName(apiName: ApiNames.GET_FOOD_TYPE_LIST);

      final Response response = await networkProvider.get(
          url: endPoint+"?categoryId=$catID");
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  /// For [Food Type Listing]
  Future<dynamic> getEstablishmentProductListing(String brandId) async {
    try {

      String endPoint = networkProvider.getApiName(apiName: ApiNames.GET_PRODUCT_LIST);
      final Response response = await networkProvider.get(url: endPoint+"?brandId=$brandId");
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  /// For [Make Order]
  Future<dynamic> makeAOrder(var body) async {
    try {
      String endPoint = networkProvider.getApiName(apiName: ApiNames.ORDER_DELIVERY);
      final Response response = await networkProvider.postWithSessionToken(url: endPoint, data: body,);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  /// For [Order Status checked]
  Future<dynamic> checkedStatusAOrder(int? orderID) async {
    try {
      String endPoint = networkProvider.getApiName(apiName: ApiNames.ORDER_STATUS_CHECHED) +"/${orderID}";
      final Response response = await networkProvider.get(url: endPoint);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }


}