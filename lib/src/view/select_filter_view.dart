import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../utils/color.dart';
import '../widgets/tag_button.dart';

class SelectFilterView extends StatelessWidget {
  SelectFilterView({
    super.key,
    required this.filter,
    required this.controller,
    this.canSearch = true,
  });

  final String filter;
  final dynamic controller;

  final bool canSearch;
  var tempData = Rx<String?>(null);
  var tempMapData = Rx<List<Map<String, String>?>>([]);

  final allData = {'value': 'all', 'label': 'All'};

  @override
  Widget build(BuildContext context) {
    print(tempMapData);
    tempMapData.value.clear();
    if (filter != 'year' || filter != 'month') {
      controller.fetchList(filter);
    }

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFFF9F9F9),
        surfaceTintColor: Color(0xFFF9F9F9),
        title: Text(
          "Filter $filter",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            color: AppColors.text_1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              (canSearch)
                  ? Container(
                      height: 45,
                      alignment: AlignmentDirectional.centerStart,
                      child: TextFormField(
                        onChanged: controller.setSearch,
                        textAlignVertical: TextAlignVertical.center,
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.text_1,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: "Search $filter",
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
              (filter != "year" && filter != "month")
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
                  "Select $filter",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: AppColors.text_4,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Obx(
                () {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.white_1,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          controller.searchData(filter.toLowerCase()).length,
                      itemBuilder: (context, index) {
                        final data =
                            controller.searchData(filter.toLowerCase())[index];

                        // Hanya bungkus bagian yang perlu dipantau dengan Obx
                        return GestureDetector(
                          onTap: () {
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
                          },
                          child: Obx(() {
                            // Bungkus hanya bagian warna dan teks yang perlu dipantau
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: (tempMapData.value.contains(data)
                                    ? AppColors.bgPrimary
                                    : AppColors.white_1),
                              ),
                              padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 14, vertical: 12),
                              child: Text(
                                data['label'] ?? "-",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: AppColors.text_1,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            );
                          }),
                        );
                      },
                    ),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(bottom: 100),
                height: 51,
                child: ElevatedButton(
                  onPressed: () {
                    if (filter == 'year' && filter == 'month') {
                      Get.back(result: tempData.value);
                    } else if (filter == 'status') {
                      for (var data in tempMapData.value) {
                        controller.addFilterStatus(data);
                      }
                      Get.back();
                    } else if (filter == 'category') {
                      for (var data in tempMapData.value) {
                        controller.addFilterCategory(data);
                      }
                      Get.back();
                    } else if (filter == 'pic') {
                      for (var data in tempMapData.value) {
                        controller.addFilterPic(data);
                      }
                      Get.back();
                    } else if (filter == 'client_source') {
                      for (var data in tempMapData.value) {
                        controller.addFilterClientSource(data);
                      }
                      Get.back();
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.primary),
                    foregroundColor: WidgetStatePropertyAll(AppColors.white_1),
                    overlayColor: WidgetStatePropertyAll(Colors.white24),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: Text(
                    "Select",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
