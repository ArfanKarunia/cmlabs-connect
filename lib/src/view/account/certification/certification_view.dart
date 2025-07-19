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

class CertificationView extends StatefulWidget {
  const CertificationView({super.key});

  @override
  State<CertificationView> createState() => _CertificationViewState();
}

class _CertificationViewState extends State<CertificationView> {
  final AccountController controller = Get.find<AccountController>();

  @override
  Widget build(BuildContext context) {
    controller.fetchCertification();

    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar("Certification", titleSpacing: 0),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Obx(
            () => controller.certificationList.isEmpty
                ? AccountSettingCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Certification",
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
                    itemCount: controller.certificationList.length,
                    itemBuilder: (context, index) {
                      final certification = controller.certificationList[index];

                      return AccountSettingCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              certification?.name ?? '-',
                              style: bold.copyWith(fontSize: 15, color: AppColors.text_2),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              "${certification?.url ?? "-"} | ${certification?.institutionName ?? "-"}",
                              style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "${certification?.startTime != null ? DateFormat('d MMM yyyy').format(certification!.startTime) : "-"}"
                              " until "
                              "${certification?.finishTime != null ? DateFormat('d MMM yyyy').format(certification!.finishTime!) : "now"}",
                              style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Description",
                              style: bold.copyWith(fontSize: 14, color: AppColors.text_2),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              certification?.description ?? "-",
                              style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                            ),
                            AccountActionSection(
                              onEdit: () {
                                Get.toNamed(
                                  AppRoutes.formCertificationnView,
                                  arguments: {"status": "edit", "id": certification?.id},
                                );
                              },
                              onDelete: () {
                                deleteBottomSheet(
                                  context,
                                  message: "Are you sure wanna delete this Certification?",
                                  onDelete: () {
                                    controller.deleteCertification(certification?.id ?? 0);
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
            title: 'Add Certification',
            onTap: () {
              Get.toNamed(
                AppRoutes.formCertificationnView,
                arguments: {"status": "add", "id": null},
              );
            },
          ),
          const SizedBox(height: 200),
        ],
      ),
    );
  }
}
