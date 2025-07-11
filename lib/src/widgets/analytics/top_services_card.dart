import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../constant/fontstyle.dart';
import '../../controllers/analytics/analytics_controller.dart';
import '../../controllers/analytics/top_services/top_services_controller.dart';
import '../../models/analytics/top_services_model.dart';
import '../../routes.dart';
import '../../utils/string_utils.dart';
import 'charts_card.dart';

class TopServicesCard extends StatefulWidget {
  final bool showViewDetails;
  const TopServicesCard({super.key, this.showViewDetails = false});

  @override
  State<TopServicesCard> createState() => _TopServicesCardState();
}

class _TopServicesCardState extends State<TopServicesCard> {
  final controller = Get.find<TopServicesController>();

String? _selectedService;

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
    _selectedService = null; // Inisialisasi: semua service ditampilkan
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        List<TopServicesData> rawData = controller.topServices.value?.topServices ?? [];
        List<TopServicesData> filteredData = [];

        if (_selectedService == null) {
          // Jika tidak ada service yang dipilih, tampilkan semua data asli
          filteredData = rawData;
        } else {
          // Jika ada service yang dipilih, hanya tampilkan service tersebut
          filteredData = rawData
              .where((serviceData) => serviceData.serviceName == _selectedService)
              .toList();
        }

        // Hitung total kuotasi dari data yang sudah difilter
        int totalFilteredQuotations = filteredData.fold(0, (sum, item) => sum + item.quotationCount);

        // Jika tidak ada data atau total kuotasi 0 setelah filter, tampilkan EmptyChartCard
        if (totalFilteredQuotations == 0) {
          return EmptyChartCard(
            title: 'Top Services',
            subtitle: controller.getChartSubtitle(controller.selectedDateType.value ?? DateType.weekly),
            onTapViewDetails: widget.showViewDetails ? () => Get.toNamed(AppRoutes.detailTopServicesView) : null,
          );
        }

        // Hitung ulang persentase untuk data yang difilter agar akurat
        List<TopServicesData> chartDataWithPercentages = filteredData.map((serviceData) {
          // Pastikan tidak ada pembagian dengan nol
          double percentage = totalFilteredQuotations > 0 ? (serviceData.quotationCount / totalFilteredQuotations) * 100 : 0;
          return TopServicesData(
            serviceName: serviceData.serviceName,
            quotationCount: serviceData.quotationCount,
            percentage: percentage,
          );
        }).toList();

        return ChartCard(
          title: 'Top Services',
          subtitle: controller.getChartSubtitle(controller.selectedDateType.value ?? DateType.weekly),
          chart: SfCircularChart(
            tooltipBehavior: TooltipBehavior(enable: true),
            series: [
              DoughnutSeries<TopServicesData, String>(
                dataSource: chartDataWithPercentages,
                xValueMapper: (d, _) => formatServiceName(d.serviceName),
                yValueMapper: (d, _) => d.quotationCount,
                pointColorMapper: (d, i) => colors[rawData.indexOf(rawData.firstWhere((element) => element.serviceName == d.serviceName))], // Pastikan warna konsisten
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
              String serviceName = rawData[index].serviceName;
              return ChartDataDescription(
                label: formatServiceName(serviceName),
                color: colors[index],
                // isSelected berarti item ini sedang dipilih secara eksklusif,
                // atau jika tidak ada yang dipilih (_selectedService == null)
                // maka semua item dianggap terpilih (untuk highlight)
                isSelected: _selectedService == null || _selectedService == serviceName,
                onTap: () {
                  setState(() {
                    if (_selectedService == serviceName) {
                      _selectedService = null; // Jika yang diklik sama, reset (tampilkan semua)
                    } else {
                      _selectedService = serviceName; // Jika yang diklik berbeda, pilih item ini saja
                    }
                  });
                },
              );
            },
          ),
          onTapViewDetails: widget.showViewDetails ? () => Get.toNamed(AppRoutes.detailTopServicesView) : null,
        );
      },
    );
  }

  String formatServiceName(String serviceName) {
    return StringUtils.toTitleCase(serviceName.replaceAll('_', ' '));
  }
}
