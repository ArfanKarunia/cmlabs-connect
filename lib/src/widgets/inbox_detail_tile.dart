import 'package:flutter/material.dart';

import '../constant/fontstyle.dart';
import '../utils/color.dart';

class InboxDetailTile extends StatelessWidget {
  final String title;
  final String content;
  const InboxDetailTile({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: bold.copyWith(
            fontSize: 15,
            color: AppColors.primaryText,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          content,
          style: regular.copyWith(
            fontSize: 13,
            letterSpacing: 0,
          ),
        ),
        // const Divider(thickness: 0.5),
        const SizedBox(height: 6),
      ],
    );
  }
}
