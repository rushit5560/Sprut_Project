import 'package:get/get.dart';
import 'package:sprut/presentation/pages/order_screen/controllers/order_controller.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrderController());
  }
}
