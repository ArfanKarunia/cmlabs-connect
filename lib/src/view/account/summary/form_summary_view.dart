import 'package:cmlabs_connect/src/controllers/account/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/fontstyle.dart';
import '../../../utils/color.dart';
import '../../../utils/string_utils.dart';
import '../../../widgets/account/account_setting_card.dart';
import '../../../widgets/custom_formfield.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';
import '../../../widgets/inbox/inbox_add_field.dart';

class FormSummaryView extends StatefulWidget {
  final String status;
  const FormSummaryView({super.key, required this.status});

  @override
  State<FormSummaryView> createState() => _FormSummaryViewState();
}

class _FormSummaryViewState extends State<FormSummaryView> {
  final AccountController controller = Get.find<AccountController>();

  final TextEditingController aboutController = TextEditingController();
  String? aboutError;

  bool validateForm() {
    aboutError = aboutController.text.isEmpty
        ? "The 'About' field is required"
        : aboutController.text.length > 1000
            ? "The maximum character of 'About' is 1000 characters"
            : null;
    setState(() {});

    return aboutError == null;
  }

  @override
  void initState() {
    super.initState();
    switch (widget.status) {
      case "add":
        controller.summarySpecializationChecked.value =
            List<bool>.filled(controller.summarySpecializationList.length, false);
        break;
      case "edit":
        aboutController.text = controller.summaryAbout.value ?? '';
        for (int i = 0; i < controller.summarySpecialization.length; i++) {
          String? specializationName = controller.summarySpecialization[i];

          // Match the specialization with the specializationList
          for (int j = 0; j < controller.summarySpecializationList.length; j++) {
            if (specializationName == controller.summarySpecializationList[j]['name']) {
              controller.summarySpecializationChecked[j] = true;
            }
          }
        }
    }
  }

  @override
  void dispose() {
    aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar("${capitalizeFirstLetter(widget.status)} Summary", titleSpacing: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            AccountSettingCard(
              child: Column(
                children: [
                  InboxAddField(
                    title: 'About',
                    child: CustomFormField(
                      controller: aboutController,
                      errorText: aboutError,
                    ),
                  ),
                  const SizedBox(height: 16),
                  InboxAddField(
                    title: 'Spesialization',
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.summarySpecializationList.length,
                      itemBuilder: (context, index) {
                        return SizedBox(
                          height: 35,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Obx(
                                () => Checkbox(
                                  side: const BorderSide(color: AppColors.text_1, width: 1.5),
                                  activeColor: AppColors.primary,
                                  value: controller.summarySpecializationChecked[index],
                                  onChanged: (value) {
                                    controller.summarySpecializationChecked[index] = value ?? false;

                                    var specialization = controller.summarySpecializationList[index]['name'];
                                    if (controller.summarySpecialization.contains(specialization)) {
                                      controller.summarySpecialization.remove(specialization);
                                    } else {
                                      controller.summarySpecialization.add(specialization);
                                    }
                                  },
                                ),
                              ),
                              Text(
                                controller.summarySpecializationList[index]['name'],
                                style: regular.copyWith(color: AppColors.text_1),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => controller.isLoadingSummary.value
                  ? const CustomLoadingButton()
                  : CustomSubmitButton(
                      title: "Save",
                      onTap: () {
                        if (validateForm()) {
                          controller.summaryAbout.value = aboutController.text;
                          controller.addSummary();
                        }
                      },
                    ),
            ),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }
}
