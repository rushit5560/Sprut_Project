import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sprut/data/models/news_model/news_model.dart';
import 'package:sprut/data/repositories/user_auth_repository/user_auth_repository.dart';

import '../../../../resources/configs/service_locator/service_locator.dart';
import '../../../../resources/services/database/database.dart';

class NewsController extends GetxController {
  DatabaseService databaseService = serviceLocator.get<DatabaseService>();

  UserAuthRepository userAuthRepository = UserAuthRepository();

  RxInt _page = 1.obs;
  int get page => _page.value;
  set page(value) => _page.value = value;

  RxBool _loading = false.obs;
  bool get loading => _loading.value;
  set loading(value) => _loading.value = value;

  List<NewsModel> news = [];

  String formattedDateTime(BuildContext context, String dateTimeVal) {
    if (dateTimeVal.isEmpty) return "";
    DateFormat dateTimeFormatter = DateFormat(
        "dd MMM yyyy, HH:mm", Localizations.localeOf(context).languageCode);
    return dateTimeFormatter.format(DateTime.parse(dateTimeVal).toLocal());
  }

  @override
  void onInit() async {
    super.onInit();
  }

  getNews() async {
    if (loading) {
      return;
    }

    loading = true;
    List<NewsModel> newsGet = await userAuthRepository.getNews(page: page);

    if (page == 1) {
      news = newsGet;
    } else {
      news.addAll(newsGet);
    }

    page += 1;

    loading = false;
    update();
  }

  Future<int> getNewsCount() async {
    int newsCount = await userAuthRepository.getNewsCount();

    return newsCount;
  }
}
