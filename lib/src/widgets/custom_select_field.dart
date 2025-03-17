import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../constant/fontstyle.dart';
import '../utils/color.dart';

class CustomSelectField extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final Widget child;
  final String? errorText;
  const CustomSelectField({
    super.key,
    this.onTap,
    this.icon = Ionicons.chevron_down_outline,
    required this.child,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: errorText != null ? AppColors.danger : AppColors.primaryText),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              children: [
                Expanded(
                  child: child,
                ),
                Icon(icon),
              ],
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              errorText.toString(),
              style: regular.copyWith(color: AppColors.danger),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ]
      ],
    );
  }
}
