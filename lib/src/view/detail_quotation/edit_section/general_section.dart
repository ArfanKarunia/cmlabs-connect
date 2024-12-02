import 'package:cmlabs_connect/src/controllers/edit_quotation/edit_quotation_controller.dart';
import 'package:cmlabs_connect/src/controllers/edit_quotation/general_info_controller.dart';
import 'package:cmlabs_connect/src/view/detail_quotation/select_field_edit_quotation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/color.dart';

class GeneralSection extends StatelessWidget {
  GeneralSection({
    super.key,
  });

  final GeneralInfoController generalInfoController =
      Get.find<GeneralInfoController>();
  final EditQuotationController editQuotationController =
      Get.put(EditQuotationController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final selectPic = generalInfoController.selectPic.value;
          return SelectFieldEditQuotation(
            name: "PIC",
            isMandatory: true,
            child: Container(
              child: selectPic == null || selectPic.isEmpty
                  ? Text(
                      "Select PIC",
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.text_3,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  : Text(
                      selectPic['label'] ?? "-",
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
                  'controller': generalInfoController,
                },
              );
              editQuotationController.onFieldChanged();
            },
          );
        }),
        const SizedBox(height: 16),
        Obx(() {
          final selectPriority = generalInfoController.selectPriority.value;
          return SelectFieldEditQuotation(
            name: "Priority",
            child: Container(
              child: selectPriority == null
                  ? Text(
                      "Select priority",
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.text_3,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  : Text(
                      selectPriority['label'] ?? "-",
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
                  'controller': generalInfoController,
                },
              );
              editQuotationController.onFieldChanged();
            },
          );
        }),
        const SizedBox(height: 16),
        Obx(() {
          final selectStatus = generalInfoController.selectStatus.value;
          return SelectFieldEditQuotation(
            name: "Status",
            child: Container(
              child: selectStatus == null
                  ? Text(
                      "Select status",
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.text_3,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  : Text(
                      selectStatus['label'] ?? "-",
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
                  'selectData': "status",
                  'controller': generalInfoController,
                },
              );
              editQuotationController.onFieldChanged();
            },
          );
        }),
        const SizedBox(height: 16),
        Obx(
          () {
            final selectType = generalInfoController.selectType.value;
            return SelectFieldEditQuotation(
              name: "Type",
              child: Container(
                child: selectType == null
                    ? Text(
                        "Select Type",
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.text_3,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : Text(
                        selectType['label'] ?? "-",
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
                    'selectData': "type",
                    'controller': generalInfoController,
                  },
                );
                editQuotationController.onFieldChanged();
              },
            );
          },
        ),
      ],
    );
  }
}
