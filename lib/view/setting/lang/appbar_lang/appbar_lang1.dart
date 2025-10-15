import 'package:booster_game/view/welcome_game/welcome.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CustomHeaderLang1 extends StatelessWidget {
  const CustomHeaderLang1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'language_setting'.tr, // lấy từ file dịch
            style: const TextStyle(
              fontFamily: 'Play',
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),

         InkWell(
          onTap: (){
              Get.offAll(WelcomeScreen());
          },
          child: SvgPicture.asset('assets/icons/next.svg'),
         )
        ],
      ),
    );
  }
}
