import 'package:booster_game/controller/banner_controller/banner_controller.dart';
import 'package:booster_game/controller/home_controller/home_controller.dart';
import 'package:booster_game/helper/dilogs/my_dilogs.dart';
import 'package:booster_game/helper/gg_ads/ads_setup.dart';
import 'package:booster_game/view/custom_ads/native_ads.dart';
import 'package:booster_game/view/game_mode/game_mode.dart';
import 'package:booster_game/view/home/circular.dart';
import 'package:booster_game/view/mode_setting/mode_setting.dart';
import 'package:booster_game/view/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

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
    _baController.ba = AdHelper.loadBannerAd(baController: _baController);
    super.initState();
    _initializeAd();
  }

  void _initializeAd() {
    if (!_adInitialized) {
      _adInitialized = true;
    }
  }

  // Hàm xử lý khi bấm vào mode_booster
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

    return Scaffold(
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
            automaticallyImplyLeading: false,
            title: SvgPicture.asset(
              'assets/svg/gaming_mode.svg',
              height: 18,
              width: 149,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: () {
                    Get.to(() => MenuScreen());
                  },
                  child: SvgPicture.asset('assets/icons/setting.svg'),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        return _baController.baLoaded.isTrue && _baController.ba != null
            ? SafeArea(
              child: SizedBox(
                height: 120,
                child: AdWidget(ad: _baController.ba!),
              ),
            )
            : SafeArea(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                height: 60,
                decoration: BoxDecoration(
                  color: const Color(0xFF172032),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFFFFFFFF).withOpacity(0.05),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Ads loading...',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
            );
      }),
      backgroundColor: const Color(0xFF18181B),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/images/main.png', fit: BoxFit.cover),
          ),

          // Content chính
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Performance Circles
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFFFFFFF).withOpacity(0.05),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Obx(
                          () => GaugeCircle(
                            label: 'CPU',
                            percentage: controller.cpuUsage.round(),
                            color: const Color(0xFF00BFFF),
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
                  ),

                  const SizedBox(height: 20),

                  // Apply For All Section
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFFFFFFF).withOpacity(0.05),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            _handleModeBoosterTap(controller);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
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
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Obx(
                                  () => SvgPicture.asset(
                                    'assets/icons/setting2.svg',
                                    // ignore: deprecated_member_use
                                    color:
                                        controller.isGameModeEnabled
                                            ? const Color(0xFF00FFB3)
                                            : Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Obx(
                          () => Padding(
                            padding: const EdgeInsets.all(5),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    await controller.toggleGameMode(false);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          !controller.isGameModeEnabled
                                              ? Colors.grey[600]
                                              : Colors.transparent,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: Colors.grey[600]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      'disable'.tr,
                                      style: TextStyle(
                                        fontFamily: 'Play',
                                        color:
                                            !controller.isGameModeEnabled
                                                ? Colors.white
                                                : Colors.grey[400],
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () async {
                                    await controller.toggleGameMode(true);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          controller.isGameModeEnabled
                                              ? const Color(0xFF00FFB3)
                                              : Colors.transparent,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color:
                                            controller.isGameModeEnabled
                                                ? const Color(0xFF00FFB3)
                                                : Colors.grey[600]!,
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      'enable'.tr,
                                      style: TextStyle(
                                        color:
                                            controller.isGameModeEnabled
                                                ? Colors.black
                                                : Colors.grey[400],
                                        fontSize: 14,
                                        fontFamily: 'Play',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Nội dung chính có scroll tránh overflow
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          NativeAdWithLoadingWidget(),
                          const SizedBox(height: 10),
                          const Text(
                            'Game Booster',
                            style: TextStyle(
                              fontFamily: 'Play',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                            ),
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              Get.to(() => GameModeSelectionScreen());
                            },
                            child: SvgPicture.asset(
                              'assets/svg/bosster.svg',
                              height: 120,
                              width: 120,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'click_button'.tr,
                            style: const TextStyle(
                              fontFamily: 'Play',
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
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
