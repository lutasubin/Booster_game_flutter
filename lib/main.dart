
import 'package:booster_game/booster_app.dart';
import 'package:booster_game/helper/anaylish_firebase/anaylish.dart';
import 'package:booster_game/helper/gg_ads/ads_setup.dart';
import 'package:booster_game/helper/remote_config/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

  //firebase initialization
  await Firebase.initializeApp();

  // ✅ Khai báo thiết bị test
  MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(testDeviceIds: ['24117RN76O']),
  );

  //initializing remote config
  await Config.initConfig();

  //init ads
  await AdHelper.initAds();

  //init storage
  await GetStorage.init();

  // log openApp
  await AnalyticsHelper.logAppOpen();
  

  //for setting orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((v) {
    runApp(const BoosterApp());
  });
}
