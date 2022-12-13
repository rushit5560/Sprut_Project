import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:sprut/data/models/establishments_all_screen_models/all_sstablishments_list_models.dart';
import 'package:sprut/data/models/establishments_all_screen_models/establishment_product_list/product_list_response.dart';
import 'package:sprut/data/models/establishments_all_screen_models/types/food_type_list_models.dart';

import '../../models/food_category_models/food_category_list_models.dart';
import '../../provider/food_category_screen_provider/food_category_provider.dart';

class FoodCategoryRepository {

  FoodCategoryProvider foodCategoryProvider = FoodCategoryProvider();

  /// [Get category]

  Future<dynamic> getFoodCategoryList() async {
    try {
      Response response = await foodCategoryProvider.getCategoryListing();
      log("StatusCode:: "+response.statusCode.toString());
      if(response.statusCode == 403 || response.statusCode == 401){
        log("Call error Cat Data");
        return Future.error("Session expired");
      }else{
        log("Call Success Cat Data");
        FoodCategoryListModel _decodedFoodCategory = FoodCategoryListModel.fromJson(response.data);
        return _decodedFoodCategory;
      }

    } on SocketException catch (_) {
      print('not connected');
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }

  ///[All Establishment List]
  Future<dynamic> getEstablishmentsList(String categoryID, double latitude, double longitude) async {
    try {
      Response response = await foodCategoryProvider.getEstablishmentListing(categoryID, latitude, longitude);
      log("StatusCode:: "+response.statusCode.toString());
      if(response.statusCode == 403 || response.statusCode == 401){
        log("Call error Cat Data");
        return Future.error("Session expired");
      }else{
        log("Call Success Cat Data :: ${response.data.toString()}");
        AllEstablishments _decodedEstablishment = AllEstablishments.fromJson(response.data);
        return _decodedEstablishment;
      }

    } on SocketException catch (_) {
      print('not connected');
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }

  ///[Food Type List]
  Future<dynamic> getFoodTypesList(String categoryID) async {
    try {
      Response response = await foodCategoryProvider.getFoodTypeListing(categoryID);
      log("StatusCode:: "+response.statusCode.toString());
      if(response.statusCode == 403 || response.statusCode == 401){
        log("Call error Cat Data");
        return Future.error("Session expired");
      }else{
        log("Call Success Type Data");
        FoodTypeModels _decodedFoodType = FoodTypeModels.fromJson(response.data);
        return _decodedFoodType;
      }

    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }

  ///[Establishment Product List]
  Future<dynamic> getProductList(String brandID,String establishmentId,String placeId) async {
    try {
      Response response = await foodCategoryProvider.getEstablishmentProductListing(brandID, establishmentId, placeId);
      log("StatusCode:: "+response.statusCode.toString());
      if(response.statusCode == 403 || response.statusCode == 401){
        log("Call error Cat Data");
        return Future.error("Session expired");
      }else{
        ProductListResponse _decodedProductList = ProductListResponse.fromJson(response.data);
        return _decodedProductList;
      }

    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }

  //order make
  Future<dynamic> makeAOrder(var body) async {
    try {
      Response response = await foodCategoryProvider.makeAOrder(body);
      log("StatusCode:: "+response.statusCode.toString());
      if(response.statusCode == 403 || response.statusCode == 401){
        log("Call error Cat Data");
        return Future.error("Session expired");
      }else{
        // ProductListResponse _decodedProductList = ProductListResponse.fromJson(response.data);
        // return _decodedProductList;

        return response.data;
      }

    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }

  //order status checked
  Future<dynamic> statusCheckedAOrder(int? orderID) async {
    try {
      Response response = await foodCategoryProvider.checkedStatusAOrder(orderID);
      log("StatusCode:: "+response.statusCode.toString());
      if(response.statusCode == 403 || response.statusCode == 401){
        log("Call error Cat Data");
        return Future.error("Session expired");
      }else{
        print("object :: Response");
        return response.data;
      }

    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }
}