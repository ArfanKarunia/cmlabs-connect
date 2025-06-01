import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/src/controllers/analytics/analytics_controller.dart'; 
import 'quotation_filter_page.dart'; 

class QuotationOverviewPage extends StatefulWidget {
  const QuotationOverviewPage({super.key});

  @override
  State<QuotationOverviewPage> createState() => _QuotationOverviewPageState();
}

class _QuotationOverviewPageState extends State<QuotationOverviewPage> {

  final AnalyticsController analyticsController = Get.find<AnalyticsController>();

  String _getSortOptionDisplayText(SortOption? option) {
    switch (option) {
      case SortOption.newestDate:
        return 'Newest Date';
      case SortOption.oldestDate:
        return 'Oldest Date';
      case SortOption.newMost:
        return 'New (Most)';
      case SortOption.newLeast:
        return 'New (Least)';
      case SortOption.acceptedMost:
        return 'Accepted (Most)';
      case SortOption.acceptedLeast:
        return 'Accepted (Least)';
      case SortOption.rejectedMost:
        return 'Rejected (Most)';
      case SortOption.rejectedLeast:
        return 'Rejected (Least)';
      case SortOption.followUpMost:
        return 'Follow-Up (Most)';
      case SortOption.followUpLeast:
        return 'Follow-Up (Least)';
      case SortOption.totalMost:
        return 'Most Total Quotations';
      case SortOption.totalLeast:
        return 'Least Total Quotations';
      default:
        return 'Newest Date'; 
    }
  }

  // Navigasi Ke Filter
  void _showFilterModal(BuildContext context) {
    Get.to(() => QuotationFilterPage()); 
  }
  // END


  void _showSortModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, 
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Sort by', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  const Text('Dates', style: TextStyle(fontWeight: FontWeight.bold)),
                  _buildRadioOption('Newest Date', SortOption.newestDate),
                  _buildRadioOption('Oldest Date', SortOption.oldestDate),
                  const SizedBox(height: 16),
                  const Text('Quotation Count per Status', style: TextStyle(fontWeight: FontWeight.bold)),
                  _buildRadioOption('New (Most)', SortOption.newMost),
                  _buildRadioOption('New (Least)', SortOption.newLeast),
                  _buildRadioOption('Accepted (Most)', SortOption.acceptedMost),
                  _buildRadioOption('Accepted (Least)', SortOption.acceptedLeast),
                  _buildRadioOption('Rejected (Most)', SortOption.rejectedMost),
                  _buildRadioOption('Rejected (Least)', SortOption.rejectedLeast),
                  _buildRadioOption('Follow-Up (Most)', SortOption.followUpMost),
                  _buildRadioOption('Follow-Up (Least)', SortOption.followUpLeast),
                  const SizedBox(height: 16),
                  const Text('Total Quotations', style: TextStyle(fontWeight: FontWeight.bold)),
                  _buildRadioOption('Most Total Quotations', SortOption.totalMost),
                  _buildRadioOption('Least Total Quotations', SortOption.totalLeast),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        );
      },
    );
  }

  
  Widget _buildRadioOption(String label, SortOption value) {
    return Obx(
      () => RadioListTile<SortOption>(
        title: Text(label),
        value: value,
        groupValue: analyticsController.selectedSortOption.value,
        onChanged: (SortOption? newOption) {
          if (newOption != null) {
            analyticsController.setSelectedSortOption(newOption);
            Navigator.pop(context); 
          }
        },
      ),
    );
  }


  Widget _buildFilterButton(String title, SortOption option) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          analyticsController.setSelectedSortOption(option); 
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: analyticsController.selectedSortOption.value == option
                ? Colors.blue
                : const Color(0xFFF0F0F0), 
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            title,
            style: TextStyle(
              color: analyticsController.selectedSortOption.value == option
                  ? Colors.white
                  : const Color(0xFF777777), 
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        titleSpacing: 0,
        title: const Text(
          'Quotation Overview',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        actions: [
          // --- IKON FILTER BARU ---
          IconButton(
            icon: Image.asset(
              'assets/icons/icon_filter.png',
              width: 32,
              height: 32,
            ),
            onPressed: () => _showFilterModal(context), // Memanggil modal filter baru
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // Pastikan konten sejajar kiri
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '150 ',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextSpan(
                        text: 'Leads',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'View all',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12), 
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: [
                
                Row(
                  mainAxisSize: MainAxisSize.min, 
                  children: [
                    _buildFilterButton('Newest', SortOption.newestDate), 
                    const SizedBox(width: 8),
                    _buildFilterButton('Most', SortOption.totalMost), 
                    const SizedBox(width: 8),
                    _buildFilterButton('Least', SortOption.totalLeast), 
                  ],
                ),
                // KANAN: Dropdown "Sort by"
                GestureDetector(
                  onTap: () => _showSortModal(context),
                  
                  child: Row(
                    mainAxisSize: MainAxisSize.min, // Agar Row hanya selebar kontennya
                    children: [
                      Text(
                        'Sort by',
                        style: TextStyle(
                          color: Color(0xFF808080), // Warna HEX #808080
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: Color(0xFF808080), // Warna HEX #808080 untuk ikon juga
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16), // Spasi sebelum quotation cards

            // Contoh _buildQuotationCard(s)
            _buildQuotationCard(
              date: 'Monday, 24 March 2025',
              totalQuotation: 53,
              newCount: 9,
              acceptedCount: 33,
              followedUpCount: 11,
              rejectedCount: 2,
            ),
            _buildQuotationCard(
              date: 'Sunday, 23 March 2025',
              totalQuotation: 14,
              newCount: 9,
              acceptedCount: 33,
              followedUpCount: 11,
              rejectedCount: 2,
            ),
            // ... (sisa widget _buildQuotationCard Anda)
          ],
        ),
      ),
    );
  }

  // Metode _buildQuotationCard dan _buildStatusBadge tetap sama seperti sebelumnya
  Widget _buildQuotationCard({
    required String date,
    required int totalQuotation,
    required int newCount,
    required int acceptedCount,
    required int followedUpCount,
    required int rejectedCount,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              date,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF202124),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Total Quotation : $totalQuotation',
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatusBadge('New', newCount, Colors.blue.shade50, Colors.blue),
                    const SizedBox(height: 12),
                    _buildStatusBadge('Accepted', acceptedCount, Colors.green.shade50, Colors.green),
                  ],
                ),
                const SizedBox(width: 24),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildStatusBadge('Followed Up', followedUpCount, Colors.orange.shade50, Colors.orange),
                    const SizedBox(height: 12),
                    _buildStatusBadge('Rejected', rejectedCount, Colors.red.shade50, Colors.red),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String label, int count, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white38,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ],
      ),
    );
  }
}