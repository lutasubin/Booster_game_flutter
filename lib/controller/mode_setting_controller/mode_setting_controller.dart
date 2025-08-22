import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:permission_handler/permission_handler.dart';

class ModeSettingController extends GetxController {
  // Brightness
  RxBool brightnessEnabled = true.obs;
  RxDouble brightnessLevel = 75.0.obs;
  
  // Audio
  RxBool ringtoneEnabled = true.obs;
  RxDouble ringtoneVolume = 75.0.obs;
  
  RxBool mediaEnabled = true.obs;
  RxDouble mediaVolume = 75.0.obs;
  
  // Call
  RxBool autoRejectCall = false.obs;
  RxBool notificationBlock = false.obs;
  
  // FPS Options
  RxInt selectedFps = 60.obs;
  
  // Store original values for restore
  double _originalBrightness = 0.75;
  
  @override
  void onInit() {
    super.onInit();
    _requestPermissions();
    _loadCurrentSettings();
    _listenToVolumeChanges();
  }
  
  // Request permissions with better error handling
  Future<void> _requestPermissions() async {
    try {
      // Request permission for system settings
      await Permission.systemAlertWindow.request();
      await Permission.phone.request();
      await Permission.notification.request();
      
      print("Permissions requested successfully");
    } catch (e) {
      print('Error requesting permissions: $e');
    }
  }
  
  // Load current device settings with better error handling
  Future<void> _loadCurrentSettings() async {
    try {
      // Get current screen brightness
      double currentBrightness = await ScreenBrightness().current;
      _originalBrightness = currentBrightness;
      brightnessLevel.value = currentBrightness * 100;
      
      // Get current volume - use await for better handling
      double? currentVolume = await FlutterVolumeController.getVolume();
      if (currentVolume != null) {
        mediaVolume.value = currentVolume * 100;
        ringtoneVolume.value = currentVolume * 100;
      }
      
      print("Current settings loaded: brightness=${brightnessLevel.value}%, volume=${mediaVolume.value}%");
      
    } catch (e) {
      print('Error loading current settings: $e');
      // Set default values if loading fails
      brightnessLevel.value = 75.0;
      mediaVolume.value = 75.0;
      ringtoneVolume.value = 75.0;
    }
  }
  
  // Listen to volume changes from hardware buttons
  void _listenToVolumeChanges() {
    try {
      FlutterVolumeController.addListener((volume) {
        if (mediaEnabled.value) {
          mediaVolume.value = volume * 100;
        }
        if (ringtoneEnabled.value) {
          ringtoneVolume.value = volume * 100;
        }
        print("Hardware volume changed: ${volume * 100}%");
      });
    } catch (e) {
      print('Error setting up volume listener: $e');
    }
  }
  
  // Update brightness on device
  Future<void> updateBrightness(double value) async {
    try {
      if (brightnessEnabled.value) {
        double brightness = value / 100; // Convert percentage to 0-1
        await ScreenBrightness().setScreenBrightness(brightness);
        brightnessLevel.value = value;
        print("Brightness updated to: ${value.toInt()}%");
      }
    } catch (e) {
      print('Error setting brightness: $e');
      // Show user-friendly error
      Get.snackbar(
        'Error',
        'Could not adjust brightness. Check permissions.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }
  
  // Update media volume on device
  Future<void> updateMediaVolume(double value) async {
    try {
      if (mediaEnabled.value) {
        double volume = value / 100; // Convert percentage to 0-1
        await FlutterVolumeController.setVolume(volume);
        mediaVolume.value = value;
        print("Media volume updated to: ${value.toInt()}%");
      }
    } catch (e) {
      print('Error setting media volume: $e');
      Get.snackbar(
        'Error',
        'Could not adjust media volume.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }
  
  // Update ringtone volume on device
  Future<void> updateRingtoneVolume(double value) async {
    try {
      if (ringtoneEnabled.value) {
        double volume = value / 100; // Convert percentage to 0-1
        await FlutterVolumeController.setVolume(volume);
        ringtoneVolume.value = value;
        print("Ringtone volume updated to: ${value.toInt()}%");
      }
    } catch (e) {
      print('Error setting ringtone volume: $e');
      Get.snackbar(
        'Error',
        'Could not adjust ringtone volume.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }
  
  // Toggle brightness enabled/disabled
  void toggleBrightness(bool enabled) {
    brightnessEnabled.value = enabled;
    if (!enabled) {
      // Restore to original brightness when disabled
      ScreenBrightness().setScreenBrightness(_originalBrightness);
      print("Brightness disabled, restored to original");
    } else {
      print("Brightness enabled");
    }
  }
  
  // Toggle ringtone enabled/disabled
  void toggleRingtone(bool enabled) {
    ringtoneEnabled.value = enabled;
    if (!enabled) {
      // Mute ringtone
      updateRingtoneVolume(0);
      print("Ringtone disabled");
    } else {
      // Restore to current slider value
      updateRingtoneVolume(ringtoneVolume.value);
      print("Ringtone enabled");
    }
  }
  
  // Toggle media enabled/disabled  
  void toggleMedia(bool enabled) {
    mediaEnabled.value = enabled;
    if (!enabled) {
      // Mute media
      updateMediaVolume(0);
      print("Media disabled");
    } else {
      // Restore to current slider value
      updateMediaVolume(mediaVolume.value);
      print("Media enabled");
    }
  }
  
  // Save function with better feedback
  Future<void> saveSettings() async {
    try {
      // Apply all current settings to device
      await updateBrightness(brightnessLevel.value);
      await updateMediaVolume(mediaVolume.value);
      await updateRingtoneVolume(ringtoneVolume.value);
      
      print("Settings saved and applied to device!");
      Get.snackbar(
        'Success',
        'Settings have been saved and applied!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFF00FFB3).withOpacity(0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );
    } catch (e) {
      print("Error saving settings: $e");
      Get.snackbar(
        'Error',
        'Could not save all settings. Check permissions.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }
  
  @override
  void onClose() {
    try {
      FlutterVolumeController.removeListener();
      print("Controller disposed successfully");
    } catch (e) {
      print("Error disposing controller: $e");
    }
    super.onClose();
  }
}