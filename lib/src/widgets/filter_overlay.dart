import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:quotation_app/src/controllers/bottom_nav_controller.dart';
import 'package:quotation_app/src/controllers/category_controller.dart';
import 'package:quotation_app/src/controllers/client_source_controller.dart';
import 'package:quotation_app/src/controllers/filter_controller.dart';
import 'package:quotation_app/src/controllers/quotation_controller.dart';
import 'package:quotation_app/src/models/category_model.dart';
import 'package:quotation_app/src/models/client_source_model.dart';
import 'package:quotation_app/src/utils/color.dart';

import '../constant/const.dart';

class FilterOverlay extends StatefulWidget {
  FilterOverlay({
    super.key,
    required this.controller,
  });

  final BottomNavController controller;

  @override
  State<FilterOverlay> createState() => _FilterOverlayState();
}

class _FilterOverlayState extends State<FilterOverlay> {
  final QuotationController quotationController =
      Get.put(QuotationController());

  final CategoryController categoryController = Get.put(CategoryController());

  final ClientSourceController clientSourceController =
      Get.put(ClientSourceController());

  // menyimpan nilai sementara untuk filter
  final Rx<DateTime?> temporaryStartDate = Rx<DateTime?>(null);

  final Rx<DateTime?> temporaryEndDate = Rx<DateTime?>(null);

  final Rx<StatusLead?> temporaryStatusLead = Rx<StatusLead?>(null);

  final Rx<Category?> temporaryCategory = Rx<Category?>(null);

  final Rx<ClientSource?> temporaryClienSource = Rx<ClientSource?>(null);

  final TextEditingController startDateController = TextEditingController();

  final TextEditingController endDateController = TextEditingController();

  void clearFilter() {
    temporaryStartDate.value = null;
    temporaryEndDate.value = null;
    temporaryStatusLead.value = null;
    temporaryCategory.value = null;
    temporaryClienSource.value = null;

    startDateController.clear();
    endDateController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return (widget.controller.isFilterActive.value)
            ? Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  // Background Blur
                  GestureDetector(
                    onTap: () => widget.controller.toggleFilterVisibility(),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.linear,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: widget.controller.blurValue.value,
                          sigmaY: widget.controller.blurValue.value,
                        ),
                        child: Container(
                          color: Colors.black38,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ),
                  ),

                  // Filter Overlay

                  Container(
                    width: double.infinity,
                    height: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.white_1,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Text("Ini Filter"),
                  )

