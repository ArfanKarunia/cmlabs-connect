import 'package:cmlabs_connect/src/controllers/account/account_controller.dart';
import 'package:cmlabs_connect/src/routes.dart';
import 'package:cmlabs_connect/src/utils/bottom_sheet.dart';
import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../constant/fontstyle.dart';
import '../../../widgets/account/account_action_section.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';

class SummaryView extends StatefulWidget {
  const SummaryView({super.key});

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {
  final AccountController controller = Get.find<AccountController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar("Summary", titleSpacing: 0),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.white_1,
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1E000000),
                  offset: Offset(3, 3),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "About",
                  style: bold.copyWith(color: AppColors.text_2),
                ),
                const SizedBox(height: 8),
                Obx(
                  () => Text(
                    controller.summaryAbout.value ?? "-",
                    style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Spesialization",
                  style: bold.copyWith(color: AppColors.text_2),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => Text(
                    controller.summarySpecialization.isNotEmpty ? controller.summarySpecialization.join(', ') : "-",
                    style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                  ),
                ),
                Obx(
                  () {
                    return controller.summaryAbout.value != null || controller.summarySpecialization.isNotEmpty
                        ? AccountActionSection(
                            onEdit: () => Get.toNamed(
                              AppRoutes.formSummaryView,
                              arguments: "edit",
                            ),
                            onDelete: () => deleteBottomSheet(
                              context,
                              message: 'Are you sure wanna delete this Summary?',
                              onDelete: () {
                                controller.deleteSummary();
                                controller.summarySpecialization.refresh();
                                Get.back();
                              },
                            ),
                          )
                        : const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => CustomSubmitButton(
              icon: Ionicons.add_outline,
              title: "Add Summary",
              isDisabled: controller.summaryAbout.value != null || controller.summarySpecialization.isNotEmpty,
              onTap: () => Get.toNamed(
                AppRoutes.formSummaryView,
                arguments: "add",
              ),
            ),
          ),
          const SizedBox(height: 200),
        ],
      ),
    );
  }
}
