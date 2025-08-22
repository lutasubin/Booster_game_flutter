import 'package:booster_game/view/onboard/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static const _animationDuration = Duration(seconds: 3);
  static const _delayAfterAnimation = Duration(milliseconds: 500);

  late AnimationController progressController;
  late Animation<double> progressAnimation;
  late Animation<double> glowAnimation;

  @override
  void onInit() {
    super.onInit();

    // Thoát fullscreen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

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
          Get.off(() => OnboardingScreen());
        });
      }
    });

    // Bắt đầu animation
    progressController.forward();
  }

  @override
  void onClose() {
    progressController.dispose();
    super.onClose();
  }
}
