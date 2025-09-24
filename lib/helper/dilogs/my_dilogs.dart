import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyDialogs {
  static showProgress() {
    Get.dialog(Center(child: CircularProgressIndicator(strokeWidth: 2)));
  }

  static enable() {
    // Hiển thị thông báo khi bật
    Get.snackbar(
      'Game Mode',
      'Mode Booster has been activated!',
      backgroundColor: const Color(0xFF00FFB3),
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      titleText: Text(
        'Game Mode',
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Play', // Font custom
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      messageText: Text(
        'Mode Booster has been activated!',
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Play', // Font custom
        ),
      ),
    );
  }

  static disable() {
    // Hiển thị thông báo khi tắt
    Get.snackbar(
      'Game Mode',
      'Mode Booster has been turned off!',
      backgroundColor: Colors.grey[600],
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
      titleText: Text(
        'Game Mode',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Play', // Font custom
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      messageText: Text(
        'Mode Booster has been turned off!',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Play', // Font custom
        ),
      ),
    );
  }

  static wanning() {
    // Nếu chưa enable, hiển thị thông báo
    Get.snackbar(
      'Game Mode',
      'Please enable Game Booster before accessing Mode Booster!',
      backgroundColor: Colors.orange[600],
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.TOP,
      titleText: Text(
        'Game Mode',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Play', // Font custom
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      messageText: Text(
        'Please enable Game Booster before accessing Mode Booster!',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Play', // Font custom
        ),
      ),
    );
  }
}
