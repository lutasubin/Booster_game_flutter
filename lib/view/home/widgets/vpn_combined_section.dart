import 'package:booster_game/controller/vpn_controller/vpn_controller.dart';
import 'package:booster_game/view/vpn_sever/vpn_sever_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openvpn_flutter/openvpn_flutter.dart';

class VpnCombinedSection extends StatelessWidget {
  final VpnController controller;

  const VpnCombinedSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        border: Border.all(color: Colors.white.withOpacity(0.05)),
       
      ),
      child: Column(
        children: [
          // Header Row: VPN Gaming + Server Selection
          _buildHeaderRow(),

          const SizedBox(height: 10),

          // Status/Timer
          _buildStatusOrTimer(),

          const SizedBox(height: 10),

          // Action Button
          Center(child: _buildActionButton()),
        ],
      ),
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // VPN Gaming Text
        const Text(
          "VPN Gaming",
          style: TextStyle(
            fontFamily: "Play",
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Server Selection Button
        Obx(
          () => InkWell(
            onTap: () {
              Get.to(
                () => const VpnServerScreen(),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 300),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Flag
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: Image.asset(
                      controller.currentServer.value.flagPath,
                      width: 28,
                      height: 20,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 28,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Icon(
                            Icons.flag,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Country Name
                  Text(
                    controller.currentServer.value.name,
                    style: const TextStyle(
                      fontFamily: 'Play',
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Arrow Icon
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusOrTimer() {
    return Obx(() {
      final stage = controller.vpnStage.value;

      if (stage == VPNStage.connected) {
        return Text(
          controller.connectionTime.value,
          style: const TextStyle(
            fontFamily: "Play",
            color: Color(0xFF00FFFF),
            fontWeight: FontWeight.bold,
            fontSize: 28,
            letterSpacing: 2,
          ),
        );
      } else if (stage == VPNStage.connecting) {
        return Text(
          "Connecting...",
          style: TextStyle(
            fontFamily: "Play",
            color: Colors.yellow.shade400,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        );
      } else {
        return Text(
          "Disconnected",
          style: TextStyle(
            fontFamily: "Play",
            color: Colors.orange.shade400,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        );
      }
    });
  }

  Widget _buildActionButton() {
    return Obx(() {
      final isConnected = controller.isVpnConnected.value;
      final buttonColor = isConnected ? Color(0xFFFF8851) : Colors.transparent;
      final colorText = isConnected ? Color(0xFFFF8851) : Colors.black;
      final buttonText = isConnected ? 'DISCONNECT' : 'CONNECT';
      final colorButton = isConnected ? Colors.transparent : Color(0xFF00FFFF);
      return GestureDetector(
        onTap: () => controller.toggleVpn(),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          decoration: BoxDecoration(
            color: colorButton,
            border: Border.all(color: buttonColor, width: 2),
          ),

          child: Text(
            buttonText,
            style: TextStyle(
              fontFamily: 'Play',
              color: colorText,
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
        ),
      );
    });
  }
}
