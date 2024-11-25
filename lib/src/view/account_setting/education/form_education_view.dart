import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../controllers/account_controller.dart';
import '../../../routes.dart';
import '../../../utils/color.dart';
import '../select_field.dart';

class FormEducationView extends StatelessWidget {
  FormEducationView({super.key, required this.status, this.id});

  final String status;

  final int? id;

  final AccountController accountController = Get.put(AccountController());

  final TextEditingController instituteController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController majorController = TextEditingController();

  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  var isCurrentlyStudyHere = false.obs;

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
        var education = accountController.educationList.value.firstWhere(
          (exp) => exp!.id == id, // Search for the experience where id matches
          orElse: () => null, // If no match is found, return null
        );

        isCurrentlyStudyHere.value = education?.finishTime == null;

        if (education != null) {
          // Update the controllers with the experience data
          var formDate =
              "${education.startTime.year}-${education.startTime.month}-${education.startTime.day}";
          var toDate = education.finishTime == null
              ? ""
              : "${education.finishTime!.year}-${education.finishTime!.month.toString().padLeft(2, '0')}-${education.finishTime!.day.toString().padLeft(2, '0')}";

          instituteController.text = education.name;
          departmentController.text = education.department;
          majorController.text = education.major;
          descriptionController.text = education.description;
          fromDateController.text = formDate;
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
          "$status Education",
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
                  "Education",
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
                          "Institute Name",
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
                      controller: instituteController,
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
                        hintText: "Institute Name",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "The 'Institute Name' field is required";
                        }

                        if (value.length > 64) {
                          return "The maximum character of 'Institute Name' is 64 characters";
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
                          "Department",
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
                      controller: departmentController,
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
                        hintText: "Department",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "The 'Department' field is required";
                        }

                        if (value.length > 64) {
                          return "The maximum character of 'Department' is 64 characters";
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
                          "Major",
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
                      controller: majorController,
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
                        hintText: "Major",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "The 'Major' field is required";
                        }

                        if (value.length > 64) {
                          return "The maximum character of 'Major' is 64 characters";
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
                      name: "Degree",
                      child: (accountController.educationDegree.value != null)
                          ? Text(
                              accountController.educationDegree.value!,
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
                          AppRoutes.selectDataEducation,
                          arguments: "degree",
                        )?.then(
                          (value) {
                            accountController.educationDegree.value =
                                value['name'];
                            print(accountController.educationDegree.value);
                            accountController.educationDegree.refresh();
                          },
                        );
                      },
                      isMandatory: true,
                      validator: (value) {
                        if (accountController.educationDegree.value == null) {
                          return "The 'Degree' field is required";
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
                              var isToDateDisabled = isCurrentlyStudyHere.value;
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
                            value: isCurrentlyStudyHere.value,
                            onChanged: (value) {
                              isCurrentlyStudyHere.value = value!;
                              if (value) {
                                toDateController.clear();
                              }
                            },
                          )),
                      Text(
                        "I currently study here",
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
                        accountController.educationInstitute.value =
                            instituteController.text;
                        accountController.educationDepartment.value =
                            departmentController.text;
                        accountController.educationMajor.value =
                            majorController.text;
                        accountController.educationFromDate.value =
                            fromDateController.text;
                        accountController.educationToDate.value =
                            toDateController.text;
                        accountController.isStillStudy.value =
                            isCurrentlyStudyHere.value;
                        accountController.educationDescription.value =
                            descriptionController.text;

                        if (status == "add") {
                          accountController.addEducation();
                        } else if (status == "edit") {
                          accountController.updateEducation(id!);
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
                ),
                SizedBox(
                  height: 150,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
