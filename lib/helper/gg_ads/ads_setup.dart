import 'dart:developer';
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
        factoryId: 'customNativeAd')
      ..load();
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
        adUnitId: Config.nativeAd,
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
        factoryId: 'customNativeAdMedium') // Sử dụng medium factory
      ..load();
  }

   //*****************Native Ad Full******************

  /// Tải và trả về một quảng cáo tự nhiên full-screen height container.
  /// Sử dụng factory riêng cho layout full.
  static NativeAd? loadNativeAdFull({required NativeAdController adController}) {
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
        factoryId: 'customNativeAdFull')
      ..load();
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
}
