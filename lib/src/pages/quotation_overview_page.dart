import 'package:flutter/material.dart';

enum SortOption {
  newestDate,
  oldestDate,
  newMost,
  newLeast,
  acceptedMost,
  acceptedLeast,
  rejectedMost,
  rejectedLeast,
  followUpMost,
  followUpLeast,
  totalMost,
  totalLeast,
}

class QuotationOverviewPage extends StatefulWidget {
  const QuotationOverviewPage({super.key});

  @override
  State<QuotationOverviewPage> createState() => _QuotationOverviewPageState();
}

class _QuotationOverviewPageState extends State<QuotationOverviewPage> {
  void _showSortModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow full height and scroll
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
                  const Text('Sort by', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  const Text('Dates', style: TextStyle(fontWeight: FontWeight.bold)),
                  _buildRadioOption('Newest Date'),
                  _buildRadioOption('Oldest Date'),
                  const SizedBox(height: 16),
                  const Text('Quotation Count per Status', style: TextStyle(fontWeight: FontWeight.bold)),
                  _buildRadioOption('New (Most)'),
                  _buildRadioOption('New (Least)'),
                  _buildRadioOption('Accepted (Most)'),
                  _buildRadioOption('Accepted (Least)'),
                  _buildRadioOption('Rejected (Most)'),
                  _buildRadioOption('Rejected (Least)'),
                  _buildRadioOption('Follow-Up (Most)'),
                  _buildRadioOption('Follow-Up (Least)'),
                  const SizedBox(height: 16),
                  const Text('Total Quotations', style: TextStyle(fontWeight: FontWeight.bold)),
                  _buildRadioOption('Most Total Quotations'),
                  _buildRadioOption('Least Total Quotations'),
                  const SizedBox(height: 32),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildRadioOption(String label) {
    return RadioListTile(
      title: Text(label),
      value: label,
      groupValue: null,
      onChanged: (value) => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      automaticallyImplyLeading: true,
      titleSpacing: 0, // <-- Tambahkan ini supaya title benar-benar nempel kiri
      title: const Text(
      'Quotation Overview',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    centerTitle: false,
    actions: [
      IconButton(
       icon: const Icon(Icons.filter_list),
       onPressed: () => _showSortModal(context),
        )
      ],
    ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            children: [
              _buildFilterButton('Newest', isSelected: true),
              const SizedBox(width: 8),
              _buildFilterButton('Most'),
              const SizedBox(width: 8),
              _buildFilterButton('Least'),
             ],
            ),
            const SizedBox(height: 16),

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
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String title, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.white : Color(0xFF777777),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

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
    // KIRI: New & Accepted
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildStatusBadge('New', newCount, Colors.blue.shade50, Colors.blue),
        const SizedBox(height: 12),
        _buildStatusBadge('Accepted', acceptedCount, Colors.green.shade50, Colors.green),
      ],
    ),
    const SizedBox(width: 24), // Jarak antar dua kolom
    // TENGAH: Followed Up & Rejected (vertikal, posisi tengah card)
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
        // Menambahkan badge untuk angka dengan background hitam
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white38, // Background hitam untuk angka
            borderRadius: BorderRadius.circular(5), // Rounded corners
          ),
          child: Text(
            '$count',
            style: TextStyle(
              color: textColor, // Warna angka sesuai dengan warna badge
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    ),
  );
}

}