import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../../constant/fontstyle.dart';
import '../../../controllers/inbox/case_studies/edit_history_case_studies_controller.dart';
import '../../../models/inbox/property/project_history_model.dart';
import '../../../routes.dart';
import '../../../utils/color.dart';
import '../../../widgets/custom_formfield.dart';
import '../../../widgets/custom_select_field.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';
import '../../../widgets/inbox/inbox_add_field.dart';
import '../../../widgets/inbox/inbox_add_section.dart';
import '../../../widgets/tag_button.dart';

class CaseStudiesEditHistoryView extends StatefulWidget {
  final ProjectHistory history;
  const CaseStudiesEditHistoryView({super.key, required this.history});

  @override
  State<CaseStudiesEditHistoryView> createState() => _CaseStudiesEditHistoryViewState();
}

class _CaseStudiesEditHistoryViewState extends State<CaseStudiesEditHistoryView> {
  final controller = Get.find<EditHistoryCaseStudiesController>();
  final TextEditingController fileNameController = TextEditingController();
  Rx<File?> pickedFile = Rx<File?>(null);

  @override
  void initState() {
    super.initState();
    controller.setInitialValue(widget.history);
  }

  @override
  void dispose() {
    fileNameController.dispose();
    super.dispose();
  }

  Future<void> _selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'docs', 'xlsx', 'csv', 'ppt'],
      );

      if (result != null) {
        PlatformFile file = result.files.first;
        pickedFile.value = File(file.path!);
        setState(() => fileNameController.text = file.name);
      } else {
        debugPrint("File selection canceled");
      }
    } catch (e) {
      debugPrint("Error picking file: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar('Edit History'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Obx(
            () {
              return InboxAddSection(
                title: 'Edit Project Activity',
                children: [
                  InboxAddField(
                    title: 'Activity Name',
                    isRequired: true,
                    child: CustomFormField(
                      controller: controller.activityName.value,
                      hintText: 'Activity Name',
                      errorText: controller.activityNameError.value,
                    ),
                  ),
                  const SizedBox(height: 11),
                  InboxAddField(
                    title: 'Type',
                    child: CustomSelectField(
                      onTap: () => Get.toNamed(AppRoutes.editCaseStudiesSelect, arguments: {
                        'title': 'Type',
                        'data': 'historyType',
                        'isMultipleChoice': true,
                        'isHistory': true,
                      }),
                      child: controller.activityType.isEmpty
                          ? const InboxTextOnField(title: 'Select Type', selected: null)
                          : Wrap(
                              clipBehavior: Clip.antiAlias,
                              children: List.generate(
                                controller.activityType.length,
                                (index) {
                                  Map<String, String> category = controller.activityType[index];

                                  return FittedBox(
                                    child: TagButton(
                                      statusLabel: category['label'].toString(),
                                      onPressed: () => controller.activityType.removeAt(index),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 11),
                  InboxAddField(
                    title: 'Note',
                    child: CustomFormField(
                      controller: controller.activityNote.value,
                      hintText: 'Note',
                    ),
                  ),
                  const SizedBox(height: 11),
                  Row(
                    children: [
                      const Text('Available to User', style: regular),
                      const SizedBox(width: 10),
                      Obx(
                        () {
                          return SizedBox(
                            height: 32,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Switch(
                                value: controller.availableToUser.value,
                                onChanged: (value) => controller.availableToUser(value),
                                activeTrackColor: AppColors.primary,
                                inactiveTrackColor: const Color(0xFFD8DAE5),
                                trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                                inactiveThumbColor: AppColors.white,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 11),
                  InboxAddField(
                    title: 'Created at',
                    child: CustomSelectField(
                      isEnabled: false,
                      icon: Ionicons.calendar_outline,
                      child: InboxTextOnField(
                        title: 'Select Meeting Schedule',
                        selected: controller.activityCreatedAt.value != null
                            ? {
                                'value': DateFormat('dd MMM yyyy')
                                    .format(controller.activityCreatedAt.value ?? DateTime.now()),
                                'label': DateFormat('dd MMM yyyy')
                                    .format(controller.activityCreatedAt.value ?? DateTime.now()),
                              }
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 11),
                  InboxAddField(
                    title: 'Upload File',
                    child: CustomSelectField(
                      onTap: () async => await _selectFile(),
                      icon: Ionicons.folder_open_outline,
                      errorText: controller.activityFileError.value,
                      child: InboxTextOnField(
                        title: fileNameController.text.isNotEmpty
                            ? fileNameController.text
                            : widget.history.file ?? 'Choose File',
                        selected: null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 11),
                  Obx(
                    () {
                      return controller.isLoading.value
                          ? const CustomLoadingButton()
                          : CustomSubmitButton(
                              title: 'Save',
                              onTap: () => controller.submitHistory(id: widget.history.id ?? 0, file: pickedFile.value),
                            );
                    },
                  ),
                ],
              );
            },
          )
        ],
      ),
    );
  }
}
