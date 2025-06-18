import 'package:cmlabs_connect/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../utils/color.dart';
import '../widgets/tag_button.dart';

class SelectEditView extends StatelessWidget {
  SelectEditView({
    super.key,
    required this.selectData,
    required this.controller,
  });

  final String selectData;

  final dynamic controller;

  // final EditQuotationController editQuotationController =
  //     Get.put(EditQuotationController());

  var temporaryData = Rx<Map<String, String>?>(null);
  var temporaryMultipleData = Rx<List<Map<String, String>?>>([]);

  String formatText(String text) {
    // Ganti tanda underscore (_) dengan spasi
    String result = text.replaceAll('_', ' ');

    // Buat huruf pertama dari setiap kata kapital
    result = result.split(' ').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');

    return result;
  }

  @override
  Widget build(BuildContext context) {
    // print("type : ${controller.selectedType}");

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFFF9F9F9),
        surfaceTintColor: Color(0xFFF9F9F9),
        title: Text(
          "Filter ${formatText(selectData)}",
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
              Container(
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
                    hintText: "Search ${formatText(selectData)}",
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
              ),
              selectData.toLowerCase() == 'type_activity' || selectData.toLowerCase() == 'type_history'
                  ? Obx(
                      () {
                        if (temporaryMultipleData.value.isNotEmpty) {
                          return Container(
                            width: double.infinity,
                            height: 50,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: temporaryMultipleData.value.length,
                              itemBuilder: (context, index) {
                                final type = temporaryMultipleData.value[index];
                                var label = type?['label'] ?? '';

                                return TagButton(
                                  statusLabel: label,
                                  onPressed: () {
                                    temporaryMultipleData.value.remove(type);
                                    temporaryMultipleData.refresh();
                                  },
                                );
                              },
                            ),
                          );
                        }
                        return Container();
                      },
                    )
                  : SizedBox.shrink(),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  "Select ${formatText(selectData)}",
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
                      shrinkWrap: true,
                      itemCount: controller.searchData(selectData.toLowerCase()).length,
                      itemBuilder: (context, index) {
                        final data = controller.searchData(selectData.toLowerCase())[index];

                        print(controller.searchData(selectData.toLowerCase()));

                        if (controller.searchData(selectData.toLowerCase()).length == 0) {
                          return SizedBox(
                            height: 200,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                "No Data",
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.text_4,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          );
                        }

                        // Hanya bungkus bagian yang perlu dipantau dengan Obx
                        return GestureDetector(
                          onTap: () {
                            if (selectData == "type_activity" || selectData == "type_history") {
                              if (temporaryMultipleData.value.contains(data)) {
                                temporaryMultipleData.value.remove(data);
                              } else {
                                temporaryMultipleData.value.add(data);
                              }
                              temporaryMultipleData.refresh();
                            } else {
                              if (temporaryData.value == null) {
                                temporaryData.value = data;
                              } else if (temporaryData.value != data) {
                                temporaryData.value = data;
                              } else {
                                temporaryData.value = null;
                              }
                            }
                          },
                          child: Obx(
                            () {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: (selectData == "type_activity" || selectData == "type_history")
                                      ? (temporaryMultipleData.value.contains(data)
                                          ? AppColors.bgPrimary
                                          : AppColors.white_1)
                                      : (temporaryData.value != null && temporaryData.value == data
                                          ? AppColors.bgPrimary
                                          : AppColors.white_1),
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
                    if (temporaryData.value != null || temporaryMultipleData.value.isNotEmpty) {
                      if (selectData == "pic") {
                        controller.addPIC(temporaryData.value!);
                        // editQuotationController.onFieldChanged();
                        Get.back();
                      } else if (selectData == "priority") {
                        controller.addPriority(temporaryData.value!);
                        // editQuotationController.onFieldChanged();
                        Get.back();
                      } else if (selectData == "status") {
                        controller.addStatus(temporaryData.value!);
                        if (temporaryData.value!["value"] == 0.toString() ||
                            temporaryData.value!["value"] == 4.toString()) {
                          // editQuotationController.onFieldChanged();
                          Get.back();
                        } else {
                          // editQuotationController.onFieldChanged();
                          Get.toNamed("/editSelect", arguments: "type");

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return SelectEditView(
                                  selectData: "type",
                                  controller: controller,
                                );
                              },
                            ),
                          );
                        }
                      } else if (selectData == "type") {
                        controller.addType(temporaryData.value!);
                        // editQuotationController.onFieldChanged();
                        Get.until((route) => Get.currentRoute == AppRoutes.editQuotation);
                      } else if (selectData == "type_contact") {
                        controller.addType(temporaryData.value!);
                        Get.back(result: temporaryData.value);
                      } else if (selectData == "status_contact") {
                        controller.addStatus(temporaryData.value!);
                        Get.back(result: temporaryData.value);
                      } else if (selectData == "detail_contact") {
                        controller.addDetailStatus(temporaryData.value!);
                        Get.back(result: temporaryData.value);
                      } else if (selectData == "status_activity") {
                        // editQuotationController.onFieldChanged();
                        Get.back(result: temporaryData.value);
                      } else if (selectData == "type_activity") {
                        // editQuotationController.onFieldChanged();
                        Get.back(result: temporaryMultipleData.value);
                      } else if (selectData == "type_history") {
                        List<String?> data = [];

                        for (var type in temporaryMultipleData.value) {
                          data.add(type?['value'] ?? '');
                        }
                        // editQuotationController.onFieldChanged();

                        Get.back(result: data);
                      } else if (selectData == "validity_url_tracking") {
                        controller.addValidity(temporaryData.value);
                        // editQuotationController.onFieldChanged();
                        Get.back();
                      }
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
