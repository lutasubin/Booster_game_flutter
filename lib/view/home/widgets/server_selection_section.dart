import 'package:booster_game/controller/vpn_controller/vpn_controller.dart';
import 'package:booster_game/view/vpn_sever/vpn_sever_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServerSelectionSection extends StatelessWidget {
  final VpnController controller;

  const ServerSelectionSection({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(
          // ignore: deprecated_member_use
          color: const Color(0xFFFFFFFF).withOpacity(0.05),
        ),
      ),
      child: InkWell(
        onTap: () {
          Get.to(
            () => const VpnServerScreen(),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 300),
          );
        },
        child: Obx(
          () => Row(
            children: [
              // Flag Image
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  controller.currentFlag.value,
                  width: 36,
                  height: 24,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback nếu không load được flag
                    return Container(
                      width: 36,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(
                        Icons.flag,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              
              // Server Name
              Expanded(
                child: Text(
                  controller.currentServer.value,
                  style: const TextStyle(
                    fontFamily: 'Play',
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              
              // Arrow Icon
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}