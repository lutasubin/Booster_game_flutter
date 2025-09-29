import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ModeSettingController extends GetxController {
  // Brightness
  RxBool brightnessEnabled = false.obs;
  RxDouble brightnessLevel = 75.0.obs;

  // Audio
  RxBool ringtoneEnabled = false.obs;
  RxDouble ringtoneVolume = 75.0.obs;

  RxBool mediaEnabled = false.obs;
  RxDouble mediaVolume = 75.0.obs;

  // Call
  RxBool autoRejectCall = false.obs;
  RxBool notificationBlock = false.obs;

  // FPS Options
  RxInt selectedFps = 60.obs;

  // Store original values for restore
  double _originalBrightness = 0.75;

  // SharedPreferences keys
  static const String _keyBrightnessEnabled = 'brightness_enabled';
  static const String _keyBrightnessLevel = 'brightness_level';
  static const String _keyRingtoneEnabled = 'ringtone_enabled';
  static const String _keyRingtoneVolume = 'ringtone_volume';
  static const String _keyMediaEnabled = 'media_enabled';
  static const String _keyMediaVolume = 'media_volume';
  static const String _keyAutoRejectCall = 'auto_reject_call';
  static const String _keyNotificationBlock = 'notification_block';
  static const String _keySelectedFps = 'selected_fps';

  @override
  void onInit() {
    super.onInit();
    _requestPermissions();
    _loadSavedSettings(); // Load saved settings first
    _loadCurrentSettings();
    _listenToVolumeChanges();
  }

  // Load saved settings from SharedPreferences
  Future<void> _loadSavedSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load brightness settings
      brightnessEnabled.value = prefs.getBool(_keyBrightnessEnabled) ?? false;
      brightnessLevel.value = prefs.getDouble(_keyBrightnessLevel) ?? 75.0;
      
      // Load audio settings
      ringtoneEnabled.value = prefs.getBool(_keyRingtoneEnabled) ?? false;
      ringtoneVolume.value = prefs.getDouble(_keyRingtoneVolume) ?? 75.0;
      
      mediaEnabled.value = prefs.getBool(_keyMediaEnabled) ?? false;
      mediaVolume.value = prefs.getDouble(_keyMediaVolume) ?? 75.0;
      
      // Load call settings
      autoRejectCall.value = prefs.getBool(_keyAutoRejectCall) ?? false;
      notificationBlock.value = prefs.getBool(_keyNotificationBlock) ?? false;
      
      // Load FPS setting
      selectedFps.value = prefs.getInt(_keySelectedFps) ?? 60;
      
      print("Saved settings loaded successfully");
    } catch (e) {
      print('Error loading saved settings: $e');
    }
  }

  // Save settings to SharedPreferences
  Future<void> _saveSettingsToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Save brightness settings
      await prefs.setBool(_keyBrightnessEnabled, brightnessEnabled.value);
      await prefs.setDouble(_keyBrightnessLevel, brightnessLevel.value);
      
      // Save audio settings
      await prefs.setBool(_keyRingtoneEnabled, ringtoneEnabled.value);
      await prefs.setDouble(_keyRingtoneVolume, ringtoneVolume.value);
      
      await prefs.setBool(_keyMediaEnabled, mediaEnabled.value);
      await prefs.setDouble(_keyMediaVolume, mediaVolume.value);
      
      // Save call settings
      await prefs.setBool(_keyAutoRejectCall, autoRejectCall.value);
      await prefs.setBool(_keyNotificationBlock, notificationBlock.value);
      
      // Save FPS setting
      await prefs.setInt(_keySelectedFps, selectedFps.value);
      
      print("Settings saved to storage successfully");
    } catch (e) {
      print('Error saving settings to storage: $e');
    }
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
      
      // Only update if not already loaded from saved settings
      if (!brightnessEnabled.value) {
        brightnessLevel.value = currentBrightness * 100;
      }

      // Get current volume - use await for better handling
      double? currentVolume = await FlutterVolumeController.getVolume();
      if (currentVolume != null) {
        // Only update if not already loaded from saved settings
        if (!mediaEnabled.value) {
          mediaVolume.value = currentVolume * 100;
        }
        if (!ringtoneEnabled.value) {
          ringtoneVolume.value = currentVolume * 100;
        }
      }

      print(
        "Current settings loaded: brightness=${brightnessLevel.value}%, volume=${mediaVolume.value}%",
      );
    } catch (e) {
      print('Error loading current settings: $e');
      // Set default values if loading fails
      if (!brightnessEnabled.value) brightnessLevel.value = 75.0;
      if (!mediaEnabled.value) mediaVolume.value = 75.0;
      if (!ringtoneEnabled.value) ringtoneVolume.value = 75.0;
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
        await _saveSettingsToStorage(); // Save after update
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
        await _saveSettingsToStorage(); // Save after update
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
        await _saveSettingsToStorage(); // Save after update
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
  Future<void> toggleBrightness(bool enabled) async {
    brightnessEnabled.value = enabled;
    if (!enabled) {
      // Restore to original brightness when disabled
      ScreenBrightness().setScreenBrightness(_originalBrightness);
      print("Brightness disabled, restored to original");
    } else {
      print("Brightness enabled");
    }
    await _saveSettingsToStorage(); // Save after toggle
  }

  // Toggle ringtone enabled/disabled
  Future<void> toggleRingtone(bool enabled) async {
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
    await _saveSettingsToStorage(); // Save after toggle
  }

  // Toggle media enabled/disabled
  Future<void> toggleMedia(bool enabled) async {
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
    await _saveSettingsToStorage(); // Save after toggle
  }

  // Save function with better feedback
  Future<void> saveSettings() async {
    try {
      // Apply all current settings to device
      await updateBrightness(brightnessLevel.value);
      await updateMediaVolume(mediaVolume.value);
      await updateRingtoneVolume(ringtoneVolume.value);
      
      // Save to storage
      await _saveSettingsToStorage();

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

  // Mở danh sách tất cả app trong cài đặt Notifications
  void openAllAppsNotificationSettings() {
    final intent = AndroidIntent(
      action: 'android.settings.NOTIFICATION_SETTINGS',
      flags: [Flag.FLAG_ACTIVITY_NEW_TASK],
    );
    intent.launch();
  }

  // Bật/tắt Auto Reject Call
  Future<void> toggleAutoRejectCall(bool value) async {
    autoRejectCall.value = value;
    await _saveSettingsToStorage(); // Save after toggle
    if (value) {
      openAllAppsNotificationSettings();
    }
  }

  // Bật/tắt Notification
  Future<void> toggleNotification(bool value) async {
    notificationBlock.value = value;
    await _saveSettingsToStorage(); // Save after toggle
    if (value) {
      openAllAppsNotificationSettings();
    }
  }

  // Update FPS selection
  Future<void> updateFpsSelection(int fps) async {
    selectedFps.value = fps;
    await _saveSettingsToStorage(); // Save after update
    print("FPS updated to: $fps");
  }

  // Clear all saved settings (useful for reset functionality)
  Future<void> clearSavedSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      print("All saved settings cleared");
    } catch (e) {
      print('Error clearing saved settings: $e');
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