// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../pages/quotation_overview_page.dart';

enum ChartType { quotationTraffic, topServices, topPic, quotationTrends }
class _CustomLegendDonutChart extends StatefulWidget {
  final List<_PieData> data;
  final List<Color> colors;

  const _CustomLegendDonutChart({
    required this.data,
    required this.colors,
  });

  @override
  State<_CustomLegendDonutChart> createState() => _CustomLegendDonutChartState();
}

class _CustomLegendDonutChartState extends State<_CustomLegendDonutChart> {
  late List<bool> _isVisible;

  @override
  void initState() {
    super.initState();
    _isVisible = List.filled(widget.data.length, true);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Legend 2 di atas
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildLegendItem(0),
            const SizedBox(width: 16),
            if (widget.data.length > 1) _buildLegendItem(1),
          ],
        ),
        const SizedBox(height: 8),
        // Legend 1 di bawah
        if (widget.data.length > 2)
          Align(
            alignment: Alignment.centerLeft,
            child: _buildLegendItem(2),
          ),
        const SizedBox(height: 8),
        // Donut chart
        SfCircularChart(
          tooltipBehavior: TooltipBehavior(enable: true),
          series: [
            DoughnutSeries<_PieData, String>(
              dataSource: List.generate(widget.data.length,
                  (i) => _isVisible[i] ? widget.data[i] : _PieData('', 0)),
              xValueMapper: (d, _) => d.category,
              yValueMapper: (d, _) => d.value,
              pointColorMapper: (d, i) => widget.colors[i],
              dataLabelMapper: (d, _) => d.value > 0 ? '${d.value.toInt()}%' : '',
              dataLabelSettings: const DataLabelSettings(
                isVisible: true,
                textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              explode: true,
            )
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem(int index) {
    return GestureDetector(
      onTap: () => setState(() => _isVisible[index] = !_isVisible[index]),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(right: 6),
            decoration: BoxDecoration(
              color: widget.colors[index].withOpacity(_isVisible[index] ? 1 : 0.3),
              shape: BoxShape.circle,
            ),
          ),
          Text(
            widget.data[index].category,
            style: TextStyle(
              fontWeight: _isVisible[index] ? FontWeight.w500 : FontWeight.w300,
              color: Colors.black.withOpacity(_isVisible[index] ? 1 : 0.4),
            ),
          ),
        ],
      ),
    );
  }
}

class ChartCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String value;
  final ChartType chartType;

  const ChartCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.chartType,
  });

  @override
  _ChartCardState createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard> {
  String? _selectedCategory;

@override
Widget build(BuildContext context) {
  return Card(
    color: const Color(0xFFF3F3F3),
    elevation: 5,
    shadowColor: Colors.black.withOpacity(0.1),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF31393C),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 36,
                child: ElevatedButton(
                  onPressed: () {
                    if (widget.chartType == ChartType.quotationTraffic) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuotationOverviewPage(),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF31393C),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(fontSize: 12, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(widget.subtitle, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Text(
            widget.value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 16),
          _buildChart(widget.chartType),

          if (widget.chartType == ChartType.quotationTraffic) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              children: [
                _buildLegendCircle('Google & GDN', 'Traffic 1', const Color(0xFF49A7FF)),
                _buildLegendCircle('Meta & CPC', 'Traffic 2', const Color(0xFF007AFF)),
                _buildLegendCircle('GAds & GDN', 'Traffic 3', const Color(0xFF85C1FF)),
              ],
            ),
          ],
        ],
      ),
    ),
  );
}

Widget _buildLegendCircle(String label, String category, Color color) {
  return GestureDetector(
    onTap: () {
      setState(() {
        _selectedCategory = _selectedCategory == category ? null : category;
      });
    },
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          margin: const EdgeInsets.only(right: 6),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontWeight: _selectedCategory == category ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    ),
  );
}
Widget _buildChart(ChartType type) {
  switch (type) {
    case ChartType.quotationTraffic:
      return _quotationTrafficChart();
    case ChartType.topServices:
      return _topServicesChart();
    case ChartType.topPic:
      return _topPicChart();
    case ChartType.quotationTrends:
      return _quotationTrendsChart();
  }
}

