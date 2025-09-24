import 'dart:io';
// ignore: unnecessary_import
import 'dart:typed_data';
import 'package:booster_game/model/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

class GameModeController extends GetxController {
  static const MethodChannel _channel = MethodChannel('system_cleaner');

  var isBoostingComplete = false.obs;
  var completedFeatures = 0.obs;

  var cacheClearedMB = 0.obs;
  var tempFilesDeleted = 0.obs;
  var oldLogsRemoved = 0.obs;
  var appCacheSizeMB = 0.0.obs;

  final List<FeatureItem> features = [
    FeatureItem(
      'clean'.tr,
      const TextStyle(
        fontFamily: "Play",
        fontSize: 16,
        fontWeight: FontWeight.w600,
          color: Colors.white,
      ),
    ),
    FeatureItem(
      'speed'.tr,
      const TextStyle(
        fontFamily: "Play",
        fontSize: 16,
        fontWeight: FontWeight.w600,
         color: Colors.white,
      ),
    ),
    FeatureItem(
      'ultra'.tr,
      const TextStyle(
        fontFamily: "Play",
        fontSize: 16,
        fontWeight: FontWeight.w600,
         color: Colors.white,
      ),
    ),
  ];

  @override
  void onInit() {
    super.onInit();
    _startRealCleaning();
  }

  Future<void> _startRealCleaning() async {
    await _getInitialCacheSize();

    for (int i = 0; i < features.length; i++) {
      await Future.delayed(Duration(seconds: i + 1));
      await _executeRealCleaningTask(i);
      completedFeatures.value = i + 1;
    }

    await Future.delayed(const Duration(seconds: 1));
    isBoostingComplete.value = true;
  }

  Future<void> _getInitialCacheSize() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final size = await _calculateDirectorySize(cacheDir);
      appCacheSizeMB.value = size / (1024 * 1024);
    } catch (e) {
      print('Error getting cache size: $e');
    }
  }

  Future<double> _calculateDirectorySize(Directory directory) async {
    double size = 0;
    try {
      await for (FileSystemEntity entity in directory.list(
        recursive: true,
        followLinks: false,
      )) {
        if (entity is File) {
          try {
            size += await entity.length();
          } catch (_) {}
        }
      }
    } catch (_) {}
    return size;
  }

  Future<void> _executeRealCleaningTask(int taskIndex) async {
    switch (taskIndex) {
      case 0:
        await _clearApplicationCache();
        break;
      case 1:
        await _cleanTemporaryFiles();
        break;
      case 2:
        await _ultraBooster();
        break;
    }
  }

  Future<void> _clearApplicationCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      int deletedSize = 0;

      await for (FileSystemEntity entity in cacheDir.list(recursive: true)) {
        if (entity is File) {
          try {
            final fileSize = await entity.length();
            await entity.delete();
            deletedSize += fileSize;
          } catch (_) {}
        }
      }

      if (Platform.isAndroid) {
        try {
          await _channel.invokeMethod('clearAppCache');
        } catch (_) {}
      }

      cacheClearedMB.value = (deletedSize / (1024 * 1024)).round();
    } catch (_) {}
  }

  Future<void> _cleanTemporaryFiles() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final appSupportDir = await getApplicationSupportDirectory();
      int deletedCount = 0;

      for (Directory dir in [tempDir, appSupportDir]) {
        try {
          await for (FileSystemEntity entity in dir.list(recursive: true)) {
            if (entity is File) {
              final fileName = entity.path.toLowerCase();
              if (fileName.endsWith('.tmp') ||
                  fileName.endsWith('.log') ||
                  fileName.endsWith('.bak')) {
                try {
                  await entity.delete();
                  deletedCount++;
                } catch (_) {}
              }
            }
          }
        } catch (_) {}
      }

      if (Platform.isAndroid) {
        try {
          await _channel.invokeMethod('killBackgroundApps');
        } catch (_) {}
      }

      tempFilesDeleted.value = deletedCount;
    } catch (_) {}
  }

  Future<void> _ultraBooster() async {
    try {
      final appSupportDir = await getApplicationSupportDirectory();
      final now = DateTime.now();
      int deletedLogs = 0;

      try {
        await for (FileSystemEntity entity in appSupportDir.list(
          recursive: true,
        )) {
          if (entity is File && entity.path.toLowerCase().contains('.log')) {
            final stat = await entity.stat();
            if (now.difference(stat.modified).inDays > 7) {
              await entity.delete();
              deletedLogs++;
            }
          }
        }
      } catch (_) {}

      oldLogsRemoved.value = deletedLogs;

      // Fake GC
      List<Uint8List> memoryBlocks = [];
      for (int i = 0; i < 50; i++) {
        memoryBlocks.add(Uint8List(1024 * 1024));
      }
      memoryBlocks.clear();

      if (Platform.isAndroid) {
        try {
          await _channel.invokeMethod('forceGC');
        } catch (_) {}
      }
    } catch (_) {}
  }
}
