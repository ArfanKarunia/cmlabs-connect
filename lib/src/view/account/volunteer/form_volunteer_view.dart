import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/account/account_controller.dart';
import '../../../constant/fontstyle.dart';
import '../../../utils/color.dart';
import '../../../utils/string_utils.dart';
import '../../../widgets/custom_formfield.dart';
import '../../../widgets/custom_select_field.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';
import '../../../widgets/inbox_add_field.dart';

class FormVolunteerView extends StatefulWidget {
  final String status;
  final int? id;
  const FormVolunteerView({super.key, required this.status, this.id});

  @override
  State<FormVolunteerView> createState() => _FormVolunteerViewState();
}

class _FormVolunteerViewState extends State<FormVolunteerView> {
  final AccountController controller = Get.find<AccountController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  final TextEditingController divisionController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;
  bool isStillActive = false;
  final TextEditingController descriptionController = TextEditingController();

  String? nameError;
  String? levelError;
  String? divisionError;
  String? fromDateError;
  String? toDateError;

  bool validateForm() {
    nameError = nameController.text.isEmpty
        ? "The 'Activity Name' field is required"
        : nameController.text.length > 64
            ? "The maximum character of 'Activity Name' is 64 characters"
            : null;
    levelError = levelController.text.isEmpty
        ? "The 'Level' field is required"
        : levelController.text.length > 64
            ? "The maximum character of 'Level' is 64 characters"
            : null;
    divisionError = divisionController.text.isEmpty
        ? "The 'Division' field is required"
        : divisionController.text.length > 64
            ? "The maximum character of 'Division' is 64 characters"
            : null;
    fromDateError = fromDate == null ? "The 'From' field is required" : null;
    toDateError = isStillActive
        ? null
        : toDate == null
            ? "The 'To' field is required"
            : null;
    setState(() {});

    return nameError == null &&
        levelError == null &&
        divisionError == null &&
        fromDateError == null &&
        toDateError == null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.status == 'edit') {
      try {
        final volunteer = controller.volunteerList.firstWhere(
          (exp) => exp!.id == widget.id,
          orElse: () => null,
        );

        setState(() => isStillActive = volunteer?.finishTime == null);

        if (volunteer != null) {
          nameController.text = volunteer.name;
          levelController.text = volunteer.position;
          divisionController.text = volunteer.division;
          descriptionController.text = volunteer.description ?? "";
          fromDate = volunteer.startTime;
          toDate = volunteer.finishTime;
        }
      } catch (e) {
        debugPrint('Error fetching experience: $e');
      }
    } else {
      controller.clearVolunteer();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    levelController.dispose();
    divisionController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar("Volunteer", titleSpacing: 0),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Text(
            "Volunteer",
            style: bold.copyWith(fontSize: 16, color: AppColors.text_1),
          ),

          const SizedBox(height: 14),

          // Activity Name
          InboxAddField(
            title: 'Activity Name',
            isRequired: true,
            child: CustomFormField(
              controller: nameController,
              errorText: nameError,
              hintText: 'Activity Name',
            ),
          ),

          const SizedBox(height: 12),

          // Level
          InboxAddField(
            title: 'Level',
            isRequired: true,
            child: CustomFormField(
              controller: levelController,
              errorText: levelError,
              hintText: 'Level',
            ),
          ),

          const SizedBox(height: 12),

          // Division
          InboxAddField(
            title: 'Division',
            isRequired: true,
            child: CustomFormField(
              controller: divisionController,
              errorText: divisionError,
              hintText: 'Division',
            ),
          ),

          const SizedBox(height: 12),

          // From and To
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
                    isEnabled: !isStillActive,
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

          // I currently study here
          Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  splashRadius: 0,
                  activeColor: AppColors.primary,
                  side: const BorderSide(width: 1, color: AppColors.text_1),
                  value: isStillActive,
                  onChanged: (value) {
                    setState(() {
                      isStillActive = value ?? false;
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
                "I currently still active here",
                style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
              ),
            ],
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
            () => controller.isLoadingVolunteer.value
                ? const CustomLoadingButton()
                : CustomSubmitButton(
                    title: 'Save',
                    onTap: () {
                      if (validateForm()) {
                        controller.volunteerName.value = nameController.text;
                        controller.volunteerPosition.value = levelController.text;
                        controller.volunteerDivision.value = divisionController.text;
                        controller.volunteerFromDate.value = "${fromDate?.year}-${fromDate?.month}-${fromDate?.day}";
                        controller.volunteerToDate.value = "${toDate?.year}-${toDate?.month}-${toDate?.day}";
                        controller.volunteerIsStillActive.value = isStillActive;
                        controller.volunteerDescription.value = descriptionController.text;

                        if (widget.status == "add") {
                          controller.addVolunteer();
                        } else if (widget.status == "edit") {
                          controller.updateVolunteer(widget.id!);
                        }
                      }
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
