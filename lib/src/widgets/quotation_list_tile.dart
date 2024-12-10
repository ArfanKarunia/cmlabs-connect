import 'package:cmlabs_connect/src/controllers/detail_quotation_controller.dart';
import 'package:cmlabs_connect/src/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../constant/const.dart';
import '../models/quotation_model.dart';
import '../utils/bottom_sheet.dart';
import '../utils/color.dart';

class QuotationListTile extends StatelessWidget {
  QuotationListTile({
    super.key,
    required this.quotation,
    required this.onDelete,
    required this.onChatWA,
  });

  final Quotation quotation;
  final VoidCallback onDelete;
  final VoidCallback onChatWA;

  final DetailQuotationController detailQuotationController = Get.put(DetailQuotationController());

  @override
  Widget build(BuildContext context) {
    StatusLead status = StatusLead.newLead;

    switch (quotation.status) {
      case 0:
        status = StatusLead.newLead;
        break;
      case 1:
        status = StatusLead.followedUp;
        break;
      case 2:
        status = StatusLead.accepted;
        break;
      case 3:
        status = StatusLead.rejected;
        break;
      case 4:
        status = StatusLead.onHold;
        break;
    }

    return GestureDetector(
      onTap: () {
        detailQuotationController.quotation.value = quotation;
        Get.toNamed(
          '/detailQuotation',
        );
      },
      child: Container(
        // height: 100, // Tinggi tile
        margin: const EdgeInsets.only(bottom: 10),
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
        child: SizedBox(
          height: 120,
          child: Stack(
            children: [
              Row(
                children: [
                  //  Berfungsi agar slidable bisa mepet kanan
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 1, // Mengambil setengah dari tile
                    child: Slidable(
                      closeOnScroll: true,
                      endActionPane: ActionPane(
                        motion: const BehindMotion(),
                        extentRatio: 1, // Memunculkan tombol saat slide
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(3),
                            child: Container(
                              width: 80,
                              height: 40,
                              child: Material(
                                color: AppColors.bgSuccess,
                                borderRadius: BorderRadius.circular(5),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(5),
                                  onTap: onChatWA,
                                  splashColor: Colors.black12, // Ripple color
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "WA",
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 10,
                                          color: AppColors.success,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Ionicons.logo_whatsapp,
                                        size: 18,
                                        color: AppColors.success,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3),
                            child: Container(
                              width: 80,
                              height: 40,
                              child: Material(
                                color: AppColors.bgDanger,
                                borderRadius: BorderRadius.circular(5),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(5),
                                  onTap: () {
                                    print("Delete");
                                    var message =
                                        "Are you sure wanna delete this Cardbox?";
                                    DeleteBottomSheet(
                                        context, onDelete, message);
                                  },
                                  splashColor: Colors.black12, // Ripple color
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Delete",
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 10,
                                          color: AppColors.danger,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Icon(
                                        Ionicons.trash_outline,
                                        size: 18,
                                        color: AppColors.danger,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              timeago.format(quotation.createdAt),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                color: AppColors.text_4,
                              ),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: StatusLeadUI(
                                statusLead: status,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      color: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (quotation.data.company?.isEmpty ?? true)
                                ? "N/A"
                                : quotation.data.company!,
                            maxLines: 1,
                            style: GoogleFonts.plusJakartaSans(
                              color: (quotation.data.company?.isEmpty ?? true) ? AppColors.text_3 :AppColors.text_1,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            quotation.section != 'ads' ? 
                            StringUtils.toCamelCase(quotation.section) : quotation.data.category.join(','),
                            maxLines: 1, // Membatasi hanya 1 baris
                            overflow: TextOverflow
                                .ellipsis, // Menambahkan ellipsis (...) jika terlalu panjang
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.text_1,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            quotation.data.pic ?? "-",
                            maxLines: 1,
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.text_4,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            quotation.data.phoneNumber ?? "-",
                            maxLines: 1,
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.text_4,
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            quotation.email,
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.text_4,
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Berfungsi agar informasi quotation hanya setengah tile
                  Expanded(child: Container()),
                ],
              ),
            ],
          ),
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
            color: color, fontSize: 10, fontWeight: FontWeight.w400),
      ),
    );
  }
}
