import 'package:booster_game/controller/mode_setting_controller/mode_setting_controller.dart';
import 'package:booster_game/controller/native_controller/native_controller.dart';
import 'package:booster_game/helper/gg_ads/ads_setup.dart';
import 'package:booster_game/view/custom_ads/native_ads.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModeSettingScreen extends StatefulWidget {
  const ModeSettingScreen({super.key});

  @override
  State<ModeSettingScreen> createState() => _ModeSettingScreenState();
}

class _ModeSettingScreenState extends State<ModeSettingScreen> {
  final _adController2 = NativeAdController();
  bool _adInitialized = false;

  @override
  void initState() {
    super.initState();
    // Chỉ tạo ad một lần khi initState
    _initializeAd();
  }

  void _initializeAd() {
    if (!_adInitialized) {
      _adController2.ad = AdHelper.loadNativeAd(adController: _adController2);
      _adInitialized = true;
    }
  }

  @override
  void dispose() {
    // Dispose ad khi widget bị destroy
    _adController2.ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ModeSettingController>();
    return Scaffold(
      backgroundColor: const Color(0xFF18181B),
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
              onPressed: () {
                AdHelper.showInterstitialAd(
                  onComplete: () {
                    Get.back();
                  },
                );
              },
            ),
            title: Text(
              'mode_setting'.tr,
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
      bottomNavigationBar: SafeArea(
        child: NativeAdWithLoadingWidget(adType: ''),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/images/main.png', fit: BoxFit.cover),
          ),

          // Content
          ListView(
            padding: EdgeInsets.all(16),
            children: [
              // Brightness Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFFFFFFF).withOpacity(0.05),
                  ),
                ),
                child: Column(
                  children: [
                    Obx(
                      () => SwitchListTile(
                        activeColor: Color(0xFFFFFFFF),
                        inactiveThumbColor: Color(0xFFFFFFFF),
                        inactiveTrackColor: Colors.transparent,
                        activeTrackColor: Color(0xFF00FFB3),
                        title: Text(
                          'bright'.tr,
                          style: TextStyle(
                            fontFamily: 'Play',
                            color: Colors.white,
                          ),
                        ),
                        value: controller.brightnessEnabled.value,
                        onChanged: (val) => controller.toggleBrightness(val),
                      ),
                    ),
                    Obx(
                      () => SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape:
                              controller.brightnessEnabled.value
                                  ? const RoundSliderThumbShape(
                                    enabledThumbRadius: 8,
                                  ) // Có chấm tròn
                                  : SliderComponentShape
                                      .noThumb, // Không có chấm tròn
                        ),
                        child: Slider(
                          activeColor: const Color(0xFF00FFB3),
                          inactiveColor: const Color(0xFF25252B),
                          value: controller.brightnessLevel.value,
                          thumbColor: Color(0xFFFFFFFF),
                          min: 0,
                          max: 100,
                          divisions: 100,
                          label: '${controller.brightnessLevel.value.round()}%',
                          onChanged:
                              controller.brightnessEnabled.value
                                  ? (val) => controller.updateBrightness(val)
                                  : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              // Ringtone Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFFFFFFF).withOpacity(0.05),
                  ),
                ),
                child: Column(
                  children: [
                    Obx(
                      () => SwitchListTile(
                        activeColor: Color(0xFFFFFFFF),
                        inactiveThumbColor: Color(0xFFFFFFFF),
                        inactiveTrackColor: Colors.transparent,
                        activeTrackColor: Color(0xFF00FFB3),
                        title: Text(
                          'ringtone'.tr,
                          style: TextStyle(
                            fontFamily: 'Play',
                            color: Colors.white,
                          ),
                        ),
                        value: controller.ringtoneEnabled.value,
                        onChanged: (val) => controller.toggleRingtone(val),
                      ),
                    ),
                    Obx(
                      () => SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape:
                              controller.ringtoneEnabled.value
                                  ? const RoundSliderThumbShape(
                                    enabledThumbRadius: 8,
                                  ) // Có chấm tròn
                                  : SliderComponentShape
                                      .noThumb, // Không có chấm tròn
                        ),
                        child: Slider(
                          activeColor: Color(0xFF00FFB3),
                          inactiveColor: const Color(0xFF25252B),
                          thumbColor: Color(0xFFFFFFFF),
                          value: controller.ringtoneVolume.value,
                          min: 0,
                          max: 100,
                          divisions: 100,
                          label: '${controller.ringtoneVolume.value.round()}%',
                          onChanged:
                              controller.ringtoneEnabled.value
                                  ? (val) =>
                                      controller.updateRingtoneVolume(val)
                                  : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              // Media Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFFFFFFF).withOpacity(0.05),
                  ),
                ),
                child: Column(
                  children: [
                    Obx(
                      () => SwitchListTile(
                        activeColor: Color(0xFFFFFFFF),
                        inactiveThumbColor: Color(0xFFFFFFFF),
                        inactiveTrackColor: Colors.transparent,
                        activeTrackColor: Color(0xFF00FFB3),
                        title: Text(
                          'media'.tr,
                          style: TextStyle(
                            fontFamily: 'Play',
                            color: Colors.white,
                          ),
                        ),
                        value: controller.mediaEnabled.value,
                        onChanged: (val) => controller.toggleMedia(val),
                      ),
                    ),
                    Obx(
                      () => SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape:
                              controller.mediaEnabled.value
                                  ? const RoundSliderThumbShape(
                                    enabledThumbRadius: 8,
                                  ) // Có chấm tròn
                                  : SliderComponentShape
                                      .noThumb, // Không có chấm tròn
                        ),
                        child: Slider(
                          activeColor: Color(0xFF00FFB3),
                          inactiveColor: const Color(0xFF25252B),
                          thumbColor: Color(0xFFFFFFFF),
                          value: controller.mediaVolume.value,
                          min: 0,
                          max: 100,
                          divisions: 100,
                          label: '${controller.mediaVolume.value.round()}%',
                          onChanged:
                              controller.mediaEnabled.value
                                  ? (val) => controller.updateMediaVolume(val)
                                  : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              // Auto Reject Call
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFFFFFFF).withOpacity(0.05),
                  ),
                ),
                child: Obx(
                  () => SwitchListTile(
                    activeColor: Color(0xFFFFFFFF),
                    inactiveThumbColor: Color(0xFFFFFFFF),
                    inactiveTrackColor: Colors.transparent,
                    activeTrackColor: Color(0xFF00FFB3),
                    title: Text(
                      'call'.tr,
                      style: TextStyle(fontFamily: 'Play', color: Colors.white),
                    ),
                    value: controller.autoRejectCall.value,
                    onChanged: (val) => controller.toggleAutoRejectCall(val),
                  ),
                ),
              ),
              SizedBox(height: 10),

              // Notification Block
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFFFFFFF).withOpacity(0.05),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Obx(
                  () => SwitchListTile(
                    activeColor: Color(0xFFFFFFFF),
                    inactiveThumbColor: Color(0xFFFFFFFF),
                    inactiveTrackColor: Colors.transparent,
                    activeTrackColor: Color(0xFF00FFB3),
                    title: Text(
                      'notification'.tr,
                      style: TextStyle(fontFamily: 'Play', color: Colors.white),
                    ),
                    value: controller.notificationBlock.value,
                    onChanged: (val) => controller.toggleNotification(val),
                  ),
                ),
              ),

              SizedBox(height: 10),

              // FPS Options
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFFFFFFF).withOpacity(0.05),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        'FPS',
                        style: TextStyle(
                          fontFamily: 'Play',
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Obx(
                      () => Column(
                        children: [
                          // First row: 60 FPS and 90 FPS
                          Row(
                            children: [
                              Expanded(child: _buildFpsOption(60, controller)),
                              SizedBox(width: 12),
                              Expanded(child: _buildFpsOption(90, controller)),
                            ],
                          ),
                          SizedBox(height: 12),
                          // Second row: 120 FPS and 144 FPS
                          Row(
                            children: [
                              Expanded(child: _buildFpsOption(120, controller)),
                              SizedBox(width: 12),
                              Expanded(
                                child: _buildFpsOption(
                                  144,
                                  controller,
                                ), // Changed from 150 to 144
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Add this helper method in your _ModeSettingScreenState class:
  Widget _buildFpsOption(int fps, ModeSettingController controller) {
    final isSelected = controller.selectedFps.value == fps;

    return GestureDetector(
      onTap: () {
        // Use the new updateFpsSelection method to save the state
        controller.updateFpsSelection(fps);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color:
                isSelected
                    ? const Color(0xFF00FFB3)
                    : Color(0xFFFFFFFF).withOpacity(0.05),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color:
                    isSelected ? const Color(0xFF00FFB3) : Colors.transparent,
                border: Border.all(color: const Color(0xFF00FFB3), width: 2),
                borderRadius: BorderRadius.circular(2),
              ),
              child:
                  isSelected
                      ? Icon(Icons.check, size: 12, color: Colors.black)
                      : null,
            ),
            SizedBox(width: 8),
            Text(
              '$fps Fps',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Play',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
