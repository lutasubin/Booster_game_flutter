import 'package:booster_game/controller/splash_controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
      final controller = Get.find<SplashController>();
    return Scaffold(
      body: Container(
        // ignore: deprecated_member_use
        color: Colors.black.withOpacity(0.9),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/Artboard 1 1 (2).png',
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/svg/Rectangle 7.svg',
                fit: BoxFit.cover,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  // Logo
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/icon.svg'),
                        const SizedBox(height: 24),
                        SvgPicture.asset('assets/svg/Gaming Mode.svg'),
                        const SizedBox(height: 10),
                        SvgPicture.asset('assets/svg/GAME BOOTER FPS.svg'),
                      ],
                    ),
                  ),

                  // Animated progress
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: AnimatedBuilder(
                      animation: controller.progressController,
                      builder: (context, child) {
                        final progress = controller.progressAnimation.value;
                        final glow = controller.glowAnimation.value;

                        return Column(
                          children: [
                            Container(
                              height: 10,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFF00FFB3),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF00FFB3)
                                        .withOpacity(0.4),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                      color: Colors.black.withOpacity(0.2)),
                                  FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: progress,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF00FFB3),
                                            Color(0xFF00E5A0),
                                            Color(0xFF00FFB3),
                                          ],
                                          stops: [0.0, 0.5, 1.0],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF00FFB3)
                                                .withOpacity(glow * 0.8),
                                            blurRadius: 10,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (progress > 0)
                                    FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: progress,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.transparent,
                                              Colors.white.withOpacity(0.5),
                                              Colors.transparent,
                                            ],
                                            stops: const [0.0, 0.5, 1.0],
                                            transform: GradientRotation(
                                              controller.progressController
                                                      .value *
                                                  6.28,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${(progress * 100).toInt()}%',
                              style: const TextStyle(
                                color: Color(0xFF00FFB3),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),
                  SvgPicture.asset(
                    'assets/svg/This action may contain ads.svg',
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
