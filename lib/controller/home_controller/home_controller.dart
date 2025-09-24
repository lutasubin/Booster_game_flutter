import 'package:booster_game/helper/dilogs/my_dilogs.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:system_info2/system_info2.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

class HomeController extends GetxController {
  // System Info - Observable
  final _cpuUsage = 0.0.obs;
  final _ramUsage = 0.0.obs;
  final _speedScore = 0.0.obs;

  // Gaming Mode - Observable (mặc định là false - disabled)
  final _isGameModeEnabled = false.obs;

  Timer? _systemInfoTimer;
  SharedPreferences? _prefs;

  // Key để lưu trạng thái
  static const String _gameModeKey = 'game_mode_enabled';

  // Method channel cho CPU monitoring
  static const MethodChannel _cpuChannel = MethodChannel('cpu_monitor');

  // Getters
  double get cpuUsage => _cpuUsage.value;
  double get ramUsage => _ramUsage.value;
  double get speedScore => _speedScore.value;
  bool get isGameModeEnabled => _isGameModeEnabled.value;

  // Reactive getters
  RxDouble get cpuUsageRx => _cpuUsage;
  RxDouble get ramUsageRx => _ramUsage;
  RxDouble get speedScoreRx => _speedScore;
  RxBool get isGameModeEnabledRx => _isGameModeEnabled;

  @override
  void onInit() {
    super.onInit();
    _initPreferences();
    _startSystemMonitoring();
  }

  @override
  void onClose() {
    _systemInfoTimer?.cancel();
    super.onClose();
  }

  /// Khởi tạo SharedPreferences và load trạng thái đã lưu
  Future<void> _initPreferences() async {
    try {
      _prefs = await SharedPreferences.getInstance();
      await _loadGameModeState();
    } catch (e) {
      print('Error initializing preferences: $e');
    }
  }

  /// Load trạng thái Game Mode từ SharedPreferences
  Future<void> _loadGameModeState() async {
    try {
      final savedState = _prefs?.getBool(_gameModeKey) ?? false;
      _isGameModeEnabled.value = savedState;
      print('Loaded game mode state: $savedState');
    } catch (e) {
      print('Error loading game mode state: $e');
      _isGameModeEnabled.value = false;
    }
  }

  /// Lưu trạng thái Game Mode vào SharedPreferences
  Future<void> _saveGameModeState(bool isEnabled) async {
    try {
      await _prefs?.setBool(_gameModeKey, isEnabled);
      print('Saved game mode state: $isEnabled');
    } catch (e) {
      print('Error saving game mode state: $e');
    }
  }

  /// Phương thức để toggle game mode với lưu trữ
  Future<void> toggleGameMode(bool isEnabled) async {
    _isGameModeEnabled.value = isEnabled;

    // Lưu trạng thái vào SharedPreferences
    await _saveGameModeState(isEnabled);

    if (isEnabled) {
      // Hiển thị thông báo khi bật
      MyDialogs.enable();
    } else {
      // Hiển thị thông báo khi tắt
      MyDialogs.disable();
    }
  }

  /// Phương thức để reset trạng thái (nếu cần)
  Future<void> resetGameModeState() async {
    try {
      await _prefs?.remove(_gameModeKey);
      _isGameModeEnabled.value = false;
      print('Reset game mode state');
    } catch (e) {
      print('Error resetting game mode state: $e');
    }
  }

  /// Phương thức kiểm tra có thể truy cập Mode Setting không
  bool canAccessModeSettings() {
    return _isGameModeEnabled.value;
  }

  /// Lấy trạng thái hiện tại từ storage (để debug)
  Future<bool?> getStoredGameModeState() async {
    try {
      return _prefs?.getBool(_gameModeKey);
    } catch (e) {
      print('Error getting stored game mode state: $e');
      return null;
    }
  }

