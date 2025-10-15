import 'package:booster_game/controller/mode_game/mode_controller.dart';
import 'package:booster_game/model/features.dart';
import 'package:booster_game/view/custom_ads/native_ads.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GameModeSelectionScreen extends StatelessWidget {
  const GameModeSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GameModeController());

    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: NativeAdWithLoadingWidget(adType: 'medium'),
      ),
      backgroundColor: const Color(0xFF18181B),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/icons/new_main.png', fit: BoxFit.cover),
          ),

          // Content
          Center(
            child: Obx(() {
              return controller.isBoostingComplete.value
                  ? _buildModeCard(
                    title: 'ready'.tr,
                    image: Image.asset(
                      'assets/images/success.png',
                      height: 92,
                      width: 166,
                      errorBuilder:
                          (_, __, ___) => const Icon(
                            Icons.check_circle,
                            color: Color(0xFF00FFB3),
                            size: 92,
                          ),
                    ),
                    features: controller.features,
                    completedFeatures: controller.completedFeatures.value,
                    borderColor: const Color(0xFF00FFB3),
                    showPlayButton: true,
                    controller: controller,
                  )
                  : _buildModeCard(
                    title: 'accelerating'.tr,
                    image: Lottie.asset(
                      'assets/icons/AI Robot.json',
                      height: 100,
                      errorBuilder:
                          (_, __, ___) => const Icon(
                            Icons.cleaning_services,
                            color: Color(0xFF00BFFF),
                            size: 100,
                          ),
                    ),
                    features: controller.features,
                    completedFeatures: controller.completedFeatures.value,
                    borderColor: const Color(0xFF00BFFF),
                    controller: controller,
                  );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildModeCard({
    required String title,
    required Widget image,
    required List<FeatureItem> features,
    required int completedFeatures,
    required Color borderColor,
    bool showPlayButton = false,
    required GameModeController controller,
  }) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
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

          if (showPlayButton) ...[
            Text(
              'Everything is ready to launch the game application.',
              style: TextStyle(fontFamily: 'Play', color: Color(0xFF00FFFF)),
            ),
          ],
          const SizedBox(height: 40),

          // Enhanced feature list sử dụng tất cả data từ controller
          ...features.asMap().entries.map((entry) {
            int index = entry.key;
            FeatureItem feature = entry.value;
            Widget icon;

            if (index < completedFeatures) {
              icon = SvgPicture.asset(
                'assets/icons/icon_chon.svg',
                width: 20,
                height: 20,
                errorBuilder:
                    (_, __, ___) => const Icon(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(feature.text, style: feature.style)],
                    ),
                  ),
                ],
              ),
            );
          }),

          const Spacer(),

          // Enhanced button với đầy đủ chức năng
          if (showPlayButton) ...[
            SafeArea(
              child: SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFF00FFFF),
                        width: 1.5,
                      ),
                      color: Colors.transparent,
                    ),
                    child: Center(
                      child: Text(
                        "Success",
                        style: const TextStyle(
                          fontFamily: 'Play',
                          fontSize: 18,
                          color: Color(0xFF00FFFF),
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
