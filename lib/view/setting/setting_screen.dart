import 'package:booster_game/helper/anaylish_firebase/anaylish.dart';
import 'package:booster_game/view/custom_ads/native_ads.dart';
import 'package:booster_game/view/setting/lang/language.dart';
import 'package:booster_game/view/setting/rate_app/rating.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

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
      backgroundColor: const Color(0xFF18181B),
      bottomNavigationBar: SafeArea(
        child: NativeAdWithLoadingWidget(adType: ''),
      ),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/main.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Row(
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
              onPressed: () => Get.back(),
            ),
            title: Text(
              'setting'.tr,
              style: TextStyle(
                fontFamily: 'Play',
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/images/main.png', fit: BoxFit.cover),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 20.0,
            ),
            child: Column(
              children: [
                // Các mục menu cũ
                _buildMenuItem(
                  context: context,
                  icon: Icons.language,
                  iconColor: Colors.white,
                  title: 'language'.tr,
                  onTap: () {
                    AnalyticsHelper.logSettingChange(
                      'open_language_settings',
                      'clicked',
                    );
                    Get.off(() => LanguageSelectionScreen());
                  },
                ),
                // const SizedBox(height: 20),
                // _buildMenuItem(
                //   context: context,
                //   icon: Icons.star,
                //   iconColor: Colors.white,
                //   title: 'rate_app'.tr,
                //   onTap: () {
                //     AnalyticsHelper.logSettingChange('open_rating', 'clicked');
                //     showRatingBottomSheet(context);
                //   },
                // ),
                const SizedBox(height: 20),
                _buildMenuItem(
                  context: context,
                  icon: Icons.share,
                  iconColor: Colors.white,
                  title: 'share'.tr,
                  onTap: () async {
                    AnalyticsHelper.logSettingChange('share_app', 'clicked');
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
                  iconColor: Colors.white,
                  title: 'privacy'.tr,
                  onTap: () {
                    AnalyticsHelper.logSettingChange(
                      'open_privacy_policy',
                      'clicked',
                    );
                    _openPrivacyPolicy();
                  },
                ),
              ],
            ),
          ),
        ],
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
          border: Border.all(
            // ignore: deprecated_member_use
            color: const Color(0xFFFFFFFF).withOpacity(0.05),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Play',
                  fontSize: 18,
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

  Future<void> _openPrivacyPolicy() async {
  final Uri url = Uri.parse("https://sites.google.com/view/policegameboosterpro/trang-ch%E1%BB%A7");
  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception("Could not launch $url");
  }
}

void showRatingBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    backgroundColor: Colors.transparent,
    builder: (_) => const RatingBottomSheet(),
  );
}
}
