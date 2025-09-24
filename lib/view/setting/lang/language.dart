import 'package:booster_game/helper/gg_ads/ads_setup.dart';
import 'package:booster_game/view/custom_ads/native_ads.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  final GetStorage storage = GetStorage();
  String selectedLanguage = "English";

  // Danh sách ngôn ngữ hiển thị (flag + name)
  final List<Map<String, String>> languages = [
    {"name": "English", "flag": "🇬🇧"},
    {"name": "United States", "flag": "🇺🇸"},
    {"name": "Portugal (Brazil)", "flag": "🇧🇷"},
    {"name": "Saudi Arabia", "flag": "🇸🇦"},
    {"name": "Indonesia", "flag": "🇮🇩"},
    {"name": "India", "flag": "🇮🇳"},
    {"name": "Korea", "flag": "🇰🇷"},
    {"name": "Vietnam", "flag": "🇻🇳"},
    {"name": "Russia", "flag": "🇷🇺"},
    {"name": "Germany", "flag": "🇩🇪"},
    {"name": "Ukraine", "flag": "🇺🇦"},
    {"name": "Singapore", "flag": "🇸🇬"},
    {"name": "China", "flag": "🇨🇳"},
  ];

  // Map tên ngôn ngữ -> Locale tương ứng
  final Map<String, Locale> languageLocales = {
    "English": const Locale('en', 'US'),
    "United States": const Locale('en', 'US'),
    "Portugal (Brazil)": const Locale('pt', 'BR'),
    "Saudi Arabia": const Locale('ar', 'SA'),
    "Indonesia": const Locale('id', 'ID'),
    "India": const Locale('hi', 'IN'),
    "Korea": const Locale('ko', 'KR'),
    "Vietnam": const Locale('vi', 'VN'),
    "Russia": const Locale('ru', 'RU'),
    "Germany": const Locale('de', 'DE'),
    "Ukraine": const Locale('uk', 'UA'),
    "Singapore": const Locale('en', 'SG'),
    "China": const Locale('zh', 'CN'),
  };

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  // Load ngôn ngữ đã lưu từ GetStorage
  // Load ngôn ngữ đã lưu từ GetStorage
  void _loadSavedLanguage() {
    String? savedLanguage = storage.read('selected_language');
    if (savedLanguage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          selectedLanguage = savedLanguage;
        });

        // Áp dụng ngôn ngữ đã lưu
        if (languageLocales.containsKey(savedLanguage)) {
          Get.updateLocale(languageLocales[savedLanguage]!);
        }
      });
    }
  }

  // Lưu ngôn ngữ vào GetStorage
  void _saveLanguage(String language) {
    storage.write('selected_language', language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NativeAdWithLoadingWidget(adType: 'medium'),
      backgroundColor: const Color(0xFF18181B),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF18181B),
        elevation: 0,
        title: Text(
          'language_setting'.tr, // lấy từ file dịch
          style: const TextStyle(
            fontFamily: 'Play',
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              AdHelper.showInterstitialAd(
                onComplete: () {
                  Get.back();
                },
              );
            },
            icon: Icon(Icons.check, size: 24, color: Colors.white),
          ),
        ],
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

                  // Lưu ngôn ngữ vào GetStorage
                  _saveLanguage(lang["name"]!);

                  // đổi Locale theo tên ngôn ngữ
                  if (languageLocales.containsKey(lang["name"])) {
                    Get.updateLocale(languageLocales[lang["name"]]!);
                  }
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
                              ? const Color(0xFF00FFB3)
                              : Colors.grey.shade800,
                    ),
                    color: const Color(0xFF18181B),
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
                              fontFamily: 'Play',
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
                                ? const Color(0xFF00FFB3)
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
