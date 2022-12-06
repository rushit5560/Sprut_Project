import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:sprut/resources/services/database/database_keys.dart';

import '../../../../data/models/map_screen_models/_tariff_option_model/_tariff_option_model.dart';
import '../../../../data/repositories/tariff_screen_repostiory/tariff_screen_repository.dart';
import '../../../../resources/configs/service_locator/service_locator.dart';
import '../../../../resources/services/database/database.dart';
import '../../home_screen/controllers/home_controller.dart';

class SettingsController extends GetxController {
  DatabaseService databaseService = serviceLocator.get<DatabaseService>();

  TariffScreenRepository tariffScreenRepository = TariffScreenRepository();

  List<TariffOption> tariffs = [];

  int selectedIndex = 0;

  List<int> preOrders = [10, 15, 20, 35];

  RxBool _improveMaps = false.obs;
  bool get improveMaps => _improveMaps.value;
  set improveMaps(value) => _improveMaps.value = value;

  RxBool _improveSprut = false.obs;
  bool get improveSprut => _improveSprut.value;
  set improveSprut(value) => _improveSprut.value = value;

  RxInt _preOrderTime = 0.obs;
  int get preOrderTime => _preOrderTime.value;
  set preOrderTime(value) => _preOrderTime.value = value;

  Future<void> updateFirebaseCrashlytics() async {
    if (improveSprut) {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
    } else {
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    }

    databaseService.saveToDisk(DatabaseKeys.crashlytics, improveSprut);
  }

  @override
  void onInit() async {
    super.onInit();

    getTariffOptions();

    int? preorder = databaseService.getFromDisk(DatabaseKeys.preorderTime);
    if (preorder != null) {
      preOrderTime = preorder;

      update();
    }

    bool? checkCrashlytics =
        databaseService.getFromDisk(DatabaseKeys.crashlytics);
    if (checkCrashlytics != null) {
      improveSprut = checkCrashlytics;

      update();
    }
  }

  getTariffOptions() async {
    tariffs = await tariffScreenRepository.fetchTariffsOptions(
        cityCode: Get.find<HomeViewController>().selectedCityCode);
    update();

    String? defaultFare = databaseService.getFromDisk(DatabaseKeys.defaultFare);
    if (defaultFare != null && defaultFare != "") {
      selectedIndex =
          tariffs.indexWhere((element) => element.optionId == defaultFare);
      if (selectedIndex == -1) {
        selectedIndex = 0;
      }

      update();
    }

    print(tariffs);
  }

  var iconsArray = [
    "cargo",
    "comfort",
    "drive",
    "economy",
    "Group (map-car)",
    "promo",
    "standart",
    "van",
    "wagon",
  ];
  String getIconExist(iconName) {
    print('hereicon ${iconsArray.indexOf(iconName)}');
    return iconsArray.indexOf(iconName) == -1
        ? 'assets/tariffs/standart.png'
        : 'assets/tariffs/$iconName.png';
  }

  void saveDefaultFare() {
    databaseService.saveToDisk(
        DatabaseKeys.defaultFare, tariffs[selectedIndex].optionId);
  }

  void savePreorder() {
    databaseService.saveToDisk(DatabaseKeys.preorderTime, preOrderTime);
  }
}
