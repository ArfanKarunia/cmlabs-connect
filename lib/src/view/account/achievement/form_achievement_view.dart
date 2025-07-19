import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/fontstyle.dart';
import '../../../controllers/account/account_controller.dart';
import '../../../utils/color.dart';
import '../../../utils/string_utils.dart';
import '../../../widgets/custom_formfield.dart';
import '../../../widgets/custom_select_field.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';
import '../../../widgets/inbox/inbox_add_field.dart';

class FormAchievementView extends StatefulWidget {
  final String status;
  final int? id;
  const FormAchievementView({super.key, required this.status, this.id});

  @override
  State<FormAchievementView> createState() => _FormAchievementViewState();
}

class _FormAchievementViewState extends State<FormAchievementView> {
  final AccountController controller = Get.find<AccountController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController institutionController = TextEditingController();
  DateTime? achievementDate;
  final TextEditingController descriptionController = TextEditingController();

  String? nameError;
  String? institutionError;
  String? dateError;

  bool validateForm() {
    nameError = nameController.text.isEmpty
        ? "The 'Achievement Name' field is required"
        : nameController.text.length > 64
            ? "The maximum character of 'Achievement Name' is 64 characters"
            : null;
    institutionError = institutionController.text.isEmpty
        ? "The 'Institution' field is required"
        : institutionController.text.length > 64
            ? "The maximum character of 'Institution' is 64 characters"
            : null;
    dateError = achievementDate == null ? "The 'Date' field is required" : null;
    setState(() {});

    return nameError == null && institutionError == null && dateError == null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.status == 'edit') {
      try {
        final achievement = controller.achievementList.firstWhere(
          (exp) => exp!.id == widget.id,
          orElse: () => null,
        );

        if (achievement != null) {
          nameController.text = achievement.name;
          institutionController.text = achievement.institutionName;
          descriptionController.text = achievement.description ?? "";
          achievementDate = achievement.year;
        }
      } catch (e) {
        debugPrint('Error fetching achievement: $e');
      }
    } else {
      controller.clearAchievement();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    institutionController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar("Achievement", titleSpacing: 0),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Text(
            "Achievement",
            style: bold.copyWith(fontSize: 16, color: AppColors.text_1),
          ),

          const SizedBox(height: 14),

          // Achievement Name
          InboxAddField(
            title: 'Achievement Name',
            isRequired: true,
            child: CustomFormField(
              controller: nameController,
              errorText: nameError,
              hintText: 'Achievement Name',
            ),
          ),

          const SizedBox(height: 12),

          // Institution
          InboxAddField(
            title: 'Institution',
            isRequired: true,
            child: CustomFormField(
              controller: institutionController,
              errorText: institutionError,
              hintText: 'Institution',
            ),
          ),

          const SizedBox(height: 12),

          // Date
          InboxAddField(
            title: 'Date',
            isRequired: true,
            child: CustomSelectField(
              errorText: dateError,
              child: InboxTextOnField(
                title: 'Select Date',
                selected: achievementDate != null
                    ? {
                        'label': formatDate(achievementDate),
                        'value': formatDate(achievementDate),
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
                if (pickedDate != null) setState(() => achievementDate = pickedDate);
              },
            ),
          ),

          const SizedBox(height: 12),

          // Description
          InboxAddField(
            title: 'Description',
            child: CustomFormField(
              controller: descriptionController,
              hintText: 'Description',
            ),
          ),

          const SizedBox(height: 14),

          Obx(
            () => controller.isLoadingAchievement.value
                ? const CustomLoadingButton()
                : CustomSubmitButton(
                    title: 'Save',
                    onTap: () {
                      if (validateForm()) {
                        controller.achievementName.value = nameController.text;
                        controller.achievementInstitute.value = institutionController.text;
                        controller.achievementYear.value =
                            "${achievementDate?.year}-${achievementDate?.month}-${achievementDate?.day}";
                        controller.achievementDescription.value = descriptionController.text;

                        if (widget.status == "add") {
                          controller.addAchievement();
                        } else if (widget.status == "edit") {
                          controller.updateAchievement(widget.id!);
                        }
                      }
                    },
                  ),
          ),

          const SizedBox(height: 200),
        ],
      ),
    );
  }
}
