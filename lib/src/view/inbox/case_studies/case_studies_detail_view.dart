import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constant/const.dart';
import '../../../constant/fontstyle.dart';
import '../../../controllers/inbox/case_studies/detail_case_studies_controller.dart';
import '../../../models/case_studies_model.dart';
import '../../../routes.dart';
import '../../../utils/color.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';
import '../../../widgets/inbox_detail_tile.dart';

class CaseStudiesDetailView extends StatefulWidget {
  final CaseStudies caseStudies;
  const CaseStudiesDetailView({super.key, required this.caseStudies});

  @override
  State<CaseStudiesDetailView> createState() => _CaseStudiesDetailViewState();
}

class _CaseStudiesDetailViewState extends State<CaseStudiesDetailView> {
  final controller = Get.find<DetailCaseStudiesController>();

  bool isShowMore = false;

  @override
  void initState() {
    super.initState();
    controller.caseStudies.value = widget.caseStudies;
    controller.fetchDetails(widget.caseStudies.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar('Detail Case Studies'),
      backgroundColor: AppColors.scaffoldBgColor2,
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        children: [
          Center(
            child: Text(
              '${widget.caseStudies.data?.company}',
              style: bold.copyWith(fontSize: 18),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            color: Colors.white,
            child: Column(
              children: [
                InboxDetailTile(
                  title: 'ID',
                  content: '${widget.caseStudies.id}',
                ),
                InboxDetailTile(
                  title: 'Joined at',
                  content: DateFormat('d MMMM yyyy, HH:mm:ss')
                      .format((widget.caseStudies.createdAt ?? DateTime.now()).toLocal()),
                ),
                InboxDetailTile(
                  title: 'Status',
                  content: statusLead[widget.caseStudies.status ?? 0].title,
                ),
                InboxDetailTile(
                  title: 'Category',
                  content: '${widget.caseStudies.data?.category?.join(', ')}',
                ),
                InboxDetailTile(
                  title: 'Name',
                  content: '${widget.caseStudies.data?.name}',
                ),
                InboxDetailTile(
                  title: 'Email',
                  content: '${widget.caseStudies.email}',
                ),
                InboxDetailTile(
                  title: 'Whatsapp',
                  content: '${widget.caseStudies.data?.phoneNumber}',
                ),
                if (isShowMore) ...[
                  InboxDetailTile(
                    title: 'Company Website',
                    content: '${widget.caseStudies.data?.website}',
                  ),
                  InboxDetailTile(
                    title: 'Company Name',
                    content: '${widget.caseStudies.data?.company}',
                  ),
                  Obx(
                    () => InboxDetailTile(
                      title: 'Company Profile',
                      content: '${controller.caseStudies.value?.data?.companyProfile}',
                    ),
                  ),
                  InboxDetailTile(
                    title: 'Messages/Notes',
                    content: '${widget.caseStudies.data?.message}',
                  ),
                  InboxDetailTile(
                    title: 'Page Source',
                    content: '${widget.caseStudies.url}',
                  ),
                  Obx(
                    () => InboxDetailTile(
                      title: 'Pitching Duration',
                      content: controller.pitchingDuration.value ?? '-',
                    ),
                  ),
                ],
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
                )
              ],
            ),
          ),
          const SizedBox(height: 21),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: CustomSubmitButton(
              title: 'Edit Data',
              onTap: () => Get.toNamed(
                AppRoutes.editCaseStudies,
                arguments: {'caseStudies': widget.caseStudies},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
