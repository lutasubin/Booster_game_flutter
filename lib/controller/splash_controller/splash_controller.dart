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

    // Initialize ads FIRST, then load them
    _initializeAdsAndLoad();

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

  // Initialize ads and then load them
  Future<void> _initializeAdsAndLoad() async {
    try {
      // Then preload ads
      AdHelper.precacheInterstitialAd();
      AdHelper.precacheOpenAd();
      print('[SplashController] Ad precaching started');
    } catch (e) {
      print('[SplashController] Error initializing ads: $e');
    }
  }

  // Kiểm tra lần đầu vào app và điều hướng
  Future<void> _checkFirstTimeAndNavigate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isFirstTime = prefs.getBool(_firstTimeKey) ?? true;

      print('[SplashController] First time: $isFirstTime');

      if (isFirstTime) {
        // Lần đầu vào app - chuyển đến onboarding
        print('[SplashController] Navigating to Onboarding');
        Get.off(() => const OnboardingScreen());
      } else {
        // Đã vào app trước đó - hiển thị Open Ad rồi chuyển đến home
        print('[SplashController] Showing Open Ad before navigating to Welcome');
        _showOpenAdAndNavigate();
      }
    } catch (e) {
      print('[SplashController] Error in navigation: $e');
      // Fallback navigation
      Get.off(() => const OnboardingScreen());
    }
  }

  // Show Open Ad and navigate
  void _showOpenAdAndNavigate() {
    print('[SplashController] Attempting to show Open Ad');
    
    // Add timeout to prevent infinite waiting
    bool navigationComplete = false;
    
    // Timeout fallback
    Future.delayed(Duration(seconds: 5), () {
      if (!navigationComplete) {
        print('[SplashController] Open Ad timeout - navigating anyway');
        navigationComplete = true;
        Get.off(() => const WelcomeScreen());
      }
    });

    AdHelper.showOpenAd(
      onComplete: () {
        if (!navigationComplete) {
          print('[SplashController] Open Ad completed - navigating to Welcome');
          navigationComplete = true;
          Get.off(() => const WelcomeScreen());
        }
      },
    );
  }

  // Method để đánh dấu đã hoàn thành onboarding
  static Future<void> markOnboardingCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_firstTimeKey, false);
      print('[SplashController] Onboarding marked as completed');
    } catch (e) {
      print('[SplashController] Error marking onboarding complete: $e');
    }
  }

  @override
  void onClose() {
    progressController.dispose();
    super.onClose();
  }
}