import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../constant/fontstyle.dart';
import '../../utils/color.dart';

class QuotationOverviewCard extends StatelessWidget {
  final String date;
  final int totalQuotation;
  final int newCount;
  final int followedUpCount;
  final int acceptedCount;
  final int rejectedCount;
  const QuotationOverviewCard({
    super.key,
    required this.date,
    required this.totalQuotation,
    required this.newCount,
    required this.followedUpCount,
    required this.acceptedCount,
    required this.rejectedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F3F3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            parseDate(date),
            style: bold.copyWith(fontSize: 16),
          ),
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              children: [
                const TextSpan(text: 'Total Quotation : ', style: regular),
                TextSpan(text: totalQuotation.toString(), style: bold),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: QuotationOverviewStatusTile(
                  title: 'New',
                  bgColor: AppColors.bgPrimary,
                  color: AppColors.primary,
                  count: newCount,
                ),
              ),
              Expanded(
                child: QuotationOverviewStatusTile(
                  title: 'Followed Up',
                  bgColor: AppColors.bgInfo,
                  color: AppColors.info,
                  count: followedUpCount,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: QuotationOverviewStatusTile(
                  title: 'Accepted',
                  bgColor: AppColors.bgSuccess,
                  color: AppColors.success,
                  count: acceptedCount,
                ),
              ),
              Expanded(
                child: QuotationOverviewStatusTile(
                  title: 'Rejected',
                  bgColor: AppColors.bgDanger,
                  color: AppColors.danger,
                  count: rejectedCount,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class QuotationOverviewStatusTile extends StatelessWidget {
  final String title;
  final int count;
  final Color bgColor;
  final Color color;
  const QuotationOverviewStatusTile({
    super.key,
    required this.title,
    required this.bgColor,
    required this.color,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        FittedBox(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: bgColor,
            ),
            child: Text(
              title,
              style: regular.copyWith(fontSize: 13, color: color),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          count.toString(),
          style: regular.copyWith(fontSize: 13, color: color),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

String parseDate(String date) {
  try {
    return DateFormat('EEEE, d MMMM y').format(DateTime.parse(date.split(', ')[1]));
  } catch (e) {
    return date;
  }
}
