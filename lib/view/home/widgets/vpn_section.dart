import 'package:booster_game/controller/vpn_controller/vpn_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VpnSection extends StatelessWidget {
  final VpnController controller;

  const VpnSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
          // ignore: deprecated_member_use
          color: const Color(0xFFFFFFFF).withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildStatusOrTimer(),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "VPN Gaming",
          style: TextStyle(
            fontFamily: "Play",
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildActionButton(),
      ],
    );
  }

  Widget _buildActionButton() {
    return Obx(
      () {
        final isConnected = controller.isVpnConnected.value;
        final buttonColor = isConnected 
            ? const Color(0xFFFF6B35) // Orange color for DISCONNECT
            : const Color(0xFF00FFB3); // Green color for CONNECT
        final buttonText = isConnected ? 'DISCONNECT' : 'CONNECT';
        
        return GestureDetector(
          onTap: () {
            if (isConnected) {
              controller.toggleVpn(false);
            } else {
              controller.toggleVpn(true);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: buttonColor,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              buttonText,
              style: TextStyle(
                fontFamily: 'Play',
                color: buttonColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusOrTimer() {
    return Obx(
      () {
        final isConnected = controller.isVpnConnected.value;
        
        if (isConnected) {
          // Show timer when connected
          return Center(
            child: Text(
              controller.connectionTime.value,
              style: const TextStyle(
                fontFamily: "Play",
                color: Color(0xFF00FFB3),
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 2,
              ),
            ),
          );
        } else {
          // Show disconnected status
          return Center(
            child: Text(
              "Disconnected",
              style: TextStyle(
                fontFamily: "Play",
                color: Colors.orange.shade400,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          );
        }
      },
    );
  }
}