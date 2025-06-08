import 'package:flutter/material.dart';

import '../../../constant/fontstyle.dart';
import '../../../utils/color.dart';

class QuickSortButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback? onTap;
  const QuickSortButton({super.key, required this.title, required this.isSelected, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: isSelected ? AppColors.primary : AppColors.inactiveOption,
        ),
        child: Center(
          child: Text(
            title,
            style: regular.copyWith(
              fontSize: 11,
              color: isSelected ? AppColors.white : AppColors.text_3,
            ),
          ),
        ),
      ),
    );
  }
}
