import 'package:booster_game/controller/app_selections_controller/app_controller.dart';
import 'package:booster_game/view/custom_ads/native_ads.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class AppSelectionScreen extends StatelessWidget {
  final controller = Get.find<AppSelectionController>();
  final TextEditingController searchController = TextEditingController();

  AppSelectionScreen({super.key});

  Future<void> _playGame(AppInfo app) async {
    try {
      await InstalledApps.startApp(app.packageName);
      Get.snackbar(
        'Starting App',
        'Opening ${app.name}...',
        backgroundColor: const Color(0xFF00FFB3),
        colorText: Colors.black,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Cannot start ${app.name}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NativeAdWithLoadingWidget(adType: ''),
      appBar: AppBar(
          backgroundColor: const  Color(0xFF18181B),
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
        title: Obx(
          () => Text(
            controller.searchQuery.isEmpty ? 'select'.tr : 'all'.tr,
            style: const TextStyle(
              fontFamily: 'Play',
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
      ),
       backgroundColor: const  Color(0xFF18181B),
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A2A),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey[400], size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      onChanged: controller.filterApps,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration:  InputDecoration(
                        hintText: 'search'.tr,
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

            const SizedBox(height: 16),

            // App list
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF00FFB3)),
                  );
                }

                if (controller.filteredApps.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.apps, size: 64, color: Colors.grey[600]),
                        const SizedBox(height: 16),
                        Text(
                          controller.searchQuery.isEmpty
                              ? 'No games found'
                              : 'No apps found',
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: controller.filteredApps.length,
                  itemBuilder: (context, index) {
                    final app = controller.filteredApps[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2A2A),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          // Icon
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[700],
                            ),
                            child:
                                app.icon != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.memory(
                                        app.icon!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : Icon(
                                      Icons.videogame_asset,
                                      color: Colors.grey[400],
                                    ),
                          ),
                          const SizedBox(width: 16),

                          // Name
                          Expanded(
                            child: Text(
                              app.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Play
                          GestureDetector(
                            onTap: () => _playGame(app),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00FFB3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child:  Text(
                                'play'.tr,
                                style: TextStyle(
                                  fontFamily: 'Play',
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
