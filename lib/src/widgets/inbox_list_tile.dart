import 'package:cmlabs_connect/src/controllers/detail_quotation_controller.dart';
import 'package:cmlabs_connect/src/models/status_lead_model.dart';
import 'package:cmlabs_connect/src/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../constant/const.dart';
import '../constant/fontstyle.dart';
import '../controllers/inbox/case_studies/case_studies_controller.dart';
import '../controllers/inbox/inbox_controller.dart';
import '../controllers/inbox/quotation/quotation_controller.dart';
import '../models/case_studies_model.dart';
import '../models/quotation_model.dart';
import '../routes.dart';
import '../utils/bottom_sheet.dart';
import '../utils/color.dart';

class QuotationListTile extends StatelessWidget {
  final Quotation quotation;
  final QuotationController quotationController;
  QuotationListTile({
    super.key,
    required this.quotation,
    required this.quotationController,
  });

  final DetailQuotationController detailQuotationController = Get.put(DetailQuotationController());

  @override
  Widget build(BuildContext context) {
    final status = statusLead[quotation.status];

    return GestureDetector(
      onTap: () {
        detailQuotationController.quotation.value = quotation;
        Get.toNamed(AppRoutes.detailQuotation);
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
          height: 110,
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
                          ButtonBehindSlideable(
                            onTap: () => quotationController.redirectToWhatsapp(
                              phoneCode: quotation.data.phoneCode,
                              phoneNumber: quotation.data.phoneNumber,
                            ),
                            bgColor: AppColors.bgSuccess,
                            color: AppColors.success,
                            title: 'WA',
                            icon: Ionicons.logo_whatsapp,
                          ),
                          ButtonBehindSlideable(
                            onTap: () => handleDeleteQuotation(
                              context,
                              controller: quotationController,
                              id: quotation.id,
                            ),
                            bgColor: AppColors.bgDanger,
                            color: AppColors.danger,
                            title: 'Delete',
                            icon: Ionicons.trash_outline,
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              timeago.format(quotation.createdAt),
                              style: regular.copyWith(fontSize: 10, color: AppColors.text_4),
                            ),
                            const SizedBox(height: 7),
                            StatusLeadTag(status: status),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (quotation.data.company?.isEmpty ?? true) ? "N/A" : quotation.data.company!,
                            maxLines: 1,
                            style: bold.copyWith(
                              fontSize: 15,
                              color: (quotation.data.company?.isEmpty ?? true) ? AppColors.text_3 : AppColors.text_1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            quotation.data.category.isNotEmpty && quotation.section != 'content-writing'
                                ? StringUtils.toCamelCase(quotation.data.category.map((cat) {
                                    return cat == null || cat.isEmpty
                                        ? '-'
                                        : cat.replaceAll('SEO Article', 'SEO Writing');
                                  }).join(', '))
                                : StringUtils.toCamelCase(quotation.section),
                            // quotation.section != 'ads' ?
                            // StringUtils.toCamelCase(quotation.section) : quotation.data.category.join(','),
                            style: regular.copyWith(fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            quotation.data.pic ?? "-",
                            style: regular.copyWith(fontSize: 11, color: AppColors.text_4),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            quotation.data.phoneNumber ?? "-",
                            style: regular.copyWith(fontSize: 11, color: AppColors.text_4),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            quotation.email,
                            style: regular.copyWith(fontSize: 11, color: AppColors.text_4),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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

class StatusLeadTag extends StatelessWidget {
  final StatusLead status;
  const StatusLeadTag({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: status.bgColor,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Text(
          status.title,
          style: regular.copyWith(fontSize: 12, color: status.color),
        ),
      ),
    );
  }
}

class CaseStudiesListTile extends StatelessWidget {
  final CaseStudies caseStudies;
  final CaseStudiesController caseStudiesController;

  const CaseStudiesListTile({
    super.key,
    required this.caseStudies,
    required this.caseStudiesController,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // detailQuotationController.quotation.value = quotation;
        // Get.toNamed(AppRoutes.detailQuotation);
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
          height: 100,
          child: Stack(
            children: [
              Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      child: Slidable(
                        closeOnScroll: true,
                        endActionPane: ActionPane(
                          motion: const BehindMotion(),
                          extentRatio: 1,
                          children: [
                            ButtonBehindSlideable(
                              onTap: () => caseStudiesController.redirectToWhatsapp(
                                phoneCode: caseStudies.data?.phoneCode,
                                phoneNumber: caseStudies.data?.phoneNumber,
                              ),
                              bgColor: AppColors.bgSuccess,
                              color: AppColors.success,
                              title: 'WA',
                              icon: Ionicons.logo_whatsapp,
                            ),
                            ButtonBehindSlideable(
                              onTap: () => handleDeleteQuotation(
                                context,
                                controller: caseStudiesController,
                                id: caseStudies.id,
                              ),
                              bgColor: AppColors.bgDanger,
                              color: AppColors.danger,
                              title: 'Delete',
                              icon: Ionicons.trash_outline,
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                timeago.format(caseStudies.createdAt ?? DateTime.now()),
                                style: regular.copyWith(fontSize: 10, color: AppColors.text_4),
                              ),
                              const SizedBox(height: 7),
                              Container(),
                            ],
                          ),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            caseStudies.data?.company ?? 'N/A',
                            maxLines: 1,
                            style: bold.copyWith(
                              fontSize: 15,
                              color: (caseStudies.data?.company?.isEmpty ?? true) ? AppColors.text_3 : AppColors.text_1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            caseStudies.data?.name ?? '-',
                            style: regular.copyWith(fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            caseStudies.data?.phoneNumber ?? "-",
                            style: regular.copyWith(fontSize: 11, color: AppColors.text_4),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            caseStudies.email.toString(),
                            style: regular.copyWith(fontSize: 11, color: AppColors.text_4),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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

class ButtonBehindSlideable extends StatelessWidget {
  final VoidCallback? onTap;
  final Color bgColor;
  final Color color;
  final String title;
  final IconData? icon;
  const ButtonBehindSlideable({
    super.key,
    required this.onTap,
    required this.bgColor,
    required this.color,
    required this.title,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        width: 80,
        height: 40,
        child: Material(
          color: bgColor,
          borderRadius: BorderRadius.circular(5),
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: onTap,
            splashColor: Colors.black12, // Ripple color
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: regular.copyWith(fontSize: 10, color: color),
                ),
                if (icon != null) ...[
                  const SizedBox(width: 5),
                  Icon(icon, size: 18, color: color),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void handleDeleteQuotation(
  BuildContext context, {
  required InboxController controller,
  int? id,
}) {
  deleteBottomSheet(
    context,
    message: 'Are you sure wanna delete this Cardbox?',
    onDelete: () async {
      Get.back();
      await controller.deleteData(id);
    },
  );
}