Widget _quotationTrafficChart() {
  final List<_TrafficData> data = [
    _TrafficData('02/02', 30, 15, 10),
    _TrafficData('03/02', 28, 20, 12),
    _TrafficData('04/02', 35, 25, 10),
    _TrafficData('05/02', 32, 15, 5),
    _TrafficData('06/02', 33, 20, 8),
    _TrafficData('07/02', 25, 10, 7),
    _TrafficData('08/02', 20, 10, 5),
  ];

  return Column(
    children: [
      _horizontalBarChart(data),
    ],
  );
}

Widget _horizontalBarChart(List<_TrafficData> data) {
  return SfCartesianChart(
    primaryXAxis: CategoryAxis(),
    primaryYAxis: NumericAxis(minimum: 0, interval: 20),
    tooltipBehavior: TooltipBehavior(enable: true),
    series: <CartesianSeries<_TrafficData, String>>[
            if (_selectedCategory == null || _selectedCategory == 'Traffic 3')
        StackedBarSeries<_TrafficData, String>(
          dataSource: data,
          xValueMapper: (d, _) => d.date,
          yValueMapper: (d, _) => d.traffic3,
          name: 'GAds & GDN',
          color: const Color(0xFF8EC5FC),
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(color: Colors.white),
          ),
        ),
      if (_selectedCategory == null || _selectedCategory == 'Traffic 2')
        StackedBarSeries<_TrafficData, String>(
          dataSource: data,
          xValueMapper: (d, _) => d.date,
          yValueMapper: (d, _) => d.traffic2,
          name: 'Meta & CPC',
          color: const Color(0xFF4F8EF5),
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(color: Colors.white),
          ),
        ),
      if (_selectedCategory == null || _selectedCategory == 'Traffic 1')
        StackedBarSeries<_TrafficData, String>(
          dataSource: data,
          xValueMapper: (d, _) => d.date,
          yValueMapper: (d, _) => d.traffic1,
          name: 'Google & GDN',
          color: const Color(0xFF6AA9F8),
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            textStyle: TextStyle(color: Colors.white),
          ),
        ),

    ],
  );
}


Widget _topServicesChart() {
  return _CustomLegendDonutChart(
    data: [
      _PieData('Digital Marketing', 42),
      _PieData('SEO Services', 35),
      _PieData('SEO Content Writing', 27),
    ],
    colors: [
      Color.fromARGB(255, 254, 191, 0),
      Color.fromARGB(255, 255, 205, 55),
      Color.fromARGB(255, 255, 213, 89),
    ],
  );
}

Widget _topPicChart() {
  return _CustomLegendDonutChart(
    data: [
      _PieData('Larasati', 42),
      _PieData('Vanessa', 35),
      _PieData('Agitha Ayudya', 27),
    ],
    colors: [
Color(0xFF4596D7), // Biru agak gelap
Color(0xFF5FB6FF), // Biru standar
Color(0xFF89C4F9), // Biru medium terang
    ],
  );
}


  Widget _quotationTrendsChart() {
    final List<_TrendData> data = [
      _TrendData('JAN', 5),
      _TrendData('FEB', 7),
      _TrendData('MAR', 14),
      _TrendData('APR', 18),
      _TrendData('MAY', 30),
      _TrendData('JUN', 40),
      _TrendData('JUL', 45),
      _TrendData('AUG', 42),
      _TrendData('SEP', 37),
      _TrendData('OKT', 30),
      _TrendData('NOV', 25),
      _TrendData('DES', 28),
    ];

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries>[
        LineSeries<_TrendData, String>(
          dataSource: data,
          xValueMapper: (d, _) => d.month,
          yValueMapper: (d, _) => d.value,
          width: 1.5, // garis lebih tipis
          markerSettings: const MarkerSettings(isVisible: true),
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelAlignment: ChartDataLabelAlignment.top, // label di dalam
          ),
        ),
      ],
    );
  }

}

class _TrafficData {
  final String date;
  final double traffic1;
  final double traffic2;
  final double traffic3;

  _TrafficData(this.date, this.traffic1, this.traffic2, this.traffic3);
}



class _PieData {
  _PieData(this.category, this.value);

  final String category;
  final double value;
}

class _TrendData {
  _TrendData(this.month, this.value);

  final String month;
  final double value;
}
