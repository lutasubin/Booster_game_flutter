import 'dart:developer';
import 'package:booster_game/controller/banner_controller/banner_controller.dart';
import 'package:booster_game/controller/native_controller/native_controller.dart';
import 'package:booster_game/helper/dilogs/my_dilogs.dart';
import 'package:booster_game/helper/remote_config/firebase_config.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  // for initializing ads sdk
  static Future<void> initAds() async {
    await MobileAds.instance.initialize();
  }

  static InterstitialAd? _interstitialAd;
  static bool _interstitialAdLoaded = false;

  static BannerAd? _bannerAd;
  static bool _bannerAdLoaded = false;

  //*****************Interstitial Ad******************

  static void precacheInterstitialAd() {
    log('Precache Interstitial Ad - Id: ${Config.interstitialAd}');

    if (Config.hideAds) return;

    InterstitialAd.load(
      adUnitId: Config.interstitialAd,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          //ad listener
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              _resetInterstitialAd();
              precacheInterstitialAd();
            },
          );
          _interstitialAd = ad;
          _interstitialAdLoaded = true;
        },
        onAdFailedToLoad: (err) {
          _resetInterstitialAd();
          log('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

  static void _resetInterstitialAd() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _interstitialAdLoaded = false;
  }

  static void showInterstitialAd({required VoidCallback onComplete}) {
    log('Interstitial Ad Id: ${Config.interstitialAd}');

    if (Config.hideAds) {
      onComplete();
      return;
    }

    if (_interstitialAdLoaded && _interstitialAd != null) {
      _interstitialAd?.show();
      onComplete();
      return;
    }

    MyDialogs.showProgress();

    InterstitialAd.load(
      adUnitId: Config.interstitialAd,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          //ad listener
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              onComplete();
              _resetInterstitialAd();
              precacheInterstitialAd();
            },
          );
          Get.back();
          ad.show();
        },
        onAdFailedToLoad: (err) {
          Get.back();
          log('Failed to load an interstitial ad: ${err.message}');
          onComplete();
        },
      ),
    );
  }

  //*****************Native Ad******************

  /// Tải và trả về một quảng cáo tự nhiên.
  /// [adController] dùng để theo dõi trạng thái tải quảng cáo.
  /// Trả về null nếu quảng cáo bị ẩn hoặc tải thất bại.
  static NativeAd? loadNativeAd({required NativeAdController adController}) {
    log('Native Ad Id: ${Config.nativeAd}');

    if (Config.hideAds) return null;

    // Luôn tạo ad mới thay vì chia sẻ static ad
    return NativeAd(
      adUnitId: Config.nativeAd,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          log('$NativeAd loaded.');
          adController.adLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          log('$NativeAd failed to load: $error');
          adController.adLoaded.value = false;
        },
      ),
      request: const AdRequest(),
      factoryId: 'customNativeAd',
    )..load();
  }

  //*****************Native Ad1******************

  /// Tải và trả về một quảng cáo tự nhiên medium.
  /// [adController] dùng để theo dõi trạng thái tải quảng cáo.
  /// Trả về null nếu quảng cáo bị ẩn hoặc tải thất bại.
  static NativeAd? loadNativeAd1({required NativeAdController adController}) {
    log('Native Ad Medium Id: ${Config.nativeAd}');

    if (Config.hideAds) return null;

    // Luôn tạo ad mới thay vì chia sẻ static ad
    return NativeAd(
      adUnitId: Config.nativeAdMedium,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          log('$NativeAd Medium loaded.');
          adController.adLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          log('$NativeAd Medium failed to load: $error');
          adController.adLoaded.value = false;
        },
      ),
      request: const AdRequest(),
      factoryId: 'customNativeAdMedium',
    ) // Sử dụng medium factory
    ..load();
  }

  //*****************Native Ad Full******************

  /// Tải và trả về một quảng cáo tự nhiên full-screen height container.
  /// Sử dụng factory riêng cho layout full.
  static NativeAd? loadNativeAdFull({
    required NativeAdController adController,
  }) {
    log('Native Ad Full Id: ${Config.nativeAd}');

    if (Config.hideAds) return null;

    return NativeAd(
      adUnitId: Config.nativeAd,
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          log('Native Ad Full loaded.');
          adController.adLoaded.value = true;
        },
        onAdFailedToLoad: (ad, error) {
          log('Native Ad Full failed to load: $error');
          adController.adLoaded.value = false;
        },
      ),
      request: const AdRequest(),
      factoryId: 'customNativeAdFull',
    )..load();
  }

  //*****************Rewarded Ad******************

  static void showRewardedAd({required VoidCallback onComplete}) {
    log('Rewarded Ad Id: ${Config.rewardedAd}');

    if (Config.hideAds) {
      onComplete();
      return;
    }

    MyDialogs.showProgress();

    RewardedAd.load(
      adUnitId: Config.rewardedAd,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          Get.back();

          //reward listener
          ad.show(
            onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
              onComplete();
            },
          );
        },
        onAdFailedToLoad: (err) {
          Get.back();
          log('Failed to load an interstitial ad: ${err.message}');
          // onComplete();
        },
      ),
    );
  }

  //*****************App Open Ad******************

  static AppOpenAd? _appOpenAd;
  static bool _isOpenAdAvailable = false;
  static DateTime? _appOpenLoadTime;

  /// Check if the ad is available and not expired
  static bool get isAppOpenAdAvailable {
    return _isOpenAdAvailable && _appOpenAd != null && _isAdNotExpired();
  }

  /// Check if ad is not expired (ads expire after 4 hours)
  static bool _isAdNotExpired() {
    if (_appOpenLoadTime == null) return false;
    final now = DateTime.now();
    final difference = now.difference(_appOpenLoadTime!);
    return difference.inHours < 4;
  }

  /// Tải quảng cáo App Open (quảng cáo khi mở app)
  static void precacheOpenAd() {
    if (Config.hideAds) {
      print('[AppOpenAd] Ads hidden by config. Skipping load.');
      return;
    }

    final openAdUnitId = Config.openAd;
    if (openAdUnitId.isEmpty) {
      print('[AppOpenAd] Error: openAd ID is empty!');
      return;
    }

    // Don't load if ad is already available and not expired
    if (isAppOpenAdAvailable) {
      print('[AppOpenAd] Ad already available and not expired. Skipping load.');
      return;
    }

    print('[AppOpenAd] Loading App Open Ad with ID: $openAdUnitId');

    AppOpenAd.load(
      adUnitId: openAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isOpenAdAvailable = true;
          _appOpenLoadTime = DateTime.now();
          print(
            '[AppOpenAd] ✅ App Open Ad loaded successfully at $_appOpenLoadTime',
          );

          // Set up fullscreen callback here to handle disposal
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              print('[AppOpenAd] Ad dismissed');
              _disposeOpenAd();
              // Preload next ad
              Future.delayed(Duration(seconds: 1), () {
                precacheOpenAd();
              });
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              print('[AppOpenAd] ❌ Failed to show: ${error.message}');
              _disposeOpenAd();
              // Preload next ad
              Future.delayed(Duration(seconds: 1), () {
                precacheOpenAd();
              });
            },
            onAdShowedFullScreenContent: (ad) {
              print('[AppOpenAd] Ad showed full screen content');
            },
          );
        },
        onAdFailedToLoad: (error) {
          _disposeOpenAd();
          print('[AppOpenAd] ❌ Failed to load: ${error.message}');

          // Retry after delay
          Future.delayed(Duration(seconds: 5), () {
            precacheOpenAd();
          });
        },
      ),
    );
  }

  static void _disposeOpenAd() {
    _appOpenAd?.dispose();
    _appOpenAd = null;
    _isOpenAdAvailable = false;
    _appOpenLoadTime = null;
  }

  static void showOpenAd({required VoidCallback onComplete}) {
    if (Config.hideAds) {
      print('[AppOpenAd] Ads hidden. Skipping show.');
      onComplete();
      return;
    }

    if (!isAppOpenAdAvailable) {
      print(
        '[AppOpenAd] ❗ Ad not ready or expired. Loading new ad and calling onComplete().',
      );
      precacheOpenAd();
      onComplete();
      return;
    }

    print('[AppOpenAd] ✅ Showing App Open Ad');

    // Store callback to call after ad is dismissed
    final originalCallback = _appOpenAd!.fullScreenContentCallback;
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        print('[AppOpenAd] Ad dismissed - calling onComplete');
        originalCallback?.onAdDismissedFullScreenContent?.call(ad);
        onComplete();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('[AppOpenAd] ❌ Failed to show: ${error.message}');
        originalCallback?.onAdFailedToShowFullScreenContent?.call(ad, error);
        onComplete();
      },
      onAdShowedFullScreenContent: (ad) {
        print('[AppOpenAd] Ad showed full screen content');
        originalCallback?.onAdShowedFullScreenContent?.call(ad);
      },
    );

    _appOpenAd!.show();
  }

  //*****************Banner Ad******************
  /// Tải trước Banner Ad để sẵn sàng hiển thị.
  static void precacheBannerAd() {
    log('Precache Banner Ad - Id: ${Config.bannerAd}');

    if (Config.hideAds) return;

    _bannerAd = BannerAd(
      adUnitId: Config.bannerAd,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          log('$BannerAd loaded.');
          _bannerAdLoaded = true;
        },
        onAdFailedToLoad: (ad, error) {
          disposeBannerAd();
          log('$BannerAd failed to load: $error');
        },
      ),
    )..load();
  }

  static void disposeBannerAd() {
    _bannerAd?.dispose();
    _bannerAd = null;
    _bannerAdLoaded = false;
  }

  static BannerAd? loadBannerAd({required BannerAdController baController}) {
    log('Banner Ad Id : ${Config.bannerAd}');

    if (Config.hideAds) return null;

    if (_bannerAdLoaded && _bannerAd != null) {
      baController.baLoaded.value = true;
      return _bannerAd;
    }
    return BannerAd(
      size: AdSize.banner,
      adUnitId: Config.bannerAd,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          log('$BannerAd loaded.');
          baController.baLoaded.value = true;
          disposeBannerAd();
          precacheBannerAd();
        },
        onAdFailedToLoad: (ad, error) {
          disposeBannerAd();
          log('$BannerAd failed to load: $error');
        },
      ),
      request: const AdRequest(),
    )..load();
  }
}
