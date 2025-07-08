import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../constant/const.dart';
import '../../../constant/fontstyle.dart';
import '../../../controllers/inbox/faq/edit_faq_controller.dart';
import '../../../models/inbox/faq_model.dart';
import '../../../routes.dart';
import '../../../utils/color.dart';
import '../../../widgets/custom_select_field.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';
import '../../../widgets/inbox_add_field.dart';
import '../../../widgets/inbox_detail_tile.dart';

class FaqEditStatusView extends StatefulWidget {
  final Faq faq;

  const FaqEditStatusView({super.key, required this.faq});

  @override
  State<FaqEditStatusView> createState() => _FaqEditStatusViewState();
}

class _FaqEditStatusViewState extends State<FaqEditStatusView> {
  final controller = Get.find<EditFaqController>();

  @override
  void initState() {
    super.initState();
    controller.setValue(data: 'status', value: {
      'label': statusLead[widget.faq.status ?? 0].title,
      'value': widget.faq.status.toString(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar('Edit FAQ'),
      backgroundColor: AppColors.scaffoldBgColor2,
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              Center(
                child: Text(
                  widget.faq.companyName ?? 'N/A',
                  style: bold.copyWith(fontSize: 18),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InboxDetailTile(
                      title: 'ID',
                      content: '${(widget.faq.id ?? '-')}',
                    ),
                    InboxDetailTile(
                      title: 'Received at',
                      content: widget.faq.createdAt != null
                          ? DateFormat('d MMMM yyyy, HH:mm:ss')
                              .format((widget.faq.createdAt ?? DateTime.now()).toLocal())
                          : '-',
                    ),

                    // Status
                    Text('Status', style: bold.copyWith(color: AppColors.primaryText)),
                    const SizedBox(height: 10),
                    Obx(
                      () => CustomSelectField(
                        onTap: () => Get.toNamed(AppRoutes.editFaqSelect, arguments: {
                          'title': 'Status',
                          'data': 'status',
                        }),
                        child: InboxTextOnField(
                          title: 'Select Status',
                          selected: controller.selectedStatus.value,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    InboxDetailTile(
                      title: 'Name',
                      content: (widget.faq.name ?? '-'),
                    ),
                    InboxDetailTile(
                      title: 'Email',
                      content: (widget.faq.email ?? '-'),
                    ),
                    InboxDetailTile(
                      title: 'Whatsapp',
                      content: (widget.faq.whatsappNumber ?? '-'),
                    ),
                    InboxDetailTile(
                      title: 'Company Name',
                      content: (widget.faq.companyName ?? '-'),
                    ),
                    InboxDetailTile(
                      title: 'Company Url',
                      content: (widget.faq.data?.website ?? '-'),
                    ),
                    InboxDetailTile(
                      title: 'Questions',
                      content: (widget.faq.question ?? '-'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 200),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: AppColors.white_1,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(30, 0, 0, 0),
                    offset: Offset(0, -4),
                    blurRadius: 10,
                  ),
                ],
              ),
              padding: const EdgeInsets.fromLTRB(15, 25, 15, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 140,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.text_4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => controller.isLoading.value
                        ? const CustomLoadingButton()
                        : CustomSubmitButton(
                            title: 'Save',
                            onTap: () => controller.submitStatusFaq(widget.faq.id ?? 0),
                          ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Click to save all changes",
                    style: regular.copyWith(fontSize: 10, color: AppColors.text_2),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
