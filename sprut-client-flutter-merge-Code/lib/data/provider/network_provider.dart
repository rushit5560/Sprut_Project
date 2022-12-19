import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sprut/resources/app_constants/api_constants.dart';
import 'package:sprut/resources/app_constants/app_constants.dart';
import 'package:sprut/resources/app_enums/api_enums.dart';
import 'package:sprut/resources/app_strings/app_strings.dart';
import 'package:sprut/resources/configs/helpers/helpers.dart';

class NetworkProviderRest {
  late Dio _dio;
  late Dio _dioSecured;

  NetworkProviderRest() {
    prepareBaseRestRequest();
  }

  final Duration defaultTimeout = Duration(seconds: 100);
  // https://fp-test.altertaxi.com.ua/v1/ukrvin/orders/8247893

  static String prodUrl = "https://fp-test.altertaxi.com.ua/v1";
  static String releaseUrl = "https://client-api.sprut.mobi/v1";

  static String baseUrl = prodUrl;

  // static final baseUrl = "https://fp-test.altertaxi.com.ua/v1";
  // Taxi
  static final apiKey = "b20b86bc-bbd1-70ca-6535-451d2d7e5922";

  //Food Delivery
  static final apiKey1 = "9e7af99a-60f8-496b-a2fc-f31b267f79c3";
  //End

  final baseHeaders = {"x-api-key": apiKey, "Content-Type": "application/json"};

  void prepareBaseRestRequest() {
    BaseOptions dioOptions = BaseOptions(
      // connectTimeout: AppConstants.CONNECT_TIMEOUT,
      // receiveTimeout: AppConstants.RECEIVE_TIMEOUT,
      baseUrl: baseUrl,
      // contentType: Headers.formUrlEncodedContentType,
      responseType: ResponseType.json,
      headers: baseHeaders,
    );
    _dio = Dio(dioOptions);
    _dio.interceptors.clear();
    _dio.interceptors.addAll([
      LogInterceptor(
        error: true,
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
      )
    ]);
  }

  void prepareBaseRestWithSessionTokenRequest() {
    BaseOptions dioOptions = BaseOptions(
      // connectTimeout: AppConstants.CONNECT_TIMEOUT,
      // receiveTimeout: AppConstants.RECEIVE_TIMEOUT,
      baseUrl: baseUrl,
      // contentType: Headers.formUrlEncodedContentType,
      responseType: ResponseType.json,
      headers: Helpers.getSecureHeaders,
    );
    _dioSecured = Dio(dioOptions);
    _dioSecured.interceptors.clear();
    _dioSecured.interceptors.addAll([
      LogInterceptor(
        error: true,
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
      )
    ]);
  }

  //Fod Delivery
  void prepareBaseRestWithNewSessionTokenRequest() {
    BaseOptions dioOptions = BaseOptions(
      // connectTimeout: AppConstants.CONNECT_TIMEOUT,
      // receiveTimeout: AppConstants.RECEIVE_TIMEOUT,
      baseUrl: baseUrl,
      // contentType: Headers.formUrlEncodedContentType,
      responseType: ResponseType.json,
      headers: Helpers.getSecureHeaders1,
    );
    _dioSecured = Dio(dioOptions);
    _dioSecured.interceptors.clear();
    _dioSecured.interceptors.addAll([
      LogInterceptor(
        error: true,
        request: true,
        requestBody: true,
        requestHeader: true,
        responseBody: true,
        responseHeader: true,
      )
    ]);
  }
  //End

  Future<dynamic> get({
    required String url,
  }) async {
    prepareBaseRestWithSessionTokenRequest();

    try {
      final response = await _dioSecured.get(url);
      return response;
    } on DioError catch (e) {
      if (e.type == DioErrorType.response) {
        return e.response;
      }
    } on Exception catch (exception) {
      return ExceptionHandlerRest.handleError(exception);
    }
  }

  Future<dynamic> getRequestWithOutToken({
    required String url,
  }) async {
    try {
      final response = await _dio.get(url);
      return response;
    } on DioError catch (e) {
      if (e.type == DioErrorType.response) {
        return e.response;
      }
    } on Exception catch (exception) {
      return ExceptionHandlerRest.handleError(exception);
    }
  }

  Future<dynamic> post({
    required String url,
    required Map<String, dynamic>? data,
  }) async {
    try {
      final response = await _dio.post(url, data: data);

      return response;
    } on DioError catch (e) {
      if (e.type == DioErrorType.response) {
        return e.response;
      }
    } on TimeoutException catch (error) {
      log(error.toString());
      return ExceptionHandlerRest.handleError(error);
    } on SocketException catch (e) {
      log(e.toString());
      return e;
    } catch (e) {
      log(e.toString());
      return e;
    }
  }

  /// Callinf using[Session Token ]
  Future<dynamic> postWithSessionToken({
    required String url,
    required Map<String, dynamic>? data,
  }) async {
    var response;
    prepareBaseRestWithSessionTokenRequest();
    try {
      response = await _dioSecured.post(url, data: data);
      // print(response);
      return response;
    } on TimeoutException catch (error) {
      log(error.toString());
      return ExceptionHandlerRest.handleError(error);
    } on SocketException catch (e) {
      log(e.toString());
      return e;
    } on DioError catch (e) {
      if (e.type == DioErrorType.response) {
        return e.response;
      }
    } catch (e) {
      log(e.toString());
      return response;
    }
  }

