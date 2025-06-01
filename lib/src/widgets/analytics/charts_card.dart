// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

import '../../constant/fontstyle.dart';
import '../../utils/color.dart';
import '../empty_state.dart';

class ChartCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String? value;
  final Color? valueColor;
  final VoidCallback? onTapDetails;
  final Widget chart;
  final List<ChartDataDescription> chartDescriptions;
  const ChartCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.value,
    this.valueColor = AppColors.text_2,
    this.onTapDetails,
    required this.chart,
    required this.chartDescriptions,
  });

  @override
  _ChartCardState createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard> {
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
          // Title + Button
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: bold.copyWith(fontSize: 18, color: AppColors.text_1),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      style: regular.copyWith(fontSize: 12, color: AppColors.text_3),
                    ),
                    if (widget.value != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.value!,
                        style: semibold.copyWith(fontSize: 15, color: widget.valueColor),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: widget.onTapDetails,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF31393C),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    'View Details',
                    style: regular.copyWith(fontSize: 12, color: AppColors.white),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),
          widget.chart,

          // if (widget.chartType == ChartType.quotationTraffic) ...[
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 6,
            children: widget.chartDescriptions,
          ),
        ],
        // ],
      ),
    );
  }
}

class ChartDataDescription extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback? onTap;
  const ChartDataDescription({
    super.key,
    required this.label,
    required this.color,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 5, backgroundColor: color),
          const SizedBox(width: 6),
          Text(label, style: isSelected ? bold.copyWith(fontSize: 12) : regular.copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}

class EmptyChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  const EmptyChartCard({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ChartCard(
      title: title,
      subtitle: subtitle,
      chart: const SizedBox(height: 200, child: EmptyState()),
      chartDescriptions: const [],
    );
  }
}
