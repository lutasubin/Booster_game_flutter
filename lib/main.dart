import 'package:booster_game/booster_app.dart';
import 'package:booster_game/helper/gg_ads/ads_setup.dart';
import 'package:booster_game/helper/remote_config/firebase_config.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);


   //firebase initialization
  await Firebase.initializeApp();

  //initializing remote config
  await Config.initConfig();

  await AdHelper.initAds();


  //for setting orientation to portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((v) {
    runApp(const BoosterApp());
  });
}
