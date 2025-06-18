import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../constant/fontstyle.dart';
import '../../../controllers/edit_quotation/client_pic_contact_controller.dart';
import '../../../controllers/inbox/case_studies/edit_case_studies_controller.dart';
import '../../../models/inbox/property/client_pic_model.dart';
import '../../../routes.dart';
import '../../../utils/color.dart';
import '../../../widgets/custom_formfield.dart';
import '../../../widgets/custom_select_field.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';
import '../../../widgets/inbox_add_field.dart';

class CaseStudiesEditPicContactView extends StatefulWidget {
  final int clientIndex;
  final ContactClientPic? currentContact;
  final int? currentContactIndex;
  const CaseStudiesEditPicContactView({
    super.key,
    required this.clientIndex,
    this.currentContact,
    this.currentContactIndex,
  });

  @override
  State<CaseStudiesEditPicContactView> createState() => _CaseStudiesEditPicContactViewState();
}

class _CaseStudiesEditPicContactViewState extends State<CaseStudiesEditPicContactView> {
  final controller = Get.find<ClientPicContactController>();
  final editCaseStudiesController = Get.find<EditCaseStudiesController>();

  @override
  void initState() {
    super.initState();
    if (widget.currentContact != null) {
      controller.setExistingValue(widget.currentContact!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar('Add Contact'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text('Contact ${widget.clientIndex + 1}', style: bold),
          const SizedBox(height: 7),
          InboxAddField(
            title: 'Type',
            isRequired: true,
            child: Obx(
              () => CustomSelectField(
                onTap: () => Get.toNamed(
                  AppRoutes.editCaseStudiesSelect,
                  arguments: {
                    'title': 'Type',
                    'data': 'contactType',
                    'isContactForm': true,
                  },
                ),
                errorText: controller.contactTypeError.value,
                child: InboxTextOnField(
                  title: 'Type',
                  selected: controller.selectedContactType.value,
                ),
              ),
            ),
          ),
          const SizedBox(height: 11),
          InboxAddField(
            title: 'Contact Info',
            isRequired: true,
            child: Obx(
              () => CustomFormField(
                controller: controller.contactInfo.value,
                hintText: 'Fill the contact based on type above',
                errorText: controller.contactInfoError.value,
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
                  AppRoutes.editCaseStudiesSelect,
                  arguments: {
                    'title': 'Status',
                    'data': 'contactStatus',
                    'isContactForm': true,
                  },
                ),
                errorText: controller.contactStatusError.value,
                child: InboxTextOnField(
                  title: 'Status',
                  selected: controller.selectedContactStatus.value,
                ),
              ),
            ),
          ),
          const SizedBox(height: 11),
          InboxAddField(
            title: 'Detail Status',
            isRequired: true,
            child: Obx(
              () => CustomSelectField(
                onTap: () => Get.toNamed(
                  AppRoutes.editCaseStudiesSelect,
                  arguments: {
                    'title': 'Detail Status',
                    'data': 'contactDetailStatus',
                    'isContactForm': true,
                  },
                ),
                errorText: controller.contactDetailStatusError.value,
                child: InboxTextOnField(
                  title: 'Detail Status',
                  selected: controller.selectedContactDetailStatus.value,
                ),
              ),
            ),
          ),
          const SizedBox(height: 11),
          InboxAddField(
            title: 'Note',
            child: Obx(
              () => CustomFormField(
                controller: controller.contactNote.value,
                hintText: 'Note',
              ),
            ),
          ),
          const SizedBox(height: 11),
          CustomSubmitButton(
            onTap: () {
              if (controller.validateForm()) {
                final contact = controller.createContactPIC();
                if (widget.currentContact != null) {
                  editCaseStudiesController.editClientPicContact(
                    clientIndex: widget.clientIndex,
                    contactIndex: widget.currentContactIndex!,
                    contact: contact,
                  );
                } else {
                  editCaseStudiesController.addClientPicContact(
                    index: widget.clientIndex,
                    contact: contact,
                  );
                }
                editCaseStudiesController.picClients.refresh();
                Get.back();
              }
            },
            title: 'Add Contact',
            icon: Ionicons.add,
          )
        ],
      ),
    );
  }
}
