import 'package:booster_game/controller/vpn_controller/vpn_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VpnServerScreen extends StatelessWidget {
  const VpnServerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VpnController controller = Get.find<VpnController>();

    return Scaffold(
      backgroundColor: const Color(0xFF18181B),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/images/main.png', fit: BoxFit.cover),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(context),

                // Server List
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: controller.availableServers.length,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final server = controller.availableServers[index];
                      return _buildServerItem(
                        controller: controller,
                        serverName: server.name,
                        flagPath: server.flagPath,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Back Button
          InkWell(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF00FFB3),
                    size: 16,
                  ),
                  Icon(
                    Icons.arrow_back_ios,
                    color: Color(0xFF00FFB3),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Title
          const Text(
            'VPN SERVER',
            style: TextStyle(
              fontFamily: 'Play',
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServerItem({
    required VpnController controller,
    required String serverName,
    required String flagPath,
  }) {
    return Obx(() {
      final isSelected = controller.currentServer.value == serverName;

      return InkWell(
        onTap: () {
          controller.changeServer(serverName, flagPath);
          // Auto back to home after selection
          Future.delayed(const Duration(milliseconds: 300), () {
            Get.back();
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  isSelected
                      ? const Color(0xFF00FFB3)
                      // ignore: deprecated_member_use
                      : const Color(0xFFFFFFFF).withOpacity(0.1),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              // Flag
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  flagPath,
                  width: 40,
                  height: 28,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 40,
                      height: 28,
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.flag,
                        size: 16,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),

              // Server Name
              Expanded(
                child: Text(
                  serverName,
                  style: TextStyle(
                    fontFamily: 'Play',
                    color: isSelected ? Colors.white : Colors.grey[300],
                    fontSize: 16,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),

              // Checkbox
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        isSelected
                            ? const Color(0xFF00FFB3)
                            : Colors.grey[600]!,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                  color:
                      isSelected ? const Color(0xFF00FFB3) : Colors.transparent,
                ),
                child:
                    isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.black)
                        : null,
              ),
            ],
          ),
        ),
      );
    });
  }
}
