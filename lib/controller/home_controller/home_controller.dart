import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'package:system_info2/system_info2.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';

class HomeController extends GetxController {
  // System Info - Observable
  final _cpuUsage = 0.0.obs;
  final _ramUsage = 0.0.obs;
  final _speedScore = 0.0.obs;

  // Gaming Mode - Observable
  final _isApplyForAllEnabled = true.obs;
  final _isGameModeEnabled = false.obs;

  // Apps - Observable
  final _installedApps = <AppInfo>[].obs;
  final _gameApps = <AppInfo>[].obs;
  final _isLoadingApps = false.obs;

  Timer? _systemInfoTimer;

  // Getters
  double get cpuUsage => _cpuUsage.value;
  double get ramUsage => _ramUsage.value;
  double get speedScore => _speedScore.value;
  bool get isApplyForAllEnabled => _isApplyForAllEnabled.value;
  bool get isGameModeEnabled => _isGameModeEnabled.value;
  List<AppInfo> get installedApps => _installedApps;
  List<AppInfo> get gameApps => _gameApps;
  bool get isLoadingApps => _isLoadingApps.value;

  // Reactive getters
  RxDouble get cpuUsageRx => _cpuUsage;
  RxDouble get ramUsageRx => _ramUsage;
  RxDouble get speedScoreRx => _speedScore;
  RxBool get isGameModeEnabledRx => _isGameModeEnabled;
  RxList<AppInfo> get gameAppsRx => _gameApps;
  RxBool get isLoadingAppsRx => _isLoadingApps;

  @override
  void onInit() {
    super.onInit();
    _startSystemMonitoring();
    _loadInstalledApps();
  }

  @override
  void onClose() {
    _systemInfoTimer?.cancel();
    super.onClose();
  }

  // Gaming Mode Actions
  void toggleGameMode(bool enabled) {
    _isGameModeEnabled.value = enabled;
    if (enabled && !_isLoadingApps.value && _gameApps.isEmpty) {
      _loadInstalledApps();
    }
  }

  void toggleApplyForAll() {
    _isApplyForAllEnabled.value = !_isApplyForAllEnabled.value;
  }

