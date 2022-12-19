import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sprut/data/models/tariff_screen_model/order_model.dart';

import '../../../../data/repositories/tariff_screen_repostiory/tariff_screen_repository.dart';
import '../../../../resources/configs/service_locator/service_locator.dart';
import '../../../../resources/services/database/database.dart';
import '../../home_screen/controllers/home_controller.dart';

class OrderHistoryController extends GetxController {
  DatabaseService databaseService = serviceLocator.get<DatabaseService>();

  TariffScreenRepository tariffScreenRepository = TariffScreenRepository();

  List<OrderModel> ordersHistory = [];

  RxBool _isLastOrder = false.obs;
  bool get lastOrder => _isLastOrder.value;
  set lastOrder(value) => _isLastOrder.value = value;

  RxInt _page = 1.obs;
  int get page => _page.value;
  set page(value) => _page.value = value;

  RxBool _loading = false.obs;
  bool get loading => _loading.value;
  set loading(value) => _loading.value = value;

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

  getOrderHistory() async {
    if (loading) {
      return;
    }

    loading = true;

    List<OrderModel> ordersHistoryGet =
        await tariffScreenRepository.getOrderHitory(
            cityCode: Get.find<HomeViewController>().selectedCityCode,
            page: page);

    if (page == 1) {
      ordersHistory = ordersHistoryGet;
    } else {
      ordersHistory.addAll(ordersHistoryGet);
    }
    page += 1;

    loading = false;

    update();
  }

  filterDecodedAddress(AddressModel item) {
    String name = '';
    isNotEmptyOrNull(item.street) ? name = '${item.street}' : '';
    isNotEmptyOrNull(item.houseNumber)
        ? name = name +
            (isNotEmptyOrNull(item.street) ? ', ' : '') +
            '${item.houseNumber}'
        : '';
    isNotEmptyOrNull(item.name)
        ? name = name + (!name.endsWith(', ') ? ', ' : '') + '${item.name}'
        : '';
    isNotEmptyOrNull(item.city)
        ? name = name + (!name.endsWith(', ') ? ', ' : '') + '${item.city}'
        : '';
    if (name.endsWith(', ')) {
      name = name.replaceRange(name.length - 2, name.length, '');
    }
    if (name.startsWith(', ')) {
      name = name.replaceRange(0, 2, '');
    }
    return name;
  }

  isNotEmptyOrNull(String? str) {
    if (str != null) {
      if (str.isNotEmpty) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
