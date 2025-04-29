import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constant/const.dart';
import '../../../constant/fontstyle.dart';
import '../../../controllers/inbox/faq/detail_faq_controller.dart';
import '../../../controllers/inbox/faq/faq_controller.dart';
import '../../../models/faq_model.dart';
import '../../../routes.dart';
import '../../../utils/color.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';
import '../../../widgets/inbox_detail_tile.dart';

class FaqDetailView extends StatefulWidget {
  final Faq faq;
  const FaqDetailView({super.key, required this.faq});

  @override
  State<FaqDetailView> createState() => _FaqDetailViewState();
}

class _FaqDetailViewState extends State<FaqDetailView> {
  final parentController = Get.find<FaqController>();
  final controller = Get.find<DetailFaqController>();

  @override
  void initState() {
    super.initState();
    controller.faq.value = widget.faq;
    controller.fetchDetails(widget.faq.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar('Detail FAQ'),
      backgroundColor: AppColors.scaffoldBgColor2,
      body: ListView(
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
                  '${widget.faq.companyName}',
                  style: bold.copyWith(fontSize: 18),
                ),
                const Divider(
                  color: AppColors.text_2,
                  thickness: 0.25,
                  height: 18,
                ),
                InboxDetailTile(
                  title: 'ID',
                  content: '${(widget.faq.id ?? '-')}',
                ),
                InboxDetailTile(
                  title: 'Received at',
                  content: widget.faq.createdAt != null
                      ? DateFormat('d MMMM yyyy, HH:mm:ss').format((widget.faq.createdAt ?? DateTime.now()).toLocal())
                      : '-',
                ),
                Obx(
                  () {
                    final index = parentController.faqList.indexWhere((faq) => faq.id == widget.faq.id);
                    return InboxDetailTile(
                      title: 'Status',
                      content: parentController.faqList[index].status != null
                          ? statusLead[parentController.faqList[index].status ?? 0].title
                          : '-',
                    );
                  },
                ),
                InboxDetailTile(
                  title: 'Name',
                  content: (widget.faq.name ?? '-'),
                ),
                Obx(
                  () => InboxDetailTile(
                    title: 'Email',
                    content: (controller.faq.value?.email ?? '-'),
                  ),
                ),
                InboxDetailTile(
                  title: 'Whatsapp',
                  content: (widget.faq.whatsappNumber ?? '-'),
                ),
                InboxDetailTile(
                  title: 'Company Name',
                  content: (widget.faq.companyName ?? '-'),
                ),
                Obx(
                  () => InboxDetailTile(
                    title: 'Company Url',
                    content: (controller.faq.value?.data?.website ?? '-'),
                  ),
                ),
                InboxDetailTile(
                  title: 'Questions',
                  content: (widget.faq.question ?? '-'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 21),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(
              () => controller.isLoading.value
                  ? const CustomLoadingButton()
                  : CustomSubmitButton(
                      title: 'Edit Data',
                      onTap: () => Get.toNamed(
                        AppRoutes.editFaqStatus,
                        arguments: {'faq': controller.faq.value},
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
