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

class VolunteerView extends StatefulWidget {
  const VolunteerView({super.key});

  @override
  State<VolunteerView> createState() => _VolunteerViewState();
}

class _VolunteerViewState extends State<VolunteerView> {
  final AccountController controller = Get.find<AccountController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar("Volunteer", titleSpacing: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Obx(
              () => controller.volunteerList.isEmpty
                  ? AccountSettingCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Volunteer",
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
                      itemCount: controller.volunteerList.length,
                      itemBuilder: (context, index) {
                        final volunteer = controller.volunteerList[index];

                        return AccountSettingCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                volunteer?.name ?? '-',
                                style: bold.copyWith(fontSize: 15, color: AppColors.text_2),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                "${volunteer?.position ?? "-"} | ${volunteer?.division ?? "-"}",
                                style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${volunteer?.startTime != null ? DateFormat('d MMM yyyy').format(volunteer!.startTime) : "-"}"
                                " until "
                                "${volunteer?.finishTime != null ? DateFormat('d MMM yyyy').format(volunteer!.finishTime!) : "now"}",
                                style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Description",
                                style: bold.copyWith(fontSize: 14, color: AppColors.text_2),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                volunteer?.description ?? "-",
                                style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                              ),
                              AccountActionSection(
                                onEdit: () {
                                  Get.toNamed(
                                    AppRoutes.formVolunteerView,
                                    arguments: {"status": "edit", "id": volunteer!.id},
                                  );
                                },
                                onDelete: () {
                                  deleteBottomSheet(
                                    context,
                                    message: "Are you sure wanna delete this Volunteer?",
                                    onDelete: () {
                                      controller.deleteVolunteer(volunteer?.id ?? 0);
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
              title: 'Add Volunteer',
              onTap: () {
                Get.toNamed(
                  AppRoutes.formVolunteerView,
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
