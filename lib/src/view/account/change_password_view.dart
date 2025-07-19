import 'package:cmlabs_connect/src/controllers/authentication/authentication_controller.dart';
import 'package:cmlabs_connect/src/controllers/user/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/fontstyle.dart';
import '../../utils/color.dart';
import '../../widgets/custom_formfield.dart';
import '../../widgets/custom_submit_button.dart';
import '../../widgets/default_appbar.dart';
import '../../widgets/inbox/inbox_add_field.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final AuthenticationController authenticationController = Get.find<AuthenticationController>();
  final UserController userController = Get.find<UserController>();

  final TextEditingController oldPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  String? oldPasswordError;
  String? newPasswordError;
  String? confirmPasswordError;

  bool validateForm() {
    oldPasswordError = oldPassword.text.isEmpty ? "The old password is required" : null;
    newPasswordError = newPassword.text.isEmpty
        ? "The new password is required"
        : newPassword.text.length < 8
            ? "The new password must contain at least 8 characters"
            : RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~]).{8,}$').hasMatch(newPassword.text)
                ? "The new password must contain a mix of uppercase, lowercase, numbers, and symbols"
                : null;
    confirmPasswordError = confirmPassword.text.isEmpty
        ? "The confirm password is required"
        : confirmPassword.text != newPassword.text
            ? "The confirm password doesn't match with new password"
            : null;
    setState(() {});

    return oldPasswordError == null && newPasswordError == null && confirmPasswordError == null;
  }

  @override
  void dispose() {
    oldPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar("Edit Password", titleSpacing: 0),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Text(
            "Edit Password",
            style: bold.copyWith(fontSize: 16, color: AppColors.text_1),
          ),
          const SizedBox(height: 14),
          InboxAddField(
            title: "Old Password",
            isRequired: true,
            child: CustomFormField(
              controller: oldPassword,
              errorText: oldPasswordError,
              hintText: "Old Password",
              isPassword: true,
            ),
          ),
          const SizedBox(height: 12),
          InboxAddField(
            title: "New Password",
            isRequired: true,
            child: CustomFormField(
              controller: newPassword,
              errorText: newPasswordError,
              hintText: "New Password",
              isPassword: true,
            ),
          ),
          const SizedBox(height: 12),
          InboxAddField(
            title: "Confirm Password",
            isRequired: true,
            child: CustomFormField(
              controller: confirmPassword,
              errorText: confirmPasswordError,
              hintText: "Confirm Password",
              isPassword: true,
            ),
          ),
          const SizedBox(height: 14),
          Obx(
            () => authenticationController.isLoading.value
                ? const CustomLoadingButton()
                : CustomSubmitButton(
                    title: "Save",
                    onTap: () {
                      if (validateForm()) {
                        authenticationController.changePassword(
                          oldPassword.text,
                          newPassword.text,
                          confirmPassword.text,
                        );
                      }
                    },
                  ),
          ),
          const SizedBox(height: 200),
        ],
      ),
    );
  }
}
