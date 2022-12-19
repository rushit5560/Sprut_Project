import 'package:get/get.dart';
import 'package:sprut/presentation/pages/delivery_home/controller/establishment_controller.dart';

class EstablishmentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EstablishmentController());
  }
}
