import 'package:cmlabs_connect/src/controllers/account/account_controller.dart';
import 'package:cmlabs_connect/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/fontstyle.dart';
import '../../../utils/color.dart';
import '../../../utils/string_utils.dart';
import '../../../widgets/custom_formfield.dart';
import '../../../widgets/custom_select_field.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';
import '../../../widgets/inbox/inbox_add_field.dart';

class FormExperienceView extends StatefulWidget {
  final String status;
  final int? id;
  const FormExperienceView({super.key, required this.status, this.id});

  @override
  State<FormExperienceView> createState() => _FormExperienceViewState();
}

class _FormExperienceViewState extends State<FormExperienceView> {
  final AccountController controller = Get.find<AccountController>();

  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;
  bool isCurrentlyWorkHere = false;

  String? jobTitleError;
  String? projectError;
  String? levelError;
  String? fromDateError;
  String? toDateError;

  bool validateForm() {
    jobTitleError = jobTitleController.text.isEmpty
        ? "The 'Job Title' field is required"
        : jobTitleController.text.length > 30
            ? "The maximum character of 'Job Title' is 30 characters"
            : null;
    projectError = controller.experienceProject.value == null ? "The 'Project' field is required" : null;
    levelError = controller.experienceLevel.value == null ? "The 'Level' field is required" : null;
    fromDateError = fromDate == null ? "The 'From' field is required" : null;
    toDateError = isCurrentlyWorkHere
        ? null
        : toDate == null
            ? "The 'To' field is required"
            : toDate!.isBefore(fromDate!)
                ? "The 'To' date must be after the 'From' date"
                : null;
    setState(() {});

    return jobTitleError == null &&
        projectError == null &&
        levelError == null &&
        fromDateError == null &&
        toDateError == null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.status == 'edit') {
      try {
        final experience = controller.experienceList.firstWhere(
          (exp) => exp?.id == widget.id,
          orElse: () => null,
        );

        setState(() => isCurrentlyWorkHere = experience?.finishTime == null);

        if (experience != null) {
          jobTitleController.text = experience.position;
          descriptionController.text = experience.description;
          fromDate = experience.startTime;
          toDate = experience.finishTime;
          controller.experienceProject.value = experience.company;
          controller.experienceLevel.value = experience.type;
        }
      } catch (e) {
        debugPrint('Error fetching experience: $e');
      }
    } else {
      controller.clearExperience();
    }
  }

  @override
  void dispose() {
    jobTitleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar("${capitalizeFirstLetter(widget.status)} Experience", titleSpacing: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Text(
              "Experience",
              style: bold.copyWith(fontSize: 16, color: AppColors.text_1),
            ),
            const SizedBox(height: 14),
            InboxAddField(
              title: 'Job Title',
              isRequired: true,
              child: CustomFormField(
                controller: jobTitleController,
                hintText: 'Job Title',
                errorText: jobTitleError,
              ),
            ),
            const SizedBox(height: 12),
            InboxAddField(
              title: 'Project',
              isRequired: true,
              child: CustomSelectField(
                errorText: projectError,
                child: Obx(
                  () => InboxTextOnField(
                    title: 'Select Project',
                    selected: controller.experienceProject.value != null
                        ? {
                            'label': controller.experienceProject.value ?? '',
                            'value': controller.experienceProject.value ?? '',
                          }
                        : null,
                  ),
                ),
                onTap: () => Get.toNamed(
                  AppRoutes.accountSelectView,
                  arguments: {'data': AccountSelectData.project},
                ),
              ),
            ),
            const SizedBox(height: 12),
            InboxAddField(
              title: 'Level',
              isRequired: true,
              child: CustomSelectField(
                errorText: levelError,
                child: Obx(
                  () => InboxTextOnField(
                    title: 'Select Level',
                    selected: controller.experienceLevel.value != null
                        ? {
                            'label': controller.experienceLevel.value ?? '',
                            'value': controller.experienceLevel.value ?? '',
                          }
                        : null,
                  ),
                ),
                onTap: () => Get.toNamed(
                  AppRoutes.accountSelectView,
                  arguments: {'data': AccountSelectData.level},
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InboxAddField(
                    title: 'From',
                    isRequired: true,
                    child: CustomSelectField(
                      errorText: fromDateError,
                      child: InboxTextOnField(
                        title: 'Select Date',
                        selected: fromDate != null
                            ? {
                                'label': formatDate(fromDate),
                                'value': formatDate(fromDate),
                              }
                            : null,
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) setState(() => fromDate = pickedDate);
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InboxAddField(
                    title: 'To',
                    isRequired: true,
                    child: CustomSelectField(
                      isEnabled: !isCurrentlyWorkHere,
                      errorText: toDateError,
                      child: InboxTextOnField(
                        title: 'Select Date',
                        selected: toDate != null
                            ? {
                                'label': formatDate(toDate),
                                'value': formatDate(toDate),
                              }
                            : null,
                      ),
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) setState(() => toDate = pickedDate);
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    splashRadius: 0,
                    activeColor: AppColors.primary,
                    side: const BorderSide(width: 1, color: AppColors.text_1),
                    value: isCurrentlyWorkHere,
                    onChanged: (value) {
                      setState(() {
                        isCurrentlyWorkHere = value ?? false;
                        if (value == true) {
                          toDate = null;
                          toDateError = null;
                        }
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  "I currently work here",
                  style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                ),
              ],
            ),
            const SizedBox(height: 12),
            InboxAddField(
              title: 'Description',
              child: CustomFormField(
                controller: descriptionController,
                hintText: 'Description',
              ),
            ),
            const SizedBox(height: 14),
            Obx(
              () => controller.isLoadingExperience.value
                  ? const CustomLoadingButton()
                  : CustomSubmitButton(
                      title: 'Save',
                      onTap: () {
                        if (validateForm()) {
                          controller.experienceJobTitle.value = jobTitleController.text;
                          controller.experienceDescription.value = descriptionController.text;
                          controller.experienceFromDate.value = "${fromDate?.year}-${fromDate?.month}-${fromDate?.day}";
                          controller.experienceToDate.value = "${toDate?.year}-${toDate?.month}-${toDate?.day}";
                          controller.experienceIsCurrentlyWorkHere.value = isCurrentlyWorkHere;

                          if (widget.status == "add") {
                            controller.addExperience();
                          } else if (widget.status == "edit") {
                            controller.updateExperience(widget.id ?? 0);
                          }
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
