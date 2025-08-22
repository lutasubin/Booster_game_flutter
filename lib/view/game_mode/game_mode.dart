import 'package:booster_game/view/app_selection/app_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class GameModeSelectionScreen extends StatefulWidget {
  const GameModeSelectionScreen({super.key});

  @override
  State<GameModeSelectionScreen> createState() =>
      _GameModeSelectionScreenState();
}

class _GameModeSelectionScreenState extends State<GameModeSelectionScreen>
    with TickerProviderStateMixin {
  bool isBoostingComplete = false;

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

    // Hiệu ứng sáng → mờ lặp lại
    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    // Sau 3 giây -> trạng thái "Sẵn sàng"
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => isBoostingComplete = true);
        _rotationController.stop();
        _opacityController.stop();
      }
    });
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
      backgroundColor: const Color(0xFF1A1A1A),
      body: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder:
              (child, animation) =>
                  FadeTransition(opacity: animation, child: child),
          child:
              isBoostingComplete
                  ? _buildModeCard(
                    key: const ValueKey('ready'),
                    title: 'Sẵn sàng',
                    image: Image.asset(
                      'assets/images/success.png',
                      height: 92,
                      width: 166,
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
                    showLoadingIndicator: true,
                  ),
        ),
      ),
    );
  }

  Widget _buildBoostingIcon() {
    return RotationTransition(
      turns: _rotationController,
      child: AnimatedBuilder(
        animation: _opacityController,
        builder:
            (context, child) => Opacity(
              opacity:
                  0.5 +
                  (_opacityController.value * 0.5), // dao động từ 0.5 -> 1.0
              child: child,
            ),
        child: Image.asset('assets/images/robot.png', height: 92, width: 166),
      ),
    );
  }

  Widget _buildModeCard({
    Key? key,
    required String title,
    required Widget image,
    required List<String> features,
    required Color borderColor,
    bool showPlayButton = false,
    bool showLoadingIndicator = false,
  }) {
    return Container(
      key: key,
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          image,
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (showLoadingIndicator) ...[
                const SizedBox(width: 12),
                const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xFF00FFB3),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 40),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/icons/icon_chon.svg'),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          if (showPlayButton)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.off(() => const AppSelectionScreen()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FFB3),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero, // Không bo góc
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
}
