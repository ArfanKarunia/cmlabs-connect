import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/authentication/authentication_controller.dart';
import '../utils/color.dart';
import '../widgets/custom_submit_button.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  final AuthenticationController controller = Get.find<AuthenticationController>();

  @override
  void initState() {
    super.initState();
    controller.loadRememberedUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/images/logos/cmlabs_splash.png',
              scale: 2,
            ),
          ),
          const CustomLoading(color: AppColors.white),
        ],
      ),
    );
  }
}
