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

class FormOrganizationView extends StatefulWidget {
  final String status;
  final int? id;
  const FormOrganizationView({super.key, required this.status, this.id});

  @override
  State<FormOrganizationView> createState() => _FormOrganizationViewState();
}

class _FormOrganizationViewState extends State<FormOrganizationView> {
  final AccountController controller = Get.find<AccountController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;
  bool isStillActive = false;
  final TextEditingController descriptionController = TextEditingController();

  String? nameError;
  String? levelError;
  String? fromDateError;
  String? toDateError;

  bool validateForm() {
    nameError = nameController.text.isEmpty
        ? "The 'Organization Name' field is required"
        : nameController.text.length > 64
            ? "The maximum character of 'Organization Name' is 64 characters"
            : null;
    levelError = levelController.text.isEmpty
        ? "The 'Level' field is required"
        : levelController.text.length > 64
            ? "The maximum character of 'Level' is 64 characters"
            : null;
    fromDateError = fromDate == null ? "The 'From' field is required" : null;
    toDateError = isStillActive
        ? null
        : toDate == null
            ? "The 'To' field is required"
            : toDate!.isBefore(fromDate!)
                ? "The 'To' date must be after the 'From' date"
                : null;
    setState(() {});

    return nameError == null && levelError == null && fromDateError == null && toDateError == null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.status == 'edit') {
      try {
        final organization = controller.organizationList.firstWhere(
          (exp) => exp!.id == widget.id,
          orElse: () => null,
        );

        setState(() => isStillActive = organization?.finishTime == null);

        if (organization != null) {
          nameController.text = organization.name;
          levelController.text = organization.position;
          descriptionController.text = organization.description ?? "";
          fromDate = organization.startTime;
          toDate = organization.finishTime;
        }
      } catch (_) {}
    } else {
      controller.clearOrganization();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    levelController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar("Organization", titleSpacing: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Text(
              "Organization",
              style: bold.copyWith(fontSize: 16, color: AppColors.text_1),
            ),

            const SizedBox(height: 14),

            // Organization Name
            InboxAddField(
              title: 'Organization Name',
              isRequired: true,
              child: CustomFormField(
                controller: nameController,
                errorText: nameError,
                hintText: 'Organization Name',
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

            // Still Active Checkbox
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
              () => controller.isLoadingOrganization.value
                  ? const CustomLoadingButton()
                  : CustomSubmitButton(
                      title: 'Save',
                      onTap: () {
                        if (validateForm()) {
                          controller.organizationName.value = nameController.text;
                          controller.organizationPosition.value = levelController.text;
                          controller.organizationFromDate.value =
                              "${fromDate?.year}-${fromDate?.month}-${fromDate?.day}";
                          controller.organizationToDate.value = "${toDate?.year}-${toDate?.month}-${toDate?.day}";
                          controller.organizationIsStillActive.value = isStillActive;
                          controller.organizationDescription.value = descriptionController.text;

                          if (widget.status == "add") {
                            controller.addOrganization();
                          } else if (widget.status == "edit") {
                            controller.updateOrganization(widget.id!);
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
