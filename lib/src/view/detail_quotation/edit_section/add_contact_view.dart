import 'package:cmlabs_connect/src/controllers/edit_quotation/client_pic_controller.dart';
import 'package:cmlabs_connect/src/controllers/edit_quotation/client_pic_contact_controller.dart';
import 'package:cmlabs_connect/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../constant/fontstyle.dart';
import '../../../utils/color.dart';
import '../../../widgets/custom_buttom.dart';

class AddContactView extends StatefulWidget {
  final int indexClientPIC;
  const AddContactView({super.key, required this.indexClientPIC});

  @override
  State<AddContactView> createState() => _AddContactViewState();
}

class _AddContactViewState extends State<AddContactView> {
  final ClientPicContactController contactpicController = Get.put(ClientPicContactController());
  final ClientPicController clientPicController = Get.put(ClientPicController());

  @override
  Widget build(BuildContext context) {
    var lenghtContact = clientPicController.selectedContactType.value[widget.indexClientPIC].length;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: AppColors.scaffoldBgColor2,
        surfaceTintColor: AppColors.scaffoldBgColor2,
        title: Text(
          "Detail Leads",
          style: bold.copyWith(fontSize: 20),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Contact ${lenghtContact + 1}",
                style: bold.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 15),
              Obx(
                () {
                  return SelectField(
                    name: "Type",
                    child: Container(
                      child: contactpicController.selectedContactType.value == null
                          ? Text(
                              "Select Contact Type",
                              style: regular.copyWith(fontSize: 13, color: AppColors.text_3),
                            )
                          : Text(
                              "${contactpicController.selectedContactType.value!['label']}",
                              style: regular.copyWith(fontSize: 13),
                            ),
                    ),
                    onPressed: () {
                      Get.toNamed(
                        AppRoutes.editSelect,
                        arguments: {
                          'selectData': "type_contact",
                          'controller': contactpicController,
                        },
                      )?.then(
                        (value) {
                          if (value != null) {
                            contactpicController.addType(value);
                            contactpicController.update();
                          }
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                "Contact Info",
                style: bold.copyWith(color: AppColors.text_2),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: contactpicController.contactInfo.value,
                style: regular,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: AppColors.primary,
                    ),
                  ),
                  hintStyle: regular.copyWith(fontSize: 12, color: AppColors.text_4),
                  hintText: "Fill the contact based on type above",
                  errorStyle: regular.copyWith(fontSize: 12, color: AppColors.danger),
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () {
                  return SelectField(
                    name: "Status",
                    child: Container(
                      child: contactpicController.selectedContactStatus.value == null
                          ? Text(
                              "Select Status",
                              style: regular.copyWith(fontSize: 13, color: AppColors.text_3),
                            )
                          : Text(
                              "${contactpicController.selectedContactStatus.value!['label']}",
                              style: regular.copyWith(fontSize: 13),
                            ),
                    ),
                    onPressed: () {
                      Get.toNamed(
                        "/editSelect",
                        arguments: {
                          'selectData': "status_contact",
                          'controller': contactpicController,
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Obx(
                () {
                  return SelectField(
                    name: "Detail Status",
                    child: Container(
                      child: contactpicController.selectedContactDetailStatus.value == null
                          ? Text(
                              "Select Detail Status",
                              style: regular.copyWith(fontSize: 13, color: AppColors.text_3),
                            )
                          : Text(
                              "${contactpicController.selectedContactDetailStatus.value!['label']}",
                              style: regular.copyWith(fontSize: 13),
                            ),
                    ),
                    onPressed: () {
                      Get.toNamed(
                        "/editSelect",
                        arguments: {
                          'selectData': "detail_contact",
                          'controller': contactpicController,
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Note",
                style: bold.copyWith(color: AppColors.text_2),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: contactpicController.contactNote.value,
                style: regular,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: AppColors.primary,
                    ),
                  ),
                  hintStyle: regular.copyWith(fontSize: 12, color: AppColors.text_4),
                  hintText: "Note",
                  errorStyle: regular.copyWith(fontSize: 12, color: AppColors.danger),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 51,
                child: ElevatedButton(
                  onPressed: () {
                    var dataContactPIC = contactpicController.createContactPIC();

                    Get.back(result: dataContactPIC);
                  },
                  style: ButtonStyle(
                    backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
                    foregroundColor: const WidgetStatePropertyAll(AppColors.white_1),
                    overlayColor: const WidgetStatePropertyAll(Colors.white30),
                    shadowColor: const WidgetStatePropertyAll(Colors.transparent),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Ionicons.add_outline),
                      SizedBox(width: 10),
                      Text("Add Contact", style: bold),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectField extends StatelessWidget {
  SelectField({
    super.key,
    required this.name,
    required this.child,
    required this.onPressed,
    this.isMandatory = false,
  });

  String name;
  bool isMandatory;
  VoidCallback onPressed;
  Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              name,
              style: bold.copyWith(color: AppColors.text_3),
            ),
            (isMandatory)
                ? Text(
                    "*",
                    style: bold.copyWith(color: AppColors.danger),
                  )
                : Container(),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 51,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryText),
            borderRadius: BorderRadius.circular(5),
          ),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              Container(
                child: child,
                width: double.infinity,
              ),
              Container(
                height: 45,
                width: 45,
                child: CustomButton(
                  backgroundColor: AppColors.white_1,
                  onPressed: onPressed,
                  child: const Icon(
                    Ionicons.chevron_down_outline,
                    color: AppColors.text_1,
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
