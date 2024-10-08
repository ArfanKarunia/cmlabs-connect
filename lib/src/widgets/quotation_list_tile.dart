import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quotation_app/src/constant/const.dart';
import 'package:quotation_app/src/models/quotation_model.dart';
import 'package:quotation_app/src/utils/color.dart';

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
          left: 5,
          right: 5,
        ),
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: AppColors.secondaryText,
              offset: Offset(2, 2),
              blurRadius: 2,
            ),
          ],
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.lightBlue,
              AppColors.white,
            ],
          ),
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
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                    Text(
                      quotation.category!.isNotEmpty
                          ? quotation.category!
                              .map((cat) => cat.name)
                              .join(', ')
                          : "-",
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryText,
                      ),
                    ),
                    Text(
                      "PIC : ${quotation.pic!.toUpperCase()}",
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.primaryText,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: StatusLeadUI(
                statusLead: quotation.statusLead,
              ),
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
      child: Text(
        status,
        style: GoogleFonts.plusJakartaSans(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w400
        )
      ),
    );
  }
}
