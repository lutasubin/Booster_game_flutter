import 'package:booster_game/view/custom_ads/native_ads.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  String selectedLanguage = "English";

  final List<Map<String, String>> languages = [
    {"name": "English", "flag": "🇬🇧"}, // Anh
    {"name": "United States", "flag": "🇺🇸"}, // Mỹ
    {"name": "Portugal (Brazil)", "flag": "🇧🇷"}, // Brazil
    {"name": "Saudi Arabia", "flag": "🇸🇦"}, // Ả Rập
    {"name": "Indonesia", "flag": "🇮🇩"}, // Indo
    {"name": "India", "flag": "🇮🇳"}, // Ấn
    {"name": "Korea", "flag": "🇰🇷"}, // Hàn
    {"name": "Vietnam", "flag": "🇻🇳"}, // Việt Nam
    {"name": "Russia", "flag": "🇷🇺"}, // Nga
    {"name": "Germany", "flag": "🇩🇪"}, // Đức
    {"name": "Ukraine", "flag": "🇺🇦"}, // Ukraina
    {"name": "Singapore", "flag": "🇸🇬"}, // Singapore
    {"name": "China", "flag": "🇨🇳"}, // Trung Quốc
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NativeAdWithLoadingWidget(adType: 'medium',),
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
          'LANGUAGE SETTING',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ...languages.map((lang) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedLanguage = lang["name"]!;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          selectedLanguage == lang["name"]
                              ? Color(0xFF00FFB3)
                              : Colors.grey.shade800,
                    ),
                    color: Colors.grey.shade900,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            lang["flag"]!,
                            style: const TextStyle(fontSize: 22),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            lang["name"]!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        selectedLanguage == lang["name"]
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color:
                            selectedLanguage == lang["name"]
                                ? Color(0xFF00FFB3)
                                : Colors.white,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
