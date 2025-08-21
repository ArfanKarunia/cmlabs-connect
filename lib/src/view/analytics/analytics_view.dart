import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/fontstyle.dart';
import '../../controllers/analytics/analytics_controller.dart';
import '../../widgets/analytics/quotation_traffic_card.dart';
import '../../widgets/analytics/quotation_trends_card.dart';
import '../../widgets/analytics/top_pics_card.dart';
import '../../widgets/analytics/top_services_card.dart';

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({super.key});

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView> {
  final AnalyticsController controller = Get.find<AnalyticsController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Page Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('Analytics', style: bold.copyWith(fontSize: 20)),
        ),

        const SizedBox(height: 20),

        // Page Content
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: const [
              QuotationTrafficCard(showViewDetails: true),
              SizedBox(height: 20),
              TopServicesCard(showViewDetails: true),
              SizedBox(height: 20),
              TopPICsCard(showViewDetails: true),
              SizedBox(height: 20),
              QuotationTrendsCard(showViewDetails: true),
              SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
