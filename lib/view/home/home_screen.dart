import 'package:booster_game/controller/home_controller/home_controller.dart';
import 'package:booster_game/view/game_mode/game_mode.dart';
import 'package:booster_game/view/home/circular.dart';
import 'package:booster_game/view/mode_setting/mode_setting.dart';
import 'package:booster_game/view/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the existing controller instance
    final HomeController controller = Get.find<HomeController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: // Gaming Mode Title
            const Row(
          children: [
            Text(
              'GAMING',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'MODE',
              style: TextStyle(
                color: Color(0xFF00FFB3),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Get.to(() => MenuScreen());
              },
              child: SvgPicture.asset('assets/icons/setting.svg'),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Performance Circles - Using reactive getters
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF1A1A1A,
                  ), // màu nền gần giống hình (xám đậm)

                  border: Border.all(
                    // ignore: deprecated_member_use
                    color: const Color(
                      0xFFFFFFFF,
                      // ignore: deprecated_member_use
                    ).withOpacity(0.05), // viền nhẹ
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(
                      () => _buildPerformanceCircle(
                        label: 'CPU',
                        percentage: controller.cpuUsage.round(),
                        color: const Color(0xFF00BFFF),
                      ),
                    ),
                    Obx(
                      () => _buildPerformanceCircle(
                        label: 'RAM',
                        percentage: controller.ramUsage.round(),
                        color: const Color(0xFFFFD700),
                      ),
                    ),
                    Obx(
                      () => _buildPerformanceCircle(
                        label: 'SPEED',
                        percentage: controller.speedScore.round(),
                        color: const Color(0xFF00FFB3),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Apply For All Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF1A1A1A,
                  ), // màu nền gần giống hình (xám đậm)

                  border: Border.all(
                    // ignore: deprecated_member_use
                    color: const Color(
                      0xFFFFFFFF,
                      // ignore: deprecated_member_use
                    ).withOpacity(0.05), // viền nhẹ
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Apply For All',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () async {
                            Get.to(() => ModeSettingScreen());
                          },
                          child: SvgPicture.asset('assets/icons/setting2.svg'),
                        ),
                      ],
                    ),
                    Obx(
                      () => Row(
                        children: [
                          GestureDetector(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    !controller.isGameModeEnabled
                                        ? Colors.grey[600]
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Disable',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => GameModeSelectionScreen());
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    controller.isGameModeEnabled
                                        ? const Color(0xFF00FFB3)
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Enable',
                                style: TextStyle(
                                  color:
                                      controller.isGameModeEnabled
                                          ? Colors.black
                                          : Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: Column(
                  children: [
                    Text(
                      'Game Booster',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(height: 20),
                    SvgPicture.asset(
                      'assets/svg/bosster.svg',
                      height: 120,
                      width: 120,
                    ),
                    SizedBox(height: 40),
                    Text(
                      'Press The Button ”🚀” To Start Speeding Up The Game',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceCircle({
    required String label,
    required int percentage,
    required Color color,
  }) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CustomPaint(
            painter: CircularProgressPainter(
              progress: percentage / 100,
              color: color,
            ),
            child: Center(
              child: Text(
                '$percentage%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
