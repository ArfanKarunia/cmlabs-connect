import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../constant/fontstyle.dart';
import '../../../controllers/inbox/quotation/add_quotation_controller.dart';
import '../../../routes.dart';
import '../../../utils/bottom_sheet.dart';
import '../../../utils/color.dart';
import '../../../utils/toast.dart';
import '../../../widgets/custom_formfield.dart';
import '../../../widgets/custom_select_field.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';
import '../../../widgets/inbox/inbox_add_field.dart';
import '../../../widgets/inbox/inbox_add_section.dart';
import '../../../widgets/tag_button.dart';

class QuotationAddView extends StatefulWidget {
  const QuotationAddView({super.key});

  @override
  State<QuotationAddView> createState() => _QuotationAddViewState();
}

class _QuotationAddViewState extends State<QuotationAddView> {
  final controller = Get.find<AddQuotationController>();

  final TextEditingController fileNameController = TextEditingController();
  Rx<File?> pickedFile = Rx<File?>(null);

  @override
  void initState() {
    super.initState();
    controller.addClientPic();
  }

  @override
  void dispose() {
    fileNameController.dispose();
    super.dispose();
  }

  Future<void> _selectFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null) {
        PlatformFile file = result.files.first;
        String extension = file.extension?.toLowerCase() ?? '';
        List<String> allowedExtensions = ['jpg', 'jpeg', 'png', 'pdf', 'docs', 'xlsx', 'csv', 'ppt'];

        if (!allowedExtensions.contains(extension)) {
          showErrorToast('The format file must be ${allowedExtensions.join(", ")}!');
          return;
        }

        if (file.size > 2 * 1024 * 1024) {
          showErrorToast('The maximum of file size is 2 MB!');
          return;
        }

        pickedFile.value = File(file.path!);
        setState(() => fileNameController.text = file.name);
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar('Add Quotation'),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                quotationFormSection(),
                const SizedBox(height: 20),
                projectInformationSection(),
                const SizedBox(height: 20),
                activitySection(),
                const SizedBox(height: 20),
                Obx(() {
                  return Column(
                    children: List.generate(controller.picNameControllers.length, (i) => picSection(i)),
                  );
                }),
                const SizedBox(height: 150),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: AppColors.white_1,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(30, 0, 0, 0),
                      offset: Offset(0, -4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(15, 25, 15, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 140,
                      height: 5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.text_4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () {
                        return controller.isLoading.value
                            ? const CustomLoadingButton()
                            : CustomSubmitButton(
                                title: 'Save',
                                onTap: () => controller.submitQuotation(pickedFile.value),
                              );
                      },
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Click to save all changes",
                      style: regular.copyWith(fontSize: 10, color: AppColors.text_2),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  InboxAddSection quotationFormSection() {
    return InboxAddSection(
      title: 'Quotation Form',
      children: [
        InboxAddField(
          title: 'Company Name',
          isRequired: true,
          child: Obx(
            () => CustomSelectField(
              onTap: () => Get.toNamed(
                AppRoutes.addQuotationSelect,
                arguments: {
                  'title': 'Company Name',
                  'data': 'companyName',
                  'canAdd': true,
                },
              ),
              errorText: controller.companyNameError.value,
              child: InboxTextOnField(
                title: 'Select Company Name',
                selected: controller.companyName.value,
              ),
            ),
          ),
        ),
        const SizedBox(height: 11),
        InboxAddField(
          title: 'Company Website',
          isRequired: true,
          child: Obx(
            () => CustomSelectField(
              onTap: () => Get.toNamed(
                AppRoutes.addQuotationSelect,
                arguments: {
                  'title': 'Company Website',
                  'data': 'companyWebsite',
                  'canAdd': true,
                },
              ),
              errorText: controller.companyWebsiteError.value,
              child: InboxTextOnField(
                title: 'Select Company Website',
                selected: controller.companyWebsite.value,
              ),
            ),
          ),
        ),
        const SizedBox(height: 11),
        InboxAddField(
          title: 'Phone Number',
          isRequired: true,
          child: Obx(
            () => Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: CustomSelectField(
                    onTap: () => Get.toNamed(
                      AppRoutes.addQuotationSelect,
                      arguments: {
                        'title': 'Country Code',
                        'data': 'countryCode',
                      },
                    ),
                    child: InboxTextOnField(
                      title: (controller.countryCode.value?['label'] ?? 'IDN (+62)'),
                      selected: controller.countryCode.value,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: CustomFormField(
                    controller: controller.phoneNumber.value,
                    keyboardType: TextInputType.phone,
                    hintText: '8xxxxxxx',
                    errorText: controller.phoneNumberError.value,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  InboxAddSection projectInformationSection() {
    return InboxAddSection(
      title: 'Project Information',
      children: [
        InboxAddField(
          title: 'Service Category',
          isRequired: true,
          child: Obx(
            () => CustomSelectField(
              onTap: () => Get.toNamed(
                AppRoutes.addQuotationSelect,
                arguments: {
                  'title': 'Service',
                  'data': 'projectService',
                  'isMultipleChoice': true,
                  'canAdd': true,
                },
              ),
              errorText: controller.projectServiceError.value,
              child: controller.projectService.isEmpty
                  ? const InboxTextOnField(title: 'Select Service', selected: null)
                  : Wrap(
                      clipBehavior: Clip.antiAlias,
                      children: List.generate(
                        controller.projectService.length,
                        (index) {
                          Map<String, String> category = controller.projectService[index];

                          return FittedBox(
                            child: TagButton(
                              statusLabel: category['label'].toString(),
                              onPressed: () => controller.projectService.removeAt(index),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 11),
        InboxAddField(
          title: 'CMLABS PIC',
          isRequired: true,
          child: Obx(
            () => CustomSelectField(
              onTap: () => Get.toNamed(
                AppRoutes.addQuotationSelect,
                arguments: {
                  'title': 'PIC',
                  'data': 'projectPic',
                },
              ),
              errorText: controller.projectPicError.value,
              child: InboxTextOnField(
                title: 'Select Project Pic',
                selected: controller.projectPic.value,
              ),
            ),
          ),
        ),
        const SizedBox(height: 11),
        InboxAddField(
          title: 'Priority',
          isRequired: true,
          child: Obx(
            () => CustomSelectField(
              onTap: () => Get.toNamed(
                AppRoutes.addQuotationSelect,
                arguments: {
                  'title': 'Priority',
                  'data': 'projectPriority',
                },
              ),
              errorText: controller.projectPriorityError.value,
              child: InboxTextOnField(
                title: 'Select Priority',
                selected: controller.projectPriority.value,
              ),
            ),
          ),
        ),
        const SizedBox(height: 11),
        InboxAddField(
          title: 'Client Source',
          isRequired: true,
          child: Obx(
            () => CustomSelectField(
              onTap: () => Get.toNamed(
                AppRoutes.addQuotationSelect,
                arguments: {
                  'title': 'Client Source',
                  'data': 'projectClientSource',
                  'canAdd': true,
                },
              ),
              errorText: controller.projectClientSourceError.value,
              child: InboxTextOnField(
                title: 'Select Client Source',
                selected: controller.projectClientSource.value,
              ),
            ),
          ),
        ),
        const SizedBox(height: 11),
        InboxAddField(
          title: 'Status',
          isRequired: true,
          child: Obx(
            () => CustomSelectField(
              onTap: () => Get.toNamed(
                AppRoutes.addQuotationSelect,
                arguments: {
                  'title': 'Status',
                  'data': 'projectStatus',
                },
              ),
              errorText: controller.projectStatusError.value,
              child: InboxTextOnField(
                title: 'Select Status',
                selected: controller.projectStatus.value,
              ),
            ),
          ),
        ),
        const SizedBox(height: 11),
        InboxAddField(
          title: 'Type',
          isRequired: true,
          child: Obx(
            () => CustomSelectField(
              onTap: () => Get.toNamed(
                AppRoutes.addQuotationSelect,
                arguments: {
                  'title': 'Type',
                  'data': 'projectType',
                  'isMultipleChoice': true,
                },
              ),
              errorText: controller.projectTypeError.value,
              child: controller.projectType.isEmpty
                  ? const InboxTextOnField(title: 'Select Project Type', selected: null)
                  : Wrap(
                      clipBehavior: Clip.antiAlias,
                      children: List.generate(
                        controller.projectType.length,
                        (index) {
                          Map<String, String> type = controller.projectType[index];

                          return FittedBox(
                            child: TagButton(
                              statusLabel: type['label'].toString(),
                              onPressed: () => controller.projectType.removeAt(index),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  InboxAddSection activitySection() {
    return InboxAddSection(
      title: 'Activity',
      children: [
        InboxAddField(
          title: 'Activity Name',
          isRequired: true,
          child: Obx(
            () => CustomFormField(
              hintText: 'Activity Name',
              controller: controller.activityName.value,
              errorText: controller.activityNameError.value,
            ),
          ),
        ),
        const SizedBox(height: 11),
        InboxAddField(
          title: 'Type',
          isRequired: true,
          child: Obx(
            () => CustomSelectField(
              onTap: () => Get.toNamed(
                AppRoutes.addQuotationSelect,
                arguments: {
                  'title': 'Activity Type',
                  'data': 'activityType',
                  'isMultipleChoice': true,
                  'canAdd': true,
                },
              ),
              errorText: controller.activityTypeError.value,
              child: controller.activityType.isEmpty
                  ? const InboxTextOnField(title: 'Select Activity Type', selected: null)
                  : Wrap(
                      clipBehavior: Clip.antiAlias,
                      children: List.generate(
                        controller.activityType.length,
                        (index) {
                          Map<String, String> type = controller.activityType[index];

                          return FittedBox(
                            child: TagButton(
                              statusLabel: type['label'].toString(),
                              onPressed: () => controller.activityType.removeAt(index),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 11),
        InboxAddField(
          title: 'Note',
          child: CustomFormField(
            hintText: 'Note',
            controller: controller.activityNote.value,
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
                      onChanged: (value) => setState(() => controller.availableToUser(value)),
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
          title: 'Upload File',
          child: CustomSelectField(
            onTap: () async => await _selectFile(),
            icon: Ionicons.folder_open_outline,
            child: InboxTextOnField(
              title: fileNameController.text.isNotEmpty ? fileNameController.text : 'Choose File',
              selected: null,
            ),
          ),
        ),
      ],
    );
  }

  InboxAddSection picSection(int index) {
    return InboxAddSection(
      title: 'PIC (Client Side)',
      children: [
        InboxAddField(
          title: 'PIC Name',
          isRequired: true,
          child: CustomFormField(
            controller: controller.picNameControllers[index],
            hintText: 'PIC Name',
            errorText: controller.picNameErrors[index],
          ),
        ),
        const SizedBox(height: 11),
        InboxAddField(
          title: 'Position',
          child: CustomFormField(
            controller: controller.picPositionControllers[index],
            hintText: 'Position',
            errorText: controller.picPositionErrors[index],
          ),
        ),
        const SizedBox(height: 11),
        Obx(
          () {
            return InboxAddField(
              title: 'Contact',
              isRequired: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (controller.picContactErrors[index] != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        controller.picContactErrors[index].toString(),
                        style: regular.copyWith(color: AppColors.danger),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  ...List.generate(controller.picClients[index].contacts.length, (i) {
                    return InboxAddField(
                      title: 'Contact ${i + 1}',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InboxAddField(
                            title: 'Type',
                            child: CustomSelectField(
                              child: InboxTextOnField(
                                title: controller.picClients[index].contacts[i].type ?? '',
                                selected: null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 11),
                          InboxAddField(
                            title: 'Contact Info',
                            child: CustomSelectField(
                              child: InboxTextOnField(
                                title: controller.picClients[index].contacts[i].info ?? '',
                                selected: null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 11),
                          InboxAddField(
                            title: 'Status',
                            child: CustomSelectField(
                              child: InboxTextOnField(
                                title: controller.picClients[index].contacts[i].status ?? '',
                                selected: null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 11),
                          InboxAddField(
                            title: 'Detail Status',
                            child: CustomSelectField(
                              child: InboxTextOnField(
                                title: controller.picClients[index].contacts[i].detail ?? '',
                                selected: null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 11),
                          InboxAddField(
                            title: 'Note',
                            child: CustomSelectField(
                              child: InboxTextOnField(
                                title: controller.picClients[index].contacts[i].note ?? '',
                                selected: null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 11),
                          CustomSubmitButton(
                            title: 'Delete Contact ${i + 1}',
                            icon: Icons.delete_outlined,
                            color: AppColors.bgDanger,
                            textColor: AppColors.danger,
                            onTap: () {
                              deleteBottomSheet(
                                context,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                message: 'Are you sure wanna delete this Contact ${i + 1}?',
                                onDelete: () {
                                  controller.picClients[index].contacts.removeAt(i);
                                  controller.picClients.refresh();
                                  Get.back();
                                },
                              );
                            },
                          ),
                          const SizedBox(height: 11),
                        ],
                      ),
                    );
                  }),
                  if (controller.picClients[index].contacts.length < 3) ...[
                    CustomSubmitButton(
                      title: 'Add More Contact',
                      icon: Ionicons.add,
                      onTap: () => Get.toNamed(AppRoutes.addQuotationContact, arguments: {'contactIndex': index}),
                    ),
                  ],
                  if (index > 0) ...[
                    const SizedBox(height: 10),
                    CustomSubmitButton(
                      title: 'Delete PIC ${index + 1}',
                      onTap: () {
                        deleteBottomSheet(
                          context,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          message: 'Are you sure wanna delete this Client PIC ${index + 1}?',
                          onDelete: () {
                            controller.removeClientPIC(index);
                            Get.back();
                          },
                        );
                      },
                      color: AppColors.bgDanger,
                      textColor: AppColors.danger,
                    ),
                  ],
                  if (controller.picNameControllers.length < 3) ...[
                    const SizedBox(height: 10),
                    CustomSubmitButton(
                      onTap: () => controller.addClientPic(),
                      title: 'Add More PIC',
                      icon: Ionicons.add,
                      color: Colors.transparent,
                      borderColor: AppColors.primary,
                      textColor: AppColors.primary,
                    ),
                  ],
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
