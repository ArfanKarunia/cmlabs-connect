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
import '../controllers/inbox/contact_us/contact_us_controller.dart';
import '../controllers/inbox/faq/faq_controller.dart';
import '../controllers/inbox/inbox_controller.dart';
import '../controllers/inbox/quotation/quotation_controller.dart';
import '../models/case_studies_model.dart';
import '../models/contact_us_model.dart';
import '../models/faq_model.dart';
import '../models/quotation_model.dart';
import '../routes.dart';
import '../utils/bottom_sheet.dart';
import '../utils/color.dart';

class InboxListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? name;
  final String phoneNumber;
  final String email;
  final DateTime createdAt;
  final int? status;
  final VoidCallback? onTap;
  final VoidCallback? onWhatsapp;
  final VoidCallback? onDelete;
  const InboxListTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.name,
    required this.phoneNumber,
    required this.email,
    required this.createdAt,
    this.status,
    this.onTap,
    this.onWhatsapp,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // height: 100, // Tinggi tile
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFF3F3F3), width: 1.2),
        ),
        child: SizedBox(
          height: name != null ? 110 : 100,
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
                            onTap: onWhatsapp,
                            bgColor: AppColors.bgSuccess,
                            color: AppColors.success,
                            title: 'WA',
                            icon: Ionicons.logo_whatsapp,
                          ),
                          ButtonBehindSlideable(
                            onTap: onDelete,
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
                              timeago.format(createdAt),
                              style: regular.copyWith(fontSize: 10, color: AppColors.text_4),
                            ),
                            const SizedBox(height: 7),
                            status != null ? StatusLeadTag(status: statusLead[status ?? 0]) : Container(),
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
                            title,
                            maxLines: 1,
                            style: bold.copyWith(
                              fontSize: 15,
                              color: AppColors.text_1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            subtitle,
                            style: regular.copyWith(fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (name != null)
                            Text(
                              name ?? '-',
                              style: regular.copyWith(fontSize: 11, color: AppColors.text_4),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          Text(
                            phoneNumber,
                            style: regular.copyWith(fontSize: 11, color: AppColors.text_4),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            email,
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

class QuotationListTile extends StatelessWidget {
  final Quotation quotation;
  final QuotationController quotationController;

  const QuotationListTile({super.key, required this.quotation, required this.quotationController});

  @override
  Widget build(BuildContext context) {
    return InboxListTile(
      title: quotation.data?.company ?? 'N/A',
      subtitle: quotation.data?.category?.isNotEmpty ?? false
          ? StringUtils.toCamelCase(quotation.data?.category?.map((cat) {
              return cat == null || cat.isEmpty ? '-' : cat.replaceAll('SEO Article', 'SEO Writing');
            }).join(', '))
          : StringUtils.toCamelCase(quotation.section),
      name: quotation.data?.pic ?? '-',
      phoneNumber: quotation.data?.phoneNumber ?? '-',
      email: quotation.email ?? '-',
      createdAt: quotation.createdAt ?? DateTime.now(),
      status: quotation.status,
      onTap: () => Get.toNamed(
        AppRoutes.detailQuotation,
        arguments: {'quotation': quotation},
      ),
      onWhatsapp: () => quotationController.redirectToWhatsapp(
        phoneCode: quotation.data?.phoneCode,
        phoneNumber: quotation.data?.phoneNumber,
      ),
      onDelete: () => handleDeleteQuotation(
        context,
        controller: quotationController,
        id: quotation.id,
      ),
    );
  }
}

class CaseStudiesListTile extends StatelessWidget {
  final CaseStudies caseStudies;
  final CaseStudiesController caseStudiesController;

  const CaseStudiesListTile({super.key, required this.caseStudies, required this.caseStudiesController});

  @override
  Widget build(BuildContext context) {
    return InboxListTile(
      title: caseStudies.data?.company ?? 'N/A',
      subtitle: caseStudies.data?.name ?? '-',
      phoneNumber: caseStudies.data?.phoneNumber ?? '-',
      email: caseStudies.email ?? '-',
      createdAt: caseStudies.createdAt ?? DateTime.now(),
      onTap: () => Get.toNamed(
        AppRoutes.detailCaseStudies,
        arguments: {'caseStudies': caseStudies},
      ),
      onWhatsapp: () => caseStudiesController.redirectToWhatsapp(
        phoneCode: caseStudies.data?.phoneCode,
        phoneNumber: caseStudies.data?.phoneNumber,
      ),
      onDelete: () => handleDeleteQuotation(
        context,
        controller: caseStudiesController,
        id: caseStudies.id,
      ),
    );
  }
}

class ContactUsListTile extends StatelessWidget {
  final ContactUs contactUs;
  final ContactUsController contactUsController;

  const ContactUsListTile({super.key, required this.contactUs, required this.contactUsController});

  @override
  Widget build(BuildContext context) {
    return InboxListTile(
      title: contactUs.data?.company?.name ?? 'N/A',
      subtitle: contactUs.data?.name ?? '-',
      phoneNumber: contactUs.data?.phoneNumber.toString() ?? '-',
      email: contactUs.email ?? '-',
      createdAt: contactUs.createdAt ?? DateTime.now(),
      status: contactUs.status,
      onTap: () => Get.toNamed(
        AppRoutes.detailContactUs,
        arguments: {'contactUs': contactUs},
      ),
      onWhatsapp: () => contactUsController.redirectToWhatsapp(
        phoneCode: contactUs.data?.phoneCode,
        phoneNumber: contactUs.data?.phoneNumber,
      ),
      onDelete: () => handleDeleteQuotation(
        context,
        controller: contactUsController,
        id: contactUs.id,
      ),
    );
  }
}

class FaqListTile extends StatelessWidget {
  final Faq faq;
  final FaqController faqController;

  const FaqListTile({super.key, required this.faq, required this.faqController});

  @override
  Widget build(BuildContext context) {
    return InboxListTile(
      title: faq.companyName ?? 'N/A',
      subtitle: faq.name ?? '-',
      phoneNumber: faq.whatsappNumber ?? '-',
      email: faq.shortQuestion ?? '-',
      createdAt: faq.createdAt ?? DateTime.now(),
      status: faq.status,
      onTap: () => Get.toNamed(
        AppRoutes.detailFaq,
        arguments: {'faq': faq},
      ),
      onWhatsapp: () => faqController.redirectToWhatsapp(
        phoneCode: faq.data?.phoneCode,
        phoneNumber: faq.data?.phoneNumber,
      ),
      onDelete: () => handleDeleteQuotation(
        context,
        controller: faqController,
        id: faq.id,
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
