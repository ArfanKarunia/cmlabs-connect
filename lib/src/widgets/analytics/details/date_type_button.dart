import 'package:flutter/material.dart';

import '../../../constant/fontstyle.dart';
import '../../../utils/color.dart';

class DateTypeButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;
  const DateTypeButton({super.key, required this.title, required this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: isSelected ? AppColors.primary : AppColors.inactiveOption)),
            color: isSelected ? AppColors.bgPrimary : null,
          ),
          child: Text(
            title,
            style: semibold.copyWith(color: isSelected ? AppColors.primary : AppColors.text_2),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
