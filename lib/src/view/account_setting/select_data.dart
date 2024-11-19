import 'package:cmlabs_connect/src/controllers/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/color.dart';

class SelectData extends StatelessWidget {
  SelectData({super.key, required this.data});

  final String data;

  final AccountController accountController = Get.put(AccountController());

  var temporaryData = Rx<Map<String, dynamic>?>(null);

  @override
  Widget build(BuildContext context) {
    temporaryData.value = null;

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFFF9F9F9),
        surfaceTintColor: Color(0xFFF9F9F9),
        title: Text(
          data,
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
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white_1,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount:
                      accountController.getData(data.toLowerCase()).length,
                  itemBuilder: (context, index) {
                    final point =
                        accountController.getData(data.toLowerCase())[index];
                    print(point);

                    // Hanya bungkus bagian yang perlu dipantau dengan Obx
                    return GestureDetector(
                      onTap: () {
                        if (temporaryData.value == null) {
                          temporaryData.value = point;
                        } else {
                          if (temporaryData.value != point) {
                            temporaryData.value = point;
                          } else {
                            temporaryData.value = null;
                          }
                        }
                      },
                      child: Obx(
                        () {
                          // Bungkus hanya bagian warna dan teks yang perlu dipantau
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: (temporaryData.value == point)
                                  ? AppColors.bgPrimary
                                  : AppColors.white_1,
                            ),
                            padding: EdgeInsetsDirectional.symmetric(
                                horizontal: 14, vertical: 12),
                            child: Text(
                              point['name'] ?? "-",
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
                    Get.back(result: temporaryData.value);
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
