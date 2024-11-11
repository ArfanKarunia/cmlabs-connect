import 'package:cmlabs_connect/src/constant/const.dart';
import 'package:cmlabs_connect/src/controllers/detail_quotation_controller.dart';
import 'package:cmlabs_connect/src/controllers/url_tracking_controller.dart';
import 'package:cmlabs_connect/src/models/quotation_model.dart';

import 'package:cmlabs_connect/src/widgets/quotation_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../utils/color.dart';
import '../widgets/custom_buttom.dart';
import 'Detail Section/activity_section.dart';
import 'Detail Section/client_pic_section.dart';
import 'Detail Section/url_tracking_section.dart';

class EditQuotationView extends StatefulWidget {
  EditQuotationView({super.key, required this.quotation});

  final Quotation quotation;

  final DetailQuotationController detailQuotationController =
      Get.put(DetailQuotationController());

  final UrlTrackingController urlTrackingController =
      Get.put(UrlTrackingController());

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
                      Text(
                        "History",
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.text_1,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: 2,
                              itemBuilder: (context, index) {
                                return HistorySection(
                                  detailQuotationController:
                                      widget.detailQuotationController,
                                );
                              },
                            )
                          ],
                        ),
                      ),
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

class HistorySection extends StatelessWidget {
  const HistorySection({
    super.key,
    required this.detailQuotationController,
  });

  final DetailQuotationController detailQuotationController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      margin: EdgeInsets.only(bottom: 15),
      width: double.infinity,
      color: AppColors.white_1,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Activity",
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.text_1,
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Request is Created",
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.text_2,
                fontSize: 12,
              ),
            ),
            Divider(),
            Text(
              "Date Time",
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.text_1,
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "1 Mei 2024, 20:30:12",
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.text_2,
                fontSize: 12,
              ),
            ),
            Divider(),
            Text(
              "Created by",
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.text_1,
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              "Super Admin",
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.text_2,
                fontSize: 12,
              ),
            ),
            Divider(),
            Text(
              "Status",
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.text_1,
                fontSize: 14,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            StatusLeadUI(statusLead: StatusLead.newLead),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  "Available to User",
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 14, color: AppColors.text_1),
                ),
                SizedBox(
                  width: 10,
                ),
                Obx(
                  () {
                    return SizedBox(
                      height: 35,
                      child: FittedBox(
                        fit: BoxFit.fill,
                        child: Switch(
                          thumbColor: WidgetStatePropertyAll(AppColors.white_1),
                          trackOutlineWidth: WidgetStatePropertyAll(0),
                          trackOutlineColor:
                              WidgetStatePropertyAll(Colors.transparent),
                          trackColor: (!detailQuotationController
                                  .isAvailableToUser.value)
                              ? WidgetStatePropertyAll(Color(0xFFD8DAE5))
                              : WidgetStatePropertyAll(AppColors.primary),
                          value:
                              detailQuotationController.isAvailableToUser.value,
                          onChanged: (bool value) {
                            detailQuotationController.isAvailableToUser.value =
                                value;
                          },
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 51,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        shadowColor: WidgetStatePropertyAll(Colors.transparent),
                        backgroundColor:
                            WidgetStatePropertyAll(AppColors.bgInfo),
                        foregroundColor: WidgetStatePropertyAll(AppColors.info),
                        overlayColor: WidgetStatePropertyAll(Colors.black12),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(Icons.chat_bubble_outline),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Icon(
                                  Icons.edit,
                                  size: 10,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Edit",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Container(
                    height: 51,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        shadowColor: WidgetStatePropertyAll(Colors.transparent),
                        backgroundColor:
                            WidgetStatePropertyAll(AppColors.bgDanger),
                        foregroundColor:
                            WidgetStatePropertyAll(AppColors.danger),
                        overlayColor: WidgetStatePropertyAll(Colors.black12),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Ionicons.trash_outline),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Delete",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
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
