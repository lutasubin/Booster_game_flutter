import 'package:booster_game/controller/home_controller/home_controller.dart';
import 'package:booster_game/controller/mode_setting_controller/mode_setting_controller.dart';
import 'package:booster_game/controller/splash_controller/splash_controller.dart';
import 'package:get/get.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Khởi tạo HomeController
    Get.put<HomeController>(HomeController(), permanent: true);

    // Khởi tạo ModeSettingController
    Get.put<ModeSettingController>(ModeSettingController(), permanent: true);

    // Khởi tạo SplashController (không cần permanent)
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
