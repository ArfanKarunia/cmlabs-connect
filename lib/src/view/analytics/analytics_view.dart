import 'package:flutter/material.dart';

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
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar('Analytics'),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: const [
          QuotationTrafficCard(),
          SizedBox(height: 20),
          TopServicesCard(),
          SizedBox(height: 20),
          TopPICsCard(),
          SizedBox(height: 20),
          QuotationTrendsCard(),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
