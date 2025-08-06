import 'package:booster_game/controller/app_binding.dart';
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
      home: SplashScreen(),
    );
  }
}
