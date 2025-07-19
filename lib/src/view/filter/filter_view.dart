import 'package:cmlabs_connect/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../constant/fontstyle.dart';
import '../../controllers/filter/filter_controller.dart';
import '../../utils/color.dart';
// import '../widgets/custom_buttom.dart';
import '../../widgets/custom_select_field.dart';
import '../../widgets/custom_submit_button.dart';
import '../../widgets/inbox_add_field.dart';
import '../../widgets/tag_button.dart';

class FilterView extends StatefulWidget {
  const FilterView({super.key});

  @override
  State<FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<FilterView> {
  final FilterController controller = Get.find<FilterController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: AppColors.scaffoldBgColor2,
        surfaceTintColor: AppColors.scaffoldBgColor2,
        title: Text(
          "Filter",
          style: bold.copyWith(fontSize: 20),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          // Title and Clear Filter button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Select Filter",
                style: bold.copyWith(fontSize: 16),
              ),
              InkWell(
                onTap: () => controller.clearFilter(),
                child: Ink(
                  child: Text(
                    "Clear filter",
                    style: regular.copyWith(
                      fontSize: 12,
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Data Range
          const Text('Data range', style: bold),
          const SizedBox(height: 15),
          SizedBox(
            child: Row(
              children: [
                Expanded(
                  child: Obx(
                    () {
                      return CustomSelectField(
                        icon: Ionicons.calendar_outline,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: controller.startDate.value ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) controller.startDate.value = pickedDate;
                        },
                        errorText: controller.startDateError.value,
                        child: InboxTextOnField(
                          title: 'Select date',
                          selected: controller.startDate.value != null
                              ? {
                                  'value':
                                      DateFormat('dd MMM yyyy').format(controller.startDate.value ?? DateTime.now()),
                                  'label':
                                      DateFormat('dd MMM yyyy').format(controller.startDate.value ?? DateTime.now()),
                                }
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10), // Spasi antar form
                Text(
                  "to",
                  style: regular.copyWith(fontSize: 12),
                ),
                const SizedBox(width: 10), // Spasi antar form
                Expanded(
                  child: Obx(
                    () {
                      return CustomSelectField(
                        icon: Ionicons.calendar_outline,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: controller.endDate.value ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) controller.endDate.value = pickedDate;
                        },
                        errorText: controller.endDateError.value,
                        child: InboxTextOnField(
                          title: 'Select date',
                          selected: controller.endDate.value != null
                              ? {
                                  'value': DateFormat('dd MMM yyyy').format(controller.endDate.value ?? DateTime.now()),
                                  'label': DateFormat('dd MMM yyyy').format(controller.endDate.value ?? DateTime.now()),
                                }
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Filter Category
          const Text(
            "Category",
            style: bold,
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: () => Get.toNamed(
              AppRoutes.filterSelect,
              arguments: {
                'filter': InboxFilterType.category,
                'isMultipleChoice': true,
              },
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryText),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () {
                        List<Map<String, String>> categoryList = controller.filterCategoryList;
                        return categoryList.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(7),
                                child: Text(
                                  'All',
                                  style: regular.copyWith(color: AppColors.text_3),
                                ),
                              )
                            : Wrap(
                                clipBehavior: Clip.antiAlias,
                                children: List.generate(
                                  categoryList.length,
                                  (index) {
                                    Map<String, String> category = categoryList[index];

                                    return FittedBox(
                                      child: TagButton(
                                        statusLabel: category['label'].toString(),
                                        onPressed: () => controller.deleteFilterCategory(category),
                                      ),
                                    );
                                  },
                                ),
                              );
                      },
                    ),
                  ),
                  const Icon(Ionicons.chevron_down_outline),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Filter PIC
          const Text(
            'PIC',
            style: bold,
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: () => Get.toNamed(
              AppRoutes.filterSelect,
              arguments: {
                'filter': InboxFilterType.pic,
                'isMultipleChoice': false,
              },
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryText),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () {
                        Map<String, String>? pic = controller.filterPic.value;
                        return Padding(
                          padding: const EdgeInsets.all(7),
                          child: Text(
                            pic != null ? pic['label'].toString() : 'All',
                            style: regular.copyWith(color: pic != null ? AppColors.text_1 : AppColors.text_3),
                          ),
                        );
                      },
                    ),
                  ),
                  const Icon(Ionicons.chevron_down_outline),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Field Client Source
          const Text(
            "Client Source",
            style: bold,
          ),
          const SizedBox(height: 15),
          InkWell(
            onTap: () => Get.toNamed(
              AppRoutes.filterSelect,
              arguments: {
                'filter': InboxFilterType.clientSource,
                'isMultipleChoice': false,
              },
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primaryText),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () {
                        Map<String, String>? clientSource = controller.filterClientSource.value;
                        return Padding(
                          padding: const EdgeInsets.all(7),
                          child: Text(
                            clientSource != null ? clientSource['label'].toString() : 'All',
                            style: regular.copyWith(color: clientSource != null ? AppColors.text_1 : AppColors.text_3),
                          ),
                        );
                      },
                    ),
                  ),
                  const Icon(Ionicons.chevron_down_outline),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Button Search
          Obx(
            () {
              return controller.isLoading.isTrue
                  ? const CustomLoadingButton()
                  : CustomSubmitButton(
                      title: 'Search',
                      onTap: () => controller.applyFilter(),
                    );
            },
          ),
        ],
      ),
    );
  }
}
