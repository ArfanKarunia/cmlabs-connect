import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../constant/fontstyle.dart';
import '../utils/color.dart';

class TagButton extends StatelessWidget {
  final String statusLabel;
  final VoidCallback? onPressed;
  const TagButton({
    super.key,
    required this.statusLabel,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.bgPrimary,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: onPressed,
            child: const Icon(Ionicons.close_outline, size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            statusLabel,
            style: regular.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
