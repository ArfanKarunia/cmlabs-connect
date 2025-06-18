import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../constant/fontstyle.dart';
import '../utils/bottom_sheet.dart';
import '../utils/color.dart';
import '../utils/string_utils.dart';
import '../widgets/tag_button.dart';

class SelectFilterView extends StatefulWidget {
  final String filter;
  final dynamic controller;
  final bool isMultipleChoice;
  final bool canSearch;
  const SelectFilterView({
    super.key,
    required this.filter,
    required this.controller,
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

  @override
  void initState() {
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
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: AppColors.scaffoldBgColor2,
        surfaceTintColor: AppColors.scaffoldBgColor2,
        title: Text(
          "Filter ${StringUtils.toCamelCase(widget.filter)}",
          style: bold.copyWith(fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (widget.canSearch)
                        ? Container(
                            height: 45,
                            alignment: AlignmentDirectional.centerStart,
                            child: TextFormField(
                              onChanged: widget.controller.setSearch,
                              textAlignVertical: TextAlignVertical.center,
                              style: regular.copyWith(fontSize: 12),
                              decoration: InputDecoration(
                                hintText: "Search ${StringUtils.toCamelCase(widget.filter)}",
                                hintStyle: regular.copyWith(fontSize: 12, color: AppColors.text_4),
                                suffixIcon: const Icon(Ionicons.search_outline, size: 24),
                                focusColor: AppColors.primary,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: const BorderSide(
                                    color: AppColors.text_3,
                                    width: 1,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    (widget.isMultipleChoice)
                        ? Obx(
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
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Text(
                        "Select ${StringUtils.toCamelCase(widget.filter)}",
                        style: regular.copyWith(fontSize: 10, color: AppColors.text_4),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.white_1,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.controller.searchData(widget.filter.toLowerCase()).length,
                        itemBuilder: (context, index) {
                          final data = widget.controller.searchData(widget.filter.toLowerCase())[index];

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
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () {
              bool isKeyboardShow = MediaQuery.of(context).viewInsets.bottom != 0;

              return TweenAnimationBuilder<double>(
                tween: Tween(
                  begin: canSelect.value ? -200 : 0,
                  end: canSelect.value ? 0 : -200,
                ),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  // print(value);
                  return Positioned(
                    bottom: value,
                    left: 0,
                    right: 0,
                    child: (isKeyboardShow)
                        ? const SizedBox.shrink()
                        : BottomSheetSaveChanges(
                            name: "Select",
                            onPressed: () {
                              switch (widget.filter) {
                                case 'year' || 'month' || 'days':
                                  Get.back(result: tempData.value);
                                  break;
                                case 'time_range':
                                  Get.back(result: tempData.value?['value']);
                                  break;
                                case 'category':
                                  for (Map<String, String>? data in tempMapData.value) {
                                    widget.controller.addFilterCategory(data);
                                  }
                                  Get.back();
                                  break;
                                case 'pic':
                                  widget.controller.addFilterPic(tempData.value);
                                  Get.back();
                                  break;
                                case 'client_source':
                                  widget.controller.addFilterClientSource(tempData.value);
                                  Get.back();
                                  break;
                                default:
                                  break;
                              }
                              // if (widget.filter == 'year') {
                              // Get.back(result: tempData.value);
                              // } else if (widget.filter == 'month') {
                              // Get.back(result: tempData.value);
                              // } else if (widget.filter == 'time_range') {
                              //   Get.back(result: tempData.value!['value']);
                              // } else if (widget.filter == 'days') {
                              // Get.back(result: tempMapData.value);
                              // } else if (widget.filter == 'category') {
                              //   for (var data in tempMapData.value) {
                              //     widget.controller.addFilterCategory(data);
                              //   }
                              //   Get.back();
                              // } else if (widget.filter == 'pic') {
                              //   widget.controller.addFilterPic(tempData.value);
                              //   Get.back();
                              // } else if (widget.filter == 'client_source') {
                              //   widget.controller.addFilterClientSource(tempData.value);
                              //   Get.back();
                              // }
                            },
                          ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
