import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/analytics/analytics_controller.dart';
import '../../utils/color.dart';
import '../../widgets/analytics/quotation_traffic_card.dart';
import '../../widgets/analytics/quotation_trends_card.dart';
import '../../widgets/analytics/top_pics_card.dart';
import '../../widgets/analytics/top_services_card.dart';
import '../../widgets/default_appbar.dart';

class AnalyticsView extends StatefulWidget {
  const AnalyticsView({super.key});

  @override
  State<AnalyticsView> createState() => _AnalyticsViewState();
}

class _AnalyticsViewState extends State<AnalyticsView> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AnalyticsController>();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar('Analytics'),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          Obx(
            () => QuotationTrafficCard(data: controller.quotationTraffic.value),
          ),
          const SizedBox(height: 20),
          Obx(
            () => TopServicesCard(data: controller.topServices.value),
          ),
          const SizedBox(height: 20),
          Obx(
            () => TopPICsCard(data: controller.topPICs.value),
          ),
          const SizedBox(height: 20),
          Obx(
            () => QuotationTrendsCard(data: controller.quotationTrends.value),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
