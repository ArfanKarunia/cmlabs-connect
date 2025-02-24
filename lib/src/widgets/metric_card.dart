import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../constant/fontstyle.dart';
import '../utils/color.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.count,
    required this.nameMetric,
    required this.color,
  });

  final int count;
  final String nameMetric;
  final Color color;

  @override
  Widget build(BuildContext context) {
    var label = "$count";

    if (nameMetric == "New Leads" && count > 10) {
      label = "10+";
    }

    if (nameMetric == "Followed Up" && count > 50) {
      label = "50+";
    }

    if (nameMetric == "Accepted" && count > 100) {
      label = "100+";
    }

    if (nameMetric == "Last 30 Day" && count > 100) {
      label = "100+";
    }

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: bold.copyWith(
                    fontSize: 20,
                    color: color,
                  ),
                ),
                Text(
                  nameMetric,
                  style: regular.copyWith(
                    fontSize: 12,
                    color: AppColors.text_3,
                  ),
                ),
              ],
            ),
            const Icon(
              Ionicons.briefcase_outline,
              color: AppColors.text_1,
              size: 35,
            ),
          ],
        ),
      ),
    );
  }
}
