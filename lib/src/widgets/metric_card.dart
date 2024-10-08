import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:quotation_app/src/utils/color.dart';

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
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 12,
        ),
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
                  '$count',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '$nameMetric',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.text_3,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Icon(
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
