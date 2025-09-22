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
      backgroundColor: const Color(0xFF1A1A1A),

      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
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
          'MODE SETTING',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),

      bottomNavigationBar: NativeAdWithLoadingWidget(adType: ''),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Brightness Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
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
                    inactiveTrackColor: const Color(0xFF25252B),
                    activeTrackColor: Color(0xFF00FFB3),
                    title: Text(
                      'Brightness (Current Device)',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: controller.brightnessEnabled.value,
                    onChanged: (val) => controller.toggleBrightness(val),
                  ),
                ),
                Obx(
                  () => Slider(
                    activeColor: Color(0xFF00FFB3),
                    inactiveColor: const Color(0xFF25252B),
                    thumbColor: Color(0xFFFFFFFF),
                    value: controller.brightnessLevel.value,
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
              ],
            ),
          ),
          SizedBox(height: 10),

          // Ringtone Section
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
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
                    inactiveTrackColor: const Color(0xFF25252B),
                    activeTrackColor: Color(0xFF00FFB3),
                    title: Text(
                      'Ringtone (System Volume)',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: controller.ringtoneEnabled.value,
                    onChanged: (val) => controller.toggleRingtone(val),
                  ),
                ),
                Obx(
                  () => Slider(
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
                            ? (val) => controller.updateRingtoneVolume(val)
                            : null,
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
              color: const Color(0xFF1A1A1A),
              border: Border.all(
                // ignore: deprecated_member_use
                color: const Color(0xFFFFFFFF).withOpacity(0.05),
              ),
            ),
            child: Column(
              children: [
                Obx(
                  () => SwitchListTile(
                    activeColor: Color(0xFFFFFFFF),
                    inactiveThumbColor: Color(0xFFFFFFFF),
                    inactiveTrackColor: const Color(0xFF25252B),
                    activeTrackColor: Color(0xFF00FFB3),
                    title: Text(
                      'Media (System Volume)',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: controller.mediaEnabled.value,
                    onChanged: (val) => controller.toggleMedia(val),
                  ),
                ),
                Obx(
                  () => Slider(
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
              ],
            ),
          ),
          SizedBox(height: 10),

          // Auto Reject Call
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              border: Border.all(
                color: const Color(0xFFFFFFFF).withOpacity(0.05),
              ),
            ),
            child: Obx(
              () => SwitchListTile(
                activeColor: Color(0xFFFFFFFF),
                inactiveThumbColor: Color(0xFFFFFFFF),
                inactiveTrackColor: const Color(0xFF25252B),
                activeTrackColor: Color(0xFF00FFB3),
                title: Text(
                  'Auto Reject Call',
                  style: TextStyle(color: Colors.white),
                ),
                value: controller.autoRejectCall.value,
                onChanged: (val) => controller.autoRejectCall.value = val,
              ),
            ),
          ),
          SizedBox(height: 10),

          // Notification Block
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              border: Border.all(
                // ignore: deprecated_member_use
                color: const Color(0xFFFFFFFF).withOpacity(0.05),
              ),
            ),
            child: Obx(
              () => SwitchListTile(
                activeColor: Color(0xFFFFFFFF),
                inactiveThumbColor: Color(0xFFFFFFFF),
                inactiveTrackColor: const Color(0xFF25252B),
                activeTrackColor: Color(0xFF00FFB3),
                title: Text(
                  'Notification Block',
                  style: TextStyle(color: Colors.white),
                ),
                value: controller.notificationBlock.value,
                onChanged: (val) => controller.notificationBlock.value = val,
              ),
            ),
          ),

          SizedBox(height: 10),
          // FPS Options
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              border: Border.all(
                color: const Color(0xFFFFFFFF).withOpacity(0.05),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'FPS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Obx(
                  () => Row(
                    children:
                        [60, 90, 120, 150].map((fps) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: ChoiceChip(
                                label: Center(child: Text('$fps ')),
                                selected: controller.selectedFps.value == fps,
                                onSelected: (val) {
                                  if (val) controller.selectedFps.value = fps;
                                },
                                selectedColor: const Color(0xFF00FFB3),
                                labelStyle: TextStyle(
                                  color:
                                      controller.selectedFps.value == fps
                                          ? Colors.black
                                          : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                backgroundColor: const Color(0xFF25252B),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
