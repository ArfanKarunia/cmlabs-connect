import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '/src/controllers/analytics/analytics_controller.dart';

// Asumsi Anda punya file colors atau deklarasi konstanta warna di tempat yang bisa diakses
// Contoh:
const Color primaryBlue = Color(0xFF35A0F6);
const Color initialSaveButtonGrey = Color(0xFF9E9E9E);
const Color pillOutlineBlue = Color(0xFF35A0F6); 

class QuotationFilterPage extends StatelessWidget {
  final AnalyticsController analyticsController = Get.find<AnalyticsController>();

  QuotationFilterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Filter',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'PlusJakartaSans', // Tambahkan font family
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Select Filter',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'PlusJakartaSans', // Tambahkan font family
                    ),
                  ),
                  const SizedBox(height: 16),

                  // --- Start Date & End Date ---
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateField(
                          context,
                          'Start Date',
                          analyticsController.filterStartDate,
                          analyticsController.setFilterStartDate,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildDateField(
                          context,
                          'End Date',
                          analyticsController.filterEndDate,
                          analyticsController.setFilterEndDate,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // --- Filter Sections ---
                  // Kita akan menambahkan Divider setelah setiap section filter
                  _FilterSectionWidget(
                    title: 'Category',
                    options: analyticsController.categoriesOptions,
                    selectedRx: analyticsController.selectedCategory,
                    onOptionSelected: (value) => analyticsController.updateFilter('category', value),
                  ),
                  const Divider(), // Garis pemisah
                  const SizedBox(height: 24), // Spasi setelah divider

                  _FilterSectionWidget(
                    title: 'PIC',
                    options: analyticsController.picOptions,
                    selectedRx: analyticsController.selectedPic,
                    onOptionSelected: (value) => analyticsController.updateFilter('pic', value),
                  ),
                  const Divider(), // Garis pemisah
                  const SizedBox(height: 24),

                  _FilterSectionWidget(
                    title: 'Client Source',
                    options: analyticsController.clientSourceOptions,
                    selectedRx: analyticsController.selectedClientSource,
                    onOptionSelected: (value) => analyticsController.updateFilter('clientSource', value),
                  ),
                  const Divider(), // Garis pemisah
                  const SizedBox(height: 24),

                  _FilterSectionWidget(
                    title: 'UTM Source and Medium',
                    options: analyticsController.utmOptions,
                    selectedRx: analyticsController.selectedUtm,
                    onOptionSelected: (value) => analyticsController.updateFilter('utm', value),
                  ),
                  const Divider(), // Garis pemisah
                  const SizedBox(height: 24),

                  _FilterSectionWidget(
                    title: 'Status',
                    options: analyticsController.statusOptions,
                    selectedRx: analyticsController.selectedStatus,
                    onOptionSelected: (value) => analyticsController.updateFilter('status', value),
                  ),
                  // Tidak perlu divider setelah section terakhir
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // --- Save Button ---
          Container(
            padding: const EdgeInsets.all(16.0),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: Column( // <--- Tambahkan Column ini
              mainAxisSize: MainAxisSize.min, // Agar Column hanya selebar isinya
              children: [
                SizedBox(
                  width:double.infinity,
                  child:Obx(
                  () => ElevatedButton(
                    onPressed: () {
                      analyticsController.applyFilters();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: analyticsController.hasFilterChanged.value
                          ? primaryBlue
                          : initialSaveButtonGrey,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: 'PlusJakartaSans',
                      ),
                    ),
                  ),
                ),
              ),
                const SizedBox(height: 8), // Spasi antara tombol dan teks
                const Text(
                  'Click to save all changes',
                  textAlign: TextAlign.center, // Pusatkan teks
                  style: TextStyle(
                    fontSize: 12, // Ukuran font yang lebih kecil
                    color: Colors.grey, // Warna teks abu-abu
                    fontFamily: 'PlusJakartaSans', // Tambahkan font family
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Reusable Widget: Date Field ---
  Widget _buildDateField(BuildContext context, String label, Rx<DateTime?> dateRx, Function(DateTime?) onDateSelected) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            fontFamily: 'PlusJakartaSans', // Tambahkan font family
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: dateRx.value ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: ColorScheme.light(
                      primary: primaryBlue, // Warna header date picker
                      onPrimary: Colors.white, // Warna teks di header
                      onSurface: Colors.black, // Warna teks di kalender
                    ),
                    textButtonTheme: TextButtonThemeData(
                      style: TextButton.styleFrom(
                        foregroundColor: primaryBlue, // Warna tombol di date picker
                      ),
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (pickedDate != null) {
              onDateSelected(pickedDate);
            }
          },
          child: Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(
                color: dateRx.value != null ? primaryBlue : pillOutlineBlue, // Outline biru jika terpilih
                width: 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateRx.value != null ? DateFormat('dd-MM-yyyy').format(dateRx.value!) : 'Select Date',
                  style: TextStyle(
                    color: dateRx.value != null ? Colors.black : Colors.grey,
                    fontFamily: 'PlusJakartaSans', // Tambahkan font family
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: dateRx.value != null ? primaryBlue : Colors.grey, // Ikon biru jika terpilih
                ),
              ],
            ),
          )),
        ),
      ],
    );
  }
}

