import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:quotation_app/src/constant/const.dart';
import 'package:quotation_app/src/models/quotation_model.dart';
import 'package:quotation_app/src/utils/color.dart';
import 'package:quotation_app/src/widgets/custom_buttom.dart';

class QuotationListTile extends StatelessWidget {
  const QuotationListTile({
    super.key,
    required this.quotation,
  });

  final Quotation quotation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        '/detailQuotation',
        arguments: {'quotation': quotation},
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        margin: const EdgeInsets.only(
          bottom: 10,
        ),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(20, 0, 0, 0),
              offset: Offset(2, 2),
              blurRadius: 10,
            ),
          ],
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        quotation.companyName!.isEmpty
                            ? "Nama Perusahaan"
                            : quotation.companyName!,
                        style: GoogleFonts.plusJakartaSans(
                            color: AppColors.text_1,
                            fontSize: 15,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                        quotation.category!.isNotEmpty
                            ? quotation.category!
                                .map((cat) => cat.name)
                                .join(', ')
                            : "-",
                        maxLines: 2,
                        style: GoogleFonts.plusJakartaSans(
                            color: AppColors.text_2,
                            fontSize: 12,
                            fontWeight: FontWeight.w400)),
                    Text("PIC : ${quotation.pic!.toUpperCase()}",
                        style: GoogleFonts.plusJakartaSans(
                            color: AppColors.text_4,
                            fontSize: 11,
                            fontWeight: FontWeight.w400))
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 10),
                  child: StatusLeadUI(
                    statusLead: quotation.statusLead,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                SizedBox(
                  height: 22,
                  width: 22,
                  child: CustomButton(
                    onPressed: () {},
                    child: Icon(
                      Ionicons.logo_whatsapp,
                      color: AppColors.white_1,
                      size: 13,
                    ), // Icon as child
                    backgroundColor:
                        AppColors.success, // Button background color
                    overlayColor: Colors.white24, // Ripple effect color
                    borderRadius: BorderRadius.circular(
                      5,
                    ), // Button shape
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                SizedBox(
                  height: 22,
                  width: 22,
                  child: CustomButton(
                    onPressed: () {
                      print("Button pressed");
                    },
                    child: Icon(
                      Ionicons.trash_outline,
                      color: AppColors.danger,
                      size: 16,
                    ), // Icon as child
                    backgroundColor:
                        AppColors.bgDanger, // Button background color
                    overlayColor: const Color.fromARGB(
                        70, 222, 87, 87), // Ripple effect color
                    borderRadius: BorderRadius.circular(
                      5,
                    ), // Button shape
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class StatusLeadUI extends StatelessWidget {
  const StatusLeadUI({
    super.key,
    required this.statusLead,
  });

  final StatusLead statusLead;

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color color;
    String status;

    switch (statusLead) {
      case StatusLead.newLead:
        bgColor = AppColors.bgPrimary;
        color = AppColors.primary;
        status = "New";
        break;
      case StatusLead.followedUp:
        bgColor = AppColors.bgInfo;
        color = AppColors.info;
        status = "Followed Up";
        break;
      case StatusLead.accepted:
        bgColor = AppColors.bgSuccess;
        color = AppColors.success;
        status = "Accepted";
        break;
      case StatusLead.rejected:
        bgColor = AppColors.bgDanger;
        color = AppColors.danger;
        status = "Rejected";
        break;
      default:
        bgColor = AppColors.bgPrimary;
        color = AppColors.primary;
        status = "New";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(status,
          style: GoogleFonts.plusJakartaSans(
              color: color, fontSize: 10, fontWeight: FontWeight.w400)),
    );
  }
}
