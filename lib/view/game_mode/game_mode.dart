import 'dart:io';
import 'dart:typed_data'; // Thêm import này
import 'package:booster_game/view/app_selection/app_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
// import 'package:get/get.dart'; // Uncomment nếu cần
import 'dart:async';

class GameModeSelectionScreen extends StatefulWidget {
  const GameModeSelectionScreen({super.key});

  @override
  State<GameModeSelectionScreen> createState() =>
      _GameModeSelectionScreenState(); // Sửa tên state cho đồng nhất
}

class _GameModeSelectionScreenState extends State<GameModeSelectionScreen>
    with TickerProviderStateMixin {
  
  // Platform channels for native code
  static const MethodChannel _channel = MethodChannel('system_cleaner');
  
  bool isBoostingComplete = false;
  int completedFeatures = 0; // số feature đã xong
  
  // Real cleaning stats
  int cacheClearedMB = 0;
  int tempFilesDeleted = 0;
  int oldLogsRemoved = 0;
  double appCacheSizeMB = 0;

  late AnimationController _rotationController;
  late AnimationController _opacityController;

  final List<String> features = [
    'Dọn dẹp bộ nhớ đệm và giải phóng ram',
    'Tăng tốc trò chơi lên tốc độ tối đa',
    'Ultra booster',
  ];

  @override
  void initState() {
    super.initState();

    // Xoay icon liên tục
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    // Bắt đầu quá trình dọn dẹp thực tế
    _startRealCleaning();
  }

  void _startRealCleaning() async {
    await _getInitialCacheSize();
    
    // chạy tiến trình từng feature với dọn dẹp thực tế
    for (int i = 0; i < features.length; i++) {
      await Future.delayed(Duration(seconds: (i + 1)));
      
      if (mounted) {
        await _executeRealCleaningTask(i);
        setState(() {
          completedFeatures = i + 1;
        });
        
        HapticFeedback.lightImpact();
      }
    }

    // Sau khi xong hết thì set trạng thái sẵn sàng
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => isBoostingComplete = true);
      _rotationController.stop();
      _opacityController.stop();
      HapticFeedback.mediumImpact();
    }
  }

  Future<void> _getInitialCacheSize() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      final size = await _calculateDirectorySize(cacheDir);
      setState(() {
        appCacheSizeMB = size / (1024 * 1024);
      });
    } catch (e) {
      debugPrint('Error getting cache size: $e');
    }
  }

  Future<double> _calculateDirectorySize(Directory directory) async {
    double size = 0;
    try {
      await for (FileSystemEntity entity in directory.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          try {
            size += await entity.length();
          } catch (e) {
            // File có thể đã bị xóa hoặc không có quyền truy cập
            debugPrint('Error reading file size: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Error calculating directory size: $e');
    }
    return size;
  }

  Future<void> _executeRealCleaningTask(int taskIndex) async {
    switch (taskIndex) {
      case 0: // Dọn dẹp bộ nhớ đệm và giải phóng ram
        await _clearApplicationCache();
        break;
      case 1: // Tăng tốc trò chơi lên tốc độ tối đa
        await _cleanTemporaryFiles();
        break;
      case 2: // Ultra booster
        await _ultraBooster();
        break;
    }
  }

  // THỰC SỰ xóa cache ứng dụng
  Future<void> _clearApplicationCache() async {
    try {
      final cacheDir = await getTemporaryDirectory();
      int deletedFiles = 0;
      int deletedSize = 0;

      await for (FileSystemEntity entity in cacheDir.list(recursive: true)) {
        if (entity is File) {
          try {
            final fileSize = await entity.length();
            await entity.delete();
            deletedFiles++;
            deletedSize += fileSize;
          } catch (e) {
            // Một số file có thể không xóa được
            debugPrint('Error deleting cache file: $e');
          }
        }
      }

      // Gọi native Android clear cache nếu có
      if (Platform.isAndroid) {
        try {
          final result = await _channel.invokeMethod('clearAppCache');
          debugPrint('Native cache clear result: $result');
        } catch (e) {
          debugPrint('Native cache clear failed: $e');
        }
      }

      setState(() {
        cacheClearedMB = (deletedSize / (1024 * 1024)).round();
      });

      debugPrint('Đã xóa $deletedFiles files cache, tiết kiệm ${cacheClearedMB}MB');
    } catch (e) {
      debugPrint('Error clearing cache: $e');
    }
  }

  // THỰC SỰ dọn file tạm thời
  Future<void> _cleanTemporaryFiles() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final appSupportDir = await getApplicationSupportDirectory();
      
      int deletedCount = 0;
      
      // Dọn file .tmp, .log, .bak
      final directories = [tempDir, appSupportDir];
      
      for (Directory dir in directories) {
        try {
          await for (FileSystemEntity entity in dir.list(recursive: true)) {
            if (entity is File) {
              final fileName = entity.path.toLowerCase();
              if (fileName.endsWith('.tmp') || 
                  fileName.endsWith('.log') || 
                  fileName.endsWith('.bak') ||
                  fileName.contains('temp')) {
                try {
                  await entity.delete();
                  deletedCount++;
                } catch (e) {
                  // Một số file có thể không xóa được
                  debugPrint('Error deleting temp file: $e');
                }
              }
            }
          }
        } catch (e) {
          // Directory có thể không tồn tại hoặc không có quyền truy cập
          debugPrint('Error accessing directory: $e');
        }
      }

      // Kill background processes nếu có thể
      if (Platform.isAndroid) {
        try {
          final result = await _channel.invokeMethod('killBackgroundApps');
          debugPrint('Background apps killed: $result');
        } catch (e) {
          debugPrint('Failed to kill background apps: $e');
        }
      }

      setState(() {
        tempFilesDeleted = deletedCount;
      });

      debugPrint('Đã xóa $deletedCount file tạm thời');
    } catch (e) {
      debugPrint('Error cleaning temp files: $e');
    }
  }

  // Ultra booster: Gọi GC và xóa log cũ
  Future<void> _ultraBooster() async {
    try {
      // Xóa log cũ
      final appSupportDir = await getApplicationSupportDirectory();
      final now = DateTime.now();
      int deletedLogs = 0;

      try {
        await for (FileSystemEntity entity in appSupportDir.list(recursive: true)) {
          if (entity is File && entity.path.toLowerCase().contains('.log')) {
            try {
              final stat = await entity.stat();
              final daysDiff = now.difference(stat.modified).inDays;
              
              // Xóa log cũ hơn 7 ngày
              if (daysDiff > 7) {
                await entity.delete();
                deletedLogs++;
              }
            } catch (e) {
              // File có thể không xóa được
              debugPrint('Error processing log file: $e');
            }
          }
        }
      } catch (e) {
        // Directory có thể không tồn tại
        debugPrint('Error accessing app support directory: $e');
      }

      setState(() {
        oldLogsRemoved = deletedLogs;
      });

      // Gọi Garbage Collector trong Dart
      List<Uint8List> memoryBlocks = [];
      
      // Cấp phát 50MB để trigger GC
      for (int i = 0; i < 50; i++) {
        memoryBlocks.add(Uint8List(1024 * 1024)); // 1MB each
      }
      
      // Xóa ngay để GC thu hồi
      memoryBlocks.clear();
      
      // Gọi native Android GC nếu có thể
      if (Platform.isAndroid) {
        try {
          final result = await _channel.invokeMethod('forceGC');
          debugPrint('Native GC result: $result');
        } catch (e) {
          debugPrint('Native GC not available: $e');
        }
      }

      debugPrint('Ultra Booster completed: $deletedLogs logs removed, GC called');
    } catch (e) {
      debugPrint('Error in ultra booster: $e');
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const  Color(0xFF18181B),
      // bottomNavigationBar: const NativeAdWithLoadingWidget(adType: ''),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (child, animation) =>
              FadeTransition(opacity: animation, child: child),
          child: isBoostingComplete
              ? _buildModeCard(
                  key: const ValueKey('ready'),
                  title: 'Sẵn sàng',
                  image: Image.asset(
                    'assets/images/success.png',
                    height: 92,
                    width: 166,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.check_circle, 
                        color: Color(0xFF00FFB3), size: 92);
                    },
                  ),
                  features: features,
                  borderColor: const Color(0xFF00FFB3),
                  showPlayButton: true,
                )
              : _buildModeCard(
                  key: const ValueKey('boosting'),
                  title: 'Đang tăng tốc ...',
                  image: _buildBoostingIcon(),
                  features: features,
                  borderColor: const Color(0xFF00BFFF),
                ),
        ),
      ),
    );
  }

  Widget _buildBoostingIcon() {
    return Lottie.asset(
      'assets/icons/AI Robot.json',
      height: 100,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.cleaning_services, 
          color: Color(0xFF00BFFF), size: 100);
      },
    );
  }

  Widget _buildModeCard({
    Key? key,
    required String title,
    required Widget image,
    required List<String> features,
    required Color borderColor,
    bool showPlayButton = false,
  }) {
    return Container(
      key: key,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color:    const  Color(0xFF18181B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          image,
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          
        
          
          const SizedBox(height: 40),

          // Danh sách tính năng
          ...features.asMap().entries.map(
            (entry) {
              int index = entry.key;
              String feature = entry.value;

              Widget icon;
              if (index < completedFeatures) {
                icon = SvgPicture.asset(
                  'assets/icons/icon_chon.svg',
                  width: 20,
                  height: 20,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.check_circle, 
                      color: Color(0xFF00FFB3), size: 20);
                  },
                );
              } else if (index == completedFeatures && !isBoostingComplete) {
                icon = const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF00FFB3),
                    ),
                  ),
                );
              } else {
                icon = const SizedBox(
                  width: 20,
                  height: 20,
                ); // để trống
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    icon,
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const Spacer(),

          if (showPlayButton)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
              // Uncomment để navigate đến màn hình tiếp theo
              Get.off(() => AppSelectionScreen()); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FFB3),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
                child: const Text(
                  'Play Game',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Widget _buildStatRow(String label, String value, Color color) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 4),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           label,
  //           style: const TextStyle(color: Colors.white70, fontSize: 14),
  //         ),
  //         Text(
  //           value,
  //           style: TextStyle(
  //             color: color,
  //             fontSize: 14,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void _showCleaningResults() {
  //   final totalSaved = cacheClearedMB;
  //   final totalFiles = tempFilesDeleted + oldLogsRemoved;
    
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false, // Không cho dismiss khi tap ngoài
  //     builder: (context) => AlertDialog(
  //       backgroundColor: const Color(0xFF2A2A2A),
  //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //       title: const Row(
  //         children: [
  //           Icon(Icons.check_circle, color: Color(0xFF00FFB3), size: 28),
  //           SizedBox(width: 12),
  //           Text(
  //             'Kết quả dọn dẹp',
  //             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  //           ),
  //         ],
  //       ),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           _buildResultItem(Icons.storage, 'Dung lượng tiết kiệm:', '$totalSaved MB', const Color(0xFF00FFB3)),
  //           const SizedBox(height: 12),
  //           _buildResultItem(Icons.delete_sweep, 'File đã xóa:', '$totalFiles files', const Color(0xFF00BFFF)),
  //           const SizedBox(height: 12),
  //           _buildResultItem(Icons.memory, 'RAM:', 'Đã tối ưu hóa', Colors.orange),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
              
  //             // Uncomment để navigate đến màn hình tiếp theo
  //             Get.off(() => AppSelectionScreen()); 
  //           },
  //           child: const Text(
  //             'Tiếp tục',
  //             style: TextStyle(color: Color(0xFF00FFB3), fontWeight: FontWeight.bold, fontSize: 16),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildResultItem(IconData icon, String label, String value, Color color) {
  //   return Row(
  //     children: [
  //       Icon(icon, color: color, size: 20),
  //       const SizedBox(width: 8),
  //       Expanded(
  //         child: Text(
  //           label,
  //           style: const TextStyle(color: Colors.white70, fontSize: 14),
  //         ),
  //       ),
  //       Text(
  //         value,
  //         style: TextStyle(
  //           color: color,
  //           fontSize: 14,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}