import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      onTap: () => Get.toNamed('/detailQuotation', arguments: {'quotation': quotation},),
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
          boxShadow: [
            const BoxShadow(
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  quotation.companyName!.isEmpty ? "Nama Perusahaan" : quotation.companyName!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryText,
                  ),
                ),
                Text(
                  quotation.category!.isNotEmpty ? quotation.category!.join(', ') : "-",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryText,
                  ),
                ),
                Text(
                  "PIC : ${quotation.pic!.toUpperCase()}",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primaryText,
                  ),
                )
              ],
            ),
            StatusLeadUI(
              statusLead: quotation.statusLead,
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
    Color color;
    String status;

    switch (statusLead) {
      case StatusLead.newLead:
        color = AppColors.primary;
        status = "New";
        break;
      case StatusLead.followedUp:
        color = AppColors.yellow;
        status = "Followed Up";
        break;
      case StatusLead.accepted:
        color = AppColors.green;
        status = "Accepted";
        break;
      case StatusLead.rejected:
        color = AppColors.red;
        status = "Rejected";
        break;
      default:
        color = AppColors.primary;
        status = "New";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          color: AppColors.white,
        ),
      ),
    );
  }
}
