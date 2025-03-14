import 'package:cmlabs_connect/src/controllers/authentication/authentication_controller.dart';
import 'package:cmlabs_connect/src/controllers/user/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../utils/color.dart';

class ChangePasswordView extends StatelessWidget {
  ChangePasswordView({super.key});

  final UserController userController = Get.put(UserController());
  final AuthenticationController authenticationController = Get.put(AuthenticationController());

  final TextEditingController oldPassword = TextEditingController();
  var _obscureOld = true.obs;

  final TextEditingController newPassword = TextEditingController();
  var _obscureNew = true.obs;

  final TextEditingController confirmPassword = TextEditingController();
  var _obscureConfirm = true.obs;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFFF9F9F9),
        surfaceTintColor: Color(0xFFF9F9F9),
        title: Text(
          "Change Password",
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
                  "Edit Password",
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
                          "Old Password",
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
                        return TextFormField(
                          controller: oldPassword,
                          obscureText: _obscureOld.value,
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
                            hintText: "Old Password",
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureOld.value
                                    ? Ionicons.eye_off_outline
                                    : Ionicons.eye_outline, // Mengubah icon berdasarkan state
                              ),
                              onPressed: () {
                                _obscureOld.value = !_obscureOld.value;
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "The old password is required";
                            }
                            // print(userController.user.value!.password);
                            // if (value != userController.user.value!.password) {
                            //   return "The old password is invalid";
                            // }

                            return null;
                          },
                        );
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
                          "New Password",
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
                        return TextFormField(
                          controller: newPassword,
                          obscureText: _obscureNew.value,
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
                            errorMaxLines: 2,
                            errorStyle: GoogleFonts.plusJakartaSans(
                              color: AppColors.danger,
                              fontSize: 11,
                            ),
                            hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              color: AppColors.text_4,
                            ),
                            hintText: "New Password",
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureNew.value
                                    ? Ionicons.eye_off_outline
                                    : Ionicons.eye_outline, // Mengubah icon berdasarkan state
                              ),
                              onPressed: () {
                                _obscureNew.value = !_obscureNew.value;
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "The new password is required";
                            }

                            if (value.length < 8) {
                              return "The new password must contain at least 8 characters";
                            }

                            // Check for at least one uppercase letter, one lowercase letter, one number, and one special character
                            final regex = RegExp(
                              r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$',
                            );

                            if (!regex.hasMatch(value)) {
                              return "The new password must contain a mix of uppercase, lowercase, numbers, and symbols";
                            }

                            return null;
                          },
                        );
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
                          "Confirm Password",
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
                        return TextFormField(
                          controller: confirmPassword,
                          obscureText: _obscureConfirm.value,
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
                            hintText: "Confirm Password",
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirm.value
                                    ? Ionicons.eye_off_outline
                                    : Ionicons.eye_outline, // Mengubah icon berdasarkan state
                              ),
                              onPressed: () {
                                _obscureConfirm.value = !_obscureConfirm.value;
                              },
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "The confirm password is required";
                            }

                            if (value != newPassword.text) {
                              return "The confirm password doesn’t match with new password";
                            }

                            return null;
                          },
                        );
                      },
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
                        authenticationController.changePassword(
                            oldPassword.text, newPassword.text, confirmPassword.text);
                      }
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
                    child: Text(
                      "Save",
                      style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.bold),
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