  //Food delivery
  Future<dynamic> getWithParam(
      {required String url, required Map<String, dynamic>? query}) async {
    prepareBaseRestWithSessionTokenRequest();
    try {
      final response = await _dioSecured.get(url, queryParameters: query);
      return response;
    } on DioError catch (e) {
      if (e.type == DioErrorType.response) {
        return e.response;
      }
    } on Exception catch (exception) {
      return ExceptionHandlerRest.handleError(exception);
    }
  }

  Future<dynamic> postWithSessionToken1({
    required String url,
    // required Map<String, dynamic>? data,
    required dynamic data,
  }) async {
    var response;
    prepareBaseRestWithSessionTokenRequest();
    try {
      response = await _dioSecured.post(url, data: data);
      // print(response);
      return response;
    } on TimeoutException catch (error) {
      log(error.toString());
      return ExceptionHandlerRest.handleError(error);
    } on SocketException catch (e) {
      log(e.toString());
      return e;
    } on DioError catch (e) {
      if (e.type == DioErrorType.response) {
        return e.response;
      }
    } catch (e) {
      log(e.toString());
      return response;
    }
  }

  //new session with token
  Future<dynamic> postWithNewSessionToken({
    required String url,
    required Map<String, dynamic>? data,
  }) async {
    var response;
    prepareBaseRestWithNewSessionTokenRequest();
    try {
      response = await _dioSecured.post(url, data: data);
      // print(response);
      return response;
    } on TimeoutException catch (error) {
      log(error.toString());
      return ExceptionHandlerRest.handleError(error);
    } on SocketException catch (e) {
      log(e.toString());
      return e;
    } on DioError catch (e) {
      if (e.type == DioErrorType.response) {
        return e.response;
      }
    } catch (e) {
      log(e.toString());
      return response;
    }
  }
  //end

  Future<dynamic> put({
    required String path,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    prepareBaseRestWithSessionTokenRequest();
    try {
      final response =
          await _dioSecured.put(path, queryParameters: query, data: data);
      return response;
    } on Exception catch (error) {
      return ExceptionHandlerRest.handleError(error);
    }
  }

  Future<dynamic> patch({
    required String path,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response =
          await _dio.patch(path, queryParameters: query, data: data);
      return response.data;
    } on Exception catch (error) {
      return ExceptionHandlerRest.handleError(error);
    }
  }

  Future<dynamic> delete({
    required String path,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    prepareBaseRestWithSessionTokenRequest();
    try {
      final response =
          await _dioSecured.delete(path, queryParameters: query, data: data);
      return response.data;
    } on Exception catch (error) {
      return ExceptionHandlerRest.handleError(error);
    }
  }

  Future<dynamic> deleteRes({
    required String path,
    Map<String, dynamic>? query,
    Map<String, dynamic>? data,
  }) async {
    prepareBaseRestWithSessionTokenRequest();
    try {
      final response =
          await _dioSecured.delete(path, queryParameters: query, data: data);
      return response;
    } on Exception catch (error) {
      return ExceptionHandlerRest.handleError(error);
    }
  }

  String getApiName({required ApiNames apiName}) {
    switch (apiName) {
      case ApiNames.INIT_SESSION:
        return baseUrl + ApiConstants.initSession;
      case ApiNames.SESSION_CONFIGRATION:
        return baseUrl + ApiConstants.sessionConfig;
      case ApiNames.GET_CITIES:
        return baseUrl + ApiConstants.getCities;

      //Food Delivery
      case ApiNames.GET_FOOD_CATEGORY:
        return baseUrl + ApiConstants.getFoodCategory;
      case ApiNames.GET_ALL_ESTABLISHMENT_LIST:
        return baseUrl + ApiConstants.getAllEstablishmentList;
      case ApiNames.GET_FOOD_TYPE_LIST:
        return baseUrl + ApiConstants.getFoodTypesList;
      case ApiNames.GET_PRODUCT_LIST:
        return baseUrl + ApiConstants.getProductList;
      case ApiNames.ORDER_DELIVERY:
        return baseUrl + ApiConstants.orderDelivery;
      case ApiNames.ORDER_STATUS_CHECHED:
        return baseUrl + ApiConstants.orderStatusChecked;
      case ApiNames.FOOD_ORDER_LISTINGS:
        return baseUrl + ApiConstants.orderStatusChecked;
      case ApiNames.ACTIVE_COUNTS:
        return baseUrl + ApiConstants.orderActiveCounts;
    }
  }
}

class APIException implements Exception {
  final String message;

  APIException({required this.message});
}

class ExceptionHandlerRest {
  ExceptionHandlerRest._privateConstructor();

  static APIException handleError(Exception error) {
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.sendTimeout:
          return APIException(message: ErrorMessages.noInternet);
        case DioErrorType.connectTimeout:
          return APIException(message: ErrorMessages.connectionTimeout);
        case DioErrorType.response:

        default:
          return APIException(message: ErrorMessages.networkGeneral);
      }
    } else {
      return APIException(message: ErrorMessages.networkGeneral);
    }
  }
}
