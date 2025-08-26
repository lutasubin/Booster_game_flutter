import 'package:booster_game/model/onboard.dart';
import 'package:booster_game/view/home/home_screen.dart';
import 'package:booster_game/controller/splash_controller/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingItem> onboardingItems = [
    OnboardingItem(
      title: "POWERFUL PERFORMANCE",
      subtitle:
          "Powerful performance boost giver you the best gaming experience",
      assetImage: "assets/images/image1.png",
      buttonText: 'Next',
    ),
    OnboardingItem(
      title: "REAL-TIME PERFORMANCE",
      subtitle: "Real-time boost. Faster, sharper, unstoppable",
      assetImage: "assets/images/image2.png",
      buttonText: 'Next',
    ),
    OnboardingItem(
      title: "ALL GAMES,ONE TAP AWAY",
      subtitle: "Boots every game in a tap. Faster, sharper, unstoppable",
      assetImage: "assets/images/image3.png",
      buttonText: 'Next',
    ),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/background_aboarding.png',
            ), // Thay đổi đường dẫn hình ảnh theo ý bạn
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          _currentPage = index;
                        });
                      },
                      itemCount: onboardingItems.length,
                      itemBuilder: (context, index) {
                        return LayoutBuilder(
                          builder: (context, constraints) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(height: screenSize.height * 0.1),
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: EdgeInsets.all(
                                      screenSize.width * 0.05,
                                    ),
                                    child: Image.asset(
                                      onboardingItems[index].assetImage,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: screenSize.width * 0.05,
                                  ),
                                  child: Column(
                                    children: [
                                      Text(
                                        onboardingItems[index].title,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 16 : 20,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFFFFFFFF),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        onboardingItems[index].subtitle,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: isSmallScreen ? 12 : 14,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(
                                            0xFFFFFFFF,
                                          ).withAlpha(179), // 0.7 opacity
                                          height: 1.4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: screenSize.height * 0.03),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
              // Button ở góc phải trên - ĐẶT SAU để nằm trên cùng
              Positioned(
                top: 20,
                right: 20,
                child: TextButton(
                  onPressed: () async {
                    if (_currentPage == onboardingItems.length - 1) {
                      // Đánh dấu đã hoàn thành onboarding
                      await SplashController.markOnboardingCompleted();
                      // Chuyển đến home screen
                      Get.offAll(() => HomeScreen());
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                  child: Text(
                    onboardingItems[_currentPage].buttonText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF00FFB3),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
