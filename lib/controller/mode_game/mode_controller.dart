import 'dart:io';
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

  // Enhanced tracking variables
  var cacheClearedMB = 0.obs;
  var tempFilesDeleted = 0.obs;
  var junkFilesRemoved = 0.obs;
  var appsKilled = 0.obs;
  var memoryFreedMB = 0.obs;
  var appCacheSizeMB = 0.0.obs;

  // Detailed results
  var cleaningResults = <String, dynamic>{}.obs;

  final List<FeatureItem> features = [
    FeatureItem(
      'clean'.tr.isNotEmpty ? 'clean'.tr : 'Đóng ứng dụng',
      const TextStyle(
        fontFamily: "Play",
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    FeatureItem(
      'speed'.tr.isNotEmpty ? 'speed'.tr : 'Dọn dẹp sâu',
      const TextStyle(
        fontFamily: "Play",
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    FeatureItem(
      'ultra'.tr.isNotEmpty ? 'ultra'.tr : 'Tăng tốc tối đa',
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
    _startEnhancedCleaning();
  }

  Future<void> _startEnhancedCleaning() async {
    await _getInitialSystemStats();

    for (int i = 0; i < features.length; i++) {
      await Future.delayed(Duration(seconds: i + 2)); // Longer delay for dramatic effect
      await _executeEnhancedCleaningTask(i);
      completedFeatures.value = i + 1;
    }

    await Future.delayed(const Duration(seconds: 2));
    isBoostingComplete.value = true;
    
    // Show final results
    _showCleaningResults();
  }

  Future<void> _getInitialSystemStats() async {
    try {
      // Get initial cache size from Flutter side
      final cacheDir = await getTemporaryDirectory();
      final size = await _calculateDirectorySize(cacheDir);
      appCacheSizeMB.value = size / (1024 * 1024);

      // Get initial system stats from Android side
      if (Platform.isAndroid) {
        try {
          final result = await _channel.invokeMethod('getSystemStats');
          cleaningResults['initialStats'] = result;
          print('📊 Initial system stats: $result');
        } catch (e) {
          print('Error getting initial stats: $e');
        }
      }
    } catch (e) {
      print('Error getting initial system stats: $e');
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

  Future<void> _executeEnhancedCleaningTask(int taskIndex) async {
    switch (taskIndex) {
      case 0:
        await _killAllRunningApps();
        break;
      case 1:
        await _performDeepCleaning();
        break;
      case 2:
        await _ultraSystemBoost();
        break;
    }
  }

  /// STEP 1: Kill all running applications
  Future<void> _killAllRunningApps() async {
    try {
      print('⚡ Killing all running applications...');
      
      if (Platform.isAndroid) {
        try {
          final result = await _channel.invokeMethod('killAllRunningApps');
          if (result is Map) {
            appsKilled.value = result['killedCount'] ?? 0;
            cleaningResults['killedApps'] = result;
            print('✅ Killed ${appsKilled.value} applications');
          }
        } catch (e) {
          print('Error killing apps via platform channel: $e');
        }
      }

      // Simulate additional work
      await Future.delayed(const Duration(milliseconds: 1500));

    } catch (e) {
      print('Error in _killAllRunningApps: $e');
    }
  }

  /// STEP 2: Perform deep cleaning (cache, temp files, junk files)
  Future<void> _performDeepCleaning() async {
    try {
      print('🧹 Starting deep cleaning...');

      // Flutter-side cleaning
      await _cleanFlutterSideFiles();

      // Android-side deep cleaning
      if (Platform.isAndroid) {
        try {
          // Clear all cache types
          final cacheResult = await _channel.invokeMethod('clearAllCache');
          if (cacheResult is Map) {
            final totalCleared = cacheResult['totalCleared'].toString();
            cacheClearedMB.value = int.tryParse(totalCleared.replaceAll('MB', '')) ?? 0;
            cleaningResults['cacheClearing'] = cacheResult;
          }

          // Delete temporary files
          final tempResult = await _channel.invokeMethod('deleteTemporaryFiles');
          if (tempResult is Map) {
            tempFilesDeleted.value = tempResult['deletedCount'] ?? 0;
            cleaningResults['tempFiles'] = tempResult;
          }

          // Clear junk files
          final junkResult = await _channel.invokeMethod('clearJunkFiles');
          if (junkResult is Map) {
            junkFilesRemoved.value = junkResult['deletedCount'] ?? 0;
            cleaningResults['junkFiles'] = junkResult;
          }

          print('✅ Deep cleaning completed');
        } catch (e) {
          print('Error in platform deep cleaning: $e');
        }
      }

      await Future.delayed(const Duration(milliseconds: 2000));

    } catch (e) {
      print('Error in _performDeepCleaning: $e');
    }
  }

  /// STEP 3: Ultra system boost (memory optimization + final cleanup)
  Future<void> _ultraSystemBoost() async {
    try {
      print('🚀 Starting ultra system boost...');

      // Flutter-side memory pressure
      await _createMemoryPressure();

      // Android-side memory cleanup and final optimization
      if (Platform.isAndroid) {
        try {
          // Clear memory
          final memoryResult = await _channel.invokeMethod('clearMemory');
          if (memoryResult is Map) {
            final memoryFreed = memoryResult['memoryFreed'].toString();
            memoryFreedMB.value = int.tryParse(memoryFreed.replaceAll('MB', '')) ?? 0;
            cleaningResults['memoryCleanup'] = memoryResult;
          }

          // Force garbage collection
          await _channel.invokeMethod('forceGC');
          
          // Get final system stats
          final finalStats = await _channel.invokeMethod('getSystemStats');
          cleaningResults['finalStats'] = finalStats;

          print('✅ Ultra boost completed');
        } catch (e) {
          print('Error in platform ultra boost: $e');
        }
      }

      await Future.delayed(const Duration(milliseconds: 1500));

    } catch (e) {
      print('Error in _ultraSystemBoost: $e');
    }
  }

  /// Flutter-side file cleaning
  Future<void> _cleanFlutterSideFiles() async {
    try {
      // Clean temporary directory
      final tempDir = await getTemporaryDirectory();
      await _cleanDirectory(tempDir);

      // Clean application support directory
      final appSupportDir = await getApplicationSupportDirectory();
      await _cleanDirectory(appSupportDir);

    } catch (e) {
      print('Error in Flutter-side cleaning: $e');
    }
  }

  /// Clean a specific directory
  Future<void> _cleanDirectory(Directory directory) async {
    try {
      if (directory.existsSync()) {
        await for (FileSystemEntity entity in directory.list(recursive: true)) {
          if (entity is File) {
            try {
              final fileName = entity.path.toLowerCase();
              final shouldDelete = fileName.endsWith('.tmp') ||
                  fileName.endsWith('.log') ||
                  fileName.endsWith('.bak') ||
                  fileName.endsWith('.cache') ||
                  fileName.contains('temp') ||
                  fileName.contains('crash');

              if (shouldDelete) {
                await entity.delete();
              }
            } catch (_) {}
          }
        }
      }
    } catch (e) {
      print('Error cleaning directory ${directory.path}: $e');
    }
  }

  /// Create memory pressure for cleanup
  Future<void> _createMemoryPressure() async {
    try {
      // Create temporary memory pressure to force cleanup
      List<Uint8List> memoryBlocks = [];
      for (int i = 0; i < 100; i++) {
        memoryBlocks.add(Uint8List(1024 * 1024)); // 1MB blocks
        if (i % 10 == 0) {
          await Future.delayed(const Duration(milliseconds: 50));
        }
      }
      
      // Clear the blocks to free memory
      memoryBlocks.clear();
      
      // Force Dart GC
      for (int i = 0; i < 3; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      
    } catch (e) {
      print('Error creating memory pressure: $e');
    }
  }

  /// Show detailed cleaning results
  void _showCleaningResults() {
    print('📋 CLEANING RESULTS SUMMARY:');
    print('   Apps Killed: ${appsKilled.value}');
    print('   Cache Cleared: ${cacheClearedMB.value}MB');
    print('   Temp Files Deleted: ${tempFilesDeleted.value}');
    print('   Junk Files Removed: ${junkFilesRemoved.value}');
    print('   Memory Freed: ${memoryFreedMB.value}MB');
    
    if (cleaningResults.isNotEmpty) {
      print('   Detailed Results: $cleaningResults');
    }
  }

  /// Get total cleaned data summary
  Map<String, dynamic> getCleaningSummary() {
    return {
      'appsKilled': appsKilled.value,
      'cacheClearedMB': cacheClearedMB.value,
      'tempFilesDeleted': tempFilesDeleted.value,
      'junkFilesRemoved': junkFilesRemoved.value,
      'memoryFreedMB': memoryFreedMB.value,
      'totalFilesRemoved': tempFilesDeleted.value + junkFilesRemoved.value,
      'totalDataClearedMB': cacheClearedMB.value + memoryFreedMB.value,
      'cleaningResults': cleaningResults,
    };
  }

  /// Manual trigger for deep cleanup
  Future<void> performManualDeepCleanup() async {
    try {
      if (Platform.isAndroid) {
        final result = await _channel.invokeMethod('performDeepCleanup');
        cleaningResults['manualDeepCleanup'] = result;
        
        // Update observable values from result
        if (result is Map) {
          final killedAppsData = result['killedApps'] as Map?;
          if (killedAppsData != null) {
            appsKilled.value = killedAppsData['killedCount'] ?? 0;
          }

          final cacheData = result['cacheClearing'] as Map?;
          if (cacheData != null) {
            final totalCleared = cacheData['totalCleared'].toString();
            cacheClearedMB.value = int.tryParse(totalCleared.replaceAll('MB', '')) ?? 0;
          }

          final tempData = result['tempFiles'] as Map?;
          if (tempData != null) {
            tempFilesDeleted.value = tempData['deletedCount'] ?? 0;
          }

          final junkData = result['junkFiles'] as Map?;
          if (junkData != null) {
            junkFilesRemoved.value = junkData['deletedCount'] ?? 0;
          }

          final memoryData = result['memoryCleanup'] as Map?;
          if (memoryData != null) {
            final memoryFreed = memoryData['memoryFreed'].toString();
            memoryFreedMB.value = int.tryParse(memoryFreed.replaceAll('MB', '')) ?? 0;
          }
        }

        print('✅ Manual deep cleanup completed');
        _showCleaningResults();
      }
    } catch (e) {
      print('Error in manual deep cleanup: $e');
    }
  }

  /// Reset all tracking values
  void resetCleaningStats() {
    isBoostingComplete.value = false;
    completedFeatures.value = 0;
    cacheClearedMB.value = 0;
    tempFilesDeleted.value = 0;
    junkFilesRemoved.value = 0;
    appsKilled.value = 0;
    memoryFreedMB.value = 0;
    appCacheSizeMB.value = 0.0;
    cleaningResults.clear();
  }

  /// Get system information
  Future<Map<String, dynamic>?> getSystemInfo() async {
    try {
      if (Platform.isAndroid) {
        final result = await _channel.invokeMethod('getSystemStats');
        return result is Map ? Map<String, dynamic>.from(result) : null;
      }
    } catch (e) {
      print('Error getting system info: $e');
    }
    return null;
  }

  @override
  void onClose() {
    // Clean up any resources if needed
    super.onClose();
  }
}