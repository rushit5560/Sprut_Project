import 'package:get/get.dart';

import '../controllers/tariff_controller.dart';

class TariffBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TariffController());
  }
}
