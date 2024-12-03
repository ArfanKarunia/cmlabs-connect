import 'package:cmlabs_connect/src/controllers/edit_quotation/contactPIC_controller.dart';
import 'package:cmlabs_connect/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../../utils/color.dart';
import '../../../widgets/custom_buttom.dart';

class AddContactView extends StatelessWidget {
  AddContactView({super.key});


  final TextEditingController infoController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  final ContactpicController contactpicController =
      Get.put(ContactpicController());

  @override
  Widget build(BuildContext context) {
    print(
        "isi dari contact value : ${contactpicController.selectedContactType.value}");

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFFF9F9F9),
        surfaceTintColor: Color(0xFFF9F9F9),
        title: Text(
          "Detail Leads",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.text_1,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Contact 1",
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.text_1,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Obx(
                () {
                  return SelectField(
                    name: "Type",
                    child: Container(
                      child:
                          contactpicController.selectedContactType.value == null
                              ? Text(
                                  "Select Contact Type",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.text_3,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              : Text(
                                  "${contactpicController.selectedContactType.value!['label']}",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.text_1,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
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
              SizedBox(
                height: 20,
              ),
              Text(
                "Contact Info",
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.text_2,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: infoController,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: AppColors.text_1,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: AppColors.primary,
                    ),
                  ),
                  hintStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.text_4),
                  hintText: "Select Contact Type",
                  errorStyle: GoogleFonts.plusJakartaSans(
                      color: AppColors.danger,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Obx(
                () {
                  return SelectField(
                    name: "Status",
                    child: Container(
                      child: contactpicController.selectedContactStatus.value ==
                              null
                          ? Text(
                              "Select Status",
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.text_3,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          : Text(
                              "${contactpicController.selectedContactStatus.value!['label']}",
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.text_1,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
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
              SizedBox(
                height: 20,
              ),
              Obx(
                () {
                  return SelectField(
                    name: "Detail Status",
                    child: Container(
                      child: contactpicController.selectedDetailStatus.value ==
                              null
                          ? Text(
                              "Select Detail Status",
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.text_3,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          : Text(
                              "${contactpicController.selectedDetailStatus.value!['label']}",
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.text_1,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
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
              SizedBox(
                height: 20,
              ),
              Text(
                "Note",
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.text_2,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: noteController,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: AppColors.text_1,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: AppColors.primary,
                    ),
                  ),
                  hintStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: AppColors.text_4),
                  hintText: "Note",
                  errorStyle: GoogleFonts.plusJakartaSans(
                      color: AppColors.danger,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 51,
                child: ElevatedButton(
                  onPressed: () {
                    var dataContactPIC = contactpicController.createContactPIC(infoController.text, noteController.text);
                    
                    Get.back(result: dataContactPIC);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        const WidgetStatePropertyAll(AppColors.primary),
                    foregroundColor:
                        const WidgetStatePropertyAll(AppColors.white_1),
                    overlayColor: const WidgetStatePropertyAll(Colors.white30),
                    shadowColor: WidgetStatePropertyAll(Colors.transparent),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Ionicons.add_outline),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Add Contact",
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
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
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.text_3,
              ),
            ),
            (isMandatory)
                ? Text(
                    "*",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.danger,
                    ),
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
