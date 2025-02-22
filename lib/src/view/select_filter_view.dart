import 'package:cmlabs_connect/src/utils/bottom_sheet.dart';
import 'package:cmlabs_connect/src/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../utils/color.dart';
import '../widgets/tag_button.dart';

class SelectFilterView extends StatefulWidget {
  SelectFilterView({
    super.key,
    required this.filter,
    required this.controller,
    this.canSearch = true,
    this.isMultipleChoice = true,
  });

  final String filter;
  final dynamic controller;
  final bool isMultipleChoice;

  final bool canSearch;

  @override
  State<SelectFilterView> createState() => _SelectFilterViewState();
}

class _SelectFilterViewState extends State<SelectFilterView> {
  var tempData = Rx<Map<String, String>?>(null);
  var tempMapData = Rx<List<Map<String, String>?>>([]);
  var canSelect = Rx<bool>(false);

  final allData = {'value': 'all', 'label': 'All'};

  @override
  void initState() {
    super.initState();

    // Listen to changes in tempData and tempMapData
    ever(tempData, (_) => _updateCanSelect());
    ever(tempMapData, (_) => _updateCanSelect());
  }

  void _updateCanSelect() {
    // Update canSelect based on tempData and tempMapData
    canSelect.value = tempData.value != null || tempMapData.value.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    tempMapData.value.clear();
    tempData.value = null;
    if (widget.filter != 'year' &&
        widget.filter != 'month' &&
        widget.filter != 'time_range' &&
        widget.filter != 'days') {
      widget.controller.fetchFilter(widget.filter);
    }

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFFF9F9F9),
        surfaceTintColor: Color(0xFFF9F9F9),
        title: Text(
          "Filter ${StringUtils.toCamelCase(widget.filter)}",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            color: AppColors.text_1,
            fontWeight: FontWeight.bold,
          ),
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
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.text_1,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                hintText: "Search ${StringUtils.toCamelCase(widget.filter)}",
                                hintStyle: GoogleFonts.plusJakartaSans(
                                  color: AppColors.text_4,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                suffixIcon: Icon(
                                  Ionicons.search_outline,
                                  size: 24,
                                ),
                                focusColor: AppColors.primary,
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide: BorderSide(
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
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: AppColors.text_4,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.white_1,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.controller.searchData(widget.filter.toLowerCase()).length,
                        itemBuilder: (context, index) {
                          final data = widget.controller.searchData(widget.filter.toLowerCase())[index];
                          print(data);

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
                                print(tempData.value);
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
                                  padding: EdgeInsetsDirectional.symmetric(horizontal: 14, vertical: 12),
                                  child: Text(
                                    data['label'] ?? "-",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: AppColors.text_1,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Obx(
            () {
              // bool isVisible = canSelect.value;
              bool isKeyboardShow = MediaQuery.of(context).viewInsets.bottom != 0;

              // print(isVisible);

              return TweenAnimationBuilder<double>(
                tween: Tween(
                  begin: canSelect.value ? -200 : 0,
                  end: canSelect.value ? 0 : -200,
                ),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                builder: (context, value, child) {
                  print(value);
                  return Positioned(
                    bottom: value,
                    left: 0,
                    right: 0,
                    child: (isKeyboardShow)
                        ? SizedBox.shrink()
                        : BottomSheetSaveChanges(
                            name: "Select",
                            onPressed: () {
                              if (widget.filter == 'year') {
                                Get.back(result: tempData.value);
                              } else if (widget.filter == 'month') {
                                Get.back(result: tempData.value);
                              } else if (widget.filter == 'time_range') {
                                Get.back(result: tempData.value!['value']);
                              } else if (widget.filter == 'days') {
                                Get.back(result: tempMapData.value);
                              } else if (widget.filter == 'category') {
                                for (var data in tempMapData.value) {
                                  widget.controller.addFilterCategory(data);
                                }
                                Get.back();
                              } else if (widget.filter == 'pic') {
                                widget.controller.addFilterPic(tempData.value);
                                Get.back();
                              } else if (widget.filter == 'client_source') {
                                widget.controller.addFilterClientSource(tempData.value);
                                Get.back();
                              }
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
