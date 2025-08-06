import 'package:booster_game/controller/home_controller/home_controller.dart';
import 'package:booster_game/view/app_selection/app_selection.dart';
import 'package:booster_game/view/home/circular.dart';
import 'package:booster_game/view/setting/setting_scrren.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the existing controller instance
    final HomeController controller = Get.find<HomeController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A1A),
        title: // Gaming Mode Title
            const Row(
          children: [
            Text(
              'GAMING',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'MODE',
              style: TextStyle(
                color: Color(0xFF00FFB3),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
               Get.to(()=>MenuScreen());
              },
              child: SvgPicture.asset('assets/icons/setting.svg'),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Performance Circles - Using reactive getters
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF1A1A1A,
                  ), // màu nền gần giống hình (xám đậm)

                  border: Border.all(
                    // ignore: deprecated_member_use
                    color: const Color(
                      0xFFFFFFFF,
                      // ignore: deprecated_member_use
                    ).withOpacity(0.05), // viền nhẹ
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Obx(
                      () => _buildPerformanceCircle(
                        label: 'CPU',
                        percentage: controller.cpuUsage.round(),
                        color: const Color(0xFF00BFFF),
                      ),
                    ),
                    Obx(
                      () => _buildPerformanceCircle(
                        label: 'RAM',
                        percentage: controller.ramUsage.round(),
                        color: const Color(0xFFFFD700),
                      ),
                    ),
                    Obx(
                      () => _buildPerformanceCircle(
                        label: 'SPEED',
                        percentage: controller.speedScore.round(),
                        color: const Color(0xFF00FFB3),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // Apply For All Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF1A1A1A,
                  ), // màu nền gần giống hình (xám đậm)

                  border: Border.all(
                    // ignore: deprecated_member_use
                    color: const Color(
                      0xFFFFFFFF,
                      // ignore: deprecated_member_use
                    ).withOpacity(0.05), // viền nhẹ
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Apply For All',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        InkWell(
                          onTap: () async {
                            // Điều hướng đến màn hình chọn app
                            await Get.to(() => const AppSelectionScreen());
                            // Refresh controller sau khi quay về
                            controller.update();
                          },
                          child: SvgPicture.asset('assets/icons/setting2.svg'),
                        ),
                      ],
                    ),
                    Obx(
                      () => Row(
                        children: [
                          GestureDetector(
                            onTap: () => controller.toggleGameMode(false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    !controller.isGameModeEnabled
                                        ? Colors.grey[600]
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'Disable',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => controller.toggleGameMode(true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    controller.isGameModeEnabled
                                        ? const Color(0xFF00FFB3)
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                'Enable',
                                style: TextStyle(
                                  color:
                                      controller.isGameModeEnabled
                                          ? Colors.black
                                          : Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Game List Section
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Game List',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Obx(
                              () => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFF00FFB3,
                                    // ignore: deprecated_member_use
                                  ).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${controller.gameApps.length}',
                                  style: const TextStyle(
                                    color: Color(0xFF00FFB3),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          onPressed:
                              () async => {
                                await Get.to(() => const AppSelectionScreen()),
                                controller.update(),
                              },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF00FFB3),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: const Text('Add Game'),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Game List Content
                    Expanded(
                      child: Obx(() {
                        if (!controller.isGameModeEnabled) {
                          return _buildGameModeDisabledState();
                        }

                        if (controller.isLoadingApps) {
                          return _buildLoadingState();
                        }

                        if (controller.gameApps.isEmpty) {
                          return _buildEmptyState();
                        }

                        return _buildGameList(controller);
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPerformanceCircle({
    required String label,
    required int percentage,
    required Color color,
  }) {
    return Column(
      children: [
        SizedBox(
          width: 80,
          height: 80,
          child: CustomPaint(
            painter: CircularProgressPainter(
              progress: percentage / 100,
              color: color,
            ),
            child: Center(
              child: Text(
                '$percentage%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildGameList(HomeController controller) {
    return ListView.builder(
      itemCount: controller.gameApps.length,
      itemBuilder: (context, index) {
        final app = controller.gameApps[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
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
          child: Row(
            children: [
              // App Icon
              Container(
                width: 48,
                height: 48,
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
                                Icons.gamepad,
                                color: Colors.grey[400],
                                size: 24,
                              );
                            },
                          ),
                        )
                        : Icon(
                          Icons.gamepad,
                          color: Colors.grey[400],
                          size: 24,
                        ),
              ),

              const SizedBox(width: 16),

              // App Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      app.packageName,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (app.versionName.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        'v${app.versionName}',
                        style: TextStyle(color: Colors.grey[500], fontSize: 10),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 16),

              // Boot Button
              ElevatedButton(
                onPressed: () => controller.bootGame(app),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FFB3),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Boot',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGameModeDisabledState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.videogame_asset_off, size: 80, color: Colors.grey[600]),
        const SizedBox(height: 24),
        Text(
          'Gaming Mode Disabled',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enable Gaming Mode to see your games',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[500], fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(
          color: Color(0xFF00FFB3),
          strokeWidth: 3,
        ),
        const SizedBox(height: 24),
        Text(
          'Loading Games...',
          style: TextStyle(color: Colors.grey[400], fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          'Scanning for installed games',
          style: TextStyle(color: Colors.grey[500], fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.rocket_launch_outlined, size: 80, color: Colors.grey[600]),
        const SizedBox(height: 24),
        Text(
          'No Games Found',
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Press "Add Game" to select games',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[500], fontSize: 14),
        ),
      ],
    );
  }
}