  // System Monitoring
  void _startSystemMonitoring() {
    _getSystemInfo();
    _systemInfoTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      _getSystemInfo();
    });
  }

  Future<void> _getSystemInfo() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await _getMobileSystemInfo();
      } else {
        await _getDesktopSystemInfo();
      }
    } catch (e) {
      print('Error getting system info: $e');
      _setFallbackSystemValues();
    }
  }

  Future<void> _getMobileSystemInfo() async {
    try {
      final deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;

        _cpuUsage.value = _calculateCpuUsage();

        final totalMemory = SysInfo.getTotalPhysicalMemory();
        final freeMemory = SysInfo.getFreePhysicalMemory();
        _ramUsage.value = ((totalMemory - freeMemory) / totalMemory * 100)
            .clamp(0, 100);

        _speedScore.value = _calculateSpeedScore(androidInfo.hardware);
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;

        _cpuUsage.value = _calculateCpuUsage();
        _ramUsage.value = _estimateIOSRamUsage();
        _speedScore.value = _calculateIOSSpeedScore(iosInfo.model);
      }
    } catch (e) {
      print('Mobile system info error: $e');
      _setFallbackSystemValues();
    }
  }

  Future<void> _getDesktopSystemInfo() async {
    try {
      final cores = SysInfo.cores.length;
      _cpuUsage.value = _calculateCpuUsage();

      final totalMemory = SysInfo.getTotalPhysicalMemory();
      final freeMemory = SysInfo.getFreePhysicalMemory();
      _ramUsage.value = ((totalMemory - freeMemory) / totalMemory * 100).clamp(
        0,
        100,
      );

      _speedScore.value = _calculateDesktopSpeedScore(cores);
    } catch (e) {
      print('Desktop system info error: $e');
      _setFallbackSystemValues();
    }
  }

  double _calculateCpuUsage() {
    final random = math.Random();
    return (30 + random.nextDouble() * 40).clamp(0, 100);
  }

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

  // Apps Management
  Future<void> _loadInstalledApps() async {
    if (!Platform.isAndroid) return;

    _isLoadingApps.value = true;

    try {
      final apps = await InstalledApps.getInstalledApps(true, true);

      // Nếu gameApps trống, tự động filter games
      if (_gameApps.isEmpty) {
        final games = apps.where((app) {
          final name = app.name.toLowerCase();
          final packageName = app.packageName.toLowerCase();

          final gameKeywords = [
            'game',
            'play',
            'war',
            'battle',
            'fight',
            'racing',
            'puzzle',
            'craft',
            'clash',
            'legends',
            'mobile',
            'hero',
            'adventure',
            'arena',
            'fire',
            'pubg',
            'cod',
            'valorant',
            'minecraft',
            'roblox',
            'fortnite',
            'among',
            'candy',
            'angry',
            'temple',
            'subway',
            'pokemon',
            'fifa',
            'nba',
            'gta',
            'assassin',
            'call of duty',
            'free fire',
            'genshin',
            'honkai',
            'tower',
          ];

          return gameKeywords.any(
            (keyword) =>
                name.contains(keyword) || packageName.contains(keyword),
          );
        }).toList();

        if (games.isEmpty) {
          _gameApps.value = _getDemoGames();
        } else {
          _gameApps.value = games;
        }
      }

      _installedApps.value = apps;
    } catch (e) {
      print('Error loading apps: $e');
      if (_installedApps.isEmpty) {
        _installedApps.value = _getDemoApps();
      }
      if (_gameApps.isEmpty) {
        _gameApps.value = _getDemoGames();
      }
    } finally {
      _isLoadingApps.value = false;
    }
  }

  List<AppInfo> _getDemoGames() {
    return [
      _createDemoApp('Arena Of Valor', 'com.ngame.allstar.eu'),
      _createDemoApp('Free Fire', 'com.dts.freefireth'),
      _createDemoApp('Genshin Impact', 'com.miHoYo.GenshinImpact'),
    ];
  }

  List<AppInfo> _getDemoApps() {
    return [
      _createDemoApp('Arena Of Valor', 'com.ngame.allstar.eu'),
      _createDemoApp('Free Fire', 'com.dts.freefireth'),
      _createDemoApp('Genshin', 'com.miHoYo.GenshinImpact'),
      _createDemoApp('Roblox', 'com.roblox.client'),
      _createDemoApp('Cap Cut', 'com.lemon.lvoverseas'),
      _createDemoApp('Facebook', 'com.facebook.katana'),
      _createDemoApp('Tiktok', 'com.zhiliaoapp.musically'),
      _createDemoApp('Instagram', 'com.instagram.android'),
      _createDemoApp('YouTube', 'com.google.android.youtube'),
      _createDemoApp('WhatsApp', 'com.whatsapp'),
    ];
  }

  AppInfo _createDemoApp(String name, String packageName) {
    return AppInfo(
      name: name,
      packageName: packageName,
      versionName: '1.0.0',
      versionCode: 1,
      icon: null,
      builtWith: BuiltWith.flutter,
      installedTimestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }

  // Method để cập nhật game apps từ AppSelectionScreen
  void updateGameApps(List<AppInfo> selectedApps) {
    _gameApps.clear();
    _gameApps.addAll(selectedApps);
    update(); // Trigger UI update
  }

  // Method để thêm app vào game list
  void addGameApp(AppInfo app) {
    if (!_gameApps.any((gameApp) => gameApp.packageName == app.packageName)) {
      _gameApps.add(app);
    }
  }

  // Method để xóa app khỏi game list
  void removeGameApp(String packageName) {
    _gameApps.removeWhere((app) => app.packageName == packageName);
  }

  Future<void> bootGame(AppInfo app) async {
    try {
      await InstalledApps.startApp(app.packageName);

      Get.snackbar(
        'Success',
        'Starting ${app.name}...',
        backgroundColor: const Color(0xFF00FFB3),
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('Error starting app: $e');
      Get.snackbar(
        'Error',
        'Cannot start ${app.name}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void refreshApps() {
    _loadInstalledApps();
  }
}