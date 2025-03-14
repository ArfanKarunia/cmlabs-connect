import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../constant/fontstyle.dart';
import '../../../controllers/edit_quotation/client_pic_contact_controller.dart';
import '../../../controllers/inbox/quotation/add_quotation_controller.dart';
import '../../../routes.dart';
import '../../../utils/color.dart';
import '../../../widgets/custom_formfield.dart';
import '../../../widgets/custom_select_field.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';
import 'quotation_add_view.dart';

class QuotationAddPicContactView extends StatefulWidget {
  final int contactIndex;
  const QuotationAddPicContactView({super.key, required this.contactIndex});

  @override
  State<QuotationAddPicContactView> createState() => _QuotationAddPicContactViewState();
}

class _QuotationAddPicContactViewState extends State<QuotationAddPicContactView> {
  final controller = Get.find<ClientPicContactController>();
  final addQuotationController = Get.find<AddQuotationController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar('Add Contact'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text('Contact ${widget.contactIndex + 1}', style: bold),
          const SizedBox(height: 7),
          QuotationAddField(
            title: 'Type',
            isRequired: true,
            child: Obx(
              () => CustomSelectField(
                onTap: () => Get.toNamed(
                  AppRoutes.addQuotationSelect,
                  arguments: {
                    'title': 'Type',
                    'data': 'contactType',
                    'isContactForm': true,
                  },
                ),
                errorText: controller.contactTypeError.value,
                child: QuotationTextOnField(
                  title: 'Type',
                  selected: controller.selectedContactType.value,
                ),
              ),
            ),
          ),
          const SizedBox(height: 11),
          QuotationAddField(
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
          QuotationAddField(
            title: 'Status',
            isRequired: true,
            child: Obx(
              () => CustomSelectField(
                onTap: () => Get.toNamed(
                  AppRoutes.addQuotationSelect,
                  arguments: {
                    'title': 'Status',
                    'data': 'contactStatus',
                    'isContactForm': true,
                  },
                ),
                errorText: controller.contactStatusError.value,
                child: QuotationTextOnField(
                  title: 'Status',
                  selected: controller.selectedContactStatus.value,
                ),
              ),
            ),
          ),
          const SizedBox(height: 11),
          QuotationAddField(
            title: 'Detail Status',
            isRequired: true,
            child: Obx(
              () => CustomSelectField(
                onTap: () => Get.toNamed(
                  AppRoutes.addQuotationSelect,
                  arguments: {
                    'title': 'Detail Status',
                    'data': 'contactDetailStatus',
                    'isContactForm': true,
                  },
                ),
                errorText: controller.contactDetailStatusError.value,
                child: QuotationTextOnField(
                  title: 'Detail Status',
                  selected: controller.selectedContactDetailStatus.value,
                ),
              ),
            ),
          ),
          const SizedBox(height: 11),
          QuotationAddField(
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
                addQuotationController.addClientPicContact(index: widget.contactIndex, contact: contact);
                addQuotationController.picClients.refresh();
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
