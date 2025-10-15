import 'package:booster_game/controller/home_controller/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ModeBoosterSection extends StatelessWidget {
  final HomeController controller;
  final VoidCallback onTap;

  const ModeBoosterSection({
    super.key,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        border: Border.all(color: const Color(0xFFFFFFFF).withOpacity(0.05)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_buildModeBoosterTitle(), _buildToggleButtons()],
        ),
      ),
    );
  }

  Widget _buildModeBoosterTitle() {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Obx(
            () => Text(
              'mode_booster'.tr,
              style: TextStyle(
                fontFamily: 'Play',
                color:
                    controller.isGameModeEnabled
                        ? Colors.white
                        : Colors.grey[500],
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 5),
          Obx(
            () => SvgPicture.asset(
              'assets/icons/mode_setting.svg',
              // ignore: deprecated_member_use
              color:
                  controller.isGameModeEnabled
                      ? const Color(0xFF00FFFF)
                      : Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Obx(
      () => Row(
        children: [
          _buildToggleButton(
            label: 'OFF',
            isActive: !controller.isGameModeEnabled,
            onTap: () => controller.toggleGameMode(false),
          ),
          const SizedBox(width: 5),
          _buildToggleButton(
            label: 'ON',
            isActive: controller.isGameModeEnabled,
            onTap: () => controller.toggleGameMode(true),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    final activeColor =
        label == 'ON' ? const Color(0xFF00FFFF) : Color(0xFF00FFFF);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? activeColor : Colors.transparent,
          border: Border.all(color: activeColor, width: 1),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Play',
            color:
                isActive
                    ? (label == 'ON' ? Colors.black : Colors.black)
                    : Colors.grey[400],
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
