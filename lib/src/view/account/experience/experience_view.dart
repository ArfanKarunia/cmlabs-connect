import 'package:cmlabs_connect/src/controllers/account/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../../constant/fontstyle.dart';
import '../../../routes.dart';
import '../../../utils/bottom_sheet.dart';
import '../../../utils/color.dart';
import '../../../widgets/account/account_action_section.dart';
import '../../../widgets/account/account_setting_card.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';

class ExperienceView extends StatefulWidget {
  const ExperienceView({super.key});

  @override
  State<ExperienceView> createState() => _ExperienceViewState();
}

class _ExperienceViewState extends State<ExperienceView> {
  final AccountController accountController = Get.find<AccountController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar("Experience", titleSpacing: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Obx(
              () => accountController.experienceList.isEmpty
                  ? AccountSettingCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Experience",
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
                      itemCount: accountController.experienceList.length,
                      itemBuilder: (context, index) {
                        final experience = accountController.experienceList[index];
                        return AccountSettingCard(
                          margin: const EdgeInsets.only(bottom: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                experience?.position ?? '-',
                                style: bold.copyWith(fontSize: 15, color: AppColors.text_2),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                "${experience?.company ?? "-"} | ${experience?.type ?? "-"}",
                                style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${experience?.startTime != null ? DateFormat('d MMM yyyy').format(experience!.startTime) : "-"}"
                                " until "
                                "${experience?.finishTime != null ? DateFormat('d MMM yyyy').format(experience!.finishTime!) : "now"}",
                                style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Description",
                                style: bold.copyWith(fontSize: 14, color: AppColors.text_2),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                experience?.description ?? "-",
                                style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                              ),
                              AccountActionSection(
                                onEdit: () => Get.toNamed(
                                  AppRoutes.formExperienceView,
                                  arguments: {"status": "edit", "id": experience?.id},
                                ),
                                onDelete: () => deleteBottomSheet(
                                  context,
                                  message: 'Are you sure wanna delete this Experience?',
                                  onDelete: () {
                                    accountController.deleteExperience(experience?.id ?? 0);
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
              title: "Add Experience",
              onTap: () => Get.toNamed(
                AppRoutes.formExperienceView,
                arguments: {"status": "add", "id": null},
              ),
            ),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }
}
