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
  void initState() {
    super.initState();
    _selectedPIC = null; // Inisialisasi: semua PIC ditampilkan
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        List<TopPICsData> rawData = controller.topPICs.value?.topPics ?? [];
        List<TopPICsData> filteredData = [];

        if (_selectedPIC == null) {
          // Jika tidak ada PIC yang dipilih, tampilkan semua data asli
          filteredData = rawData;
        } else {
          // Jika ada PIC yang dipilih, hanya tampilkan PIC tersebut
          filteredData = rawData
              .where((picData) => picData.picName == _selectedPIC)
              .toList();
        }

        // Hitung total kuotasi dari data yang sudah difilter
        int totalFilteredQuotations = filteredData.fold(0, (sum, item) => sum + item.quotationCount);

        // Jika tidak ada data atau total kuotasi 0 setelah filter, tampilkan EmptyChartCard
        if (totalFilteredQuotations == 0) {
          return EmptyChartCard(
            title: 'Top PICs',
            subtitle: controller.getChartSubtitle(controller.selectedDateType.value ?? DateType.weekly),
            onTapViewDetails: widget.showViewDetails ? () => Get.toNamed(AppRoutes.detailTopPICsView) : null,
          );
        }

        // Hitung ulang persentase untuk data yang difilter agar akurat
        List<TopPICsData> chartDataWithPercentages = filteredData.map((picData) {
          // Pastikan tidak ada pembagian dengan nol
          double percentage = totalFilteredQuotations > 0 ? (picData.quotationCount / totalFilteredQuotations) * 100 : 0;
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
                pointColorMapper: (d, i) => colors[rawData.indexOf(rawData.firstWhere((element) => element.picName == d.picName))], // Pastikan warna konsisten
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
            rawData.length, // Tetap iterasi semua rawData untuk legend
            (index) {
              String picName = rawData[index].picName;
              return ChartDataDescription(
                label: formatPICName(picName),
                color: colors[index],
                // isSelected berarti item ini sedang dipilih secara eksklusif,
                // atau jika tidak ada yang dipilih (_selectedPIC == null)
                // maka semua item dianggap terpilih (untuk highlight)
                isSelected: _selectedPIC == null || _selectedPIC == picName,
                onTap: () {
                  setState(() {
                    if (_selectedPIC == picName) {
                      _selectedPIC = null; // Jika yang diklik sama, reset (tampilkan semua)
                    } else {
                      _selectedPIC = picName; // Jika yang diklik berbeda, pilih item ini saja
                    }
                  });
                },
              );
            },
          ),
          onTapViewDetails: widget.showViewDetails ? () => Get.toNamed(AppRoutes.detailTopPICsView) : null,
        );
      },
    );
  }

  String formatPICName(String picName) {
    return StringUtils.toTitleCase(picName.replaceAll('_', ' '));
  }
}
