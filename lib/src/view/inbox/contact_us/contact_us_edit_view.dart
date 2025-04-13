import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:safe_password_generator/safe_password_generator.dart';

import '../../../constant/fontstyle.dart';
import '../../../controllers/inbox/contact_us/edit_contact_us_controller.dart';
import '../../../models/contact_us_model.dart';
import '../../../routes.dart';
import '../../../utils/bottom_sheet.dart';
import '../../../utils/color.dart';
import '../../../utils/toast.dart';
import '../../../widgets/custom_formfield.dart';
import '../../../widgets/custom_select_field.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';
import '../../../widgets/inbox_add_field.dart';
import '../../../widgets/inbox_add_section.dart';
import '../../../widgets/inbox_history_tile.dart';
import '../../../widgets/tag_button.dart';

class ContactUsEditView extends StatefulWidget {
  final ContactUs contactUs;

  const ContactUsEditView({super.key, required this.contactUs});

  @override
  State<ContactUsEditView> createState() => _ContactUsEditViewState();
}

class _ContactUsEditViewState extends State<ContactUsEditView> {
  final controller = Get.find<EditContactUsController>();

  int historyLength = 10;
  bool isValidityEnabled = true;

  @override
  void initState() {
    super.initState();
    controller.fetchData(widget.contactUs.id ?? 0).then((_) => updateValidity());
    controller.urlTrackingPassword.value.addListener(updateValidity);
  }

  @override
  void dispose() {
    controller.urlTrackingPassword.value.removeListener(updateValidity);
    super.dispose();
  }

