import 'package:cmlabs_connect/src/controllers/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../../utils/color.dart';

class FormPublicationView extends StatelessWidget {
  FormPublicationView({super.key, required this.status, this.id});

  final String status;
  final int? id;

  final AccountController accountController = Get.put(AccountController());

  final TextEditingController titleController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

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
        var publication = accountController.publicationList.value.firstWhere(
          (exp) => exp!.id == id, // Search for the experience where id matches
          orElse: () => null, // If no match is found, return null
        );

        if (publication != null) {
          // Update the controllers with the experience data
          var date = publication.year != null ?
              "${publication.year!.year}-${publication.year!.month}-${publication.year!.day}" : "";

          titleController.text = publication.title;
          urlController.text = publication.url;
          dateController.text = date;
          descriptionController.text = publication.description ?? "";
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
          "$status Publication",
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
                  "Publication",
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
                          "Publication Title",
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
                      controller: titleController,
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
                        hintText: "Publication Title",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "The 'Publication Title' field is required";
                        }

                        if (value.length > 64) {
                          return "The maximum character of 'Publication Title' is 64 characters";
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
                          "Publication Link",
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
                      controller: urlController,
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
                        hintText: "Publication Link",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "The 'Publication Link' field is required";
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
                          "Date",
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
                      controller: dateController,
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
                          suffixIcon: Icon(
                            Ionicons.calendar_outline,
                            color: AppColors.text_1,
                          )),
                      onTap: () => _selectDate(context, dateController),
                      validator: (value) {
                        if (dateController.text.isEmpty) {
                          return "The ‘Date’ field is required";
                        }
                        return null;
                      },
                    ),
                  ],
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
                        accountController.publicationTitle.value = titleController.text;
                        accountController.publicationUrl.value = urlController.text;
                        accountController.publicationYear.value = dateController.text;
                        accountController.publicationDescription.value = descriptionController.text;

                        if (status == "add") {
                          accountController.addPublication();
                        } else if (status == "edit") {
                          accountController.updatePublication(id!);
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
