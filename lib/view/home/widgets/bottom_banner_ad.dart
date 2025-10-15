import 'package:booster_game/controller/banner_controller/banner_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BottomBannerAd extends StatelessWidget {
  final BannerAdController baController;

  const BottomBannerAd({
    super.key,
    required this.baController,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return baController.baLoaded.isTrue && baController.ba != null
          ? SafeArea(
              child: SizedBox(
                height: 120,
                child: AdWidget(ad: baController.ba!),
              ),
            )
          : SafeArea(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF172032),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    // ignore: deprecated_member_use
                    color: const Color(0xFFFFFFFF).withOpacity(0.05),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Ads loading...',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            );
    });
  }
}