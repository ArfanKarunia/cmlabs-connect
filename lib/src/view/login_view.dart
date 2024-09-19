import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quotation_app/src/utils/color.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xff50AAF3),
            Color(0xff1F95F5),
          ], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white),
                ),

                SizedBox(
                  height: 10,
                ),

                // Description
                Text(
                  "Log in first, so you don't get the wrong server",
                  style: TextStyle(fontSize: 14, color: AppColors.white),
                ),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text Input Email
                Text(
                  "Email",
                  style: TextStyle(fontSize: 14, color: AppColors.white),
                ),
                SizedBox(
                  height: 5,
                ),

                // TextFormField
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      hintText: "Your email",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: AppColors.secondaryText,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: 22,
                ),

                // Text Input Password
                Text(
                  "Password",
                  style: TextStyle(fontSize: 14, color: AppColors.white),
                ),
                SizedBox(
                  height: 5,
                ),

                // TextFormField
                Container(
                  // padding: EdgeInsets.symmetric(
                  //   horizontal: 10,
                  // ),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  child: TextFormField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      hintText: "Your password",
                      hintStyle: TextStyle(
                        fontSize: 14,
                        color: Color(0xff9C9C9C),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Button Submit
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 38, vertical: 10),
              child: ElevatedButton(
                onPressed: () => Get.toNamed('/'),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.white),
                  overlayColor: WidgetStatePropertyAll(AppColors.lightBlue),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                child: Text(
                  "Submit",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),

            // logo CMLABS
            Container(
              width: double.infinity,
              height: 30,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image:
                        AssetImage('assets/images/logos/logo_name_cmlabs.png'),
                    fit: BoxFit.contain),
              ),
            )
          ],
        ),
      ),
    );
  }
}
