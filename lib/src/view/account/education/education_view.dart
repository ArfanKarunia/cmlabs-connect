import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../../controllers/account/account_controller.dart';
import '../../../constant/fontstyle.dart';
import '../../../routes.dart';
import '../../../utils/bottom_sheet.dart';
import '../../../utils/color.dart';
import '../../../widgets/account/account_action_section.dart';
import '../../../widgets/account/account_setting_card.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';

class EducationView extends StatefulWidget {
  const EducationView({super.key});

  @override
  State<EducationView> createState() => _EducationViewState();
}

class _EducationViewState extends State<EducationView> {
  final AccountController controller = Get.find<AccountController>();

  @override
  Widget build(BuildContext context) {
    controller.fetchEducation();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar('Education', titleSpacing: 0),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Obx(
            () => controller.educationList.isEmpty
                ? AccountSettingCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Education",
                          style: bold.copyWith(fontSize: 15, color: AppColors.text_2),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "-",
                          style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                        )
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.educationList.length,
                    itemBuilder: (context, index) {
                      final education = controller.educationList[index];

                      return AccountSettingCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              education?.name ?? '-',
                              style: bold.copyWith(fontSize: 15, color: AppColors.text_2),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              "${education?.department ?? "-"} | ${education?.degree ?? "-"}",
                              style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "${education?.startTime != null ? DateFormat('d MMM yyyy').format(education!.startTime) : "-"}"
                              " until "
                              "${education?.finishTime != null ? DateFormat('d MMM yyyy').format(education!.finishTime!) : "now"}",
                              style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Description",
                              style: bold.copyWith(fontSize: 14, color: AppColors.text_2),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              education?.description ?? "-",
                              style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                            ),
                            AccountActionSection(
                              onEdit: () => Get.toNamed(
                                AppRoutes.formEducationView,
                                arguments: {"status": "edit", "id": education?.id},
                              ),
                              onDelete: () => deleteBottomSheet(
                                context,
                                message: 'Are you sure wanna delete this Education?',
                                onDelete: () {
                                  controller.deleteEducation(education?.id ?? 0);
                                  Get.back();
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 16),
          CustomSubmitButton(
            icon: Ionicons.add_outline,
            title: "Add Education",
            onTap: () => Get.toNamed(
              AppRoutes.formEducationView,
              arguments: {"status": "add", "id": null},
            ),
          ),
          const SizedBox(height: 200),
        ],
      ),
    );
  }
}