                  // Container(
                  //   padding: const EdgeInsets.all(25),
                  //   width: double.infinity,
                  //   decoration: BoxDecoration(
                  //     color: AppColors.white,
                  //     border: Border.all(
                  //       color: AppColors.primary,
                  //       width: 1,
                  //     ),
                  //     borderRadius: const BorderRadius.only(
                  //       topLeft: Radius.circular(20),
                  //       topRight: Radius.circular(20),
                  //     ),
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     mainAxisSize: MainAxisSize.min,
                  //     children: [
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           const Text(
                  //             "Filter",
                  //             style: TextStyle(
                  //               fontSize: 16,
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //           GestureDetector(
                  //             onTap: () {
                  //               quotationController.clearFilter();
                  //               clearFilter();

                  //               widget.controller
                  //                   .toggleFilterVisibility();
                  //             },
                  //             child: const Text(
                  //               "Clear",
                  //               style: TextStyle(
                  //                 decoration: TextDecoration.underline,
                  //                 fontSize: 12,
                  //                 fontWeight: FontWeight.bold,
                  //                 color: AppColors.primary,
                  //               ),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       const SizedBox(
                  //         height: 15,
                  //       ),
                        // const Text(
                        //   "Data range",
                        //   style: TextStyle(
                        //     fontSize: 12,
                        //     fontWeight: FontWeight.w600,
                        //   ),
                        // ),
                        // const SizedBox(
                        //   height: 5,
                        // ),
                        // SizedBox(
                        //   child: Row(
                        //     children: [
                        //       Expanded(
                        //         child: TextFormField(
                        //           style: TextStyle(
                        //             fontSize: 14,
                        //           ),
                        //           decoration: const InputDecoration(
                        //             border: OutlineInputBorder(),
                        //           ),
                        //           readOnly: true,
                        //           controller: startDateController,
                        //           onTap: () async {
                        //             DateTime? pickedDate = await showDatePicker(
                        //               context: context,
                        //               initialDate: quotationController
                        //                       .filterStartDate.value ??
                        //                   DateTime.now(),
                        //               firstDate: DateTime(2000),
                        //               lastDate: DateTime(2100),
                        //             );
                        //             if (pickedDate != null) {
                        //               temporaryStartDate.value = pickedDate;
                        //               startDateController.text =
                        //                   DateFormat('yyyy-MM-dd')
                        //                       .format(pickedDate);
                        //             }
                        //           },
                        //         ),
                        //       ),
                        //       const SizedBox(width: 10), // Spasi antar form
                        //       const Text(
                        //         "to",
                        //         style: TextStyle(
                        //           fontSize: 12,
                        //         ),
                        //       ),
                        //       const SizedBox(width: 10), // Spasi antar form
                        //       Expanded(
                        //         child: TextFormField(
                        //           style: TextStyle(
                        //             fontSize: 14,
                        //           ),
                        //           decoration: const InputDecoration(
                        //             border: OutlineInputBorder(),
                        //           ),
                        //           readOnly: true,
                        //           controller: endDateController,
                        //           onTap: () async {
                                    // DateTime? pickedDate = await showDatePicker(
                                    //   context: context,
                                    //   initialDate: quotationController
                                    //           .filterEndDate.value ??
                                    //       DateTime.now(),
                                    //   firstDate: DateTime(2000),
                                    //   lastDate: DateTime(2100),
                                    // );
                                    // if (pickedDate != null) {
                                    //   temporaryEndDate.value = pickedDate;
                                    //   endDateController.text =
                                    //       DateFormat('yyyy-MM-dd')
                                    //           .format(pickedDate);
                                    // }
                        //           },
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                  //       const SizedBox(
                  //         height: 15,
                  //       ),
                  //       Row(
                  //         children: [
                  //           Expanded(
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 const Text(
                  //                   "Status",
                  //                   style: TextStyle(
                  //                     fontSize: 12,
                  //                     fontWeight: FontWeight.w600,
                  //                   ),
                  //                 ),
                  //                 const SizedBox(
                  //                   height: 5,
                  //                 ),
                  //                 Container(
                  //                   height: 40,
                  //                   padding:
                  //                       EdgeInsets.symmetric(horizontal: 10),
                  //                   width: double.infinity,
                  //                   decoration: BoxDecoration(
                  //                       border: Border.all(
                  //                           color: AppColors.primaryText),
                  //                       borderRadius: BorderRadius.circular(5)),
                  //                   child: DropdownButton<StatusLead>(
                  //                     isExpanded: true,
                  //                     focusColor: AppColors.primary,
                  //                     borderRadius: BorderRadius.circular(10),
                  //                     dropdownColor: AppColors.white,
                  //                     style: TextStyle(
                  //                         fontSize: 14,
                  //                         color: AppColors.primaryText),
                  //                     value: temporaryStatusLead.value,
                  //                     items: StatusLead.values.map((value) {
                  //                       String label;

                  //                       switch (value) {
                  //                         case StatusLead.newLead:
                  //                           label = 'New';
                  //                           break;
                  //                         case StatusLead.followedUp:
                  //                           label = 'Followed Up';
                  //                           break;
                  //                         case StatusLead.accepted:
                  //                           label = 'Accepted';
                  //                           break;
                  //                         case StatusLead.rejected:
                  //                           label = 'Rejected';
                  //                           break;
                  //                       }
                  //                       return DropdownMenuItem<StatusLead>(
                  //                         child: Text(label),
                  //                         value: value,
                  //                       );
                  //                     }).toList(),
                  //                     onChanged: (StatusLead? value) {
                  //                       temporaryStatusLead.value = value;
                  //                     },
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //           const SizedBox(
                  //             width: 15,
                  //           ),
                  //           Expanded(
                  //             child: Column(
                  //               crossAxisAlignment: CrossAxisAlignment.start,
                  //               children: [
                  //                 const Text(
                  //                   "Client Source",
                  //                   style: TextStyle(
                  //                     fontSize: 12,
                  //                     fontWeight: FontWeight.w600,
                  //                   ),
                  //                 ),
                  //                 const SizedBox(
                  //                   height: 5,
                  //                 ),
                  //                 Container(
                  //                   height: 40,
                  //                   padding:
                  //                       EdgeInsets.symmetric(horizontal: 10),
                  //                   width: double.infinity,
                  //                   decoration: BoxDecoration(
                  //                       border: Border.all(
                  //                           color: AppColors.primaryText),
                  //                       borderRadius: BorderRadius.circular(5)),
                  //                   child: DropdownButton<ClientSource>(
                  //                     isExpanded: true,
                  //                     focusColor: AppColors.primary,
                  //                     borderRadius: BorderRadius.circular(10),
                  //                     dropdownColor: AppColors.white,
                  //                     style: TextStyle(
                  //                         fontSize: 14,
                  //                         color: AppColors.primaryText),
                  //                     value: temporaryClienSource.value,
                  //                     items: clientSourceController
                  //                         .getListClientSource
                  //                         .map((source) {
                  //                       return DropdownMenuItem<ClientSource>(
                  //                         child: Text(source.name),
                  //                         value: source,
                  //                       );
                  //                     }).toList(),
                  //                     onChanged:
                  //                         (ClientSource? selectedClientSource) {
                  //                       temporaryClienSource.value =
                  //                           selectedClientSource;
                  //                     },
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       const SizedBox(
                  //         height: 15,
                  //       ),
                  //       const Text(
                  //         "Category",
                  //         style: TextStyle(
                  //           fontSize: 12,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //       const SizedBox(
                  //         height: 5,
                  //       ),
                  //       Container(
                  //         height: 40,
                  //         padding: EdgeInsets.symmetric(horizontal: 10),
                  //         width: double.infinity,
                  //         decoration: BoxDecoration(
                  //             border: Border.all(color: AppColors.primaryText),
                  //             borderRadius: BorderRadius.circular(5)),
                  //         child: DropdownButton<Category>(
                  //           isExpanded: true,
                  //           focusColor: AppColors.primary,
                  //           borderRadius: BorderRadius.circular(10),
                  //           dropdownColor: AppColors.white,
                  //           style: TextStyle(
                  //               fontSize: 14, color: AppColors.primaryText),
                  //           value: temporaryCategory.value,
                  //           items: categoryController.getListCategory
                  //               .map((category) {
                  //             return DropdownMenuItem<Category>(
                  //               child: Text(category.name),
                  //               value: category,
                  //             );
                  //           }).toList(),
                  //           onChanged: (Category? selectedCategory) {
                  //             temporaryCategory.value = selectedCategory;
                  //           },
                  //         ),
                  //       ),
                  //       const SizedBox(
                  //         height: 15,
                  //       ),
                  //       const Text(
                  //         "PIC",
                  //         style: TextStyle(
                  //           fontSize: 12,
                  //           fontWeight: FontWeight.w600,
                  //         ),
                  //       ),
                  //       const SizedBox(
                  //         height: 5,
                  //       ),
                  //       SizedBox(
                  //         height: 40,
                  //         width: double.infinity,
                  //         child: TextFormField(
                  //           decoration: const InputDecoration(
                  //             border: OutlineInputBorder(),
                  //           ),
                  //         ),
                  //       ),
                  //       const SizedBox(
                  //         height: 50,
                  //       ),
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.center,
                  //         children: [
                  //           SizedBox(
                  //             height: 35,
                  //             width: 200,
                  //             child: ElevatedButton(
                  //               style: ButtonStyle(
                  //                 backgroundColor: const WidgetStatePropertyAll(
                  //                     AppColors.primary),
                  //                 foregroundColor: const WidgetStatePropertyAll(
                  //                     AppColors.white),
                  //                 overlayColor: const WidgetStatePropertyAll(
                  //                     Colors.white30),
                  //                 shape: WidgetStatePropertyAll(
                  //                   RoundedRectangleBorder(
                  //                     borderRadius: BorderRadius.circular(10),
                  //                   ),
                  //                 ),
                  //               ),
                  //               onPressed: () {
                  //                 // filter Category
                  //                 quotationController.setFilterCategory(
                  //                     temporaryCategory.value);

                  //                 // filter Client Source
                  //                 quotationController.setFilterClientSource(
                  //                     temporaryClienSource.value);

                  //                 // filter Status Lead
                  //                 quotationController.setFilterStatus(
                  //                     temporaryStatusLead.value);

                  //                 // filter Date Range
                  //                 quotationController.filterStartDate.value =
                  //                     temporaryStartDate.value;
                  //                 quotationController.filterEndDate.value =
                  //                     temporaryEndDate.value;

                  //                 // close Filter Container
                  //                 widget.controller
                  //                     .toggleFilterVisibility();
                  //               },
                  //               child: const Text("Submit"),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       const SizedBox(
                  //         height: 20,
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              )
            : Container();
      },
    );
  }
}
