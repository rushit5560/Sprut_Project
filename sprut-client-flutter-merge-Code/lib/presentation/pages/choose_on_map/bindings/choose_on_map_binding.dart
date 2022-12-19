import 'package:get/get.dart';
import 'package:sprut/presentation/pages/choose_on_map/controller/choose_on_map_controller.dart';
class ChooseOnMapBinding extends Bindings {
 
  
 @override
  void dependencies() {
    Get.lazyPut(() => ChooseOnMapController());
  }
   
}