import 'package:booster_game/view/custom_ads/native_ads.dart';
import 'package:booster_game/view/setting/lang/appbar_lang/appbar_lang.dart';
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

  void _loadSavedLanguage() {
    String? savedLanguage = storage.read('selected_language');
    if (savedLanguage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          selectedLanguage = savedLanguage;
        });
        if (languageLocales.containsKey(savedLanguage)) {
          Get.updateLocale(languageLocales[savedLanguage]!);
        }
      });
    }
  }

  void _saveLanguage(String language) {
    storage.write('selected_language', language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF18181B),
      bottomNavigationBar: const SafeArea(
        child: NativeAdWithLoadingWidget(adType: 'medium'),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/icons/new_main.png', fit: BoxFit.cover),
          ),

          SafeArea(
            child: Column(
              children: [
                const CustomHeaderLang(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    children: [
                      ...languages.map((lang) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedLanguage = lang["name"]!;
                            });
                            _saveLanguage(lang["name"]!);
                            if (languageLocales.containsKey(lang["name"])) {
                              Get.updateLocale(languageLocales[lang["name"]]!);
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 14,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color:
                                    selectedLanguage == lang["name"]
                                        ? const Color(0xFF00FFFF)
                                        : Colors.grey.shade800,
                              ),
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
                                          ? const Color(0xFF00FFFF)
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
