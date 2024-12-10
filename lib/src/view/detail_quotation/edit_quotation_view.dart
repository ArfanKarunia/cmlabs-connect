import 'package:cmlabs_connect/src/controllers/edit_quotation/edit_quotation_controller.dart';
import 'package:cmlabs_connect/src/controllers/edit_quotation/history_changes_controller.dart';
import 'package:cmlabs_connect/src/controllers/edit_quotation/url_tracking_controller.dart';
import 'package:cmlabs_connect/src/models/quotation_model.dart';
import 'package:cmlabs_connect/src/utils/bottom_sheet.dart';
import 'package:cmlabs_connect/src/view/detail_quotation/edit_section/general_section.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/color.dart';
import 'edit_section/activity_section.dart';
import 'edit_section/client_pic_section.dart';
import 'edit_section/history_section.dart';
import 'edit_section/url_tracking_section.dart';

class EditQuotationView extends StatefulWidget {
  EditQuotationView({super.key, required this.quotation});

  final Quotation quotation;

  final EditQuotationController editQuotationController =
      Get.put(EditQuotationController());

  final UrlTrackingController urlTrackingController =
      Get.put(UrlTrackingController());

  final HistoryChangesController historyChangesController =
      Get.put(HistoryChangesController());

  @override
  State<EditQuotationView> createState() => _EditQuotationViewState();
}

class _EditQuotationViewState extends State<EditQuotationView> {
  // @override
  // void dispose() {
  //   // Menjalankan aksi yang diperlukan saat view ditutup
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     widget.detailQuotationController.clearSelectedData();
  //     widget.detailQuotationController.isChanged.value = false;
  //   });
  //   super.dispose();
  // }

  @override
  void initState() {
    super.initState();
    // Menjalankan aksi pertama kali saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.editQuotationController.loadExistingData(widget.quotation);
      widget.historyChangesController.fetchHistoryChanges(widget.quotation.id);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFFF9F9F9),
        surfaceTintColor: Color(0xFFF9F9F9),
        title: Text(
          "Detail Leads",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.text_1,
          ),
        ),
      ),
      body: Obx(
        () {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Edit PIC, Priority, Status, & Type
                      GeneralSection(),
                      const SizedBox(height: 25),

                      // Edit Client PIC (name, position, & Contact)
                      ClientSidePICSection(),
                      const SizedBox(height: 25),

                      // Edit Activity (topic, schedule, status activity, type activity, note activity, remarks, & additional note)
                      ActivitySection(),
                      const SizedBox(height: 25),

                      // Edit URL Tracking, password, & validity
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "URL Tracking",
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.text_1,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Obx(
                            () {
                              return SizedBox(
                                height: 35,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Switch(
                                    thumbColor: WidgetStatePropertyAll(
                                        AppColors.white_1),
                                    trackOutlineWidth:
                                        WidgetStatePropertyAll(0),
                                    trackOutlineColor: WidgetStatePropertyAll(
                                        Colors.transparent),
                                    trackColor: (!widget.urlTrackingController
                                            .isTracking.value)
                                        ? WidgetStatePropertyAll(
                                            Color(0xFFD8DAE5))
                                        : WidgetStatePropertyAll(
                                            AppColors.primary),
                                    value: widget
                                        .urlTrackingController.isTracking.value,
                                    onChanged: (bool value) {
                                      widget.urlTrackingController
                                          .changeStatusTracking(
                                              widget.quotation.id, value);

                                      widget.editQuotationController
                                          .onFieldChanged();
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      (widget.urlTrackingController.isTracking.value)
                          ? URLTrackingSection()
                          : SizedBox.shrink(),
                      const SizedBox(height: 25),

                      // EDIT history changes lead
                      HistorySection(),
                      const SizedBox(height: 180),
                    ],
                  ),
                ),
              ),

              // Button Save
              Obx(
                () {
                  bool isVisible =
                      widget.editQuotationController.isChanged.value;
                  bool isKeyboardShow =
                      MediaQuery.of(context).viewInsets.bottom != 0;

                  return TweenAnimationBuilder<double>(
                    tween: Tween(
                      begin: isVisible ? -200 : 0,
                      end: isVisible ? 0 : -200,
                    ),
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    builder: (context, value, child) {
                      return Positioned(
                        bottom: value,
                        left: 0,
                        right: 0,
                        child: (isKeyboardShow)
                            ? SizedBox.shrink()
                            : BottomSheetSaveChanges(
                                quotation: widget.quotation,
                                onPressed: () {
                                  widget.editQuotationController
                                      .updateQuotation(widget.quotation);
                                },
                              ),
                      );
                    },
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
