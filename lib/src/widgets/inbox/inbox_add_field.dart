import 'package:flutter/material.dart';

import '../../constant/fontstyle.dart';
import '../../utils/color.dart';

class InboxAddField extends StatelessWidget {
  final String title;
  final bool isRequired;
  final Widget child;
  const InboxAddField({
    super.key,
    required this.title,
    this.isRequired = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: title,
            children: isRequired
                ? [
                    TextSpan(
                      text: '*',
                      style: bold.copyWith(color: AppColors.danger),
                    ),
                  ]
                : null,
          ),
          style: bold,
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class InboxTextOnField extends StatelessWidget {
  final String title;
  final Map<String, String>? selected;
  const InboxTextOnField({super.key, required this.title, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
      child: Text(
        selected?['label'] ?? title,
        style: regular.copyWith(color: selected != null ? AppColors.text_1 : AppColors.text_3),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
