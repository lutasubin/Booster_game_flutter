import 'package:booster_game/view/setting/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset(
            'assets/icons/gaming_mode.svg',
            height: 18,
            width: 149,
          ),

          InkWell(
            onTap: () {
              Get.to(() => MenuScreen());
            },
            child: SvgPicture.asset('assets/icons/setting.svg'),
          ),
        ],
      ),
    );
  }
}
