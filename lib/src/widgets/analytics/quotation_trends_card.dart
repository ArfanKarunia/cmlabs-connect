import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controllers/analytics/analytics_controller.dart';
import '../../controllers/analytics/quotation_trends/quotation_trends_controller.dart';
import '../../models/analytics/quotation_trends_model.dart';
import '../../routes.dart';
import '../../utils/color.dart';
import 'charts_card.dart';

class QuotationTrendsCard extends StatefulWidget {
  final bool showViewDetails;
  const QuotationTrendsCard({super.key, this.showViewDetails = false});

  @override
  State<QuotationTrendsCard> createState() => _QuotationTrendsCardState();
}

class _QuotationTrendsCardState extends State<QuotationTrendsCard> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<QuotationTrendsController>();

    return Obx(
      () => controller.data == null || controller.compareLastTwo == null || controller.lineChart == null
          ? EmptyChartCard(
              title: 'Quotation Trends',
              subtitle: controller.getChartSubtitle(controller.selectedDateType.value ?? DateType.monthly),
              onTapViewDetails: widget.showViewDetails ? () => Get.toNamed(AppRoutes.detailQuotationTrendsView) : null,
            )
          : ChartCard(
              title: 'Quotation Trends',
              subtitle: '${controller.compareLastTwo?.fromPeriod} vs ${controller.compareLastTwo?.toPeriod}',
              value: (controller.compareLastTwo?.percentChange ?? 0) > 0
                  ? '+ ${controller.compareLastTwo?.percentChange.toInt()}%'
                  : '${controller.compareLastTwo?.percentChange.toInt()}%',
              valueColor: (controller.compareLastTwo?.percentChange ?? 0) > 0 ? AppColors.green : AppColors.red,
              chart: Column(
                children: [
                  const SizedBox(height: 10),
                  SfCartesianChart(
                    primaryXAxis: const CategoryAxis(),
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CartesianSeries>[
                      LineSeries<QuotationTrendsData, String>(
                        name: 'Total Quotation',
                        dataSource: controller.lineChart,
                        xValueMapper: (d, _) => d.period,
                        yValueMapper: (d, _) => d.count,
                        width: 1.5,
                        markerSettings: const MarkerSettings(isVisible: true),
                        dataLabelSettings: const DataLabelSettings(
                          isVisible: true,
                          labelAlignment: ChartDataLabelAlignment.top,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              chartDescriptions: const [],
              onTapViewDetails: widget.showViewDetails ? () => Get.toNamed(AppRoutes.detailQuotationTrendsView) : null,
            ),
    );
  }
}
