import 'package:flutter/material.dart';

import '../constant/fontstyle.dart';

class InboxAddSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const InboxAddSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: bold.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}
