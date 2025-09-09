import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constant/const.dart';
import '../../../constant/fontstyle.dart';
import '../../../controllers/inbox/quotation/detail_quotation_controller.dart';
import '../../../models/inbox/quotation_model.dart';
import '../../../routes.dart';
import '../../../utils/color.dart';
import '../../../utils/string_utils.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';
import '../../../widgets/inbox/inbox_detail_tile.dart';

class QuotationDetailView extends StatefulWidget {
  final Quotation quotation;
  const QuotationDetailView({super.key, required this.quotation});

  @override
  State<QuotationDetailView> createState() => _QuotationDetailViewState();
}

class _QuotationDetailViewState extends State<QuotationDetailView> {
  final controller = Get.find<DetailQuotationController>();

  bool isShowMore = false;

  @override
  void initState() {
    super.initState();
    controller.fetchDetails(widget.quotation.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar('Detail Quotation'),
      backgroundColor: AppColors.scaffoldBgColor2,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.quotation.data?.company ?? '-',
                    style: bold.copyWith(fontSize: 18),
                  ),
                  const Divider(
                    color: AppColors.text_2,
                    thickness: 0.25,
                    height: 18,
                  ),
                  InboxDetailTile(
                    title: 'ID',
                    content: '${widget.quotation.id ?? '-'}',
                  ),
                  InboxDetailTile(
                    title: 'Joined at',
                    content: DateFormat('d MMMM yyyy, HH:mm:ss').format(
                      (widget.quotation.createdAt ?? DateTime.now()).toLocal(),
                    ),
                  ),
                  InboxDetailTile(
                    title: 'Status',
                    content: statusLead[widget.quotation.status ?? 0].title,
                  ),
                  InboxDetailTile(
                    title: 'Category',
                    content: widget.quotation.data?.category?.map((e) => formatServiceName(e)).join(', ') ?? '-',
                  ),
                  InboxDetailTile(
                    title: 'Client Source',
                    content: widget.quotation.data?.clientSource?.name ?? '-',
                  ),
                  InboxDetailTile(
                    title: 'Name',
                    content: widget.quotation.data?.name ?? '-',
                  ),
                  InboxDetailTile(
                    title: 'Email',
                    content: widget.quotation.email ?? '-',
                  ),
                  InboxDetailTile(
                    title: 'Whatsapp',
                    content: widget.quotation.data?.phoneNumber ?? '-',
                  ),
                  if (isShowMore) ...[
                    InboxDetailTile(
                      title: 'Company Website',
                      content: widget.quotation.data?.website ?? '-',
                    ),
                    InboxDetailTile(
                      title: 'Reg Status',
                      content: widget.quotation.data?.registrationStatus ?? '-',
                    ),
                    InboxDetailTile(
                      title: 'Company Name',
                      content: widget.quotation.data?.company ?? '-',
                    ),
                    InboxDetailTile(
                      title: 'Company Profile',
                      content: widget.quotation.data?.companyProfile ?? '-',
                    ),
                    InboxDetailTile(
                      title: 'Page Source',
                      content: widget.quotation.url ?? '-',
                    ),
                    InboxDetailTile(
                      title: 'Service',
                      content: widget.quotation.data?.category?.map((e) => formatServiceName(e)).join(', ') ?? '-',
                    ),
                    InboxDetailTile(
                      title: 'Region',
                      content: widget.quotation.data?.region ?? '-',
                    ),
                    Obx(
                      () => InboxDetailTile(
                        title: 'Pitching Duration',
                        content: controller.pitchingDuration.value ?? '-',
                      ),
                    )
                  ],
                ],
              ),
            ),
            InkWell(
              onTap: () => setState(() => isShowMore = !isShowMore),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isShowMore ? 'Show Less' : 'Show More',
                    style: bold.copyWith(color: AppColors.primary),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    isShowMore ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 21),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Obx(
                () => CustomSubmitButton(
                  title: 'Edit Data',
                  isDisabled: controller.quotation.value == null,
                  onTap: () => Get.toNamed(
                    AppRoutes.editQuotation,
                    arguments: {'quotation': controller.quotation.value},
                  ),
                ),
              ),
            ),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }
}
