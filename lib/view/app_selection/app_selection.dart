import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:installed_apps/app_info.dart';
import 'package:booster_game/controller/home_controller/home_controller.dart';

class AppSelectionScreen extends StatefulWidget {
  const AppSelectionScreen({super.key});

  @override
  State<AppSelectionScreen> createState() => _AppSelectionScreenState();
}

class _AppSelectionScreenState extends State<AppSelectionScreen> {
  final HomeController controller = Get.find<HomeController>();
  final TextEditingController searchController = TextEditingController();

  // Danh sách các app được chọn (lưu package name)
  final Set<String> selectedApps = <String>{};

  // Danh sách apps để hiển thị (sau khi filter)
  List<AppInfo> filteredApps = [];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    // Load tất cả installed apps nếu chưa có
    if (controller.installedApps.isEmpty) {
      controller.refreshApps();
    }

    // Khởi tạo danh sách đã chọn từ gameApps hiện tại
    selectedApps.addAll(controller.gameApps.map((app) => app.packageName));

    // Khởi tạo filtered apps
    filteredApps = List.from(controller.installedApps);
  }

  void _filterApps(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredApps = List.from(controller.installedApps);
      } else {
        filteredApps =
            controller.installedApps.where((app) {
              return app.name.toLowerCase().contains(query.toLowerCase()) ||
                  app.packageName.toLowerCase().contains(query.toLowerCase());
            }).toList();
      }
    });
  }

  void _toggleAppSelection(String packageName) {
    setState(() {
      if (selectedApps.contains(packageName)) {
        selectedApps.remove(packageName);
      } else {
        selectedApps.add(packageName);
      }
    });
  }

  void _saveSelection() {
    try {
      // Lọc ra các apps được chọn
      final selectedGameApps =
          controller.installedApps
              .where((app) => selectedApps.contains(app.packageName))
              .toList();

      // Cập nhật gameApps trong controller
      controller.updateGameApps(selectedGameApps);

      Get.back();

      // Hiển thị thông báo sau khi đã back
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar(
          'Success',
          'Selected ${selectedApps.length} games',
          backgroundColor: const Color(0xFF00FFB3),
          colorText: Colors.black,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      });
    } catch (e) {
      print('Error saving selection: $e');
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'SELECT APP',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveSelection,
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
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[800]!, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[400], size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    onChanged: _filterApps,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    decoration: const InputDecoration(
                      hintText: 'Search App ...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Apps List
          Expanded(
            child: Obx(() {
              if (controller.isLoadingApps) {
                return const Center(
                  child: CircularProgressIndicator(color: Color(0xFF00FFB3)),
                );
              }

              if (filteredApps.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey[600]),
                      const SizedBox(height: 16),
                      Text(
                        'No apps found',
                        style: TextStyle(color: Colors.grey[400], fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredApps.length,
                itemBuilder: (context, index) {
                  final app = filteredApps[index];
                  final isSelected = selectedApps.contains(app.packageName);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),

                      border: Border.all(
                        // ignore: deprecated_member_use
                        color: const Color(
                          0xFFFFFFFF,
                          // ignore: deprecated_member_use
                        ).withOpacity(0.05), // viền nhẹ
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child:
                            app.icon != null
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.memory(
                                    app.icon!,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.android,
                                        color: Colors.grey[400],
                                        size: 20,
                                      );
                                    },
                                  ),
                                )
                                : Icon(
                                  Icons.android,
                                  color: Colors.grey[400],
                                  size: 20,
                                ),
                      ),
                      title: Text(
                        app.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle:
                          app.versionName.isNotEmpty
                              ? Text(
                                'v${app.versionName}',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              )
                              : null,
                      trailing: GestureDetector(
                        onTap: () => _toggleAppSelection(app.packageName),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color:
                                isSelected
                                    ? const Color(0xFF00FFB3)
                                    : Colors.transparent,
                            border: Border.all(
                              color:
                                  isSelected
                                      ? const Color(0xFF00FFB3)
                                      : Colors.grey[600]!,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child:
                              isSelected
                                  ? const Icon(
                                    Icons.check,
                                    size: 16,
                                    color: Colors.black,
                                  )
                                  : null,
                        ),
                      ),
                      onTap: () => _toggleAppSelection(app.packageName),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
