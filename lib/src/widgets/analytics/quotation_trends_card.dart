import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../models/analytics/quotation_trends_model.dart';
import '../../routes.dart';
import '../../utils/color.dart';
import 'charts_card.dart';

class QuotationTrendsCard extends StatelessWidget {
  final QuotationTrends? data;
  const QuotationTrendsCard({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return data == null || data?.compareLastTwo == null || data?.lineChart == null
        ? const EmptyChartCard(
            title: 'Quotation Trends',
            subtitle: 'This Week',
          )
        : ChartCard(
            title: 'Quotation Trends',
            subtitle: '${data?.compareLastTwo.fromPeriod} vs ${data?.compareLastTwo.toPeriod}',
            value: data!.compareLastTwo.percentChange > 0
                ? '+ ${data!.compareLastTwo.percentChange.toInt()}%'
                : '${data!.compareLastTwo.percentChange.toInt()}%',
            valueColor: data!.compareLastTwo.percentChange > 0 ? AppColors.green : AppColors.red,
            chart: Column(
              children: [
                const SizedBox(height: 10),
                SfCartesianChart(
                  primaryXAxis: const CategoryAxis(),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: <CartesianSeries>[
                    LineSeries<QuotationTrendsData, String>(
                      name: 'Total Quotation',
                      dataSource: data!.lineChart,
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
            onTapDetails: () => Get.toNamed(AppRoutes.analyticsDetailView),
          );
  }
}
