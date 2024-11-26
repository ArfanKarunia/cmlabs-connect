import 'package:cmlabs_connect/src/controllers/edit_quotation/url_tracking_controller.dart';
import 'package:cmlabs_connect/src/utils/toast.dart';
import 'package:cmlabs_connect/src/view/detail_quotation/select_field_edit_quotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../../utils/color.dart';

class URLTrackingSection extends StatelessWidget {
  URLTrackingSection({
    super.key,
  });

  final UrlTrackingController urlTrackingController =
      Get.put(UrlTrackingController());

  var _obscureText = true.obs;

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
            controller: urlTrackingController.urlController,
            maxLines: 2,
            readOnly: true,
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
              onPressed: () {
                Clipboard.setData(ClipboardData(
                    text: urlTrackingController.urlController.text));
                showSuccessToast("Berhasil menyimpan URL");
              },
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
          Obx(
            () {
              return TextFormField(
                controller: urlTrackingController.passwordController,
                obscureText: _obscureText.value,
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
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText.value
                          ? Ionicons.eye_off_outline
                          : Ionicons
                              .eye_outline, // Mengubah icon berdasarkan state
                    ),
                    onPressed: () {
                      _obscureText.value = !_obscureText.value;
                    },
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            height: 51,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                urlTrackingController.generatePassword();
              },
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
          SelectFieldEditQuotation(
            name: "Validity",
            child: Obx(
              () {
                return (urlTrackingController.selectedValidity.value != null)
                    ? Text(
                        "${urlTrackingController.selectedValidity.value!['label']}",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.text_1,
                        ),
                      )
                    : Text(
                        "Select status",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.text_3,
                        ),
                      );
              },
            ),
            onPressed: () {
              Get.toNamed(
                "/editSelect",
                arguments: {
                  'selectData': "validity_url_tracking",
                  'controller': urlTrackingController,
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
