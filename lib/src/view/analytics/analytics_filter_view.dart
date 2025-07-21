import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../constant/fontstyle.dart';
import '../../controllers/analytics/analytics_controller.dart';
import '../../utils/color.dart';
import '../../widgets/custom_submit_button.dart';
import '../../widgets/default_appbar.dart';

class AnalyticsFilterView extends StatefulWidget {
  final AnalyticsType analyticsType;
  final AnalyticsController controller;
  const AnalyticsFilterView({super.key, required this.analyticsType, required this.controller});

  @override
  State<AnalyticsFilterView> createState() => _AnalyticsFilterViewState();
}

class _AnalyticsFilterViewState extends State<AnalyticsFilterView> {
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.controller.selectedStartDate.value != null) {
      startDateController.text = DateFormat('dd MMM yyyy').format(widget.controller.selectedStartDate.value!);
    }
    if (widget.controller.selectedEndDate.value != null) {
      endDateController.text = DateFormat('dd MMM yyyy').format(widget.controller.selectedEndDate.value!);
    }
  }

  @override
  void dispose() {
    startDateController.dispose();
    endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar('Filter', titleSpacing: 0),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Select Filter',
                        style: bold.copyWith(fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () => widget.controller.resetFilter(),
                        child: Text(
                          'Reset Filters',
                          style: regular.copyWith(
                            fontSize: 13,
                            color: AppColors.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Select Date
                  buildDateRange(context),
                  const Divider(height: 40, color: Color(0xFFD9D9D9)),

                  // Category
                  if (widget.analyticsType != AnalyticsType.topServices) ...[
                    AnalyticsFilterSection(
                      title: 'Category',
                      type: AnalyticsFilterType.category,
                      controller: widget.controller,
                    ),
                    const Divider(height: 40, color: Color(0xFFD9D9D9)),
                  ],

                  // PIC & Client Source
                  if (widget.analyticsType == AnalyticsType.quotationTraffic) ...[
                    AnalyticsFilterSection(
                      title: 'PIC',
                      type: AnalyticsFilterType.pic,
                      controller: widget.controller,
                    ),
                    const Divider(height: 40, color: Color(0xFFD9D9D9)),
                    AnalyticsFilterSection(
                      title: 'Client Source',
                      type: AnalyticsFilterType.clientSource,
                      controller: widget.controller,
                    ),
                    const Divider(height: 40, color: Color(0xFFD9D9D9)),
                  ],

                  // UTM Source and Medium
                  AnalyticsFilterSection(
                    title: 'UTM Source and Medium',
                    type: AnalyticsFilterType.utm,
                    controller: widget.controller,
                  ),
                  const Divider(height: 40, color: Color(0xFFD9D9D9)),

                  // Status
                  AnalyticsFilterSection(
                    title: 'Status',
                    type: AnalyticsFilterType.status,
                    controller: widget.controller,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
            buildSaveBottomSheet(),
          ],
        ),
      ),
    );
  }

  Container buildSaveBottomSheet() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 16),
          Obx(
            () => widget.controller.isFilterLoading.value
                ? const CustomLoadingButton()
                : CustomSubmitButton(
                    title: 'Save',
                    onTap: () => widget.controller.applyFilters(),
                  ),
          ),
          const SizedBox(height: 10),
          Text(
            'Click to save all changes',
            style: regular.copyWith(fontSize: 10, color: AppColors.text_2),
          ),
        ],
      ),
    );
  }

  Row buildDateRange(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Start Date', style: bold),
              const SizedBox(height: 8),
              AnalyticsFilterDateField(
                controller: startDateController,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: widget.controller.selectedStartDate.value ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    widget.controller.selectedStartDate.value = pickedDate;
                    startDateController.text = DateFormat('dd MMM yyyy').format(pickedDate);
                  }
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('End Date', style: bold),
              const SizedBox(height: 8),
              AnalyticsFilterDateField(
                controller: endDateController,
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: widget.controller.selectedEndDate.value ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    widget.controller.selectedEndDate.value = pickedDate;
                    endDateController.text = DateFormat('dd MMM yyyy').format(pickedDate);
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AnalyticsFilterDateField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onTap;
  const AnalyticsFilterDateField({
    super.key,
    required this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: regular.copyWith(fontSize: 13, color: AppColors.primary),
      decoration: InputDecoration(
        focusColor: AppColors.primary,
        suffixIcon: const Icon(
          Ionicons.calendar_outline,
          color: AppColors.primary,
        ),
        hintText: "Select date",
        hintStyle: regular.copyWith(fontSize: 13, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
      readOnly: true,
      controller: controller,
      onTap: onTap,
    );
  }
}

class AnalyticsFilterSection extends StatefulWidget {
  final String title;
  final AnalyticsController controller;
  final AnalyticsFilterType type;

  const AnalyticsFilterSection({
    super.key,
    required this.title,
    required this.controller,
    required this.type,
  });

  @override
  State<AnalyticsFilterSection> createState() => AnalyticsFilterSectionState();
}

class AnalyticsFilterSectionState extends State<AnalyticsFilterSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> currentDisplayOptions = _isExpanded
        ? widget.controller.getFilterOptions(type: widget.type)
        : widget.controller.getFilterOptions(type: widget.type).take(6).toList();
    bool showViewOtherButton = currentDisplayOptions.length >= 6;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: bold.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final double screenWidth = constraints.maxWidth;
            // Spasi horizontal total untuk 3 kolom = (3-1) * 8.0 = 16.0
            // Spasi horizontal total untuk 2 kolom = (2-1) * 8.0 = 8.0
            // Lebar item untuk 2 kolom: (screenWidth - crossAxisSpacing) / crossAxisCount
            const double crossAxisSpacing = 8.0;
            const int crossAxisCount = 2; // Ubah menjadi 2 kolom
            final double itemWidth = (screenWidth - (crossAxisSpacing * (crossAxisCount - 1))) / crossAxisCount;
            const double itemHeight = 40; // Tinggi tetap untuk pill

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
                return Obx(
                  () => _buildFilterPill(
                    label: option['label'] ?? '',
                    isSelected:
                        widget.controller.getSelectedFilterOption(type: widget.type)['value'] == option['value'],
                    onTap: () => widget.controller.setSelectedFilterOption(type: widget.type, option: option),
                  ),
                );
              },
            );
          },
        ),
        if (showViewOtherButton) ...[
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isExpanded ? 'View Less' : 'View Other',
                  style: regular.copyWith(color: AppColors.primary),
                ),
                const SizedBox(width: 6),
                Icon(
                  _isExpanded ? Ionicons.chevron_up_outline : Ionicons.chevron_down_outline,
                  color: AppColors.primary,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // --- Reusable Widget: Filter Pill (di dalam AnalyticsFilterSectionState) ---
  Widget _buildFilterPill({
    required String label,
    bool isSelected = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // Padding lebih besar
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.primary, width: 1),
        ),
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            label,
            style: regular.copyWith(color: isSelected ? AppColors.white : AppColors.primary),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }
}