// --- START: _FilterSectionWidget BARU (pengganti _buildFilterSection) ---
class _FilterSectionWidget extends StatefulWidget {
  final String title;
  final List<String> options;
  final RxString selectedRx;
  final Function(String) onOptionSelected;

  const _FilterSectionWidget({
    required this.title,
    required this.options,
    required this.selectedRx,
    required this.onOptionSelected,
  });

  @override
  State<_FilterSectionWidget> createState() => _FilterSectionWidgetState();
}

class _FilterSectionWidgetState extends State<_FilterSectionWidget> {
  bool _isExpanded = false;
  // Ubah initialVisibleCount menjadi 6 (3x2 grid)
  final int _initialVisibleCount = 6;

  @override
  Widget build(BuildContext context) {
    List<String> displayOptions = List.from(widget.options);
    if (!displayOptions.contains('All')) {
      displayOptions.insert(0, 'All');
    }

    List<String> currentDisplayOptions = _isExpanded
        ? displayOptions
        : displayOptions.take(_initialVisibleCount).toList();

    bool showViewOtherButton = displayOptions.length > _initialVisibleCount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'PlusJakartaSans', // Tambahkan font family
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = constraints.maxWidth;
            // Spasi horizontal total untuk 3 kolom = (3-1) * 8.0 = 16.0
            // Spasi horizontal total untuk 2 kolom = (2-1) * 8.0 = 8.0
            // Lebar item untuk 2 kolom: (screenWidth - crossAxisSpacing) / crossAxisCount
            final double crossAxisSpacing = 8.0;
            final int crossAxisCount = 2; // Ubah menjadi 2 kolom
            final double itemWidth = (screenWidth - (crossAxisSpacing * (crossAxisCount - 1))) / crossAxisCount;
            final double itemHeight = 40; // Tinggi tetap untuk pill

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount, // 2 kolom
                crossAxisSpacing: crossAxisSpacing,
                mainAxisSpacing: 8.0,
                childAspectRatio: itemWidth / itemHeight, // Rasio lebar/tinggi item
              ),
              itemCount: currentDisplayOptions.length,
              itemBuilder: (context, index) {
                final option = currentDisplayOptions[index];
                return Obx(() => _buildFilterPill(
                  option,
                  widget.selectedRx.value == option,
                  () => widget.onOptionSelected(option),
                ));
              },
            );
          },
        ),
        if (showViewOtherButton)
          Align(
            alignment: Alignment.center,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(
                _isExpanded ? 'View Less' : 'View Other',
                style: const TextStyle(
                  color: Colors.blue,
                  fontFamily: 'PlusJakartaSans', // Tambahkan font family
                ),
              ),
            ),
          ),
      ],
    );
  }

  // --- Reusable Widget: Filter Pill (di dalam _FilterSectionWidgetState) ---
  Widget _buildFilterPill(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Padding lebih besar
        decoration: BoxDecoration(
          color: isSelected ? primaryBlue : Colors.white, 
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? primaryBlue : pillOutlineBlue, 
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontSize: 14,
              fontFamily: 'PlusJakartaSans', // Tambahkan font family
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
// --- END: _FilterSectionWidget BARU ---