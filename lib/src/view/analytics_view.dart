import 'package:flutter/material.dart';

import '../widgets/charts_card.dart';

class AnalyticsView extends StatelessWidget {
  const AnalyticsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Analytics',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 4,
        // ignore: deprecated_member_use
        shadowColor: Colors.grey.withOpacity(0.1), // Menambahkan shadow pada AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ChartCard(
              title: 'Quotation Traffic Analytics',
              subtitle: 'This Week',
              value: '85 Quotations',
              chartType: ChartType.quotationTraffic,
            ),
            const SizedBox(height: 20),
            ChartCard(
              title: 'Top Services',
              subtitle: 'This Week',
              chartType: ChartType.topServices,
              value: '',
            ),
            const SizedBox(height: 20),
            ChartCard(
              title: 'Top PIC',
              subtitle: 'This Week',
              value: '',
              chartType: ChartType.topPic,
            ),
            const SizedBox(height: 20),
            ChartCard(
              title: 'Quotation Trends Analytics',
              subtitle: 'This Year',
              value: '12 Months',
              chartType: ChartType.quotationTrends,
            ),
          ],
        ),
      ),
    );
  }
}
