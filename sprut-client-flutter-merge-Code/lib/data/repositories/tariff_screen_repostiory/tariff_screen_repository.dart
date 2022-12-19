import 'package:sprut/data/models/map_screen_models/_tariff_option_model/_tariff_option_model.dart';
import 'package:sprut/data/models/map_screen_models/order/order.dart';
import 'package:sprut/data/models/tariff_screen_model/card_model.dart';
import 'package:sprut/data/models/tariff_screen_model/order_model.dart';
import 'package:sprut/data/models/tariff_screen_model/profile_model.dart';
import 'package:sprut/data/models/tariff_screen_model/service_model.dart';
import 'package:sprut/data/provider/tariff_screen_provider/tariff_screen_provider.dart';
import 'package:dio/dio.dart';

import '../../models/tariff_screen_model/recharge_model.dart';

class TariffScreenRepository {
  TariffSelectionProvider tariffSelectionProvider = TariffSelectionProvider();

  Future<dynamic> fetchTariffsOptions({required String cityCode}) async {
    List<TariffOption> _tariffOptions = [];

    try {
      final Response response =
          await tariffSelectionProvider.getTariffsOptions(cityCode: cityCode);

      List _decoded = response.data;

      for (var item in _decoded) {
        _tariffOptions.add(TariffOption.fromJson(item));
      }
      return _tariffOptions;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> fetchProfile() async {
    try {
      final Response response = await tariffSelectionProvider.getProfile();

      ProfileModel profileModel = ProfileModel.fromJson(response.data);

      return profileModel.profile;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> updatedProfile(String paymentType) async {
    try {
      final Response response =
          await tariffSelectionProvider.updateProfile(paymentType);

      ProfileModel profileModel = ProfileModel.fromJson(response.data);

      return profileModel.profile;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> rechargeBalance(String balance) async {
    try {
      final Response response =
          await tariffSelectionProvider.rechargeBalance(balance);

      RechargeModel rechargeModel = RechargeModel.fromJson(response.data);

      return rechargeModel;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> addCard() async {
    try {
      final Response response = await tariffSelectionProvider.addCard();

      RechargeModel rechargeModel = RechargeModel.fromJson(response.data);

      return rechargeModel;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> fetchCards() async {
    try {
      final Response response = await tariffSelectionProvider.getCards();

      CardModel cardModel = CardModel.fromJson(response.data);

      return cardModel.cards;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> defaultCard(String cardId) async {
    try {
      final Response response =
          await tariffSelectionProvider.defaultCard(cardId);

      Cards cards = Cards.fromJson(response.data["card"]);

      return cards;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> deleteCard(String cardId) async {
    try {
      final Response response =
          await tariffSelectionProvider.deleteCard(cardId);

      return response.data;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> fetchServices({required String cityCode}) async {
    try {
      final Response response =
          await tariffSelectionProvider.getServices(cityCode: cityCode);

      List<ServiceModel> serviceModel = List<ServiceModel>.from(
        response.data.map(
          (x) => ServiceModel.fromJson(x),
        ),
      );

      return serviceModel;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> createOrder(
      {required String cityCode, required dynamic data}) async {
    try {
      final Response response = await tariffSelectionProvider.createOrder(
          cityCode: cityCode, data: data);

      OrderModel orderModel = OrderModel.fromJson(response.data);
      return orderModel;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> addPaymentOrder(
      {required String cityCode,
      required String orderId,
      required String paymentType}) async {
    try {
      final Response response = await tariffSelectionProvider.addPaymentOrder(
          cityCode: cityCode, orderId: orderId, paymentType: paymentType);

      return response.data;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> deleteOrder(
      {required String cityCode, required String orderId}) async {
    try {
      final Response response = await tariffSelectionProvider.deleteOrder(
          cityCode: cityCode, orderId: orderId);

      return response.data;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> updateOrder(
      {required String cityCode, required String orderId}) async {
    try {
      final Response response = await tariffSelectionProvider.updateOrder(
          cityCode: cityCode, orderId: orderId);

      OrderModel orderModel = OrderModel.fromJson(response.data);
      return orderModel;
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
      final Response response = await tariffSelectionProvider.orderRating(
          cityCode: cityCode, orderId: orderId, rating: rating, review: review);

      return response.data;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> orderTip(
      {required String cityCode,
      required String orderId,
      required double tip}) async {
    try {
      final Response response = await tariffSelectionProvider.orderTip(
          cityCode: cityCode, orderId: orderId, tip: tip);

      return response.data;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getOrderHitory({
    required String cityCode,
    required int page,
  }) async {
    List<OrderModel> _listOrders = [];
    try {
      final dynamic response = await tariffSelectionProvider.getOrderHitory(
          cityCode: cityCode, page: page);

      printWrapped(response.toString());

      List _decoded = response.data["rows"];

      for (var item in _decoded) {
        _listOrders.add(OrderModel.fromJson(item));
      }
      return _listOrders;
    } catch (e) {
      return _listOrders;
    }
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }
}
