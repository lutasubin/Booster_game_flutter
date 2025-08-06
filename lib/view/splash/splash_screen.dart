import 'package:booster_game/view/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _progressAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    // Animation cho hiệu ứng phát sáng
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _progressController.forward();

    // Tự động chuyển trang sau khi animation hoàn thành
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          Get.off(() => const HomeScreen());
        });
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // ignore: deprecated_member_use
        color: Colors.black.withOpacity(0.9),
        child: Stack(
          children: [
            // Background ảnh
            Positioned.fill(
              child: Image.asset(
                'assets/images/Artboard 1 1 (2).png',
                fit: BoxFit.cover,
              ),
            ),

            // Overlay SVG phủ mờ
            Positioned.fill(
              child: SvgPicture.asset(
                'assets/svg/Rectangle 7.svg',
                fit: BoxFit.cover,
              ),
            ),

            // Nội dung chính
            Align(
              alignment: Alignment.center,
              child: Column(
                children: [
                  // Logo và tiêu đề
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/icons/icon.svg'),
                        const SizedBox(height: 24),
                        SvgPicture.asset('assets/svg/Gaming Mode.svg'),
                        const SizedBox(height: 10),
                        SvgPicture.asset('assets/svg/GAME BOOTER FPS.svg'),
                      ],
                    ),
                  ),

                  // Enhanced Loading Bar - Khung vuông vắn
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: AnimatedBuilder(
                      animation: _progressController,
                      builder: (context, child) {
                        return Container(
                          height: 10,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF00FFB3),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00FFB3).withOpacity(0.4),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              // Background
                              Container(color: Colors.black.withOpacity(0.2)),

                              // Progress bar với gradient
                              FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: _progressAnimation.value,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF00FFB3),
                                        Color(0xFF00E5A0),
                                        Color(0xFF00FFB3),
                                      ],
                                      stops: [0.0, 0.5, 1.0],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF00FFB3,
                                        ).withOpacity(
                                          _glowAnimation.value * 0.8,
                                        ),
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Shimmer effect
                              if (_progressAnimation.value > 0)
                                FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: _progressAnimation.value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.transparent,
                                          Colors.white.withOpacity(0.5),
                                          Colors.transparent,
                                        ],
                                        stops: const [0.0, 0.5, 1.0],
                                        transform: GradientRotation(
                                          _progressController.value * 6.28,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Progress percentage (optional)
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return Text(
                        '${(_progressAnimation.value * 100).toInt()}%',
                        style: const TextStyle(
                          color: Color(0xFF00FFB3),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),
                  SvgPicture.asset(
                    'assets/svg/This action may contain ads.svg',
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
