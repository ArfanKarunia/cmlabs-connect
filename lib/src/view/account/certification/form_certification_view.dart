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

class FormCertificationView extends StatefulWidget {
  final String status;
  final int? id;
  const FormCertificationView({super.key, required this.status, this.id});

  @override
  State<FormCertificationView> createState() => _FormCertificationViewState();
}

class _FormCertificationViewState extends State<FormCertificationView> {
  final AccountController controller = Get.find<AccountController>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final TextEditingController institutionController = TextEditingController();
  DateTime? fromDate;
  DateTime? toDate;
  bool isHaveExpiration = false;
  final TextEditingController descriptionController = TextEditingController();

  String? nameError;
  String? linkError;
  String? institutionError;
  String? fromDateError;
  String? toDateError;

  bool validateForm() {
    nameError = nameController.text.isEmpty
        ? "The 'Certification Name' field is required"
        : nameController.text.length > 64
            ? "The maximum character of 'Certification Name' is 64 characters"
            : null;
    linkError = linkController.text.isEmpty ? "The 'Certification Link' field is required" : null;
    institutionError = institutionController.text.isEmpty
        ? "The 'Institution' field is required"
        : institutionController.text.length > 64
            ? "The maximum character of 'Institution' is 64 characters"
            : null;
    fromDateError = fromDate == null ? "The 'From' field is required" : null;
    toDateError = isHaveExpiration
        ? null
        : toDate == null
            ? "The 'To' field is required"
            : null;
    setState(() {});

    return nameError == null &&
        linkError == null &&
        institutionError == null &&
        fromDateError == null &&
        toDateError == null;
  }

  @override
  void initState() {
    super.initState();
    if (widget.status == 'edit') {
      try {
        final certification = controller.certificationList.firstWhere(
          (exp) => exp!.id == widget.id,
          orElse: () => null,
        );

        setState(() => isHaveExpiration = certification?.finishTime == null);

        if (certification != null) {
          nameController.text = certification.name;
          linkController.text = certification.url;
          institutionController.text = certification.institutionName;
          descriptionController.text = certification.description ?? "";
          fromDate = certification.startTime;
          toDate = certification.finishTime;
        }
      } catch (e) {
        debugPrint('Error fetching experience: $e');
      }
    } else {
      controller.clearCertification();
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    linkController.dispose();
    institutionController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar("Certification", titleSpacing: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Text(
              "Certification",
              style: bold.copyWith(fontSize: 16, color: AppColors.text_1),
            ),

            const SizedBox(height: 14),

            // Certification Name
            InboxAddField(
              title: 'Certification Name',
              isRequired: true,
              child: CustomFormField(
                controller: nameController,
                errorText: nameError,
                hintText: 'Certification Name',
              ),
            ),

            const SizedBox(height: 12),

            // Certification Link
            InboxAddField(
              title: 'Certification Link',
              isRequired: true,
              child: CustomFormField(
                controller: linkController,
                errorText: linkError,
                hintText: 'Certification Link',
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
                      isEnabled: !isHaveExpiration,
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

            // No Expiration
            Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    splashRadius: 0,
                    activeColor: AppColors.primary,
                    side: const BorderSide(width: 1, color: AppColors.text_1),
                    value: isHaveExpiration,
                    onChanged: (value) {
                      setState(() {
                        isHaveExpiration = value ?? false;
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
                  "No Expiration",
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
              () => controller.isLoadingCertification.value
                  ? const CustomLoadingButton()
                  : CustomSubmitButton(
                      title: 'Save',
                      onTap: () {
                        if (validateForm()) {
                          controller.certificationName.value = nameController.text;
                          controller.certificationLink.value = linkController.text;
                          controller.certificationInstitution.value = institutionController.text;
                          controller.certificationFromDate.value =
                              "${fromDate?.year}-${fromDate?.month}-${fromDate?.day}";
                          controller.certificationToDate.value = "${toDate?.year}-${toDate?.month}-${toDate?.day}";
                          controller.certificationDescription.value = descriptionController.text;
                          controller.certificationIsNoExpiration.value = isHaveExpiration;

                          if (widget.status == "add") {
                            controller.addCertification();
                          } else if (widget.status == "edit") {
                            controller.updateCertification(widget.id!);
                          }
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
