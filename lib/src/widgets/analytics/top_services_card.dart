import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constant/fontstyle.dart';
import '../../controllers/analytics/analytics_controller.dart';
import '../../controllers/analytics/top_services/top_services_controller.dart';
import '../../models/analytics/top_services_model.dart';
import '../../routes.dart';
import 'charts_card.dart';

class TopServicesCard extends StatefulWidget {
  final bool isDetail;
  const TopServicesCard({super.key, this.isDetail = false});

  @override
  State<TopServicesCard> createState() => _TopServicesCardState();
}

class _TopServicesCardState extends State<TopServicesCard> {
  final controller = Get.find<TopServicesController>();

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
  Widget build(BuildContext context) {
    return Obx(
      () {
        _isVisible = List.filled(controller.topServices.value?.topServices.length ?? 0, true);

        return controller.topServices.value == null || controller.topServices.value?.topServices.isEmpty == true
            ? EmptyChartCard(
                title: 'Top Services',
                subtitle: controller.getChartSubtitle(controller.selectedDateType.value ?? DateType.weekly),
              )
            : ChartCard(
                title: 'Top Services',
                subtitle: controller.getChartSubtitle(controller.selectedDateType.value ?? DateType.weekly),
                chart: SfCircularChart(
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: [
                    DoughnutSeries<TopServicesData, String>(
                      dataSource: List.generate(
                        controller.topServices.value?.topServices.length ?? 0,
                        (i) => _isVisible[i]
                            ? controller.topServices.value?.topServices[i] ??
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
                  controller.topServices.value?.topServices.length ?? 0,
                  (index) => ChartDataDescription(
                    label: _formatServiceName(controller.topServices.value?.topServices[index].serviceName ?? ''),
                    color: colors[index],
                    isSelected: _isVisible[index],
                    onTap: () {
                      setState(() => _isVisible[index] = !_isVisible[index]);
                    },
                  ),
                ),
                isDetail: widget.isDetail,
                onTapDetails: () => Get.toNamed(AppRoutes.detailQuotationTrafficView),
              );
      },
    );
  }

  String _formatServiceName(String name) {
    return name.split('-').map((word) => word.isEmpty ? word : word[0].toUpperCase() + word.substring(1)).join(' ');
  }
}