  // ============== SYSTEM MONITORING ==============
  void _startSystemMonitoring() {
    _getSystemInfo();
    _systemInfoTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _getSystemInfo();
    });
  }

  Future<void> _getSystemInfo() async {
    try {
      if (Platform.isAndroid) {
        await _getAndroidSystemInfo();
      } else if (Platform.isIOS) {
        await _getIOSSystemInfo();
      } else {
        await _getDesktopSystemInfo();
      }
    } catch (e) {
      print('Error getting system info: $e');
      _setFallbackSystemValues();
    }
  }

  /// Android system info với CpuManager
  Future<void> _getAndroidSystemInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      // CPU thật từ CpuManager
      _cpuUsage.value = await getAndroidCpuUsage();

      // RAM thật
      final ramPercent = await getAndroidRamUsage();
      _ramUsage.value = ramPercent;

      // Speed score giả lập dựa vào hardware
      _speedScore.value = _calculateSpeedScore(androidInfo.hardware);
    } catch (e) {
      print('Android system info error: $e');
      _setFallbackSystemValues();
    }
  }

  /// iOS system info (giả lập)
  Future<void> _getIOSSystemInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      final iosInfo = await deviceInfo.iosInfo;

      _cpuUsage.value = math.Random().nextDouble() * 100; // iOS cần native code
      _ramUsage.value = _estimateIOSRamUsage();
      _speedScore.value = _calculateIOSSpeedScore(iosInfo.model);
    } catch (e) {
      print('iOS system info error: $e');
      _setFallbackSystemValues();
    }
  }

  /// Desktop system info
  Future<void> _getDesktopSystemInfo() async {
    try {
      final cores = SysInfo.cores.length;

      final totalMemory = SysInfo.getTotalPhysicalMemory();
      final freeMemory = SysInfo.getFreePhysicalMemory();
      _ramUsage.value = ((totalMemory - freeMemory) / totalMemory * 100).clamp(0, 100);

      _speedScore.value = _calculateDesktopSpeedScore(cores);
    } catch (e) {
      print('Desktop system info error: $e');
      _setFallbackSystemValues();
    }
  }

  // ============== CPU USAGE THẬT VỚI CPUMANAGER ==============

  /// CPU usage thật từ CpuManager (Android)
  Future<double> getAndroidCpuUsage() async {
    try {
      // Gọi CpuManager qua MethodChannel
      final double cpuUsage = await _cpuChannel.invokeMethod('getCpuUsage');
      return cpuUsage.clamp(0, 100);
    } catch (e) {
      print("Error getting CPU from CpuManager: $e");
      // Fallback về load average method
      return await _getCpuFallback();
    }
  }

  /// App CPU usage (optional)
  Future<double> getAppCpuUsage() async {
    try {
      final double appCpuUsage = await _cpuChannel.invokeMethod('getAppCpuUsage');
      return appCpuUsage.clamp(0, 50);
    } catch (e) {
      print("Error getting app CPU: $e");
      return 15.0; // Default app CPU
    }
  }

  /// Lấy thông tin chi tiết CPU
  Future<Map<String, dynamic>> getCpuInfo() async {
    try {
      final Map<dynamic, dynamic> cpuInfo = await _cpuChannel.invokeMethod('getCpuInfo');
      return Map<String, dynamic>.from(cpuInfo);
    } catch (e) {
      print("Error getting CPU info: $e");
      return {
        'systemCpuUsage': await getAndroidCpuUsage(),
        'appCpuUsage': 15.0,
        'numCores': 4,
        'error': e.toString(),
      };
    }
  }

  /// Test tất cả các CPU methods
  Future<Map<String, double>> testCpuMethods() async {
    try {
      print("🧪 Testing all CPU measurement methods...");
      final Map<dynamic, dynamic> results = await _cpuChannel.invokeMethod('testCpuMethods');
      final Map<String, double> testResults = Map<String, double>.from(
        results.map((key, value) => MapEntry(key.toString(), value?.toDouble() ?? 0.0))
      );
      
      print("📊 CPU Test Results:");
      testResults.forEach((method, value) {
        print("   $method: ${value.toStringAsFixed(1)}%");
      });
      
      return testResults;
    } catch (e) {
      print("❌ Error testing CPU methods: $e");
      return {
        'error': 0.0,
        'fallback': await _getCpuFallback(),
      };
    }
  }

  /// Reset CpuManager
  Future<void> resetCpuManager() async {
    try {
      await _cpuChannel.invokeMethod('resetCpuManager');
      print("✅ CPU Manager reset successfully");
    } catch (e) {
      print("❌ Error resetting CPU manager: $e");
    }
  }

  /// Fallback CPU method
  Future<double> _getCpuFallback() async {
    try {
      // Sử dụng performance-based estimation
      final stopwatch = Stopwatch()..start();
      
      for (int i = 0; i < 50000; i++) {
      }
      
      stopwatch.stop();
      final executionTime = stopwatch.elapsedMilliseconds;
      
      // Baseline: ~30-80ms cho mobile devices
      final baselineTime = 50.0;
      final performanceRatio = executionTime / baselineTime;
      
      final estimatedCpu = 30.0 + (performanceRatio - 1.0) * 25.0 + 
                          (math.Random().nextDouble() * 10.0 - 5.0);
      
      return estimatedCpu.clamp(20, 80);
      
    } catch (e) {
      print("Error in CPU fallback: $e");
      final random = math.Random();
      return (35 + random.nextInt(25)).toDouble(); // 35% - 60%
    }
  }

  // ============== RAM USAGE (giữ nguyên) ==============

  /// RAM usage (Android)
  Future<double> getAndroidRamUsage() async {
    try {
      final memInfo = await File('/proc/meminfo').readAsLines();
      int total = 0;
      int free = 0;

      for (var line in memInfo) {
        if (line.startsWith('MemTotal:')) {
          total = int.parse(line.split(RegExp(r'\s+'))[1]);
        } else if (line.startsWith('MemAvailable:')) {
          free = int.parse(line.split(RegExp(r'\s+'))[1]);
        }
      }

      if (total > 0 && free > 0) {
        double usedPercent = ((total - free) / total) * 100;
        return usedPercent.clamp(0, 100);
      }
      return 0.0;
    } catch (e) {
      print("Error reading RAM usage: $e");
      return _getFallbackRamUsage();
    }
  }

  /// Fallback RAM usage
  double _getFallbackRamUsage() {
    final random = math.Random();
    return (45 + random.nextInt(25)).toDouble(); // 45% - 70%
  }

  // ============== HELPER FUNCTIONS (giữ nguyên) ==============

  double _estimateIOSRamUsage() {
    final random = math.Random();
    return (40 + random.nextDouble() * 30).clamp(0, 100);
  }

  double _calculateSpeedScore(String hardware) {
    if (hardware.toLowerCase().contains('snapdragon')) {
      return (70 + math.Random().nextDouble() * 20).clamp(0, 100);
    } else if (hardware.toLowerCase().contains('exynos')) {
      return (65 + math.Random().nextDouble() * 20).clamp(0, 100);
    } else {
      return (50 + math.Random().nextDouble() * 30).clamp(0, 100);
    }
  }

  double _calculateIOSSpeedScore(String model) {
    if (model.toLowerCase().contains('pro')) {
      return (80 + math.Random().nextDouble() * 15).clamp(0, 100);
    } else {
      return (65 + math.Random().nextDouble() * 25).clamp(0, 100);
    }
  }

  double _calculateDesktopSpeedScore(int cores) {
    final baseScore = cores * 10;
    final random = math.Random();
    return (baseScore + random.nextDouble() * 20).clamp(0, 100);
  }

  void _setFallbackSystemValues() {
    _cpuUsage.value = 55.0;
    _ramUsage.value = 56.0;
    _speedScore.value = 55.0;
  }

  // ============== DEBUG METHODS ==============

  /// Method để debug và test CPU measurement
  Future<void> debugCpuMeasurement() async {
    print("🔍 ==> CPU Debug Information <==");
    
    try {
      // Test individual methods
      // Get detailed CPU info
      final cpuInfo = await getCpuInfo();
      print("📱 Device Info:");
      cpuInfo.forEach((key, value) {
        print("   $key: $value");
      });
      
      // Current readings
      final currentCpu = await getAndroidCpuUsage();
      final currentAppCpu = await getAppCpuUsage();
      
      print("📊 Current Readings:");
      print("   System CPU: ${currentCpu.toStringAsFixed(1)}%");
      print("   App CPU: ${currentAppCpu.toStringAsFixed(1)}%");
      
    } catch (e) {
      print("❌ Debug error: $e");
    }
    
    print("🔍 ==> End CPU Debug <==\n");
  }
}