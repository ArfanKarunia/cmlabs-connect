import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../constant/fontstyle.dart';
import '../controllers/filter/filter_controller.dart';
import '../utils/color.dart';
import '../utils/string_utils.dart';
import '../widgets/custom_submit_button.dart';
import '../widgets/default_appbar.dart';
import '../widgets/empty_state.dart';
import '../widgets/tag_button.dart';

class SelectFilterView extends StatefulWidget {
  final InboxFilterType filter;
  final bool isMultipleChoice;
  final bool canSearch;
  const SelectFilterView({
    super.key,
    required this.filter,
    this.canSearch = true,
    this.isMultipleChoice = true,
  });

  @override
  State<SelectFilterView> createState() => _SelectFilterViewState();
}

class _SelectFilterViewState extends State<SelectFilterView> {
  Rx<Map<String, String>?> tempData = Rx<Map<String, String>?>(null);
  Rx<List<Map<String, String>?>> tempMapData = Rx<List<Map<String, String>?>>([]);
  Rx<bool> canSelect = Rx<bool>(false);

  final allData = {'value': 'all', 'label': 'All'};

  final FilterController controller = Get.find<FilterController>();

  @override
  void initState() {
    controller.clearSearch();

    super.initState();
    ever(tempData, (_) => _updateCanSelect());
    ever(tempMapData, (_) => _updateCanSelect());
  }

  void _updateCanSelect() {
    canSelect.value = tempData.value != null || tempMapData.value.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar("Filter ${capitalizeFirstLetter(widget.filter.name)}", titleSpacing: 0),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              if (widget.canSearch) ...[
                Container(
                  height: 45,
                  alignment: AlignmentDirectional.centerStart,
                  child: TextFormField(
                    onChanged: (value) {
                      Timer(Durations.long2, () {
                        controller.setSearch(value);
                        setState(() {});
                      });
                    },
                    textAlignVertical: TextAlignVertical.center,
                    style: regular.copyWith(fontSize: 12),
                    decoration: InputDecoration(
                      hintText: "Search ${capitalizeFirstLetter(widget.filter.name)}",
                      hintStyle: regular.copyWith(fontSize: 12, color: AppColors.text_4),
                      suffixIcon: const Icon(Ionicons.search_outline, size: 24),
                      focusColor: AppColors.primary,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: AppColors.primary, width: 2),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                        borderSide: const BorderSide(color: AppColors.text_3, width: 1),
                      ),
                    ),
                  ),
                ),
              ],
              if (widget.isMultipleChoice) ...[
                Obx(
                  () {
                    if (tempMapData.value.isNotEmpty) {
                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: tempMapData.value.length,
                          itemBuilder: (context, index) {
                            final data = tempMapData.value[index];
                            var label = data?['label'] ?? "-";

                            return TagButton(
                              statusLabel: label,
                              onPressed: () {
                                tempMapData.value.remove(data);
                                tempMapData.refresh();
                              },
                            );
                          },
                        ),
                      );
                    }

                    return Container();
                  },
                )
              ],
              const SizedBox(height: 10),
              Text(
                "Select ${capitalizeFirstLetter(widget.filter.name)}",
                style: regular.copyWith(fontSize: 10, color: AppColors.text_4),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white_1,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: controller.searchData(widget.filter).isEmpty
                    ? Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        color: AppColors.scaffoldBgColor2,
                        child: const EmptyState(),
                      )
                    : ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: controller.searchData(widget.filter).length,
                        itemBuilder: (context, index) {
                          final data = controller.searchData(widget.filter)[index];

                          // Hanya bungkus bagian yang perlu dipantau dengan Obx
                          return GestureDetector(
                            onTap: () {
                              if (widget.isMultipleChoice) {
                                if (data['value'] == 'all') {
                                  if (tempMapData.value.isNotEmpty) {
                                    tempMapData.value.clear();
                                  }
                                  tempMapData.value.add(allData);
                                } else if (tempMapData.value.contains(data)) {
                                  tempMapData.value.remove(data);
                                } else {
                                  if (tempMapData.value.contains(allData)) {
                                    tempMapData.value.clear();
                                  }
                                  tempMapData.value.add(data);
                                }
                                tempMapData.refresh();
                              } else {
                                if (tempData.value == data) {
                                  tempData.value = null;
                                } else {
                                  tempData.value = data;
                                }
                              }
                            },
                            child: Obx(
                              () {
                                // Bungkus hanya bagian warna dan teks yang perlu dipantau
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: (widget.isMultipleChoice)
                                        ? (tempMapData.value.contains(data) ? AppColors.bgPrimary : AppColors.white_1)
                                        : (tempData.value == data)
                                            ? AppColors.bgPrimary
                                            : AppColors.white_1,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  child: Text(
                                    data['label'] ?? "-",
                                    style: regular.copyWith(fontSize: 13),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 150),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: AppColors.white_1,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(30, 0, 0, 0),
                    offset: Offset(0, -4),
                    blurRadius: 10,
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(15, 25, 15, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 140,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.text_4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => controller.isLoading.value
                        ? const CustomLoadingButton()
                        : CustomSubmitButton(
                            title: 'Select',
                            isDisabled: !canSelect.value,
                            onTap: () {
                              switch (widget.filter) {
                                case InboxFilterType.year || InboxFilterType.month || InboxFilterType.days:
                                  Get.back(result: tempData.value);
                                  break;
                                case InboxFilterType.timeRange:
                                  Get.back(result: tempData.value?['value']);
                                  break;
                                case InboxFilterType.category:
                                  for (Map<String, String>? data in tempMapData.value) {
                                    controller.addFilterCategory(data);
                                  }
                                  Get.back();
                                  break;
                                case InboxFilterType.pic:
                                  controller.addFilterPic(tempData.value);
                                  Get.back();
                                  break;
                                case InboxFilterType.clientSource:
                                  controller.addFilterClientSource(tempData.value);
                                  Get.back();
                                  break;
                              }
                            },
                          ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Click to save all changes",
                    style: regular.copyWith(fontSize: 10, color: AppColors.text_2),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
