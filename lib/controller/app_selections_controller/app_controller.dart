import 'package:get/get.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class AppSelectionController extends GetxController {
  var installedApps = <AppInfo>[].obs;
  var filteredApps = <AppInfo>[].obs;
  var searchQuery = "".obs;
  var isLoading = false.obs;

  final List<String> gameKeywords = [
    "game", "play", "fun", "battle", "fight", "war", "quest", "arena",
    "adventure", "puzzle", "racing", "run", "shooter", "fps", "strategy",
    "card", "casino", "chess", "board", "sports", "football", "soccer",
    "basketball", "tennis", "cricket", "golf",
    "mobile", "mobi",
    "riot", "garena", "tencent", "supercell", "sega", "ubisoft",
    "ea", "bandai", "namco", "konami", "nintendo", "activision",
    "pubg", "pubg mobile", "free fire", "ff", "lien quan", "arena of valor",
    "aov", "mobile legends", "mlbb", "genshin", "impact",
    "call of duty", "cod", "codm", "call of duty mobile",
    "fifa", "pes", "minecraft", "roblox", "pokemon", "clash", "royale",
    "clash of clans", "coc", "brawl stars", "fortnite", "among us",
    "gta", "grand theft auto", "cyberpunk", "witcher", "dota", "lol",
    "league of legends", "valorant", "csgo", "counter strike",
    "resident evil", "assassin", "creed", "spiderman",
    "dragon ball", "naruto", "one piece",
  ];

  @override
  void onInit() {
    super.onInit();
    refreshApps();
  }

  /// Load danh sách app cài đặt
  Future<void> refreshApps() async {
    isLoading.value = true;
    installedApps.value = await InstalledApps.getInstalledApps(true, true);
    initializeData();
    isLoading.value = false;
  }

  /// Kiểm tra app có phải game không
  bool _isGame(AppInfo app) {
    final lowerName = app.name.toLowerCase();
    final lowerPackage = app.packageName.toLowerCase();
    return gameKeywords.any((kw) =>
        lowerName.contains(kw.toLowerCase()) ||
        lowerPackage.contains(kw.toLowerCase()));
  }

  /// Mặc định chỉ show game
  void initializeData() {
    filteredApps.value =
        installedApps.where((app) => _isGame(app)).toList();
  }

  /// Tìm kiếm: nếu query trống thì show game, nếu có query thì tìm toàn bộ app
  void filterApps(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      initializeData();
    } else {
      filteredApps.value = installedApps.where((app) {
        final lowerName = app.name.toLowerCase();
        final lowerPackage = app.packageName.toLowerCase();
        return lowerName.contains(query.toLowerCase()) ||
            lowerPackage.contains(query.toLowerCase());
      }).toList();
    }
  }
}