  void updateValidity() {
    setState(() {
      isValidityEnabled = controller.urlTrackingPassword.value.text != controller.urlTrackingInitialPassword.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: defaultAppBar('Edit Contact Us'),
      backgroundColor: AppColors.scaffoldBgColor2,
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              basicInformation(),
              const SizedBox(height: 20),
              clientPicSection(),
              const SizedBox(height: 20),
              activitySection(),
              const SizedBox(height: 20),
              Obx(() => urlTrackingSection()),
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
                    () => controller.isLoading.value
                        ? const CustomLoadingButton()
                        : CustomSubmitButton(
                            title: 'Save',
                            onTap: () => controller.submitForm(),
                          ),
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

  Column basicInformation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InboxAddField(
          title: 'PIC',
          child: Obx(
            () => CustomSelectField(
              onTap: () => Get.toNamed(
                AppRoutes.editContactUsSelect,
                arguments: {
                  'title': 'PIC',
                  'data': 'pic',
                },
              ),
              child: InboxTextOnField(
                title: 'Select PIC',
                selected: controller.selectedPic.value,
              ),
            ),
          ),
        ),
        const SizedBox(height: 11),
        InboxAddField(
          title: 'Priority',
          child: Obx(
            () => CustomSelectField(
              isEnabled: controller.selectedPic.value != null,
              onTap: () => Get.toNamed(
                AppRoutes.editContactUsSelect,
                arguments: {
                  'title': 'Priority',
                  'data': 'priority',
                },
              ),
              child: InboxTextOnField(
                title: 'Select Priority',
                selected: controller.selectedPriority.value,
              ),
            ),
          ),
        ),
        const SizedBox(height: 11),
        InboxAddField(
          title: 'Status',
          child: Obx(
            () => CustomSelectField(
              isEnabled: controller.selectedPic.value != null,
              onTap: () => Get.toNamed(
                AppRoutes.editContactUsSelect,
                arguments: {
                  'title': 'Status',
                  'data': 'status',
                },
              ),
              child: InboxTextOnField(
                title: 'Select Status',
                selected: controller.selectedStatus.value,
              ),
            ),
          ),
        ),
        const SizedBox(height: 11),
        InboxAddField(
          title: 'Type',
          child: Obx(
            () => CustomSelectField(
              isEnabled: controller.selectedPic.value != null,
              onTap: () => Get.toNamed(
                AppRoutes.editContactUsSelect,
                arguments: {
                  'title': 'Type',
                  'data': 'type',
                  'isMultipleChoice': true,
                },
              ),
              child: controller.selectedType.isEmpty
                  ? const InboxTextOnField(title: 'Select Type', selected: null)
                  : Wrap(
                      clipBehavior: Clip.antiAlias,
                      children: List.generate(
                        controller.selectedType.length,
                        (index) {
                          Map<String, String> category = controller.selectedType[index];

                          return FittedBox(
                            child: TagButton(
                              statusLabel: category['label'].toString(),
                              onPressed: () => controller.selectedType.removeAt(index),
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

  InboxAddSection clientPicSection() {
    return InboxAddSection(
      title: 'PIC (Client Side)',
      children: [
        Obx(
          () => Column(
            children: List.generate(
              controller.picClients.length,
              (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InboxAddField(
                      title: 'PIC Name',
                      // isRequired: true,
                      child: CustomFormField(
                        isEnabled: controller.selectedPic.value != null,
                        controller: controller.picNameControllers[index],
                        hintText: 'PIC Name',
                      ),
                    ),
                    const SizedBox(height: 11),
                    InboxAddField(
                      title: 'Position',
                      child: CustomFormField(
                        isEnabled: controller.selectedPic.value != null,
                        controller: controller.picPositionControllers[index],
                        hintText: 'Position',
                      ),
                    ),
                    const SizedBox(height: 11),
                    Obx(
                      () {
                        return InboxAddField(
                          title: 'Contact',
                          // isRequired: true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ...List.generate(controller.picClients[index].contacts.length, (i) {
                                return Obx(
                                  () => InboxAddField(
                                    title: 'Contact ${i + 1}',
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        InboxAddField(
                                          title: 'Type',
                                          child: CustomSelectField(
                                            isEnabled: controller.selectedPic.value != null,
                                            child: InboxTextOnField(
                                              title: controller.picClients[index].contacts[i].type.toString(),
                                              selected: null,
                                            ),
                                            onTap: () => Get.toNamed(
                                              AppRoutes.editContactUsContact,
                                              arguments: {
                                                'clientIndex': index,
                                                'currentContact': controller.picClients[index].contacts[i],
                                                'currentContactIndex': i,
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 11),
                                        InboxAddField(
                                          title: 'Contact Info',
                                          child: CustomSelectField(
                                            isEnabled: controller.selectedPic.value != null,
                                            child: InboxTextOnField(
                                              title: controller.picClients[index].contacts[i].info.toString(),
                                              selected: null,
                                            ),
                                            onTap: () => Get.toNamed(
                                              AppRoutes.editContactUsContact,
                                              arguments: {
                                                'clientIndex': index,
                                                'currentContact': controller.picClients[index].contacts[i],
                                                'currentContactIndex': i,
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 11),
                                        InboxAddField(
                                          title: 'Status',
                                          child: CustomSelectField(
                                            isEnabled: controller.selectedPic.value != null,
                                            child: InboxTextOnField(
                                              title: controller.picClients[index].contacts[i].status.toString(),
                                              selected: null,
                                            ),
                                            onTap: () => Get.toNamed(
                                              AppRoutes.editContactUsContact,
                                              arguments: {
                                                'clientIndex': index,
                                                'currentContact': controller.picClients[index].contacts[i],
                                                'currentContactIndex': i,
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 11),
                                        InboxAddField(
                                          title: 'Detail Status',
                                          child: CustomSelectField(
                                            isEnabled: controller.selectedPic.value != null,
                                            child: InboxTextOnField(
                                              title: controller.picClients[index].contacts[i].detail.toString(),
                                              selected: null,
                                            ),
                                            onTap: () => Get.toNamed(
                                              AppRoutes.editContactUsContact,
                                              arguments: {
                                                'clientIndex': index,
                                                'currentContact': controller.picClients[index].contacts[i],
                                                'currentContactIndex': i,
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 11),
                                        InboxAddField(
                                          title: 'Note',
                                          child: CustomSelectField(
                                            isEnabled: controller.selectedPic.value != null,
                                            child: InboxTextOnField(
                                              title: controller.picClients[index].contacts[i].note.toString(),
                                              selected: null,
                                            ),
                                            onTap: () => Get.toNamed(
                                              AppRoutes.editContactUsContact,
                                              arguments: {
                                                'clientIndex': index,
                                                'currentContact': controller.picClients[index].contacts[i],
                                                'currentContactIndex': i,
                                              },
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
                                  ),
                                );
                              }),
                              CustomSubmitButton(
                                title: 'Add More Contact',
                                icon: Ionicons.add,
                                onTap: () => Get.toNamed(
                                  AppRoutes.editContactUsContact,
                                  arguments: {'clientIndex': index},
                                ),
                              ),
                              const SizedBox(height: 10),
                              CustomSubmitButton(
                                title: 'Delete PIC ${index + 1}',
                                onTap: () => controller.removeClientPIC(index),
                                color: AppColors.bgDanger,
                                textColor: AppColors.danger,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                  ],
                );
              },
            ),
          ),
        ),
        Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.picNameControllers.length < 3) ...[
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
          );
        })
      ],
    );
  }

  InboxAddSection activitySection() {
    return InboxAddSection(
      title: 'Activity',
      children: [
        Obx(() {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(
                controller.activityName.length,
                (index) {
                  return InboxAddField(
                    title: 'Activity ${index + 1}',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        InboxAddField(
                          title: 'Topic/Name',
                          child: CustomFormField(
                            isEnabled: controller.selectedPic.value != null,
                            controller: controller.activityName[index],
                            hintText: 'Meeting Topic',
                          ),
                        ),
                        const SizedBox(height: 11),
                        InboxAddField(
                          title: 'Meeting Schedule',
                          child: Obx(
                            () => CustomSelectField(
                              isEnabled: controller.selectedPic.value != null,
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  controller.setActivityValue(
                                    data: 'activitySchedule',
                                    index: index,
                                    value: pickedDate,
                                  );
                                }
                              },
                              icon: Ionicons.calendar_outline,
                              child: InboxTextOnField(
                                title: 'Select Meeting Schedule',
                                selected: controller.activitySchedule[index] != null
                                    ? {
                                        'value': DateFormat('dd MMM yyyy')
                                            .format(controller.activitySchedule[index] ?? DateTime.now()),
                                        'label': DateFormat('dd MMM yyyy')
                                            .format(controller.activitySchedule[index] ?? DateTime.now()),
                                      }
                                    : null,
                                // controller.projectPic.value,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 11),
                        InboxAddField(
                          title: 'Status',
                          child: Obx(
                            () => CustomSelectField(
                              isEnabled: controller.selectedPic.value != null,
                              onTap: () => Get.toNamed(
                                AppRoutes.editContactUsSelect,
                                arguments: {
                                  'title': 'Activity Status',
                                  'data': 'activityStatus',
                                  'isActivity': true,
                                  'index': index,
                                },
                              ),
                              child: InboxTextOnField(
                                title: 'Select Status',
                                selected: controller.activityStatus[index],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 11),
                        InboxAddField(
                          title: 'Type',
                          child: Obx(
                            () => CustomSelectField(
                              isEnabled: controller.selectedPic.value != null,
                              onTap: () => Get.toNamed(
                                AppRoutes.editContactUsSelect,
                                arguments: {
                                  'title': 'Activity Type',
                                  'data': 'activityType',
                                  'isActivity': true,
                                  'index': index,
                                },
                              ),
                              child: InboxTextOnField(
                                title: 'Select Type',
                                selected: controller.activityType[index],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text('Available to User', style: regular.copyWith(fontSize: 12)),
                            const SizedBox(width: 10),
                            Obx(
                              () => SizedBox(
                                height: 32,
                                child: FittedBox(
                                  fit: BoxFit.fill,
                                  child: Switch(
                                    value: controller.activityAvailableToUser[index],
                                    onChanged: (value) {
                                      setState(() => controller.activityAvailableToUser[index] = value);
                                    },
                                    activeTrackColor: AppColors.primary,
                                    inactiveTrackColor: const Color(0xFFD8DAE5),
                                    trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                                    inactiveThumbColor: AppColors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        InboxAddField(
                          title: 'Note',
                          child: CustomFormField(
                            isEnabled: controller.selectedPic.value != null,
                            controller: controller.activityNote[index],
                            hintText: 'Meeting Note',
                          ),
                        ),
                        const SizedBox(height: 11),
                        CustomSubmitButton(
                          title: 'Delete Activity ${index + 1}',
                          onTap: () => controller.removeActivity(index),
                          color: AppColors.bgDanger,
                          textColor: AppColors.danger,
                        ),
                        const SizedBox(height: 11),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        }),
        CustomSubmitButton(
          onTap: () => controller.addNewActivity(),
          title: 'Add More Activity',
          icon: Ionicons.add,
          color: Colors.transparent,
          borderColor: AppColors.primary,
          textColor: AppColors.primary,
        ),
        const SizedBox(height: 11),
        InboxAddField(
          title: 'Remarks',
          child: CustomFormField(
            controller: controller.activityRemarks.value,
            hintText: 'Remarks',
          ),
        ),
        const SizedBox(height: 11),
        InboxAddField(
          title: 'Additional Notes',
          child: CustomFormField(
            controller: controller.activityAdditionalNotes.value,
            hintText: 'Additional Notes',
          ),
        ),
      ],
    );
  }

  Column urlTrackingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'URL Tracking',
              style: bold.copyWith(fontSize: 16, color: AppColors.text_1),
            ),
            SizedBox(
              height: 32,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Switch(
                  value: controller.urlTrackingEnabled.value,
                  onChanged: (value) => setState(() => controller.urlTrackingEnabled(value)),
                  activeTrackColor: AppColors.primary,
                  inactiveTrackColor: const Color(0xFFD8DAE5),
                  trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                  inactiveThumbColor: AppColors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 11),
        InboxAddField(
          title: 'URL',
          isRequired: true,
          child: CustomSelectField(
            isEnabled: controller.selectedPic.value != null && controller.urlTrackingEnabled.value,
            icon: null,
            child: InboxTextOnField(title: 'URL', selected: {'label': '${controller.urlTrackingUrl.value}'}),
          ),
        ),
        const SizedBox(height: 11),
        CustomSubmitButton(
          title: 'Copy URL',
          isDisabled: !controller.urlTrackingEnabled.value,
          onTap: () async {
            if (controller.urlTrackingUrl.value != null) {
              await Clipboard.setData(ClipboardData(text: controller.urlTrackingUrl.value ?? ''));
              showSuccessToast('URL Copied!');
            }
          },
        ),
        const SizedBox(height: 11),
        InboxAddField(
          title: 'Password',
          isRequired: true,
          child: CustomFormField(
            isEnabled: controller.selectedPic.value != null && controller.urlTrackingEnabled.value,
            isPassword: true,
            controller: controller.urlTrackingPassword.value,
          ),
        ),
        const SizedBox(height: 11),
        Text(
          'Expired at',
          style: regular.copyWith(fontSize: 12, color: AppColors.text_3),
        ),
        const SizedBox(height: 4),
        Text(
          controller.urlTrackingExpired.value != null
              ? DateFormat('d MMM yyyy').format(controller.urlTrackingExpired.value!)
              : '-',
          style: regular.copyWith(fontSize: 11, color: AppColors.text_4),
        ),
        const SizedBox(height: 11),
        CustomSubmitButton(
          title: 'Generate Password',
          isDisabled: controller.selectedPic.value != null && !controller.urlTrackingEnabled.value,
          onTap: () {
            controller.urlTrackingPassword.value.text = SafePasswordGenerator.generatePassword(
              length: 16,
              includeUppercase: true,
              includeLowercase: true,
              includeNumbers: true,
              includeSpecialCharacters: true,
            );
          },
        ),
        const SizedBox(height: 11),
        InboxAddField(
          title: 'Validity',
          child: Obx(
            () => CustomSelectField(
              isEnabled:
                  controller.selectedPic.value != null && controller.urlTrackingEnabled.value && isValidityEnabled,
              onTap: () => Get.toNamed(
                AppRoutes.editContactUsSelect,
                arguments: {
                  'title': 'Validity',
                  'data': 'validity',
                },
              ),
              child: InboxTextOnField(
                title: 'Select Validity',
                selected: controller.selectedValidity.value,
              ),
            ),
          ),
        ),
        const SizedBox(height: 11),
        InboxAddField(
          title: 'History',
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: const BoxDecoration(color: AppColors.white),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...List.generate(
                  historyLength > controller.historyList.length ? controller.historyList.length : historyLength,
                  (index) => HistoryTile(
                    controller: controller,
                    index: index,
                    onEditRoute: AppRoutes.editContactUsHistory,
                  ),
                ),
                if (historyLength < controller.historyList.length)
                  CustomSubmitButton(
                    title: 'Load More',
                    padding: 8,
                    onTap: () => setState(() => historyLength += 10),
                  ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
