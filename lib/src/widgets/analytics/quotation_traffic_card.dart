import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../controllers/analytics/analytics_controller.dart';
import '../../controllers/analytics/quotation_traffic/quotation_traffic_controller.dart';
import '../../routes.dart';
import '../../utils/color.dart';
import 'charts_card.dart';

class QuotationTrafficCard extends StatefulWidget {
  final bool showViewDetails;
  const QuotationTrafficCard({super.key, this.showViewDetails = false});

  @override
  State<QuotationTrafficCard> createState() => _QuotationTrafficCardState();
}

class _QuotationTrafficCardState extends State<QuotationTrafficCard> {
  final controller = Get.find<QuotationTrafficController>();

  String? selectedCategory;
  List<Color> colors = [
    const Color(0xFFD1EBFF),
    const Color(0xFFAFDAFF),
    const Color(0xFF8DC9FF),
    const Color(0xFF6BB8FF),
    const Color(0xFF66B5FF),
    const Color(0xFF49A7FF),
    AppColors.primary,
    const Color(0xFF3A86CC),
    const Color(0xFF2B6599),
    const Color(0xFF1C4466),
    const Color(0xFF0D2233),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        List<QuotationTrafficModified> chartData = _parseChartData();
        List<String> sources = _extractAllSources(chartData);

        return controller.quotationTraffic.value == null || controller.quotationTraffic.value?.totalQuotation == 0
            ? EmptyChartCard(
                title: 'Quotation Traffic',
                subtitle: controller.getChartSubtitle(controller.selectedDateType.value ?? DateType.daily),
                onTapViewDetails:
                    widget.showViewDetails ? () => Get.toNamed(AppRoutes.detailQuotationTrafficView) : null,
              )
            : ChartCard(
                title: 'Quotation Traffic',
                subtitle: controller.getChartSubtitle(controller.selectedDateType.value ?? DateType.daily),
                value: '${controller.quotationTraffic.value?.totalQuotation} Quotations',
                chart: SfCartesianChart(
                  primaryXAxis: const CategoryAxis(),
                  primaryYAxis: const NumericAxis(minimum: 0, interval: 20),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: _buildStackedBarSeries(chartData, sources),
                ),
                chartDescriptions: List.generate(
                  sources.length,
                  (index) => ChartDataDescription(
                    label: _formatSourceName(sources[index]),
                    color: colors[index],
                    isSelected: selectedCategory == sources[index],
                    onTap: () {
                      setState(() => selectedCategory = selectedCategory == sources[index] ? null : sources[index]);
                    },
                  ),
                ),
                onTapViewDetails:
                    widget.showViewDetails ? () => Get.toNamed(AppRoutes.detailQuotationTrafficView) : null,
                onTapExport: () async {
                  await controller.exportData();
                  Get.back();
                },
              );
      },
    );
  }

  List<QuotationTrafficModified> _parseChartData() {
    List<QuotationTrafficModified> data = [];

    if (controller.quotationTraffic.value != null) {
      for (int i = 0;
          i < controller.quotationTraffic.value!.labels.length && i < controller.quotationTraffic.value!.data.length;
          i++) {
        Map<String, dynamic> perSource =
            Map<String, dynamic>.from(controller.quotationTraffic.value!.data[i].perSource);
        // int total = widget.data.data[i].total;

        // Convert all values to int and clean up source names
        Map<String, int> sourceValues = {};
        perSource.forEach((key, value) {
          sourceValues[key] = (value is int) ? value : int.tryParse(value.toString()) ?? 0;
        });

        data.add(QuotationTrafficModified(
          date: controller.quotationTraffic.value!.labels[i],
          sourceValues: sourceValues,
        ));
      }
    }

    return data;
  }

  List<String> _extractAllSources(List<QuotationTrafficModified> chartData) {
    Set<String> allSources = {};

    for (QuotationTrafficModified dataPoint in chartData) {
      allSources.addAll(dataPoint.sourceValues.keys);
    }

    return allSources.toList();
  }

  List<StackedBarSeries<QuotationTrafficModified, String>> _buildStackedBarSeries(
    List<QuotationTrafficModified> chartData,
    List<String> sources,
  ) {
    List<StackedBarSeries<QuotationTrafficModified, String>> series = [];

    for (int i = 0; i < sources.length; i++) {
      String source = sources[i];
      if (selectedCategory == null || selectedCategory == source) {
        series.add(
          StackedBarSeries<QuotationTrafficModified, String>(
            dataSource: chartData,
            xValueMapper: (QuotationTrafficModified data, _) => _formatDate(data.date),
            yValueMapper: (QuotationTrafficModified data, _) => data.getValueForSource(source),
            name: _formatSourceName(source),
            color: colors[i],
            emptyPointSettings: EmptyPointSettings(
              mode: EmptyPointMode.zero,
              color: colors[i].withValues(alpha: 0.1),
            ),
            // dataLabelSettings: DataLabelSettings(
            //   isVisible: true,
            //   textStyle: regular.copyWith(fontSize: 12, color: Colors.white),
            // ),
          ),
        );
      }
    }

    return series;
  }

  String _formatSourceName(String source) {
    return source
        .split(' & ')
        .map((word) => word.split(' ').map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1)).join(' '))
        .join(' & ');
  }

  String _formatDate(String fullDate) {
    List<String> parts = fullDate.split(', ');
    if (parts.length >= 2) {
      List<String> dateParts = parts[1].split('-');
      if (dateParts.length == 3) {
        return '${dateParts[1]}-${dateParts[2]}';
      }
      return parts[1];
    }
    return fullDate;
  }
}

class QuotationTrafficModified {
  final String date;
  final Map<String, int> sourceValues;
  const QuotationTrafficModified({required this.date, required this.sourceValues});

  int getValueForSource(String source) {
    return sourceValues[source] ?? 0;
  }
}
