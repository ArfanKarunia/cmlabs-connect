import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../controllers/detail_quotation_controller.dart';
import '../../models/quotation_model.dart';
import '../../utils/color.dart';

class DetailQuotationView extends StatelessWidget {
  DetailQuotationView({super.key, required this.quotation});

  final Quotation quotation;

  final DetailQuotationController detailQuotationController =
      Get.put(DetailQuotationController());

  @override
  Widget build(BuildContext context) {
    final dataQuotation = detailQuotationController.detailData(quotation);

    // detailQuotationController.clearSelectedData();

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
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            children: [
              Text(
                dataQuotation['company'] ?? "Nama Perusahaan",
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.text_1,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                color: AppColors.white_1,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                width: double.infinity,
                child: Obx(
                  () {
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: (detailQuotationController.isShowAll.value)
                          ? detailQuotationController.title.length
                          : 8,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final title = detailQuotationController.title[index];
                        final value = dataQuotation[title];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.text_1,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              value ?? "-",
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.text_1,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Divider(
                              color: AppColors.text_4,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              Obx(
                () {
                  return Container(
                    width: 200,
                    child: TextButton(
                      onPressed: () {
                        detailQuotationController.changeShowValue();
                        print("${detailQuotationController.isShowAll.value}");
                      },
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        overlayColor: WidgetStatePropertyAll(Colors.white60),
                        foregroundColor:
                            WidgetStatePropertyAll(AppColors.primary),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (!detailQuotationController.getShowAllValue)
                              ? Text("Show more")
                              : Text("Show less"),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            (!detailQuotationController.getShowAllValue)
                                ? Ionicons.chevron_down_outline
                                : Ionicons.chevron_up_outline,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                height: 51,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 42),
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed("/editQuotation",
                        arguments: {'quotation': quotation});
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
                    "Edit Data",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
