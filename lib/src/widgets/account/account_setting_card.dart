import 'package:flutter/material.dart';

import '../../utils/color.dart';

class AccountSettingCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;
  const AccountSettingCard({super.key, required this.child, this.margin});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.white_1,
        borderRadius: BorderRadius.circular(5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1E000000),
            offset: Offset(3, 3),
            blurRadius: 5,
          ),
        ],
      ),
      child: child,
    );
  }
}
