import 'package:flutter/material.dart';

import '../utils/color.dart';
import '../utils/network_image.dart';

class CustomAvatar extends StatelessWidget {
  final String? link;
  final double radius;
  const CustomAvatar({super.key, this.link, this.radius = 20});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.white,
      backgroundImage: link != null
          ? getImageProvider(link.toString())
          : const AssetImage(
              "assets/icons/cmlabs_icon.png",
            ),
    );
  }
}
