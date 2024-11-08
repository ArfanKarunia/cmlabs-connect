import 'package:cmlabs_connect/src/models/client_pic_model.dart';
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

  var temporaryData = Rx<Map<String, String>?>(null);
  var temporaryTypeActivity = <Map<String, String>>[].obs;

  String formatText(String text) {
    // Ganti tanda underscore (_) dengan spasi
    String result = text.replaceAll('_', ' ');

    // Buat huruf pertama dari setiap kata kapital
    result = result
        .split(' ')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');

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
                    hintText: "Search $selectData",
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
              selectData.toLowerCase() == 'type_activity'
                  ? Obx(
                      () {
                        if (temporaryTypeActivity.isNotEmpty) {
                          return Container(
                            width: double.infinity,
                            height: 50,
                            child: ListView.builder(
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              itemCount: temporaryTypeActivity.length,
                              itemBuilder: (context, index) {
                                final type = temporaryTypeActivity[index];
                                var label = type['label'];

                                return TagButton(
                                  statusLabel: label!,
                                  onPressed: () {
                                    temporaryTypeActivity.remove(type);
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
                  "Select $selectData",
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
                      itemCount: controller
                          .searchData(selectData.toLowerCase())
                          .length,
                      itemBuilder: (context, index) {
                        final data = controller
                            .searchData(selectData.toLowerCase())[index];

                        // Hanya bungkus bagian yang perlu dipantau dengan Obx
                        return GestureDetector(
                          onTap: () {
                            if (selectData == "type_activity") {
                              if (temporaryTypeActivity.contains(data)) {
                                temporaryTypeActivity.remove(data);
                              } else {
                                temporaryTypeActivity.add(data);
                              }
                            } else {
                              if (temporaryData.value == null) {
                                temporaryData.value = data;
                              } else if (temporaryData.value != data) {
                                temporaryData.value = data;
                              } else {
                                temporaryData.value = null;
                              }
                            }
                            print("Data tmp ${temporaryData.value}");
                          },
                          child: Obx(
                            () {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: (selectData == "type_activity")
                                      ? (temporaryTypeActivity.contains(data)
                                          ? AppColors.bgPrimary
                                          : AppColors.white_1)
                                      : (temporaryData.value != null &&
                                              temporaryData.value == data
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
                    if (temporaryData.value != null ||
                        temporaryTypeActivity.isNotEmpty) {
                      if (selectData == "pic") {
                        controller.addPIC(temporaryData.value!);
                        Get.back();
                      } else if (selectData == "priority") {
                        controller.addPriority(temporaryData.value!);
                        Get.back();
                      } else if (selectData == "status") {
                        controller.addStatus(temporaryData.value!);
                        // Get.toNamed("/editSelect", arguments: "type");
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
                      } else if (selectData == "type") {
                        controller.addType(temporaryData.value!);
                        Get.until((route) =>
                            Get.currentRoute == AppRoutes.editQuotation);
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
                        Get.back(result: temporaryData.value);
                      } else if (selectData == "type_activity") {
                        Get.back(result: temporaryTypeActivity);
                      }
                      print("$selectData");
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
