import 'package:flutter/widgets.dart';
import 'package:ionicons/ionicons.dart';

import '../constant/fontstyle.dart';
import '../utils/color.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Ionicons.briefcase_outline,
            color: AppColors.text_4,
            size: 35,
          ),
          Text(
            'No available data',
            style: bold.copyWith(fontSize: 24, color: AppColors.text_4),
          ),
        ],
      ),
    );
  }
}
