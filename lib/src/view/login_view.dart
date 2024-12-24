import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../controllers/authentication_controller.dart';
import '../utils/color.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AuthenticationController authController =
      Get.put(AuthenticationController());

  bool isCheckedRememberme = false;

  // Variabel untuk menyimpan error dari API
  String? _messageError;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool changeStatusCheckedRememberMe() {
    return isCheckedRememberme = !isCheckedRememberme;
  }

  void _submitForm() async {
    _messageError = null;

    if (_formKey.currentState!.validate()) {
      print('Form is valid');
      // Jika form valid, lakukan aksi seperti login
      try {
        Map<String, String>? response = await authController.login(
          emailController.text,
          passwordController.text,
        );

        if (response != null) {
          final status = response['status'];
          final message = response['message'];

          if (status == "Success") {
            setState(() {
              _messageError = null;
            });

            Get.snackbar(
              'Login Successful',
              message!,
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 4),
            );

            Get.toNamed('/home');
          }

          if (status == "Error") {
            setState(() {
              _messageError = message;
            });

            _formKey.currentState!.validate();
            Get.snackbar(
              'Login Failed',
              _messageError!,
              snackPosition: SnackPosition.TOP,
              duration: Duration(seconds: 4),
            );
          }
        }
      } catch (e) {
        // Tampilkan snackbar untuk kegagalan login
        Get.snackbar(
          'Login Failed',
          e.toString(),
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 4),
        );

        print('Login failed: ${e.toString()}');
      }
    } else {
      // Jika form tidak valid, tampilkan pesan error
      Get.snackbar(
        'Login Failed',
        "Form is not valid",
        snackPosition: SnackPosition.TOP,
        duration: Duration(seconds: 4),
      );
    }
  }

  String? _validateEmail(String? value) {
    if (_messageError != null) {
      return _messageError;
    }

    if (value == null || value.isEmpty) {
      return 'The email must not be empty';
    }
    // RegExp untuk validasi email
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'The email must be a valid email address';
    }
    return null; // Return null jika tidak ada error
  }

  String? _validatePassword(String? value) {
    if (_messageError != null) {
      return _messageError;
    }

    if (value == null || value.isEmpty) {
      return 'The password must not be empty';
    }

    return null; // Return null jika tidak ada error
  }

  @override
  void initState() {
    super.initState();

    // clientSourceController.fetchClientSourceData();
    // Tambahkan listener ke controller
    emailController.addListener(() {
      if (_messageError != null) {
        _formKey.currentState?.reset(); // Reset form key jika ada error
        setState(() {
          _messageError = null; // Hapus pesan error
        });
      }
    });

    passwordController.addListener(() {
      if (_messageError != null) {
        _formKey.currentState?.reset(); // Reset form key jika ada error
        setState(() {
          _messageError = null; // Hapus pesan error
        });
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF1F1F1),
      body: Stack(
        children: [
          Positioned(
            top: -80,
            left: -50,
            child: Container(
              padding: EdgeInsets.all(55),
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFECEFF2),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE9EEF3),
                ),
              ),
            ),
          ),
          ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 150),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/images/logos/logo_primary.png"),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 45,
                    ),
                    Form(
                      key: _formKey,
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 18, vertical: 13),
                        width: 328,
                        decoration: BoxDecoration(
                            color: AppColors.white_2,
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(
                          children: [
                            Text(
                              "Login",
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.text_1,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Log in first, so you don't get the wrong server",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.text_3,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(
                              height: 26,
                            ),
                            FormInputWidget(
                              controller: emailController,
                              title: "Email",
                              isPassword: false,
                              validator: (value) {
                                return _validateEmail(value);
                              },
                            ),
                            SizedBox(
                              height: 22,
                            ),
                            FormInputWidget(
                              controller: passwordController,
                              title: "Password",
                              isPassword: true,
                              validator: (value) {
                                return _validatePassword(value);
                              },
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              children: [
                                Obx(
                                  () {
                                    return Checkbox(
                                      splashRadius: 0,
                                      activeColor: AppColors.primary,
                                      side: BorderSide(
                                          width: 1, color: AppColors.text_2),
                                      value: authController.isRememberMe.value,
                                      onChanged: (value) {
                                        authController.toggleRememberMe(value!);
                                      },
                                    );
                                  },
                                ),
                                Text(
                                  "Remember me",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.text_2,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 26,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 51,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // Panggil metode untuk submit form jika validasi berhasil
                                    authController.isLoading.value
                                        ? null
                                        : _submitForm();

                                    // Navigasi ke halaman /home
                                  }
                                },
                                style: ButtonStyle(
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  backgroundColor:
                                      WidgetStatePropertyAll(AppColors.primary),
                                  foregroundColor:
                                      WidgetStatePropertyAll(AppColors.white),
                                  overlayColor:
                                      WidgetStatePropertyAll(Colors.white12),
                                ),
                                child: Text(
                                  "Login",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Obx(
            () { 
              print(authController.isLoading.value);
              if (authController.isLoading.value) {
                return Container(
                  decoration: BoxDecoration(color: Colors.black38),
                  child: Center(
                      child: LoadingAnimationWidget.progressiveDots(
                          color: AppColors.white_1, size: 50)),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}

class FormInputWidget extends StatefulWidget {
  const FormInputWidget({
    super.key,
    required this.controller,
    required this.title,
    required this.isPassword,
    this.validator,
  });

  final TextEditingController controller;
  final String title;
  final bool isPassword;
  final String? Function(String?)? validator;

  @override
  State<FormInputWidget> createState() => _FormInputWidgetState();
}

class _FormInputWidgetState extends State<FormInputWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            textAlign: TextAlign.left,
            style: GoogleFonts.plusJakartaSans(
              color: AppColors.text_2,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: widget.controller,
            keyboardType: widget.isPassword
                ? TextInputType.text
                : TextInputType.emailAddress,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: AppColors.text_1,
              fontWeight: FontWeight.w400,
            ),
            obscureText: widget.isPassword ? _obscureText : false,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 2,
                  color: AppColors.primary,
                ),
              ),
              hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.text_4),
              hintText: "Enter your ${widget.title.toLowerCase()}",
              errorStyle: GoogleFonts.plusJakartaSans(
                  color: AppColors.danger,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
              suffixIcon: (widget.isPassword)
                  ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? Ionicons.eye_off_outline
                            : Ionicons
                                .eye_outline, // Mengubah icon berdasarkan state
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText =
                              !_obscureText; // Toggle status obscureText
                        });
                      },
                    )
                  : null,
            ),
            validator: widget.validator,
          ),
        ],
      ),
    );
  }
}
