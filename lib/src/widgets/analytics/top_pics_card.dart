import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constant/fontstyle.dart';
import '../../models/analytics/top_pics_model.dart';
import '../../routes.dart';
import '../../utils/color.dart';
import 'charts_card.dart';

class TopPICsCard extends StatefulWidget {
  final TopPICs data;
  const TopPICsCard({super.key, required this.data});

  @override
  State<TopPICsCard> createState() => _TopPICsCardState();
}

class _TopPICsCardState extends State<TopPICsCard> {
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
  void initState() {
    super.initState();
    _isVisible = List.filled(widget.data.topPics.length, true);
  }

  @override
  Widget build(BuildContext context) {
    return ChartCard(
      title: 'Top Pics',
      subtitle: 'This Week',
      chart: SfCircularChart(
        tooltipBehavior: TooltipBehavior(enable: true),
        series: [
          DoughnutSeries<TopPICsData, String>(
            dataSource: List.generate(
              widget.data.topPics.length,
              (i) => _isVisible[i]
                  ? widget.data.topPics[i]
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
            xValueMapper: (d, _) => _formatPicName(d.picName),
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
        widget.data.topPics.length,
        (index) => ChartDataDescription(
          label: _formatPicName(widget.data.topPics[index].picName),
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

  String _formatPicName(String name) {
    return name.split('-').map((word) => word.isEmpty ? word : word[0].toUpperCase() + word.substring(1)).join(' ');
  }
}
