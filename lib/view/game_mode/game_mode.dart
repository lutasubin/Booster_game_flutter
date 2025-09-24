import 'package:booster_game/controller/mode_game/mode_controller.dart';
import 'package:booster_game/model/features.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:booster_game/view/app_selection/app_selection.dart';

class GameModeSelectionScreen extends StatelessWidget {
  const GameModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GameModeController());

    return Scaffold(
      backgroundColor: const Color(0xFF18181B),
      body: Center(
        child: Obx(() {
          return controller.isBoostingComplete.value
              ? _buildModeCard(
                  title: 'ready'.tr,
                  image: Image.asset('assets/images/success.png',
                      height: 92,
                      width: 166,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.check_circle, color: Color(0xFF00FFB3), size: 92)),
                  features: controller.features,
                  completedFeatures: controller.completedFeatures.value,
                  borderColor: const Color(0xFF00FFB3),
                  showPlayButton: true,
                )
              : _buildModeCard(
                  title: 'accelerating'.tr,
                  image: Lottie.asset('assets/icons/AI Robot.json',
                      height: 100,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.cleaning_services, color: Color(0xFF00BFFF), size: 100)),
                  features: controller.features,
                  completedFeatures: controller.completedFeatures.value,
                  borderColor: const Color(0xFF00BFFF),
                );
        }),
      ),
    );
  }

  Widget _buildModeCard({
  required String title,
  required Widget image,
  required List<FeatureItem> features, // đổi từ String sang FeatureItem
  required int completedFeatures,
  required Color borderColor,
  bool showPlayButton = false,
}) {
  return Container(
    width: double.infinity,
    height: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: const Color(0xFF18181B),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        image,
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'Play',
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 40),

        ...features.asMap().entries.map((entry) {
          int index = entry.key;
          FeatureItem feature = entry.value;
          Widget icon;

          if (index < completedFeatures) {
            icon = SvgPicture.asset(
              'assets/icons/icon_chon.svg',
              width: 20,
              height: 20,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.check_circle,
                color: Color(0xFF00FFB3),
                size: 20,
              ),
            );
          } else if (index == completedFeatures && !showPlayButton) {
            icon = const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation(Color(0xFF00FFB3)),
              ),
            );
          } else {
            icon = const SizedBox(width: 20, height: 20);
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                icon,
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    feature.text,
                    style: feature.style, // dùng style riêng
                  ),
                ),
              ],
            ),
          );
        }),

        const Spacer(),
        if (showPlayButton)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Get.off(() =>  AppSelectionScreen()),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00FFB3),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
              ),
              child: Text(
                'play_game'.tr,
                style: const TextStyle(
                  fontFamily: 'Play',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        const SizedBox(height: 20),
      ],
    ),
  );
}

}
