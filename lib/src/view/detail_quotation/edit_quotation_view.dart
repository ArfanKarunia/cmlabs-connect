import 'package:cmlabs_connect/src/controllers/detail_quotation_controller.dart';
import 'package:cmlabs_connect/src/controllers/history_changes_controller.dart';
import 'package:cmlabs_connect/src/controllers/url_tracking_controller.dart';
import 'package:cmlabs_connect/src/models/quotation_model.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../utils/color.dart';
import '../../widgets/custom_buttom.dart';
import 'detail_section/activity_section.dart';
import 'detail_section/client_pic_section.dart';
import 'detail_section/history_section.dart';
import 'detail_section/url_tracking_section.dart';

class EditQuotationView extends StatefulWidget {
  EditQuotationView({super.key, required this.quotation});

  final Quotation quotation;

  final DetailQuotationController detailQuotationController =
      Get.put(DetailQuotationController());

  final UrlTrackingController urlTrackingController =
      Get.put(UrlTrackingController());

  final HistoryChangesController historyChangesController = Get.put(HistoryChangesController());

  final TextEditingController topicActivity = TextEditingController();

  final TextEditingController noteActivity = TextEditingController();

  @override
  State<EditQuotationView> createState() => _EditQuotationViewState();
}

class _EditQuotationViewState extends State<EditQuotationView> {
  @override
  void initState() {
    super.initState();
    // Menjalankan aksi pertama kali saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.detailQuotationController.editSelectedData(widget.quotation);
      widget.detailQuotationController.isChanged.value = false;
    });
  }

  @override
  void dispose() {
    // Menjalankan aksi yang diperlukan saat view ditutup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.detailQuotationController.clearSelectedData();
      widget.detailQuotationController.isChanged.value = false;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.detailQuotationController.editSelectedData(widget.quotation);
    widget.historyChangesController.fetchHistoryChanges(widget.quotation.id);

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
                      SelectField(
                        name: "PIC",
                        isMandatory: true,
                        child: Container(
                          child: (widget.detailQuotationController.selectPic
                                      .value ==
                                  null)
                              ? Text(
                                  "Select PIC",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.text_3,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : Text(
                                  widget.detailQuotationController.selectPic
                                          .value?['label'] ??
                                      "-",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.text_1,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                        ),
                        onPressed: () {
                          Get.toNamed(
                            "/editSelect",
                            arguments: {
                              'selectData': "pic",
                              'controller': widget.detailQuotationController,
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      SelectField(
                        name: "Priority",
                        child: Container(
                          child: (widget.detailQuotationController
                                      .selectPriority.value ==
                                  null)
                              ? Text(
                                  "Select priority",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.text_3,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : Text(
                                  widget.detailQuotationController
                                          .selectPriority.value?['label'] ??
                                      "-",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.text_1,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                        ),
                        onPressed: () {
                          Get.toNamed(
                            "/editSelect",
                            arguments: {
                              'selectData': "priority",
                              'controller': widget.detailQuotationController,
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      SelectField(
                        name: "Status",
                        child: Obx(
                          () {
                            return Container(
                              child: (widget.detailQuotationController
                                          .selectStatus.value ==
                                      null)
                                  ? Text(
                                      "Select status",
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.text_3,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  : Text(
                                      widget.detailQuotationController
                                              .selectStatus.value?['label'] ??
                                          "-",
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.text_1,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                            );
                          },
                        ),
                        onPressed: () {
                          Get.toNamed(
                            "/editSelect",
                            arguments: {
                              'selectData': "status",
                              'controller': widget.detailQuotationController,
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      SelectField(
                        name: "Type",
                        child: Obx(
                          () {
                            return Container(
                              child: (widget.detailQuotationController
                                          .selectedType.value ==
                                      null)
                                  ? Text(
                                      "Select type",
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.text_3,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  : Text(
                                      widget.detailQuotationController
                                              .selectedType.value?['label'] ??
                                          "-",
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.text_1,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                            );
                          },
                        ),
                        onPressed: () {
                          Get.toNamed(
                            "/editSelect",
                            arguments: {
                              'selectData': "type",
                              'controller': widget.detailQuotationController,
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 25),
                      ClientSidePICSection(
                          controller: widget.detailQuotationController),
                      const SizedBox(height: 25),
                      ActivitySection(),
                      const SizedBox(height: 25),
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
                      HistorySection(),
                      const SizedBox(height: 180),
                    ],
                  ),
                ),
              ),
              Obx(
                () {
                  bool isVisible =
                      widget.detailQuotationController.isChanged.value;
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

class BottomSheetSaveChanges extends StatefulWidget {
  BottomSheetSaveChanges({super.key, required this.quotation});

  Quotation quotation;

  @override
  State<BottomSheetSaveChanges> createState() => _BottomSheetSaveChangesState();
}

class _BottomSheetSaveChangesState extends State<BottomSheetSaveChanges> {
  DetailQuotationController detailQuotationController =
      Get.put(DetailQuotationController());

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: AppColors.white_1,
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(30, 0, 0, 0),
                offset: const Offset(0, -4),
                blurRadius: 10,
              ),
            ],
          ),
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            bottom: 20,
            top: 25,
          ),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: () {
                    detailQuotationController.updateQuotation(widget.quotation);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(AppColors.primary),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: Text(
                    "Save",
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.white_1,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Click to save all changes",
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.text_2,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SelectField extends StatelessWidget {
  SelectField({
    super.key,
    required this.name,
    required this.child,
    required this.onPressed,
    this.isMandatory = false,
  });

  String name;
  bool isMandatory;
  VoidCallback onPressed;
  Widget child;

  @override
  Widget build(BuildContext context) {

    
    return Column(
      children: [
        Row(
          children: [
            Text(
              name,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.text_3,
              ),
            ),
            (isMandatory)
                ? Text(
                    "*",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.danger,
                    ),
                  )
                : Container(),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 51,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryText),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                child: child,
                width: double.infinity,
              ),
              Container(
                height: 45,
                width: 45,
                child: CustomButton(
                  backgroundColor: AppColors.white_1,
                  onPressed: onPressed,
                  child: const Icon(
                    Ionicons.chevron_down_outline,
                    color: AppColors.text_1,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
