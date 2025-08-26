import 'package:booster_game/helper/gg_ads/ads_setup.dart';
import 'package:booster_game/view/onboard/onboarding_screen.dart';
import 'package:booster_game/view/welcome_game/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static const _animationDuration = Duration(seconds: 3);
  static const _delayAfterAnimation = Duration(milliseconds: 500);
  static const String _firstTimeKey = 'first_time_app';

  late AnimationController progressController;
  late Animation<double> progressAnimation;
  late Animation<double> glowAnimation;

  @override
  void onInit() {
    super.onInit();

    // Thoát fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);


    AdHelper.precacheInterstitialAd();
    AdHelper.precacheNativeAd();

    // Khởi tạo animation
    progressController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: progressController, curve: Curves.easeInOut),
    );

    glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: progressController, curve: Curves.easeInOut),
    );

    // Lắng nghe khi hoàn thành
    progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(_delayAfterAnimation, () {
          _checkFirstTimeAndNavigate();
        });
      }
    });

    // Bắt đầu animation
    progressController.forward();
  }

  // Kiểm tra lần đầu vào app và điều hướng
  Future<void> _checkFirstTimeAndNavigate() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool(_firstTimeKey) ?? true;

    if (isFirstTime) {
      // Lần đầu vào app - chuyển đến onboarding
      Get.off(() => const OnboardingScreen());
    } else {
      // Đã vào app trước đó - chuyển thẳng đến home
      Get.off(() => const WelcomeScreen());
    }
  }

  // Method để đánh dấu đã hoàn thành onboarding
  static Future<void> markOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_firstTimeKey, false);
  }

  @override
  void onClose() {
    progressController.dispose();
    super.onClose();
  }
}
