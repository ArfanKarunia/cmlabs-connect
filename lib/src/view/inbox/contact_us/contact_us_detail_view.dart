import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constant/const.dart';
import '../../../constant/fontstyle.dart';
import '../../../controllers/inbox/contact_us/detail_contact_us_controller.dart';
import '../../../models/inbox/contact_us_model.dart';
import '../../../routes.dart';
import '../../../utils/color.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';
import '../../../widgets/inbox/inbox_detail_tile.dart';

class ContactUsDetailView extends StatefulWidget {
  final ContactUs contactUs;
  const ContactUsDetailView({super.key, required this.contactUs});

  @override
  State<ContactUsDetailView> createState() => _ContactUsDetailViewState();
}

class _ContactUsDetailViewState extends State<ContactUsDetailView> {
  final controller = Get.find<DetailContactUsController>();

  bool isShowMore = false;

  @override
  void initState() {
    super.initState();
    controller.contactUs.value = widget.contactUs;
    controller.fetchDetails(widget.contactUs.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar('Detail Contact Us'),
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
                  '${widget.contactUs.data?.company?.name}',
                  style: bold.copyWith(fontSize: 18),
                ),
                const Divider(
                  color: AppColors.text_2,
                  thickness: 0.25,
                  height: 18,
                ),
                InboxDetailTile(
                  title: 'ID',
                  content: '${(widget.contactUs.id ?? '-')}',
                ),
                InboxDetailTile(
                  title: 'Joined at',
                  content: DateFormat('d MMMM yyyy, HH:mm:ss')
                      .format((widget.contactUs.createdAt ?? DateTime.now()).toLocal()),
                ),
                InboxDetailTile(
                  title: 'Status',
                  content: statusLead[widget.contactUs.status ?? 0].title,
                ),
                InboxDetailTile(
                  title: 'Category',
                  content: '${widget.contactUs.data?.category?.join(', ')}',
                ),
                InboxDetailTile(
                  title: 'Name',
                  content: (widget.contactUs.data?.name ?? '-'),
                ),
                InboxDetailTile(
                  title: 'Email',
                  content: (widget.contactUs.email ?? '-'),
                ),
                InboxDetailTile(
                  title: 'Whatsapp',
                  content: (widget.contactUs.data?.phoneNumber ?? '-'),
                ),
                if (isShowMore) ...[
                  InboxDetailTile(
                    title: 'Company Website',
                    content: (widget.contactUs.data?.website ?? '-'),
                  ),
                  InboxDetailTile(
                    title: 'Company Name',
                    content: (widget.contactUs.data?.company?.name ?? '-'),
                  ),
                  InboxDetailTile(
                    title: 'Company Profile',
                    content: (controller.contactUs.value?.data?.portfolio ?? '-'),
                  ),
                  InboxDetailTile(
                    title: 'Messages/Notes',
                    content: (widget.contactUs.data?.message ?? '-'),
                  ),
                  InboxDetailTile(
                    title: 'Page Source',
                    content: (widget.contactUs.url ?? '-'),
                  ),
                  Obx(
                    () => InboxDetailTile(
                      title: 'Pitching Duration',
                      content: controller.pitchingDuration.value ?? '-',
                    ),
                  ),
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
                const SizedBox(width: 6),
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
            child: CustomSubmitButton(
              title: 'Edit Data',
              onTap: () => Get.toNamed(
                AppRoutes.editContactUs,
                arguments: {'contactUs': widget.contactUs},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
