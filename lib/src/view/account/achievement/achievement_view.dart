import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../../constant/fontstyle.dart';
import '../../../controllers/account/account_controller.dart';
import '../../../routes.dart';
import '../../../utils/bottom_sheet.dart';
import '../../../utils/color.dart';
import '../../../widgets/account/account_action_section.dart';
import '../../../widgets/account/account_setting_card.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';

class AchievementView extends StatefulWidget {
  const AchievementView({super.key});

  @override
  State<AchievementView> createState() => _AchievementViewState();
}

class _AchievementViewState extends State<AchievementView> {
  final AccountController controller = Get.find<AccountController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar("Achievement", titleSpacing: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Obx(
              () => controller.achievementList.isEmpty
                  ? AccountSettingCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Achievement",
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
                      itemCount: controller.achievementList.length,
                      itemBuilder: (context, index) {
                        final achievement = controller.achievementList[index];

                        return AccountSettingCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                achievement?.name ?? '-',
                                style: bold.copyWith(fontSize: 15, color: AppColors.text_2),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                achievement?.institutionName ?? "-",
                                style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                achievement?.year != null ? DateFormat('d MMM yyyy').format(achievement!.year) : "-",
                                style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Description",
                                style: bold.copyWith(fontSize: 14, color: AppColors.text_2),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                achievement?.description ?? "-",
                                style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                              ),
                              AccountActionSection(
                                onEdit: () {
                                  Get.toNamed(
                                    AppRoutes.formAchievementView,
                                    arguments: {"status": "edit", "id": achievement?.id},
                                  );
                                },
                                onDelete: () {
                                  deleteBottomSheet(
                                    context,
                                    message: "Are you sure wanna delete this Achievement?",
                                    onDelete: () {
                                      controller.deleteAchievement(achievement?.id ?? 0);
                                      Get.back();
                                    },
                                  );
                                },
                              )
                            ],
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            CustomSubmitButton(
              icon: Ionicons.add_outline,
              title: 'Add Achievement',
              onTap: () {
                Get.toNamed(
                  AppRoutes.formAchievementView,
                  arguments: {"status": "add", "id": null},
                );
              },
            ),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }
}
