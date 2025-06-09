import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constant/fontstyle.dart';
import '../../controllers/analytics/analytics_controller.dart';
import '../../controllers/analytics/top_pics/top_pics_controller.dart';
import '../../models/analytics/top_pics_model.dart';
import '../../routes.dart';
import '../../utils/color.dart';
import '../../utils/string_utils.dart';
import 'charts_card.dart';

class TopPICsCard extends StatefulWidget {
  final bool showViewDetails;
  const TopPICsCard({super.key, this.showViewDetails = false});

  @override
  State<TopPICsCard> createState() => _TopPICsCardState();
}

class _TopPICsCardState extends State<TopPICsCard> {
  final controller = Get.find<TopPICsController>();

  late List<bool> _isVisible;
  List<Color> colors = [
    const Color(0xFF4596D7),
    const Color(0xFF5FB6FF),
    const Color(0xFF89C4F9),
    const Color(0xFF2A75B3),
    const Color(0xFF1B5C8F),
    const Color(0xFF0D436B),
    const Color(0xFF6EBEFF),
    const Color(0xFF3D8CC7),
    const Color(0xFF9AD2FF),
    const Color(0xFFB5DDFF),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        _isVisible = List.filled(controller.topPICs.value?.topPics.length ?? 0, true);

        return controller.topPICs.value == null || controller.topPICs.value?.topPics.isEmpty == true
            ? EmptyChartCard(
                title: 'Top PICs',
                subtitle: controller.getChartSubtitle(controller.selectedDateType.value ?? DateType.weekly),
                onTapViewDetails: widget.showViewDetails ? () => Get.toNamed(AppRoutes.detailTopPICsView) : null,
              )
            : ChartCard(
                title: 'Top PICs',
                subtitle: controller.getChartSubtitle(controller.selectedDateType.value ?? DateType.weekly),
                chart: SfCircularChart(
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: [
                    DoughnutSeries<TopPICsData, String>(
                      dataSource: List.generate(
                        controller.topPICs.value?.topPics.length ?? 0,
                        (i) => _isVisible[i]
                            ? controller.topPICs.value?.topPics[i] ??
                                TopPICsData(
                                  picName: '',
                                  quotationCount: 0,
                                  newCount: 0,
                                  followedUp: 0,
                                  accepted: 0,
                                  rejected: 0,
                                  onHold: 0,
                                  percentage: 0,
                                )
                            : TopPICsData(
                                picName: '',
                                quotationCount: 0,
                                newCount: 0,
                                followedUp: 0,
                                accepted: 0,
                                rejected: 0,
                                onHold: 0,
                                percentage: 0,
                              ),
                      ),
                      xValueMapper: (d, _) => formatPICName(d.picName),
                      yValueMapper: (d, _) => d.quotationCount,
                      pointColorMapper: (d, i) => colors[i],
                      dataLabelMapper: (d, _) => d.percentage > 0 ? '${d.percentage.toInt()}%' : '',
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        textStyle: bold.copyWith(fontSize: 16, color: AppColors.white),
                      ),
                      explode: true,
                    )
                  ],
                ),
                chartDescriptions: List.generate(
                  controller.topPICs.value?.topPics.length ?? 0,
                  (index) => ChartDataDescription(
                    label: formatPICName(controller.topPICs.value?.topPics[index].picName ?? ''),
                    color: colors[index],
                    isSelected: _isVisible[index],
                    onTap: () {
                      setState(() => _isVisible[index] = !_isVisible[index]);
                    },
                  ),
                ),
                onTapViewDetails: widget.showViewDetails ? () => Get.toNamed(AppRoutes.detailTopPICsView) : null,
              );
      },
    );
  }
}
