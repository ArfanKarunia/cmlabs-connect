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
import '../../../widgets/custom_formfield.dart';
import '../../../widgets/custom_select_field.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';
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
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar('Add Quotation'),
      body: Stack(
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
    );
  }

  QuotationAddSection quotationFormSection() {
    return QuotationAddSection(
      title: 'Quotation Form',
      children: [
        QuotationAddField(
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
              child: QuotationTextOnField(
                title: 'Select Company Name',
                selected: controller.companyName.value,
              ),
            ),
          ),
        ),
        const SizedBox(height: 11),
        QuotationAddField(
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
              child: QuotationTextOnField(
                title: 'Select Company Website',
                selected: controller.companyWebsite.value,
              ),
            ),
          ),
        ),
        const SizedBox(height: 11),
        QuotationAddField(
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
                    child: QuotationTextOnField(
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

  QuotationAddSection projectInformationSection() {
    return QuotationAddSection(
      title: 'Project Information',
      children: [
        QuotationAddField(
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
                  ? const QuotationTextOnField(title: 'Select Service', selected: null)
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
        QuotationAddField(
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
              child: QuotationTextOnField(
                title: 'Select Project Pic',
                selected: controller.projectPic.value,
              ),
            ),
          ),
        ),
        const SizedBox(height: 11),
        QuotationAddField(
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
              child: QuotationTextOnField(
                title: 'Select Priority',
                selected: controller.projectPriority.value,
              ),
            ),
          ),
        ),
        const SizedBox(height: 11),
        QuotationAddField(
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
              child: QuotationTextOnField(
                title: 'Select Client Source',
                selected: controller.projectClientSource.value,
              ),
            ),
          ),
        ),
        const SizedBox(height: 11),
        QuotationAddField(
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
              child: QuotationTextOnField(
                title: 'Select Status',
                selected: controller.projectStatus.value,
              ),
            ),
          ),
        ),
        const SizedBox(height: 11),
        QuotationAddField(
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
                  ? const QuotationTextOnField(title: 'Select Project Type', selected: null)
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

  QuotationAddSection activitySection() {
    return QuotationAddSection(
      title: 'Activity',
      children: [
        QuotationAddField(
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
        QuotationAddField(
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
                  ? const QuotationTextOnField(title: 'Select Activity Type', selected: null)
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
        QuotationAddField(
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
        QuotationAddField(
          title: 'Upload File',
          child: CustomSelectField(
            onTap: () async => await _selectFile(),
            icon: Ionicons.folder_open_outline,
            child: QuotationTextOnField(
              title: fileNameController.text.isNotEmpty ? fileNameController.text : 'Choose File',
              selected: null,
            ),
          ),
        ),
      ],
    );
  }

  QuotationAddSection picSection(int index) {
    return QuotationAddSection(
      title: 'PIC (Client Side)',
      children: [
        QuotationAddField(
          title: 'PIC Name',
          isRequired: true,
          child: CustomFormField(
            controller: controller.picNameControllers[index],
            hintText: 'PIC Name',
            errorText: controller.picNameErrors[index],
          ),
        ),
        const SizedBox(height: 11),
        QuotationAddField(
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
            return QuotationAddField(
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
                    return QuotationAddField(
                      title: 'Contact ${i + 1}',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          QuotationAddField(
                            title: 'Type',
                            child: CustomSelectField(
                              child: QuotationTextOnField(
                                title: controller.picClients[index].contacts[i].type.toString(),
                                selected: null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 11),
                          QuotationAddField(
                            title: 'Contact Info',
                            child: CustomSelectField(
                              child: QuotationTextOnField(
                                title: controller.picClients[index].contacts[i].info.toString(),
                                selected: null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 11),
                          QuotationAddField(
                            title: 'Status',
                            child: CustomSelectField(
                              child: QuotationTextOnField(
                                title: controller.picClients[index].contacts[i].status.toString(),
                                selected: null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 11),
                          QuotationAddField(
                            title: 'Detail Status',
                            child: CustomSelectField(
                              child: QuotationTextOnField(
                                title: controller.picClients[index].contacts[i].detail.toString(),
                                selected: null,
                              ),
                            ),
                          ),
                          const SizedBox(height: 11),
                          QuotationAddField(
                            title: 'Note',
                            child: CustomSelectField(
                              child: QuotationTextOnField(
                                title: controller.picClients[index].contacts[i].note.toString(),
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
                  CustomSubmitButton(
                    title: 'Add More Contact',
                    icon: Ionicons.add,
                    onTap: () => Get.toNamed(AppRoutes.addQuotationContact, arguments: {'contactIndex': index}),
                  ),
                  if (index > 0) ...[
                    const SizedBox(height: 10),
                    CustomSubmitButton(
                      title: 'Delete PIC ${index + 1}',
                      onTap: () => controller.removeClientPIC(index),
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

class QuotationAddSection extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const QuotationAddSection({super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: bold.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }
}

class QuotationAddField extends StatelessWidget {
  final String title;
  final bool isRequired;
  final Widget child;
  const QuotationAddField({
    super.key,
    required this.title,
    this.isRequired = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: title,
            children: isRequired
                ? [
                    TextSpan(
                      text: '*',
                      style: bold.copyWith(color: AppColors.danger),
                    ),
                  ]
                : null,
          ),
          style: bold,
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}

class QuotationTextOnField extends StatelessWidget {
  final String title;
  final Map<String, String>? selected;
  const QuotationTextOnField({super.key, required this.title, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
      child: Text(
        selected?['label'] ?? title,
        style: regular.copyWith(color: selected != null ? AppColors.text_1 : AppColors.text_3),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
