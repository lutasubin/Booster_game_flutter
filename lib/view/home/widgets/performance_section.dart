import 'package:booster_game/controller/home_controller/home_controller.dart';
import 'package:booster_game/view/game_mode/game_mode.dart';
import 'package:booster_game/view/home/circular.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PerformanceSection extends StatelessWidget {
  final HomeController controller;

  const PerformanceSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        border: Border.all(color: const Color(0xFFFFFFFF).withOpacity(0.05)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          _buildBoosterButton(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Obx(
                () => GaugeCircle(
                  label: 'CPU',
                  percentage: controller.cpuUsage.round(),
                  color: const Color(0xFF00FFFF),
                ),
              ),
              Obx(
                () => GaugeCircle(
                  label: 'RAM',
                  percentage: controller.ramUsage.round(),
                  color: const Color(0xFFFFD700),
                ),
              ),
              Obx(
                () => GaugeCircle(
                  label: 'SPEED',
                  percentage: controller.speedScore.round(),
                  color: const Color(0xFF00FFB3),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBoosterButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Performance',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Play',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => GameModeSelectionScreen());
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF00FFFF), width: 1.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.rocket_launch, color: Color(0xFF00FFFF)),
                  SizedBox(width: 8),
                  Text(
                    "BOOSTER",
                    style: TextStyle(
                      fontFamily: "Play",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00FFFF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
