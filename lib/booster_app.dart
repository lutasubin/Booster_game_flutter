import 'package:booster_game/controller/app_binding.dart';
import 'package:booster_game/helper/lang/translation_service.dart';
import 'package:booster_game/view/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoosterApp extends StatelessWidget {
  const BoosterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBinding(),
      debugShowCheckedModeBanner: false,
      locale: TranslationService.getSavedLocale(),
      translations: TranslationService(),
      fallbackLocale: TranslationService.fallbackLocale,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.ltr, // luôn LTR
          child: child!,
        );
      },
      home: SplashScreen(),
    );
  }
}
