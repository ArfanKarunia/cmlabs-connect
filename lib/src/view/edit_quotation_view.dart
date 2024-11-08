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

class EditQuotationView extends StatefulWidget {
  EditQuotationView({super.key, required this.quotation});

  final Quotation quotation;

  final DetailQuotationController detailQuotationController =
      Get.put(DetailQuotationController());

  final UrlTrackingController urlTrackingController =
      Get.put(UrlTrackingController());

  final TextEditingController topicActivity = TextEditingController();

  final TextEditingController noteActivity = TextEditingController();

  var isChanged = false.obs;

  void showChangeConfirmationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white_1,
      isScrollControlled: true,
      builder: (context) {
        return Wrap(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                bottom: 50,
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
                  Text(
                    "Delete",
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.text_1,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Are you sure wanna delete this Cardbox?",
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.text_1,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(AppColors.primary),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      child: Text(
                        "Yes, delete it",
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.white_1,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Swipe down or Tap the screen to close",
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
      },
    );
  }

  @override
  State<EditQuotationView> createState() => _EditQuotationViewState();
}

class _EditQuotationViewState extends State<EditQuotationView> {
  @override
  Widget build(BuildContext context) {
    widget.detailQuotationController.clearSelectedData();
    widget.detailQuotationController.editSelectedData(widget.quotation);

    print("Data Client PIC pada quotation");
    // print(
    //     "banyak client pic : ${widget.detailQuotationController.selectedPICClient.length}");
    // print(
    //     "banyak contact client pic 1 : ${widget.detailQuotationController.selectedPICClient[0].contacts.length}");
    // print(
    //     "tyoe contact client pic 1 : ${widget.detailQuotationController.selectedPICClient[0].contacts[0]!.type ?? 'type kosong'}");
    // print(
    //     "info contact client pic 1 : ${widget.detailQuotationController.selectedPICClient[0].contacts[0]!.info ?? 'info kosong'}");
    // print(
    //     "status contact client pic 1 : ${widget.detailQuotationController.selectedPICClient[0].contacts[0]!.status ?? 'status kosong'}");
    // print(
    //     "detail Status contact client pic 1 : ${widget.detailQuotationController.selectedPICClient[0].contacts[0]!.detail ?? 'detail kosong'}");
    // print(
    //     "note contact client pic 1 : ${widget.detailQuotationController.selectedPICClient[0].contacts[0]!.note ?? 'note kosong'}");

    // print("pic : ${widget.quotation.data.pic}");
    // print("priority : ${widget.quotation.priority}");
    // print("status : ${widget.quotation.status}");

    // print("Data pada Selected");
    // print("pic : ${widget.detailQuotationController.selectPic}");
    // print("priority : ${widget.detailQuotationController.selectPriority}");
    // print("status : ${widget.detailQuotationController.selectStatus}");

    // print("typeList : ${widget.detailQuotationController.typeList}");
    // print("type : ${widget.detailQuotationController.selectedType}");

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Obx(
            () {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectField(
                    name: "PIC",
                    isMandatory: true,
                    child: Container(
                        child:
                            (widget.detailQuotationController.selectPic.value ==
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
                                  )),
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
                  const SizedBox(
                    height: 16,
                  ),
                  SelectField(
                    name: "Priority",
                    child: Container(
                      child: (widget.detailQuotationController.selectPriority
                                  .value ==
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
                              widget.detailQuotationController.selectPriority
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
                          'selectData': "priority",
                          'controller': widget.detailQuotationController,
                        },
                      );
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SelectField(
                    name: "Status",
                    child: Obx(
                      () {
                        return Container(
                          child: (widget.detailQuotationController.selectStatus
                                      .value ==
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
                                  widget.detailQuotationController.selectStatus
                                          .value?['label'] ??
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
                  const SizedBox(
                    height: 16,
                  ),
                  SelectField(
                    name: "Type",
                    child: Obx(
                      () {
                        return Container(
                          child: (widget.detailQuotationController.selectedType
                                      .value ==
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
                                  widget.detailQuotationController.selectedType
                                          .value?['label'] ??
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
                  const SizedBox(
                    height: 25,
                  ),
                  ClientSidePICSection(
                    controller: widget.detailQuotationController,
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ActivitySection(),
                  const SizedBox(
                    height: 25,
                  ),
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
                                thumbColor:
                                    WidgetStatePropertyAll(AppColors.white_1),
                                trackOutlineWidth: WidgetStatePropertyAll(0),
                                trackOutlineColor:
                                    WidgetStatePropertyAll(Colors.transparent),
                                trackColor: (!widget
                                        .urlTrackingController.isTracking.value)
                                    ? WidgetStatePropertyAll(Color(0xFFD8DAE5))
                                    : WidgetStatePropertyAll(AppColors.primary),
                                value: widget
                                    .urlTrackingController.isTracking.value,
                                onChanged: (bool value) {
                                  widget.urlTrackingController.isTracking
                                      .value = value;
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
                  const SizedBox(
                    height: 25,
                  ),
                  Text(
                    "History",
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.text_1,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
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
                                    widget.detailQuotationController);
                          },
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                ],
              );
            },
          ),
        ),
      ),
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

class URLTrackingSection extends StatelessWidget {
  const URLTrackingSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "URL",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.text_3,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            // controller: widget.controller,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.text_1,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: AppColors.primary,
                ),
              ),
              hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.text_4),
              hintText: "URL",
              errorStyle: GoogleFonts.plusJakartaSans(
                  color: AppColors.danger,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            height: 51,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(AppColors.primary),
                foregroundColor: WidgetStatePropertyAll(AppColors.white_1),
                overlayColor: WidgetStatePropertyAll(Colors.white30),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              child: Text(
                "Copy URL",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            "Password",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.text_3,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextFormField(
            // controller: widget.controller,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.text_1,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: AppColors.primary,
                ),
              ),
              hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.text_4),
              hintText: "Password",
              errorStyle: GoogleFonts.plusJakartaSans(
                  color: AppColors.danger,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            height: 51,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(AppColors.primary),
                foregroundColor: WidgetStatePropertyAll(AppColors.white_1),
                overlayColor: WidgetStatePropertyAll(Colors.white30),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              child: Text(
                "Generate Password",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          SelectField(
            name: "Validity",
            child: Text("Select Validity"),
            onPressed: () {},
          ),
        ],
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
