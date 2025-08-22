import 'package:booster_game/controller/mode_setting_controller/mode_setting_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ModeSettingScreen extends StatelessWidget {
  const ModeSettingScreen({super.key});

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
        actions: [
          TextButton(
            onPressed: () => controller.saveSettings(),
            child: const Text(
              'SAVE',
              style: TextStyle(
                color: Color(0xFF00FFB3),
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
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
                    onChanged: controller.brightnessEnabled.value
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
                    onChanged: controller.ringtoneEnabled.value
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
                      style: TextStyle(color: Colors.white)
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
                    onChanged: controller.mediaEnabled.value
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

          // FPS Options
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Text(
              'FPS',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Obx(
            () => Wrap(
              spacing: 10,
              children: [60, 90, 120, 144].map((fps) {
                return ChoiceChip(
                  label: Text('$fps Fps'),
                  selected: controller.selectedFps.value == fps,
                  onSelected: (val) {
                    if (val) controller.selectedFps.value = fps;
                  },
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}