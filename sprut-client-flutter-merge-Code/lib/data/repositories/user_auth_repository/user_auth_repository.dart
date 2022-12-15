import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:sprut/data/models/available_cities_model/available_cities_model.dart';
import 'package:sprut/data/models/news_model/news_model.dart';
import 'package:sprut/data/models/session_configration_response_model/session_configration_response.model.dart';
import 'package:sprut/data/models/sessions_model/sessions_model.dart';
import 'package:sprut/data/provider/authentication/auth_provider.dart';
import 'package:sprut/resources/app_strings/app_strings.dart';
import 'package:sprut/resources/configs/service_locator/service_locator.dart';
import 'package:sprut/resources/services/database/database.dart';
import 'package:sprut/resources/services/database/database_keys.dart';

class UserAuthRepository {
  DatabaseService database = serviceLocator.get<DatabaseService>();

  final UserAuthProvider userAuthProvider = UserAuthProvider();

  ///[User logged in]
  Future<dynamic> initialzeUserSession(
      {required String userPhoneNumber}) async {
    try {
      final response = await userAuthProvider.initSession(
          phoneNumber: "380" + userPhoneNumber);

      InitSessionModel initSessionInstance =
          InitSessionModel.fromJson(response);

      database.saveToDisk(DatabaseKeys.sessionToken, initSessionInstance.token);

      return initSessionInstance;
    } catch (e) {
      return Future.error(e);
    }
  }

  /// For [Verify Otp]
  Future<dynamic> verifyOTP({required String otp}) async {
    try {
      final response = await userAuthProvider.sessionConfigration(code: otp);

      SessionConfigrationResponse sessionConfigration =
          SessionConfigrationResponse.fromJson(response);

      log(sessionConfigration.token);
      database.saveToDisk(DatabaseKeys.sessionToken, sessionConfigration.token);

      return response;
    } catch (e) {
      return Future.error(ErrorMessages.wrongOtp);
    }
  }

  /// [Get available cities]

  Future<dynamic> getAvailableCities() async {
    try {
      final Response response = await userAuthProvider.getAvailableCities();

      List cities = response.data;

      log("getAvailableCities :: ${response.data}");

      List<AvailableCitiesModel> availableCities = [];
      cities.forEach((element) {
        availableCities.add(AvailableCitiesModel.fromJson(element));
      });

      return availableCities;
    } catch (e) {
      log(e.toString());
      return Future.error(e);
    }
  }

  Future<dynamic> getNews({required int page}) async {
    List<NewsModel> _listNews = [];
    try {
      final Response response = await userAuthProvider.getNews(page: page);

      List _decoded = response.data["clientNews"];

      for (var item in _decoded) {
        _listNews.add(NewsModel.fromJson(item));
      }
      return _listNews;
    } catch (e) {
      log(e.toString());
      return _listNews;
    }
  }

  Future<int> getNewsCount() async {
    try {
      final Response response = await userAuthProvider.getNewsCount();
      return response.data["total"] ?? 0;
    } catch (e) {
      log(e.toString());
      return 0;
    }
  }
}
