import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constant/fontstyle.dart';
import '../../models/analytics/top_services_model.dart';
import '../../routes.dart';
import 'charts_card.dart';

class TopServicesCard extends StatefulWidget {
  final TopServices? data;
  const TopServicesCard({super.key, this.data});

  @override
  State<TopServicesCard> createState() => _TopServicesCardState();
}

class _TopServicesCardState extends State<TopServicesCard> {
  late List<bool> _isVisible;
  List<Color> colors = [
    const Color(0xFFFFB300), // Deep amber yellow
    const Color(0xFFFFA000), // Dark amber
    const Color(0xFFFF8F00), // Orange amber
    const Color(0xFFFF6F00), // Deep orange amber
    const Color(0xFFFB8C00), // Dark orange
    const Color(0xFFF57C00), // Deeper orange
    const Color(0xFFEF6C00), // Very deep orange
    const Color(0xFFE65100), // Darkest orange
    const Color(0xFFFFA726), // Medium amber
    const Color(0xFFFFB74D), // Light amber
  ];

  @override
  void initState() {
    super.initState();
    _isVisible = List.filled(widget.data?.topServices.length ?? 0, true);
  }

  @override
  Widget build(BuildContext context) {
    return widget.data == null || widget.data?.topServices.isEmpty == true
        ? const EmptyChartCard(
            title: 'Top Services',
            subtitle: 'This Week',
          )
        : ChartCard(
            title: 'Top Services',
            subtitle: 'This Week',
            chart: SfCircularChart(
              tooltipBehavior: TooltipBehavior(enable: true),
              series: [
                DoughnutSeries<TopServicesData, String>(
                  dataSource: List.generate(
                    widget.data?.topServices.length ?? 0,
                    (i) => _isVisible[i]
                        ? widget.data?.topServices[i] ??
                            TopServicesData(
                              serviceName: '',
                              quotationCount: 0,
                              percentage: 0,
                            )
                        : TopServicesData(
                            serviceName: '',
                            quotationCount: 0,
                            percentage: 0,
                          ),
                  ),
                  xValueMapper: (d, _) => _formatServiceName(d.serviceName),
                  yValueMapper: (d, _) => d.quotationCount,
                  pointColorMapper: (d, i) => colors[i],
                  dataLabelMapper: (d, _) => d.percentage > 0 ? '${d.percentage.toInt()}%' : '',
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    textStyle: bold.copyWith(fontSize: 16, color: Colors.white),
                  ),
                  explode: true,
                )
              ],
            ),
            chartDescriptions: List.generate(
              widget.data?.topServices.length ?? 0,
              (index) => ChartDataDescription(
                label: _formatServiceName(widget.data?.topServices[index].serviceName ?? ''),
                color: colors[index],
                isSelected: _isVisible[index],
                onTap: () {
                  setState(() => _isVisible[index] = !_isVisible[index]);
                },
              ),
            ),
            onTapDetails: () => Get.toNamed(AppRoutes.analyticsDetailView),
          );
  }

  String _formatServiceName(String name) {
    return name.split('-').map((word) => word.isEmpty ? word : word[0].toUpperCase() + word.substring(1)).join(' ');
  }
}
