import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constant/fontstyle.dart';
import '../../controllers/analytics/analytics_controller.dart';
import '../../controllers/analytics/top_pics/top_pics_controller.dart';
import '../../models/analytics/top_pics_model.dart';
import '../../routes.dart';
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
  String? _selectedPIC;

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
        List<TopPICsData> rawData = controller.topPICs.value?.topPics ?? [];
        List<TopPICsData> filteredData = [];

        if (controller.isLoading.value) {
          return ChartLoadingCard(
            title: 'Top PICs',
            subtitle: controller.getChartSubtitle(controller.selectedDateType.value ?? DateType.weekly),
            onTapViewDetails: widget.showViewDetails ? () => Get.toNamed(AppRoutes.detailTopPICsView) : null,
          );
        }

        if (_selectedPIC == null) {
          filteredData = rawData;
        } else {
          filteredData = rawData.where((picData) => picData.picName == _selectedPIC).toList();
        }

        int totalFilteredQuotations = filteredData.fold(0, (sum, item) => sum + item.quotationCount);
        if (totalFilteredQuotations == 0) {
          return ChartEmptyCard(
            title: 'Top PICs',
            subtitle: controller.getChartSubtitle(controller.selectedDateType.value ?? DateType.weekly),
            onTapViewDetails: widget.showViewDetails ? () => Get.toNamed(AppRoutes.detailTopPICsView) : null,
          );
        }

        List<TopPICsData> chartDataWithPercentages = filteredData.map((picData) {
          double percentage =
              totalFilteredQuotations > 0 ? (picData.quotationCount / totalFilteredQuotations) * 100 : 0;
          return TopPICsData(
            picName: picData.picName,
            quotationCount: picData.quotationCount,
            newCount: picData.newCount,
            followedUp: picData.followedUp,
            accepted: picData.accepted,
            rejected: picData.rejected,
            onHold: picData.onHold,
            percentage: percentage,
          );
        }).toList();

        return ChartCard(
          title: 'Top PICs',
          subtitle: controller.getChartSubtitle(controller.selectedDateType.value ?? DateType.weekly),
          chart: SfCircularChart(
            tooltipBehavior: TooltipBehavior(enable: true),
            series: [
              DoughnutSeries<TopPICsData, String>(
                dataSource: chartDataWithPercentages,
                xValueMapper: (d, _) => formatPICName(d.picName),
                yValueMapper: (d, _) => d.quotationCount,
                pointColorMapper: (d, i) => colors[rawData.indexOf(
                  rawData.firstWhere((element) => element.picName == d.picName),
                )],
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
            rawData.length,
            (index) {
              String picName = rawData[index].picName;
              return ChartDataDescription(
                label: formatPICName(picName),
                color: colors[index],
                isSelected: _selectedPIC == null || _selectedPIC == picName,
                onTap: () {
                  setState(() => _selectedPIC = _selectedPIC == picName ? null : picName);
                },
              );
            },
          ),
          onTapViewDetails: widget.showViewDetails ? () => Get.toNamed(AppRoutes.detailTopPICsView) : null,
          onTapExport: () async {
            await controller.exportData();
            Get.back();
          },
        );
      },
    );
  }

  String formatPICName(String picName) {
    return StringUtils.toTitleCase(picName.replaceAll('_', ' '));
  }
}
