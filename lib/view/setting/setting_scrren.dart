import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF02091A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF02091A),
        elevation: 0,
        leading: IconButton(
          icon: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_back_ios, color: Color(0xFF00FFB3), size: 16),
              Icon(Icons.arrow_back_ios, color: Color(0xFF00FFB3), size: 16),
            ],
          ),
          onPressed: () => Get.back(),
        ),

        title: const Text(
          'SETTING',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          children: [
            // Các mục menu cũ
            _buildMenuItem(
              context: context,
              icon: Icons.language,
              iconColor: Colors.purpleAccent,
              title: 'Language'.tr,
              onTap: () {},
            ),
            const SizedBox(height: 20),
            _buildMenuItem(
              context: context,
              icon: Icons.star,
              iconColor: Colors.yellow,
              title: 'Rate us'.tr,
              onTap: () {},
            ),
            const SizedBox(height: 20),
            _buildMenuItem(
              context: context,
              icon: Icons.share,
              iconColor: Colors.blueAccent,
              title: 'Share with friend'.tr,
              onTap: () async {
                final String appLink =
                    'https://play.google.com/store/apps/details?id=com.example.booster_game';
                final String message = 'Check out Our app: $appLink';
                await Share.share(message, subject: 'Share App');
              },
            ),
            const SizedBox(height: 20),
            _buildMenuItem(
              context: context,
              icon: Icons.privacy_tip,
              iconColor: const Color(0xFF03C343),
              title: 'Privacy Policy'.tr,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String title,
    String? trailingText,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: const Color(0xFF172032),
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFFFFFFF),
                ),
              ),
            ),
            if (trailingText != null)
              Text(
                trailingText,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}
