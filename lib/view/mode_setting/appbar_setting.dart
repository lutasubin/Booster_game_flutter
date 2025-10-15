import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CustomHeaderModeSetting extends StatelessWidget {
  const CustomHeaderModeSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'setting'.tr,
            style: TextStyle(
              fontFamily: 'Play',
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: SvgPicture.asset('assets/icons/Save.svg'),
          ),
        ],
      ),
    );
  }
}
