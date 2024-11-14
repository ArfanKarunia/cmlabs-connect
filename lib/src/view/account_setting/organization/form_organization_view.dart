import 'package:cmlabs_connect/src/controllers/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/color.dart';

class FormOrganizationView extends StatelessWidget {
  FormOrganizationView({super.key, required this.status, this.id});

  final String status;
  final int? id;

  final AccountController accountController = Get.put(AccountController());

  final TextEditingController nameController = TextEditingController();
  final TextEditingController levelController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  var isStillActive = false.obs;

  final _formKey = GlobalKey<FormState>();

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      controller.text =
          "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
    }
  }

  @override
  Widget build(BuildContext context) {

    if (status == 'edit') {
      try {
        var organization =
            accountController.organizationList.value.firstWhere(
          (exp) => exp!.id == id, // Search for the experience where id matches
          orElse: () => null, // If no match is found, return null
        );

        isStillActive.value = organization?.finishTime == null;

        if (organization != null) {
          // Update the controllers with the experience data
          var fromDate =
              "${organization.startTime.year}-${organization.startTime.month}-${organization.startTime.day}";
          var toDate = organization.finishTime == null
              ? ""
              : "${organization.finishTime!.year}-${organization.finishTime!.month.toString().padLeft(2, '0')}-${organization.finishTime!.day.toString().padLeft(2, '0')}";

          nameController.text = organization.name;
          levelController.text = organization.position;
          descriptionController.text = organization.description ?? "";
          fromDateController.text = fromDate;
          toDateController.text = toDate;
        } else {
          // Handle case where experience is not found
          print('Experience not found!');
        }
      } catch (e) {
        // Handle any errors that occur while fetching experience
        print('Error fetching experience: $e');
      }
    }

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFFF9F9F9),
        surfaceTintColor: Color(0xFFF9F9F9),
        title: Text(
          "$status Organization",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.text_1,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Organization",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    color: AppColors.text_1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 14,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Organization Name",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: AppColors.text_2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "*",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: AppColors.danger,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: nameController,
                      cursorColor: AppColors.primary,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.text_1,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.text_1,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        errorStyle: GoogleFonts.plusJakartaSans(
                          color: AppColors.danger,
                          fontSize: 11,
                        ),
                        hintStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.text_4,
                        ),
                        hintText: "Organization Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "The 'Organization Name' field is required";
                        }

                        if (value.length > 64) {
                          return "The maximum character of 'Organization Name' is 64 characters";
                        }

                        return null;
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Level",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: AppColors.text_2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "*",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: AppColors.danger,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: levelController,
                      cursorColor: AppColors.primary,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.text_1,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.text_1,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        errorStyle: GoogleFonts.plusJakartaSans(
                          color: AppColors.danger,
                          fontSize: 11,
                        ),
                        hintStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.text_4,
                        ),
                        hintText: "Level",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "The 'Level' field is required";
                        }

                        if (value.length > 64) {
                          return "The maximum character of 'Level' is 64 characters";
                        }

                        return null;
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "From",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: AppColors.text_2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "*",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: AppColors.danger,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            controller: fromDateController,
                            readOnly: true,
                            cursorColor: AppColors.primary,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: AppColors.text_1,
                            ),
                            decoration: InputDecoration(
                              hintText: "Select date",
                              hintStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: AppColors.text_4,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 2,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: AppColors.text_1,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              errorStyle: GoogleFonts.plusJakartaSans(
                                color: AppColors.danger,
                                fontSize: 11,
                              ),
                            ),
                            onTap: () =>
                                _selectDate(context, fromDateController),
                            validator: (value) {
                              if (fromDateController.text.isEmpty) {
                                return "The ‘From’ field is required";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "To",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: AppColors.text_2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "*",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: AppColors.danger,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Obx(
                            () {
                              var isToDateDisabled = isStillActive.value;
                              return TextFormField(
                                controller: toDateController,
                                readOnly: true,
                                cursorColor: AppColors.primary,
                                enabled: !isToDateDisabled,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: AppColors.text_1,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Select date",
                                  hintStyle: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    color: AppColors.text_4,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.primary,
                                      width: 2,
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: AppColors.text_1,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  errorStyle: GoogleFonts.plusJakartaSans(
                                    color: AppColors.danger,
                                    fontSize: 11,
                                  ),
                                  filled: true,
                                  fillColor: isToDateDisabled
                                      ? const Color.fromARGB(10, 0, 0, 0)
                                      : AppColors.white_1,
                                ),
                                onTap: isToDateDisabled
                                    ? null
                                    : () =>
                                        _selectDate(context, toDateController),
                                validator: (value) {
                                  if (!isToDateDisabled &&
                                      toDateController.text.isEmpty) {
                                    return "The ‘To’ field is required";
                                  }
                                  return null;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Container(
                  height: 30,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Obx(() => Checkbox(
                            side: BorderSide(
                              color: AppColors.text_1,
                              width: 1.5,
                            ),
                            activeColor: AppColors.primary,
                            value: isStillActive.value,
                            onChanged: (value) {
                              isStillActive.value = value!;
                              if (value) {
                                toDateController.clear();
                              }
                            },
                          )),
                      Text(
                        "I currently still active here",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.text_2,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Description",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: AppColors.text_2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: descriptionController,
                      cursorColor: AppColors.primary,
                      maxLines: 3,
                      minLines: 1,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.text_1,
                      ),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.text_1,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        errorStyle: GoogleFonts.plusJakartaSans(
                          color: AppColors.danger,
                          fontSize: 11,
                        ),
                        hintStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: AppColors.text_4,
                        ),
                        hintText: "Description",
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 14,
                ),
                SizedBox(
                  height: 51,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Save the form

                        accountController.organizationName.value = nameController.text;
                        accountController.organizationPosition.value = levelController.text;
                        accountController.organizationFromDate.value = fromDateController.text;
                        accountController.organizationToDate.value = toDateController.text;
                        accountController.isStillActive.value = isStillActive.value;
                        accountController.organizationDescription.value = descriptionController.text;

                        if (status == "add") {
                          accountController.addOrganization();
                        } else if (status == "edit") {
                          accountController.updateOrganization(id!);
                        }
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStatePropertyAll(AppColors.primary),
                      foregroundColor:
                          WidgetStatePropertyAll(AppColors.white_1),
                      overlayColor: WidgetStatePropertyAll(Colors.white30),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                    child: Text(
                      "Save",
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
