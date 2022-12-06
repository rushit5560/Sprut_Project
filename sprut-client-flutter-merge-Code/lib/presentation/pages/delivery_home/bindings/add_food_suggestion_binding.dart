import 'package:get/get.dart';
import 'package:sprut/presentation/pages/delivery_home/controller/address_food_suggestion_controller.dart';

class AddressFoodSuggestionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddressFoodSuggestionController());
  }
}
