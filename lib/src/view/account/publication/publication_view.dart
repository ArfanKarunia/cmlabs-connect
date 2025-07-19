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

class PublicationView extends StatefulWidget {
  const PublicationView({super.key});

  @override
  State<PublicationView> createState() => _PublicationViewState();
}

class _PublicationViewState extends State<PublicationView> {
  final AccountController controller = Get.find<AccountController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar("Publication", titleSpacing: 0),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Obx(
            () => controller.publicationList.isEmpty
                ? AccountSettingCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Publication",
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
                    itemCount: controller.publicationList.length,
                    itemBuilder: (context, index) {
                      final publication = controller.publicationList[index];

                      return AccountSettingCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              publication?.title ?? '-',
                              style: bold.copyWith(fontSize: 15, color: AppColors.text_2),
                            ),
                            const SizedBox(height: 14),
                            Text(
                              publication?.url ?? "-",
                              style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              publication?.year != null ? DateFormat('d MMM yyyy').format(publication!.year!) : "-",
                              style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              "Description",
                              style: bold.copyWith(fontSize: 14, color: AppColors.text_2),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              publication?.description ?? "-",
                              style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                            ),
                            AccountActionSection(
                              onEdit: () {
                                Get.toNamed(
                                  AppRoutes.formPublicationView,
                                  arguments: {"status": "edit", "id": publication?.id},
                                );
                              },
                              onDelete: () {
                                deleteBottomSheet(
                                  context,
                                  message: "Are you sure wanna delete this Publication?",
                                  onDelete: () {
                                    controller.deletePublication(publication?.id ?? 0);
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
            title: 'Add Publication',
            onTap: () {
              Get.toNamed(
                AppRoutes.formPublicationView,
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
