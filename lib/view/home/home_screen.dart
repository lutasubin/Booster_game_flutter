import 'package:booster_game/controller/banner_controller/banner_controller.dart';
import 'package:booster_game/controller/home_controller/home_controller.dart';
import 'package:booster_game/controller/vpn_controller/vpn_controller.dart';
import 'package:booster_game/helper/dilogs/my_dilogs.dart';
import 'package:booster_game/helper/gg_ads/ads_setup.dart';
import 'package:booster_game/view/custom_ads/native_ads.dart';
import 'package:booster_game/view/home/widgets/appbar_home.dart';
import 'package:booster_game/view/home/widgets/bottom_banner_ad.dart';
import 'package:booster_game/view/home/widgets/performance_section.dart';
import 'package:booster_game/view/home/widgets/mode_booster_section.dart';
import 'package:booster_game/view/home/widgets/vpn_combined_section.dart';
import 'package:booster_game/view/mode_setting/mode_setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _baController = BannerAdController();
  bool _adInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeAd();
  }

  void _initializeAd() {
    if (!_adInitialized) {
      _baController.ba = AdHelper.loadBannerAd(baController: _baController);
      _adInitialized = true;
    }
  }

  void _handleModeBoosterTap(HomeController controller) {
    if (controller.canAccessModeSettings()) {
      Get.to(() => ModeSettingScreen());
    } else {
      MyDialogs.wanning();
    }
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final VpnController vpnController = Get.find<VpnController>();

    return Scaffold(
      bottomNavigationBar: BottomBannerAd(baController: _baController),
      backgroundColor: const Color(0xFF18181B),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/icons/new_main.png', fit: BoxFit.cover),
          ),
          // Content chính
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomHeader(),
                    // Performance Circles
                    PerformanceSection(controller: controller),

                    const SizedBox(height: 20),

                    // Mode Booster Section
                    ModeBoosterSection(
                      controller: controller,
                      onTap: () => _handleModeBoosterTap(controller),
                    ),

                    const SizedBox(height: 10),

                    // Native Ads
                    NativeAdWithLoadingWidget(),

                    const SizedBox(height: 10),

                    // VPN Combined Section (VPN + Server in one block)
                    VpnCombinedSection(controller: vpnController),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}