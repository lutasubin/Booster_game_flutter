import 'dart:ui';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class TranslationService extends Translations {
  static final GetStorage _storage = GetStorage();
  static final locale = const Locale('en', 'US');
  static final fallbackLocale = const Locale('en', 'US');

  // Danh sách ngôn ngữ hỗ trợ
  static final supportedLocales = [
    const Locale('en', 'US'),
    const Locale('vi', 'VN'),
    const Locale('ru', 'RU'),
    const Locale('de', 'DE'),
    const Locale('uk', 'UA'),
    const Locale('en', 'SG'),
    const Locale('zh', 'CN'),
    const Locale('pt', 'BR'),
    const Locale('ar', 'SA'),
    const Locale('id', 'ID'),
    const Locale('hi', 'IN'),
    const Locale('ko', 'KR'),
  ];

  // Map tên ngôn ngữ -> Locale tương ứng
  static final Map<String, Locale> languageLocales = {
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

  // Khởi tạo GetStorage và load ngôn ngữ đã lưu
  static Future<void> init() async {
    await GetStorage.init();
  }

  // Lấy ngôn ngữ đã lưu
  static Locale getSavedLocale() {
    String? savedLanguage = _storage.read('selected_language');
    if (savedLanguage != null && languageLocales.containsKey(savedLanguage)) {
      return languageLocales[savedLanguage]!;
    }
    return locale; // Trả về ngôn ngữ mặc định
  }

  // Lưu ngôn ngữ
  static void saveLanguage(String language) {
    _storage.write('selected_language', language);
  }

  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      // home
      'mode_booster': 'Mode Booster',
      'disable': 'Disable',
      'enable': 'Enable',
      'click_button': 'Press The Button "🚀" To Start Speeding Up The Game',

      // lang
      'language_setting': 'LANGUAGE SETTING',

      // mode setting
      'mode_setting': 'MODE SETTING',
      'bright': 'Brightness (Current Device)',
      'ringtone': 'Ringtone (System Volume)',
      'media': 'Media (System Volume)',
      'call': 'Auto Reject Call',
      'notification': 'Notification Block',
      'fps': 'Fps',
      'play_game': 'Play Game',

      // mode game
      'ready': 'Ready',
      'accelerating': 'Accelerating...',
      'clean': 'Clean up cache and free up ram',
      'speed': 'Speed up the game to maximum speed',
      'ultra': 'Ultra booster',

      // app_selection
      'select': 'SELECT GAME',
      'all': 'ALL APPS',
      'search': 'Search App',
      'play': 'Play',

      // welcome
      'play_now': 'PLAY NOW',

      // Setting
      'setting': 'SETTING',
      'rate_app': 'Rate App',
      'share': 'Share',
      'privacy': 'Privacy Policy',
      'language': 'Language',
    },

    'vi_VN': {
      // home
      'mode_booster': 'Chế Độ Tăng Tốc',
      'disable': 'Tắt',
      'enable': 'Bật',
      'click_button': 'Nhấn Nút "🚀" Để Bắt Đầu Tăng Tốc Game',

      // lang
      'language_setting': 'CÀI ĐẶT NGÔN NGỮ',

      // mode setting
      'mode_setting': 'CÀI ĐẶT CHẾ ĐỘ',
      'bright': 'Độ Sáng (Thiết Bị Hiện Tại)',
      'ringtone': 'Nhạc Chuông (Âm Lượng Hệ Thống)',
      'media': 'Phương Tiện (Âm Lượng Hệ Thống)',
      'call': 'Tự Động Từ Chối Cuộc Gọi',
      'notification': 'Chặn Thông Báo',
      'fps': 'Fps',
      'play_game': 'Chơi Game',

      // mode game
      'ready': 'Sẵn Sàng',
      'accelerating': 'Đang Tăng Tốc...',
      'clean': 'Dọn dẹp bộ nhớ đệm và giải phóng RAM',
      'speed': 'Tăng tốc game lên tốc độ tối đa',
      'ultra': 'Tăng tốc siêu cấp',

      // app_selection
      'select': 'CHỌN GAME',
      'all': 'TẤT CẢ ỨNG DỤNG',
      'search': 'Tìm Kiếm Ứng Dụng',
      'play': 'Chơi',

      // welcome
      'play_now': 'CHƠI NGAY',

      // Setting
      'setting': 'CÀI ĐẶT',
      'rate_app': 'Đánh Giá Ứng Dụng',
      'share': 'Chia Sẻ',
      'privacy': 'Chính Sách Bảo Mật',
      'language': 'Ngôn Ngữ',
    },

    'ru_RU': {
      // home
      'mode_booster': 'Режим Ускорения',
      'disable': 'Disable',
      'enable': 'Enable',
      'click_button': 'Нажмите Кнопку "🚀" Чтобы Начать Ускорение Игры',

      // lang
      'language_setting': 'НАСТРОЙКА ЯЗЫКА',

      // mode setting
      'mode_setting': 'НАСТРОЙКА РЕЖИМА',
      'bright': 'Яркость (Текущее Устройство)',
      'ringtone': 'Мелодия (Системная Громкость)',
      'media': 'Медиа (Системная Громкость)',
      'call': 'Автоотклонение Звонков',
      'notification': 'Блокировка Уведомлений',
      'fps': 'Fps',
      'play_game': 'Играть',

      // mode game
      'ready': 'Готов',
      'accelerating': 'Ускорение...',
      'clean': 'Очистить кеш и освободить RAM',
      'speed': 'Ускорить игру до максимальной скорости',
      'ultra': 'Ультра ускоритель',

      // app_selection
      'select': 'ВЫБРАТЬ ИГРУ',
      'all': 'ВСЕ ПРИЛОЖЕНИЯ',
      'search': 'Поиск Приложений',
      'play': 'Играть',

      // welcome
      'play_now': 'ИГРАТЬ СЕЙЧАС',

      // Setting
      'setting': 'НАСТРОЙКИ',
      'rate_app': 'Оценить Приложение',
      'share': 'Поделиться',
      'privacy': 'Политика Конфиденциальности',
      'language': 'Язык',
    },

    'de_DE': {
      // home
      'mode_booster': 'Booster-Modus',
      'disable': 'Disable',
      'enable': 'Enable',
      'click_button':
          'Drücken Sie Die Taste "🚀" Um Das Spiel Zu Beschleunigen',

      // lang
      'language_setting': 'SPRACHEINSTELLUNGEN',

      // mode setting
      'mode_setting': 'MODUS EINSTELLUNGEN',
      'bright': 'Helligkeit (Aktuelles Gerät)',
      'ringtone': 'Klingelton (System-Lautstärke)',
      'media': 'Medien (System-Lautstärke)',
      'call': 'Anrufe Automatisch Ablehnen',
      'notification': 'Benachrichtigungen Blockieren',
      'fps': 'Fps',
      'play_game': 'Spiel Spielen',

      // mode game
      'ready': 'Bereit',
      'accelerating': 'Beschleunigung...',
      'clean': 'Cache leeren und RAM freigeben',
      'speed': 'Spiel auf maximale Geschwindigkeit beschleunigen',
      'ultra': 'Ultra Booster',

      // app_selection
      'select': 'SPIEL AUSWÄHLEN',
      'all': 'ALLE APPS',
      'search': 'App Suchen',
      'play': 'Spielen',

      // welcome
      'play_now': 'JETZT SPIELEN',

      // Setting
      'setting': 'EINSTELLUNGEN',
      'rate_app': 'App Bewerten',
      'share': 'Teilen',
      'privacy': 'Datenschutzrichtlinie',
      'language': 'Sprache',
    },

    'uk_UA': {
      // home
      'mode_booster': 'Mode Booster',
      'disable': 'Disable',
      'enable': 'Enable',
      'click_button': 'Натисніть Кнопку "🚀" Щоб Почати Прискорення Гри',

      // lang
      'language_setting': 'НАЛАШТУВАННЯ МОВИ',

      // mode setting
      'mode_setting': 'НАЛАШТУВАННЯ РЕЖИМУ',
      'bright': 'Яскравість (Поточний Пристрій)',
      'ringtone': 'Мелодія (Системна Гучність)',
      'media': 'Медіа (Системна Гучність)',
      'call': 'Автовідхилення Дзвінків',
      'notification': 'Блокування Сповіщень',
      'fps': 'Fps',
      'play_game': 'Грати',

      // mode game
      'ready': 'Готовий',
      'accelerating': 'Прискорення...',
      'clean': 'Очистити кеш і звільнити RAM',
      'speed': 'Прискорити гру до максимальної швидкості',
      'ultra': 'Ультра прискорювач',

      // app_selection
      'select': 'ВИБРАТИ ГРУ',
      'all': 'ВСІ ДОДАТКИ',
      'search': 'Пошук Додатків',
      'play': 'Грати',

      // welcome
      'play_now': 'ГРАТИ ЗАРАЗ',

      // Setting
      'setting': 'НАЛАШТУВАННЯ',
      'rate_app': 'Оцінити Додаток',
      'share': 'Поділитися',
      'privacy': 'Політика Конфіденційності',
      'language': 'Мова',
    },

    'en_SG': {
      // home
      'mode_booster': 'Mode Booster',
      'disable': 'Disable',
      'enable': 'Enable',
      'click_button': 'Press The Button "🚀" To Start Speeding Up The Game',

      // lang
      'language_setting': 'LANGUAGE SETTING',

      // mode setting
      'mode_setting': 'MODE SETTING',
      'bright': 'Brightness (Current Device)',
      'ringtone': 'Ringtone (System Volume)',
      'media': 'Media (System Volume)',
      'call': 'Auto Reject Call',
      'notification': 'Notification Block',
      'fps': 'Fps',
      'play_game': 'Play Game',

      // mode game
      'ready': 'Ready',
      'accelerating': 'Accelerating...',
      'clean': 'Clean up cache and free up ram',
      'speed': 'Speed up the game to maximum speed',
      'ultra': 'Ultra booster',

      // app_selection
      'select': 'SELECT GAME',
      'all': 'ALL APPS',
      'search': 'Search App',
      'play': 'Play',

      // welcome
      'play_now': 'PLAY NOW',

      // Setting
      'setting': 'SETTING',
      'rate_app': 'Rate App',
      'share': 'Share',
      'privacy': 'Privacy Policy',
      'language': 'Language',
    },

    'zh_CN': {
      // home
      'mode_booster': '加速模式',
      'disable': '禁用',
      'enable': '启用',
      'click_button': '按下"🚀"按钮开始游戏加速',

      // lang
      'language_setting': '语言设置',

      // mode setting
      'mode_setting': '模式设置',
      'bright': '亮度（当前设备）',
      'ringtone': '铃声（系统音量）',
      'media': '媒体（系统音量）',
      'call': '自动拒接电话',
      'notification': '通知屏蔽',
      'fps': '帧数',
      'play_game': '玩游戏',

      // mode game
      'ready': '准备就绪',
      'accelerating': '加速中...',
      'clean': '清理缓存并释放内存',
      'speed': '将游戏加速到最大速度',
      'ultra': '超级加速器',

      // app_selection
      'select': '选择游戏',
      'all': '所有应用',
      'search': '搜索应用',
      'play': '玩',

      // welcome
      'play_now': '立即玩',

      // Setting
      'setting': '设置',
      'rate_app': '评价应用',
      'share': '分享',
      'privacy': '隐私政策',
      'language': '语言',
    },

    'pt_BR': {
      // home
      'mode_booster': 'Modo Booster',
      'disable': 'Desabilitar',
      'enable': 'Habilitar',
      'click_button': 'Pressione O Botão "🚀" Para Começar A Acelerar O Jogo',

      // lang
      'language_setting': 'CONFIGURAÇÃO DE IDIOMA',

      // mode setting
      'mode_setting': 'CONFIGURAÇÃO DE MODO',
      'bright': 'Brilho (Dispositivo Atual)',
      'ringtone': 'Toque (Volume do Sistema)',
      'media': 'Mídia (Volume do Sistema)',
      'call': 'Rejeição Automática de Chamadas',
      'notification': 'Bloqueio de Notificações',
      'fps': 'Fps',
      'play_game': 'Jogar',

      // mode game
      'ready': 'Pronto',
      'accelerating': 'Acelerando...',
      'clean': 'Limpar cache e liberar RAM',
      'speed': 'Acelerar o jogo para velocidade máxima',
      'ultra': 'Ultra booster',

      // app_selection
      'select': 'SELECIONAR JOGO',
      'all': 'TODOS OS APPS',
      'search': 'Buscar App',
      'play': 'Jogar',

      // welcome
      'play_now': 'JOGAR AGORA',

      // Setting
      'setting': 'CONFIGURAÇÕES',
      'rate_app': 'Avaliar App',
      'share': 'Compartilhar',
      'privacy': 'Política de Privacidade',
      'language': 'Idioma',
    },

    'ar_SA': {
      // home
      'mode_booster': 'وضع المسرع',
      'disable': 'تعطيل',
      'enable': 'تفعيل',
      'click_button': 'اضغط على الزر "🚀" لبدء تسريع اللعبة',

      // lang
      'language_setting': 'إعدادات اللغة',

      // mode setting
      'mode_setting': 'إعدادات الوضع',
      'bright': 'السطوع (الجهاز الحالي)',
      'ringtone': 'نغمة الرنين (صوت النظام)',
      'media': 'الوسائط (صوت النظام)',
      'call': 'رفض المكالمات تلقائياً',
      'notification': 'حظر الإشعارات',
      'fps': 'معدل الإطارات',
      'play_game': 'لعب اللعبة',

      // mode game
      'ready': 'جاهز',
      'accelerating': 'تسريع...',
      'clean': 'تنظيف الذاكرة المؤقتة وتحرير الذاكرة',
      'speed': 'تسريع اللعبة إلى أقصى سرعة',
      'ultra': 'مسرع فائق',

      // app_selection
      'select': 'اختيار لعبة',
      'all': 'جميع التطبيقات',
      'search': 'البحث عن تطبيق',
      'play': 'لعب',

      // welcome
      'play_now': 'العب الآن',

      // Setting
      'setting': 'الإعدادات',
      'rate_app': 'تقييم التطبيق',
      'share': 'مشاركة',
      'privacy': 'سياسة الخصوصية',
      'language': 'اللغة',
    },

    'id_ID': {
      // home
      'mode_booster': 'Mode Booster',
      'disable': 'Nonaktifkan',
      'enable': 'Aktifkan',
      'click_button': 'Tekan Tombol "🚀" Untuk Mulai Mempercepat Game',

      // lang
      'language_setting': 'PENGATURAN BAHASA',

      // mode setting
      'mode_setting': 'PENGATURAN MODE',
      'bright': 'Kecerahan (Perangkat Saat Ini)',
      'ringtone': 'Nada Dering (Volume Sistem)',
      'media': 'Media (Volume Sistem)',
      'call': 'Tolak Panggilan Otomatis',
      'notification': 'Blokir Notifikasi',
      'fps': 'Fps',
      'play_game': 'Main Game',

      // mode game
      'ready': 'Siap',
      'accelerating': 'Mempercepat...',
      'clean': 'Bersihkan cache dan bebaskan RAM',
      'speed': 'Percepat game ke kecepatan maksimum',
      'ultra': 'Ultra booster',

      // app_selection
      'select': 'PILIH GAME',
      'all': 'SEMUA APLIKASI',
      'search': 'Cari Aplikasi',
      'play': 'Main',

      // welcome
      'play_now': 'MAIN SEKARANG',

      // Setting
      'setting': 'PENGATURAN',
      'rate_app': 'Beri Rating Aplikasi',
      'share': 'Bagikan',
      'privacy': 'Kebijakan Privasi',
      'language': 'Bahasa',
    },

    'hi_IN': {
      // home
      'mode_booster': 'मोड बूस्टर',
      'disable': 'बंद करें',
      'enable': 'चालू करें',
      'click_button': 'गेम को तेज़ करने के लिए "🚀" बटन दबाएं',

      // lang
      'language_setting': 'भाषा सेटिंग',

      // mode setting
      'mode_setting': 'मोड सेटिंग',
      'bright': 'चमक (वर्तमान डिवाइस)',
      'ringtone': 'रिंगटोन (सिस्टम वॉल्यूम)',
      'media': 'मीडिया (सिस्टम वॉल्यूम)',
      'call': 'ऑटो कॉल रिजेक्ट',
      'notification': 'नोटिफिकेशन ब्लॉक',
      'fps': 'Fps',
      'play_game': 'गेम खेलें',

      // mode game
      'ready': 'तैयार',
      'accelerating': 'तेज़ कर रहा है...',
      'clean': 'कैश साफ करें और RAM खाली करें',
      'speed': 'गेम को अधिकतम गति तक तेज़ करें',
      'ultra': 'अल्ट्रा बूस्टर',

      // app_selection
      'select': 'गेम चुनें',
      'all': 'सभी ऐप्स',
      'search': 'ऐप खोजें',
      'play': 'खेलें',

      // welcome
      'play_now': 'अभी खेलें',

      // Setting
      'setting': 'सेटिंग',
      'rate_app': 'ऐप को रेट करें',
      'share': 'साझा करें',
      'privacy': 'गोपनीयता नीति',
      'language': 'भाषा',
    },

    'ko_KR': {
      // home
      'mode_booster': '모드 부스터',
      'disable': '비활성화',
      'enable': '활성화',
      'click_button': '"🚀" 버튼을 눌러 게임 속도를 높이세요',

      // lang
      'language_setting': '언어 설정',

      // mode setting
      'mode_setting': '모드 설정',
      'bright': '밝기 (현재 기기)',
      'ringtone': '벨소리 (시스템 볼륨)',
      'media': '미디어 (시스템 볼륨)',
      'call': '자동 통화 거부',
      'notification': '알림 차단',
      'fps': 'Fps',
      'play_game': '게임 플레이',

      // mode game
      'ready': '준비',
      'accelerating': '가속 중...',
      'clean': '캐시 정리 및 RAM 해제',
      'speed': '게임을 최대 속도로 가속',
      'ultra': '울트라 부스터',

      // app_selection
      'select': '게임 선택',
      'all': '모든 앱',
      'search': '앱 검색',
      'play': '플레이',

      // welcome
      'play_now': '지금 플레이',

      // Setting
      'setting': '설정',
      'rate_app': '앱 평가',
      'share': '공유',
      'privacy': '개인정보 보호정책',
      'language': '언어',
    },
  };
}
