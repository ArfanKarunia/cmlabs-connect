import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../controllers/authentication_controller.dart';
import '../controllers/filter_controller.dart';
import '../utils/color.dart';
import '../widgets/tag_button.dart';

class SelectFilterView extends StatelessWidget {
  SelectFilterView({super.key, required this.filterData});
  final String filterData;

  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());

  final FilterController filterController = Get.put(FilterController());

  @override
  Widget build(BuildContext context) {
    filterController.fetchList(filterData);

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFFF9F9F9),
        surfaceTintColor: Color(0xFFF9F9F9),
        title: Text(
          "Filter $filterData",
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
                  onChanged: filterController.setSearch,
                  textAlignVertical: TextAlignVertical.center,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.text_1,
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: "Search $filterData",
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
              Obx(
                () {
                  if (filterData.toLowerCase() == 'status') {
                    if (filterController.filterStatusList.isNotEmpty) {
                      return Container(
                        width: double.infinity,
                        height: 50,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: filterController.filterStatusList.length,
                          itemBuilder: (context, index) {
                            final status =
                                filterController.filterStatusList[index];
                            var label = status['label'];

                            return TagButton(
                              statusLabel: label!,
                              onPressed: () {
                                filterController.deleteFilterStatus(status);
                              },
                            );
                          },
                        ),
                      );
                    }
                  } else if (filterData.toLowerCase() == 'client source') {
                    if (filterController.filterClientSourceList.isNotEmpty) {
                      return Container(
                        width: double.infinity,
                        height: 50,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount:
                              filterController.filterClientSourceList.length,
                          itemBuilder: (context, index) {
                            final clientSource =
                                filterController.filterClientSourceList[index];
                            var label = clientSource['label'];

                            return TagButton(
                              statusLabel: label!,
                              onPressed: () {
                                filterController
                                    .deleteFilterClientSource(clientSource);
                              },
                            );
                          },
                        ),
                      );
                    }
                  } else if (filterData.toLowerCase() == 'pic') {
                    if (filterController.filterPicList.isNotEmpty) {
                      return Container(
                        width: double.infinity,
                        height: 50,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: filterController.filterPicList.length,
                          itemBuilder: (context, index) {
                            final pic = filterController.filterPicList[index];
                            var label = pic['label'];

                            return TagButton(
                              statusLabel: label!,
                              onPressed: () {
                                filterController.deleteFilterPic(pic);
                              },
                            );
                          },
                        ),
                      );
                    }
                  } else if (filterData.toLowerCase() == 'category') {
                    if (filterController.filterCategoryList.isNotEmpty) {
                      return Container(
                        width: double.infinity,
                        height: 50,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: filterController.filterCategoryList.length,
                          itemBuilder: (context, index) {
                            final category =
                                filterController.filterCategoryList[index];
                            var label = category['label'];

                            return TagButton(
                              statusLabel: label!,
                              onPressed: () {
                                filterController.deleteFilterCategory(category);
                              },
                            );
                          },
                        ),
                      );
                    }
                  }

                  return Container();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  "Select $filterData",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: AppColors.text_4,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Obx(
                () {
                  print(filterData);
                  // print("cari data : ${filterData.toLowerCase() == 'status'}");
                  if (filterData.toLowerCase() == 'status') {
                    // print("Cari Data: ${filterController.searchData}");

                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.white_1,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filterController
                            .searchData(filterData.toLowerCase())
                            .length,
                        itemBuilder: (context, index) {
                          final status = filterController
                              .searchData(filterData.toLowerCase())[index];

                          // Hanya bungkus bagian yang perlu dipantau dengan Obx
                          return GestureDetector(
                            onTap: () {
                              if (filterController.filterStatusList
                                  .contains(status)) {
                                filterController.deleteFilterStatus(status);
                              } else {
                                filterController.addFilterStatus(status);
                              }
                            },
                            child: Obx(() {
                              // Bungkus hanya bagian warna dan teks yang perlu dipantau
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: (filterController.filterStatusList
                                          .contains(status)
                                      ? AppColors.bgPrimary
                                      : AppColors.white_1),
                                ),
                                padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: 14, vertical: 12),
                                child: Text(
                                  status['label'] ?? "-",
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
                  } else if (filterData.toLowerCase() == 'client source') {
                    print("Cari Data: ${filterData}");
                    print("${filterController.filterClientSourceList}");
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.white_1,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filterController
                            .searchData(filterData.toLowerCase())
                            .length,
                        itemBuilder: (context, index) {
                          final clientSource = filterController
                              .searchData(filterData.toLowerCase())[index];
                          print("data client Source : ${clientSource}");

                          return GestureDetector(
                            onTap: () {
                              if (filterController.filterClientSourceList
                                  .contains(clientSource)) {
                                filterController
                                    .deleteFilterClientSource(clientSource);
                              } else {
                                filterController
                                    .addFilterClientSource(clientSource);
                              }
                            },
                            child: Obx(
                              () {
                                return Container(
                                  decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: (filterController.filterClientSourceList
                                          .contains(clientSource)
                                      ? AppColors.bgPrimary
                                      : AppColors.white_1),
                                ),
                                  padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: 14, vertical: 12),
                                  child: Text(
                                    clientSource['label'] ?? "-",
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
                  } else if (filterData.toLowerCase() == 'pic') {
                    // print("Cari Data: ${filterController.searchData}");
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.white_1,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filterController
                            .searchData(filterData.toLowerCase())
                            .length,
                        itemBuilder: (context, index) {
                          final pic = filterController
                              .searchData(filterData.toLowerCase())[index];

                          return GestureDetector(
                            onTap: () {
                              if (filterController.filterPicList
                                  .contains(pic)) {
                                filterController.deleteFilterPic(pic);
                              } else {
                                filterController.addFilterPic(pic);
                              }
                            },
                            child: Obx(
                              () {
                                return Container(
                                  decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: (filterController.filterPicList
                                          .contains(pic)
                                      ? AppColors.bgPrimary
                                      : AppColors.white_1),
                                ),
                                  padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: 14, vertical: 12),
                                  child: Text(
                                    pic['label'] ?? "-",
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
                  } else if (filterData.toLowerCase() == 'category') {
                    // print("Cari Data: ${filterController.searchData}");
                    return Container(
                      margin: EdgeInsets.only(bottom: 50),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.white_1,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: filterController
                            .searchData(filterData.toLowerCase())
                            .length,
                        itemBuilder: (context, index) {
                          final category = filterController
                              .searchData(filterData.toLowerCase())[index];

                          return GestureDetector(
                            onTap: () {
                              if (filterController.filterPicList
                                  .contains(category)) {
                                filterController.deleteFilterCategory(category);
                              } else {
                                filterController.addFilterCategory(category);
                              }
                            },
                            child: Obx(
                              () {
                                return Container(
                                  decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: (filterController.filterCategoryList
                                          .contains(category)
                                      ? AppColors.bgPrimary
                                      : AppColors.white_1),
                                ),
                                  padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: 14, vertical: 12),
                                  child: Text(
                                    category['label'] ?? "-",
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
                  } else {
                    return Container(
                      child: Text("YOLO"),
                    );
                  }
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
                      filterController.searchFilter(filterData.toLowerCase());
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(AppColors.primary),
                      foregroundColor:
                          WidgetStatePropertyAll(AppColors.white_1),
                      overlayColor: WidgetStatePropertyAll(Colors.white24),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    child: Text(
                      "Search",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
