import 'package:cmlabs_connect/src/controllers/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/color.dart';

class FormSummaryView extends StatelessWidget {
  FormSummaryView({super.key, required this.status});

  final String status;

  final AccountController accountController = Get.put(AccountController());

  final TextEditingController aboutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print("form: ${status}");

    if (status == "add") {
      accountController.isChecked.value = List<bool>.filled(
          accountController.specializationList.value.length, false);
    }

    if (status == "edit") {
      aboutController.text = accountController.about.value ?? '';
      for (var i = 0; i < accountController.specialization.value.length; i++) {
        var specializationName = accountController.specialization.value[i];

        // Match the specialization with the specializationList
        for (var j = 0;
            j < accountController.specializationList.value.length;
            j++) {
          if (specializationName ==
              accountController.specializationList.value[j]['name']) {
            accountController.isChecked[j] = true; // Mark as checked if matched
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFFF9F9F9),
        surfaceTintColor: Color(0xFFF9F9F9),
        title: Text(
          "$status Summary",
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
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                    color: AppColors.white_1,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(30, 0, 0, 0),
                        offset: Offset(3, 3),
                        blurRadius: 5,
                      ),
                    ]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "About",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text_2,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: aboutController,
                      cursorColor: AppColors.primary,
                      maxLines: null,
                      minLines: 1,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.text_1,
                      ),
                      decoration: InputDecoration(
                        focusColor: AppColors.primary,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: AppColors.primary, width: 2),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide:
                              BorderSide(color: AppColors.primary, width: 1),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      "Spesialization",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text_2,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount:
                          accountController.specializationList.value.length,
                      itemBuilder: (context, index) {
                        // Bungkus hanya Checkbox dengan Obx
                        return Container(
                          height: 35,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Obx(
                                () => Checkbox(
                                  side: BorderSide(
                                    color: AppColors.text_1,
                                    width: 1.5,
                                  ),
                                  activeColor: AppColors.primary,
                                  value: accountController.isChecked[index],
                                  onChanged: (value) {
                                    accountController.isChecked[index] = value!;
                                    var specialization = accountController
                                        .specializationList
                                        .value[index]['name'];
                                    if (accountController.specialization.value
                                        .contains(specialization)) {
                                      accountController.specialization.value
                                          .remove(specialization);
                                    } else {
                                      accountController.specialization.value
                                          .add(specialization);
                                    }
                                  },
                                ),
                              ),
                              Text(
                                accountController
                                    .specializationList.value[index]['name'],
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14,
                                  color: AppColors.text_1,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 51,
                child: ElevatedButton(
                  onPressed: () {
                    accountController.about.value = aboutController.text;
                    accountController.addSumary();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.primary),
                    foregroundColor: WidgetStatePropertyAll(AppColors.white_1),
                    overlayColor: WidgetStatePropertyAll(Colors.white30),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Save",
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> _showBackDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text(
            'Are you sure you want to leave this page?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Never mind'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Leave'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }
}
