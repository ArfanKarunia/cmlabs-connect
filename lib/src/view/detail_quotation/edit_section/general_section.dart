import 'package:cmlabs_connect/src/controllers/edit_quotation/general_info_controller.dart';
import 'package:cmlabs_connect/src/view/detail_quotation/select_field_edit_quotation.dart';
import 'package:cmlabs_connect/src/widgets/tag_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/color.dart';

class GeneralSection extends StatelessWidget {
  GeneralSection({
    super.key,
  });

  final GeneralInfoController generalInfoController =
      Get.put(GeneralInfoController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectFieldEditQuotation(
          name: "PIC",
          isMandatory: true,
          child: Container(
            child: Obx(
              () {
                return (generalInfoController.selectPic.value == null ||
                        generalInfoController.selectPic.value == {})
                    ? Text(
                        "Select PIC",
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.text_3,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : Text(
                        generalInfoController.selectPic.value?['label'] ?? "-",
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.text_1,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      );
              },
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
          },
        ),
        const SizedBox(height: 16),
        SelectFieldEditQuotation(
          name: "Priority",
          child: Container(
            child: Obx(
              () {
                return (generalInfoController.selectPriority.value == null)
                    ? Text(
                        "Select priority",
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.text_3,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : Text(
                        generalInfoController.selectPriority.value?['label'] ??
                            "-",
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.text_1,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      );
              },
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
          },
        ),
        const SizedBox(height: 16),
        SelectFieldEditQuotation(
          name: "Status",
          child: Container(
            child: Obx(
              () {
                return (generalInfoController.selectStatus.value == null)
                    ? Text(
                        "Select status",
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.text_3,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : Text(
                        generalInfoController.selectStatus.value?['label'] ??
                            "-",
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.text_1,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      );
              },
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
          },
        ),
        const SizedBox(height: 16),
        SelectFieldEditQuotation(
          name: "Type",
          child: Container(
            child: Obx(
              () {
                return (generalInfoController.selectType.value == null)
                    ? Text(
                        "Select Type",
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.text_3,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    : Text(
                        generalInfoController.selectType.value?['label'] ?? "-",
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.text_1,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      );
              },
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
          },
        ),
      ],
    );
  }
}
