import 'package:booster_game/helper/gg_ads/ads_setup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomHeaderLang extends StatelessWidget {
  const CustomHeaderLang({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'language_setting'.tr, // lấy từ file dịch
            style: const TextStyle(
              fontFamily: 'Play',
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),

          IconButton(
            onPressed: () {
              AdHelper.showInterstitialAd(
                onComplete: () {
                  Get.back();
                },
              );
            },
            icon: Icon(Icons.check, size: 24, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
