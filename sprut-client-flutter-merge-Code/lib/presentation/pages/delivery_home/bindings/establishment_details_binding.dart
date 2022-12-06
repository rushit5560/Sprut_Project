import 'package:get/get.dart';
import 'package:sprut/presentation/pages/delivery_home/controller/establishment_details_controller.dart';

class EstablishmentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EstablishmentDetailsController());
  }
}
