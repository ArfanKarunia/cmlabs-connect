import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/fontstyle.dart';
import '../../../controllers/account/account_controller.dart';
import '../../../routes.dart';
import '../../../utils/color.dart';
import '../../../utils/string_utils.dart';
import '../../../widgets/custom_formfield.dart';
import '../../../widgets/custom_select_field.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';
import '../../../widgets/inbox/inbox_add_field.dart';

class FormEducationView extends StatefulWidget {
  final String status;
  final int? id;
  const FormEducationView({super.key, required this.status, this.id});

  @override
  State<FormEducationView> createState() => _FormEducationViewState();
}

class _FormEducationViewState extends State<FormEducationView> {
  final AccountController controller = Get.find<AccountController>();

  final TextEditingController instituteController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController majorController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;
  final TextEditingController descriptionController = TextEditingController();
  bool isCurrentlyStudyHere = false;

  String? instituteError;
  String? departmentError;
  String? majorError;
  String? degreeError;
  String? fromDateError;
  String? toDateError;

  bool validateForm() {
    instituteError = instituteController.text.isEmpty
        ? "The 'Institute Name' field is required"
        : instituteController.text.length > 64
            ? "The maximum character of 'Institute Name' is 64 characters"
            : null;
    departmentError = departmentController.text.isEmpty
        ? "The 'Department' field is required"
        : departmentController.text.length > 64
            ? "The maximum character of 'Department' is 64 characters"
            : null;
    majorError = majorController.text.isEmpty
        ? "The 'Major' field is required"
        : majorController.text.length > 64
            ? "The maximum character of 'Major' is 64 characters"
            : null;
    degreeError = controller.educationDegree.value == null ? "The 'Degree' field is required" : null;
    fromDateError = fromDate == null ? "The 'From' field is required" : null;
    toDateError = isCurrentlyStudyHere
        ? null
        : toDate == null
            ? "The 'To' field is required"
            : null;
    setState(() {});

    return instituteError == null &&
        departmentError == null &&
        majorError == null &&
        degreeError == null &&
        fromDateError == null &&
        toDateError == null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.status == 'edit') {
      try {
        final education = controller.educationList.firstWhere(
          (exp) => exp!.id == widget.id,
          orElse: () => null,
        );

        setState(() => isCurrentlyStudyHere = education?.finishTime == null);

        if (education != null) {
          instituteController.text = education.name;
          departmentController.text = education.department;
          majorController.text = education.major;
          descriptionController.text = education.description;
          fromDate = education.startTime;
          toDate = education.finishTime;
        }
      } catch (e) {
        debugPrint('Error fetching experience: $e');
      }
    } else {
      controller.clearEducation();
    }
  }

  @override
  void dispose() {
    instituteController.dispose();
    departmentController.dispose();
    majorController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar('Education', titleSpacing: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Text(
              "Education",
              style: bold.copyWith(fontSize: 16, color: AppColors.text_1),
            ),

            const SizedBox(height: 14),

            // Institute Name
            InboxAddField(
              title: 'Institute Name',
              isRequired: true,
              child: CustomFormField(
                controller: instituteController,
                hintText: 'Institute Name',
                errorText: instituteError,
              ),
            ),

            const SizedBox(height: 12),

            // Department
            InboxAddField(
              title: 'Department',
              isRequired: true,
              child: CustomFormField(
                controller: departmentController,
                hintText: 'Department',
                errorText: departmentError,
              ),
            ),

            const SizedBox(height: 12),

            // Major
            InboxAddField(
              title: 'Major',
              isRequired: true,
              child: CustomFormField(
                controller: majorController,
                hintText: 'Major',
                errorText: majorError,
              ),
            ),

            const SizedBox(height: 12),

            // Degree
            InboxAddField(
              title: 'Degree',
              isRequired: true,
              child: CustomSelectField(
                errorText: degreeError,
                child: Obx(
                  () => InboxTextOnField(
                    title: 'Degree',
                    selected: controller.educationDegree.value != null
                        ? {
                            'label': controller.educationDegree.value ?? '',
                            'value': controller.educationDegree.value ?? '',
                          }
                        : null,
                  ),
                ),
                onTap: () => Get.toNamed(
                  AppRoutes.accountSelectView,
                  arguments: {'data': AccountSelectData.degree},
                ),
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
                      isEnabled: !isCurrentlyStudyHere,
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
                    value: isCurrentlyStudyHere,
                    onChanged: (value) {
                      setState(() {
                        isCurrentlyStudyHere = value ?? false;
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
                  "I currently study here",
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
              () => controller.isLoadingEducation.value
                  ? const CustomLoadingButton()
                  : CustomSubmitButton(
                      title: 'Save',
                      onTap: () {
                        if (validateForm()) {
                          controller.educationInstitute.value = instituteController.text;
                          controller.educationDepartment.value = departmentController.text;
                          controller.educationMajor.value = majorController.text;
                          controller.educationFromDate.value = "${fromDate?.year}-${fromDate?.month}-${fromDate?.day}";
                          controller.educationToDate.value = "${toDate?.year}-${toDate?.month}-${toDate?.day}";
                          controller.educationIsStillStudy.value = isCurrentlyStudyHere;
                          controller.educationDescription.value = descriptionController.text;

                          if (widget.status == "add") {
                            controller.addEducation();
                          } else if (widget.status == "edit") {
                            controller.updateEducation(widget.id ?? 0);
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
