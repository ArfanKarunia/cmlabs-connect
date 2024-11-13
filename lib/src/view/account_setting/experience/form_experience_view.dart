import 'package:cmlabs_connect/src/controllers/account_controller.dart';
import 'package:cmlabs_connect/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/color.dart';
import '../select_field.dart';

class FormExperienceView extends StatelessWidget {
  FormExperienceView({super.key, required this.status, this.id});

  final String status;

  final int? id;

  final AccountController accountController = Get.put(AccountController());

  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();

  var isCurrentlyWorkHere = false.obs;

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
    accountController.fetchProjectList();

    if (status == 'edit') {
      try {
        var experience = accountController.experienceList.value.firstWhere(
          (exp) => exp!.id == id, // Search for the experience where id matches
          orElse: () => null, // If no match is found, return null
        );

        isCurrentlyWorkHere.value = experience?.finishTime == null;

        if (experience != null) {
          // Update the controllers with the experience data
          var formDate =
              "${experience.startTime.year}-${experience.startTime.month}-${experience.startTime.day}";
          var toDate = experience.finishTime == null
              ? ""
              : "${experience.finishTime!.year}-${experience.finishTime!.month.toString().padLeft(2, '0')}-${experience.finishTime!.day.toString().padLeft(2, '0')}";

          jobTitleController.text = experience.position;
          descriptionController.text = experience.description;
          fromDateController.text = formDate;
          toDateController.text = toDate;

          accountController.experienceProject.value = experience.company;
          accountController.experienceLevel.value = experience.type;
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
          "$status Experience",
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
                  "Experience",
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
                          "Job Title",
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
                      controller: jobTitleController,
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
                        hintText: "Job Title",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "The 'Job Title' field is required";
                        }

                        if (value.length > 30) {
                          return "The maximum character of 'Job Title' is 30 characters";
                        }

                        return null;
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Obx(
                  () {
                    return SelectField(
                      name: "Project",
                      child: (accountController.experienceProject.value != null)
                          ? Text(
                              accountController.experienceProject.value!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: AppColors.text_1,
                              ),
                            )
                          : Text(
                              "Select Project",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: AppColors.text_4,
                              ),
                            ),
                      onPressed: () {
                        Get.toNamed(
                          AppRoutes.selectDataExperience,
                          arguments: "Project",
                        )?.then(
                          (value) {
                            accountController.experienceProject.value =
                                value['name'];
                            print(accountController.experienceProject.value);
                            accountController.experienceProject.refresh();
                          },
                        );
                      },
                      isMandatory: true,
                      validator: (value) {
                        if (accountController.experienceProject.value == null) {
                          return "The 'Project' field is required";
                        }
                        return null;
                      },
                    );
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                Obx(
                  () {
                    return SelectField(
                      name: "Level",
                      child: (accountController.experienceLevel.value != null)
                          ? Text(
                              accountController.experienceLevel.value!,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: AppColors.text_1,
                              ),
                            )
                          : Text(
                              "-",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: AppColors.text_4,
                              ),
                            ),
                      onPressed: () {
                        Get.toNamed(
                          AppRoutes.selectDataExperience,
                          arguments: "level",
                        )?.then(
                          (value) {
                            accountController.experienceLevel.value =
                                value['name'];
                            print(accountController.experienceLevel.value);
                            accountController.experienceLevel.refresh();
                          },
                        );
                      },
                      isMandatory: true,
                      validator: (value) {
                        if (accountController.experienceLevel.value == null) {
                          return "The 'Level' field is required";
                        }
                        return null;
                      },
                    );
                  },
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
                              var isToDateDisabled = isCurrentlyWorkHere.value;
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
                            value: isCurrentlyWorkHere.value,
                            onChanged: (value) {
                              isCurrentlyWorkHere.value = value!;
                              if (value) {
                                toDateController.clear();
                              }
                            },
                          )),
                      Text(
                        "I currently work here",
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
                        accountController.experienceJobTitle.value =
                            jobTitleController.text;
                        accountController.experienceDescription.value =
                            descriptionController.text;
                        accountController.experienceFromDate.value =
                            fromDateController.text;
                        accountController.experienceToDate.value =
                            toDateController.text;
                        accountController.experienceIsCurrentlyWorkHere.value =
                            isCurrentlyWorkHere.value;

                        if (status == "add") {
                          accountController.addExperience();
                        } else if (status == "edit") {
                          accountController.updateExperience(id!);
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
