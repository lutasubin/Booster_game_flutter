import 'package:booster_game/view/custom_ads/native_ads.dart';
import 'package:booster_game/view/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.height < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF18181B),
      bottomNavigationBar: SafeArea(
        child: NativeAdWithLoadingWidget(adType: ''),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/images/welcome_hd.png',
            ), // Thay bằng ảnh background của bạn
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                SvgPicture.asset('assets/icons/text_splash.svg'),

                const SizedBox(height: 20),

                // Subtitle
                Text(
                  'Wishing you great performance and lots of fun.\nEnjoy your game!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Play',
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withAlpha(204), // 0.8 opacity
                    height: 1.5,
                  ),
                ),

                const Spacer(flex: 3),

                // Play Now Button
                Container(
                  width: double.infinity,
                  height: 56,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      Get.offAll(
                        () => HomeScreen(),
                        transition: Transition.fade,
                        duration: const Duration(milliseconds: 500),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00FFFF),
                      foregroundColor: Colors.black,
                      elevation: 8,
                      shadowColor: const Color(
                        0xFF00FFFF,
                      ).withAlpha(102), // 0.4 opacity
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.zero, // Không bo góc
                      ),
                    ),
                    child: Text(
                      'play_now'.tr,
                      style: TextStyle(
                        fontFamily: 'Play',
                        fontSize: isSmallScreen ? 16 : 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Bottom disclaimer text
                Text(
                  'This action may contain ads',
                  style: TextStyle(
                    fontFamily: 'Play',
                    fontSize: isSmallScreen ? 10 : 12,
                    color: Colors.white.withAlpha(153), // 0.6 opacity
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
