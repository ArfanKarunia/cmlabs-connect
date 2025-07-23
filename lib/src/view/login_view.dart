import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/fontstyle.dart';
import '../controllers/authentication/authentication_controller.dart';
import '../routes.dart';
import '../utils/color.dart';
import '../widgets/custom_formfield.dart';
import '../widgets/custom_submit_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthenticationController authController = Get.find<AuthenticationController>();

  bool isFormValid = false;
  TextEditingController emailController = TextEditingController();
  String? emailError;
  TextEditingController passwordController = TextEditingController();
  String? passwordError;
  bool isCheckedRememberme = false;

  void _validateForm() {
    if (emailController.text.isEmpty) {
      emailError = 'The email must not be empty';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text)) {
      emailError = 'The email must be a valid email address';
    } else {
      emailError = null;
    }

    if (passwordController.text.isEmpty) {
      passwordError = 'The password must not be empty';
    } else {
      passwordError = null;
    }

    // Update form validity
    setState(() => isFormValid = emailError == null && passwordError == null);
  }

  void _submitForm() async {
    try {
      Map<String, String>? response = await authController.login(
        emailController.text,
        passwordController.text,
      );

      final code = response['code'];
      final status = response['status'];
      final message = response['message'];

      if (status == "Success") {
        Get.snackbar(
          'Login Successful',
          message ?? 'Selamat Datang!',
          snackPosition: SnackPosition.TOP,
          duration: const Duration(seconds: 4),
        );

        Get.offAndToNamed(AppRoutes.home);
      }

      if (status == "Error") {
        setState(() {
          if (code == "404") {
            emailError = message;
          } else if (code == "401") {
            passwordError = message;
          } else {
            emailError = message;
            passwordError = message;
          }
          isFormValid = false;
        });
      }
    } catch (e) {
      // Tampilkan snackbar untuk kegagalan login
      Get.snackbar(
        'Login Failed',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 4),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    authController.loadRememberedUser();
    emailController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
  }

  @override
  void dispose() {
    emailController.removeListener(_validateForm);
    passwordController.removeListener(_validateForm);
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor,
      body: SafeArea(
        child: Stack(
          children: [
            // Decoration behind
            Positioned(
              top: -80,
              left: -50,
              child: Container(
                padding: const EdgeInsets.all(55),
                width: 350,
                height: 350,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFECEFF2),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFE9EEF3),
                  ),
                ),
              ),
            ),

            // Login Page
            ListView(
              children: [
                SizedBox(height: deviceHeight / 15),
                Container(
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logos/logo_primary.png',
                        scale: 2,
                      ),

                      const SizedBox(height: 45),

                      // Login Form
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                        decoration: BoxDecoration(color: AppColors.white_2, borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Text(
                              "Login",
                              style: bold.copyWith(fontSize: 24, color: AppColors.text_1),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Log in first, so you don't get the wrong server",
                              textAlign: TextAlign.center,
                              style: regular.copyWith(fontSize: 13, color: AppColors.text_3),
                            ),
                            const SizedBox(height: 26),

                            // Email
                            FormInputWidget(
                              controller: emailController,
                              title: "Email",
                              errorText: emailError,
                            ),

                            const SizedBox(height: 22),

                            // Password
                            FormInputWidget(
                              controller: passwordController,
                              title: "Password",
                              isPassword: true,
                              errorText: passwordError,
                            ),

                            const SizedBox(height: 22),

                            // Remember me
                            Row(
                              children: [
                                Obx(
                                  () => SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: Checkbox(
                                      splashRadius: 0,
                                      activeColor: AppColors.primary,
                                      side: const BorderSide(width: 1, color: AppColors.text_2),
                                      value: authController.isRememberMe.value,
                                      onChanged: (value) => authController.toggleRememberMe(value!),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  "Remember me",
                                  style: regular.copyWith(fontSize: 13, color: AppColors.text_2),
                                ),
                              ],
                            ),

                            const SizedBox(height: 26),

                            // Login Button
                            Obx(
                              () => authController.isLoading.value
                                  ? const CustomLoadingButton()
                                  : CustomSubmitButton(
                                      title: 'Login',
                                      isDisabled: !isFormValid,
                                      onTap: () => _submitForm(),
                                    ),
                            ),

                            const SizedBox(height: 8),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
