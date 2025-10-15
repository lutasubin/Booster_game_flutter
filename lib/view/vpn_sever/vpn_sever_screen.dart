import 'package:booster_game/controller/vpn_controller/vpn_controller.dart';
import 'package:booster_game/model/vpn_sever.dart';
import 'package:booster_game/view/custom_ads/native_ads.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class VpnServerScreen extends StatelessWidget {
  const VpnServerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final VpnController controller = Get.find<VpnController>();

    return Scaffold(
      bottomNavigationBar: SafeArea(child: NativeAdWithLoadingWidget()),
      backgroundColor: const Color(0xFF18181B),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/icons/new_main.png', fit: BoxFit.cover),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    itemCount: controller.servers.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final server = controller.servers[index];
                      // Bọc từng item trong Obx để chỉ rebuild item được chọn
                      return Obx(() {
                        final isSelected =
                            server == controller.currentServer.value;
                        return _buildServerItem(
                          controller: controller,
                          server: server,
                          isSelected: isSelected,
                        );
                      });
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: SvgPicture.asset('assets/icons/back.svg'),
          ),
          const SizedBox(width: 30),
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
    required VpnServer server,
    required bool isSelected,
  }) {
    return InkWell(
      onTap: () {
        controller.selectServer(server);
        // Auto back to previous screen after selection
        Future.delayed(const Duration(milliseconds: 200), () => Get.back());
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected
                    ? const Color(0xFF00FFFF)
                    // ignore: deprecated_member_use
                    : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Flag Image
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.asset(
                server.flagPath,
                width: 40,
                height: 28,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) => Container(
                      width: 40,
                      height: 28,
                      color: Colors.grey[800],
                      child: const Icon(
                        Icons.flag,
                        size: 16,
                        color: Colors.grey,
                      ),
                    ),
              ),
            ),
            const SizedBox(width: 16),
            // Server Name
            Expanded(
              child: Text(
                server.name,
                style: TextStyle(
                  fontFamily: 'Play',
                  color: isSelected ? Colors.white : Colors.grey[300],
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
                      isSelected ? const Color(0xFF00FFFF) : Colors.grey[600]!,
                  width: 2,
                ),

                color:
                    isSelected ? const Color(0xFF00FFFF) : Colors.transparent,
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
  }
}
