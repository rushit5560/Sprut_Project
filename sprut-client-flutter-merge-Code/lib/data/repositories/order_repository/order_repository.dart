
import 'dart:convert';
import 'dart:developer';

import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:sprut/data/models/tariff_screen_model/order_model.dart';
import 'package:sprut/data/provider/order/order_provider.dart';
import 'package:dio/dio.dart';
import 'package:sprut/presentation/pages/order_screen/controllers/order_controller.dart';

import '../../models/oder_delivery/delivery_payment_response.dart';
import '../../models/oder_delivery/oder_delivery_response.dart';
import '../../models/tariff_screen_model/order_details_response.dart';


class OrderRepository {
  OrderProvider _orderProvider = OrderProvider();

  Future<List<OrderModel>?> fetchOrders(String cityCode,String pages) async {
    try {
      final Response response = await _orderProvider.getOrders(cityCode,pages);
      if(response.statusCode == 403) {
        Get.find<OrderController>().isLoading = false;
        Get.find<OrderController>().update();

        log("Call error Cat Data");
        return Future.error("Session expired");
      }
      // print("Order Listing :: ${response.data}");

      OrderDetailsResponse orderResponse = OrderDetailsResponse.fromJson(response.data);
      print("Order Listing :: ${orderResponse.orderData}");
      // List<OrderModel> data = List<OrderModel>.from(response.data.map((x) => OrderModel.fromJson(x)));
      List<OrderModel>? data = orderResponse.orderData;
      return data;
    } catch (e) {
      Get.find<OrderController>().isLoading = false;
      Get.find<OrderController>().update();
      return Future.error(e);
    }
  }

  Future<dynamic> fetchOrderInformation(String cityCode,String orderID) async {
    try {
      final Response response = await _orderProvider.getOrderInfo(cityCode,orderID);
      if(response.statusCode == 403) {
        Get.find<OrderController>().isLoading = false;
        Get.find<OrderController>().update();
        log("Call error Cat Data");
        return Future.error("Session expired");
      }
      // print("Order Details :: ${response.data}");
      return response.data;
    } catch (e) {
      Get.find<OrderController>().isLoading = false;
      Get.find<OrderController>().update();
      return Future.error(e);
    }
  }


  Future<dynamic> createOrder(
      {required String cityCode, required dynamic data}) async {
    try {
      final Response response = await _orderProvider.createOrder(
          cityCode: cityCode, data: data);
     // print("Order Response---> ${response.toString()}");
      //print("Order statusCode---> ${response.statusCode}");
      if(response.statusCode == 403) {
        log("Call error Cat Data");
        return Future.error("Session expired");
      }else if(response.statusCode == 500) {
        // Map<String, dynamic> data = jsonDecode(jsonEncode(response.data));
        return Future.error(jsonEncode(response.data));
      }
      MakeOrderResponse orderResponse = MakeOrderResponse.fromJson(response.data);
      return orderResponse;
    } catch (e) {
      //print("Order Response---> ${e}");
      return Future.error(e);
    }
  }

  Future<dynamic> addPaymentOrder(
      {required String cityCode,
        required String orderId,
        required String paymentType}) async {
    try {
      final Response response = await _orderProvider.addPaymentOrder(
          cityCode: cityCode, orderId: orderId, paymentType: paymentType);

      if(response.statusCode == 403){
        log("Call error Cat Data");
        return Future.error("Session expired");
      }

      DeliveryPaymentResponse deliveryPaymentResponse = DeliveryPaymentResponse.fromJson(response.data);
      return deliveryPaymentResponse;
    } catch (e) {
      return Future.error(e);
    }
  }

 Future<dynamic> addAgainPaymentOrder(
      {required String cityCode,
        required String orderId,
        required String paymentType}) async {
    try {
      final Response response = await _orderProvider.addAgainPaymentOrder(
          cityCode: cityCode, orderId: orderId, paymentType: paymentType);

      if(response.statusCode == 403){
        log("Call error Cat Data");
        return Future.error("Session expired");
      }

      DeliveryPaymentResponse deliveryPaymentResponse = DeliveryPaymentResponse.fromJson(response.data);
      return deliveryPaymentResponse;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> payOrderPaymentOrder(
      {required String cityCode,
        required String orderId,
        required String price}) async {
    try {
      final Response response = await _orderProvider.payOrderPaymentOrder(
          cityCode: cityCode, orderId: orderId, price: price);
      if(response.statusCode == 403){
        log("Call error Cat Data");
        return Future.error("Session expired");
      }
      return response.data;
    } catch (e) {
      return Future.error(e);
    }
  }



  Future<dynamic> cancelOrder(
      {required String cityCode,
        required String orderId, required String deliverySta}) async {
    try {
      final Response response = await _orderProvider.cancelOrder(
          cityCode: cityCode, orderId: orderId, deliveryStatus: deliverySta);
      if(response.statusCode == 403){
        log("Call error Cat Data");
        return Future.error("Session expired");
      }
      return response.data;
    } catch (e) {
      return Future.error(e);
    }
  }


  Future<dynamic> deleteOrder(
      {required String cityCode, required String orderId}) async {
    try {
      final Response response = await _orderProvider.deleteOrder(
          cityCode: cityCode, orderId: orderId);

      return response.data;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> updateOrder(
      {required String cityCode, required String orderId}) async {
    try {
      final Response response = await _orderProvider.updateOrder(
          cityCode: cityCode, orderId: orderId);
      if(response.statusCode == 403){
        log("Call error Cat Data");
        return Future.error("Session expired");
      }
      printWrapped(response.data.toString());
      OrderModel orderModel = OrderModel.fromJson(response.data);
      return orderModel;
    } catch (e) {
      return Future.error(e);
    }
  }

  void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  Future<dynamic> feedbackOrders(
      {required String cityCode,
        required String orderId,
        required bool isOrderStatus}) async {
    try {
      final Response response = await _orderProvider.orderFeedBack(cityCode, orderId, isOrderStatus);

      // final Response response = await _orderProvider.orderFeedBack(
      //     cityCode: cityCode, orderID: orderId, isSuccessFullOrder: isOrderStatus);
      if(response.statusCode == 403){
        log("Call error Cat Data");
        return Future.error("Session expired");
      }
      return response.data;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> ratingOrders(
      {required String cityCode,
        required String orderId,
        required String ratingValue}) async {
    try {
      final Response response = await _orderProvider.ratingOrders(cityCode, orderId, ratingValue);

      // final Response response = await _orderProvider.orderFeedBack(
      //     cityCode: cityCode, orderID: orderId, isSuccessFullOrder: isOrderStatus);
      if(response.statusCode == 403){
        log("Call error Cat Data");
        return Future.error("Session expired");
      }
      return response.data;
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> storeStatusChecked(
      {required String cityCode}) async {
    try {
      final Response response = await _orderProvider.storeStatusCheck(cityCode);
      //print("Order Response---> ${response.toString()}");
      if(response.statusCode == 403){
        log("Call error Cat Data");
        return Future.error("Session expired");
      }
      return response.data;
    } catch (e) {
      //print("Order Response---> ${e}");
      return Future.error(e);
    }
  }

}
