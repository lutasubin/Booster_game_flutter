import 'package:booster_game/controller/home_controller/home_controller.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    

    // Khởi tạo HomeController
    Get.put<HomeController>(HomeController(), permanent: true);

   
  }
}