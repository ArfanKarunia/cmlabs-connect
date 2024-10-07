import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:quotation_app/src/app.dart';
import 'package:quotation_app/src/utils/color.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isCheckedRememberme = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool changeStatusCheckedRememberMe() {
    return isCheckedRememberme = !isCheckedRememberme;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Jika form valid, lakukan aksi seperti login
      print('Form is valid');
    } else {
      // Jika form tidak valid, tampilkan pesan error
      print('Form is not valid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
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
                color: const Color.fromARGB(10, 255, 255, 255),
              ),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color.fromARGB(10, 255, 255, 255),
                ),
              ),
            ),
          ),
          Container(
            // color: Colors.red,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/logos/logo_light.png"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 45,
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 13),
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
                        ),
                        SizedBox(
                          height: 22,
                        ),
                        FormInputWidget(
                          controller: passwordController,
                          title: "Password",
                          isPassword: true,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Checkbox(
                              splashRadius: 0,
                              activeColor: AppColors.primary,
                              side:
                                  BorderSide(width: 1, color: AppColors.text_2),
                              value: isCheckedRememberme,
                              onChanged: (value) {
                                setState(() {
                                  isCheckedRememberme = value!;
                                });
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
                        ElevatedButton(
                          onPressed: () {
                            _submitForm();
                          },
                          style: ButtonStyle(
                            fixedSize: WidgetStatePropertyAll(
                              Size(234, 40),
                            ),
                            shape: WidgetStatePropertyAll(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
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
    );
  }
}

class FormInputWidget extends StatefulWidget {
  const FormInputWidget({
    super.key,
    required this.controller,
    required this.title,
    required this.isPassword,
  });

  final TextEditingController controller;
  final String title;
  final bool isPassword;

  @override
  State<FormInputWidget> createState() => _FormInputWidgetState();
}

class _FormInputWidgetState extends State<FormInputWidget> {
  bool _obscureText = true;

  String? _validateEmail(String? value) {
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
    if (value == null || value.isEmpty) {
      return 'The email must not be empty';
    }

    return null; // Return null jika tidak ada error
  }

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

                errorStyle: GoogleFonts.plusJakartaSans(color: AppColors.danger, fontSize: 12, fontWeight: FontWeight.w400),

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
              validator: (value) {
                return widget.isPassword
                    ? _validatePassword(value)
                    : _validateEmail(value);
              })
        ],
      ),
    );
  }
}
