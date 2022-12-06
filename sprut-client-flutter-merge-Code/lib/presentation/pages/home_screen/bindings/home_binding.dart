import 'package:get/get.dart';
import 'package:sprut/presentation/pages/home_screen/controllers/home_controller.dart';

class HomeBinding  extends Bindings {
 
  
 @override
  void dependencies() {
    Get.lazyPut(() => HomeViewController());
  }
   
}