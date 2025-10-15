import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CustomHeaderSetting extends StatelessWidget {
  const CustomHeaderSetting({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Get.back();
            },
            child: SvgPicture.asset('assets/icons/back.svg'),
          ),
          SizedBox(width: 30),
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
        ],
      ),
    );
  }
}
