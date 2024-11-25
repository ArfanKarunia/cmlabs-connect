import 'package:cmlabs_connect/src/controllers/account_controller.dart';
import 'package:cmlabs_connect/src/controllers/authentication_controller.dart';
import 'package:cmlabs_connect/src/controllers/user_controller.dart';
import 'package:cmlabs_connect/src/routes.dart';
import 'package:cmlabs_connect/src/utils/bottom_sheet.dart';
import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:cmlabs_connect/src/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../models/user_model.dart';

class AccountView extends StatelessWidget {
  AccountView({super.key});

  final UserController userController = Get.put(
    UserController(),
  );

  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());

  final AccountController accountController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    accountController.fetchProfile();

    User? user = userController.user.value;
    user!.picUrl;

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Color(0xFFF9F9F9),
        toolbarHeight: 100,
        surfaceTintColor: Color(0xFFF9F9F9),
        title: Text(
          "Account Setting",
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.text_1,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.white,
                              image: DecorationImage(
                                image: (user.picUrl != null &&
                                        user.picUrl!.isNotEmpty)
                                    ? NetworkImage(user.picUrl!)
                                    : const AssetImage(
                                        "assets/icons/cmlabs_icon.png",
                                      ) as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 24,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.text_1,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                userController.user.value?.roleName ?? 'User',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.text_3,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Text(
                                user.email,
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.primary,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        child: CustomButton(
                          onPressed: () {},
                          borderRadius: BorderRadius.circular(10),
                          backgroundColor: Colors.transparent,
                          overlayColor: Colors.black12,
                          child: Icon(
                            Icons.notifications_outlined,
                            color: AppColors.text_1,
                            size: 29,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 51,
                width: double.infinity,
                child: ElevatedButton(
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
                  onPressed: () {
                    Get.toNamed(AppRoutes.editProfileView);
                  },
                  child: Text(
                    "Edit Profile",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                splashColor: Colors.black12,
                tileColor: AppColors.white_1,
                onTap: () {
                  Get.toNamed(AppRoutes.summaryView);
                },
                leading: Image(
                  image: AssetImage("assets/icons/icons_interface.png"),
                ),
                title: Text(
                  "Summary",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(Ionicons.chevron_forward_outline),
              ),
              ListTile(
                splashColor: Colors.black12,
                tileColor: AppColors.white_1,
                onTap: () {
                  Get.toNamed(AppRoutes.experienceView);
                },
                leading: Image(
                  image: AssetImage("assets/icons/icons_misc.png"),
                ),
                title: Text(
                  "Experiences",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(Ionicons.chevron_forward_outline),
              ),
              ListTile(
                splashColor: Colors.black12,
                tileColor: AppColors.white_1,
                onTap: () {
                  Get.toNamed(AppRoutes.educationView);
                },
                leading: Image(
                  image: AssetImage("assets/icons/icons_writing.png"),
                ),
                title: Text(
                  "Education",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(Ionicons.chevron_forward_outline),
              ),
              ListTile(
                splashColor: Colors.black12,
                tileColor: AppColors.white_1,
                onTap: () {
                  Get.toNamed(AppRoutes.organizationView);
                },
                leading: Image(
                  image: AssetImage("assets/icons/icons_structure.png"),
                ),
                title: Text(
                  "Organization",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(Ionicons.chevron_forward_outline),
              ),
              ListTile(
                splashColor: Colors.black12,
                tileColor: AppColors.white_1,
                onTap: () {
                  Get.toNamed(AppRoutes.volunteerView);
                },
                leading: Image(
                  image: AssetImage("assets/icons/icons_bag.png"),
                ),
                title: Text(
                  "Volunteer",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(Ionicons.chevron_forward_outline),
              ),
              ListTile(
                splashColor: Colors.black12,
                tileColor: AppColors.white_1,
                onTap: () {
                  Get.toNamed(AppRoutes.certificationView);
                },
                leading: Image(
                  image: AssetImage("assets/icons/icons_book.png"),
                ),
                title: Text(
                  "Certification",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(Ionicons.chevron_forward_outline),
              ),
              ListTile(
                splashColor: Colors.black12,
                tileColor: AppColors.white_1,
                onTap: () {
                  Get.toNamed(AppRoutes.achievementView);
                },
                leading: Image(
                  image: AssetImage("assets/icons/icons_file.png"),
                ),
                title: Text(
                  "Achievement",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(Ionicons.chevron_forward_outline),
              ),
              ListTile(
                splashColor: Colors.black12,
                tileColor: AppColors.white_1,
                onTap: () {
                  Get.toNamed(AppRoutes.publicationView);
                },
                leading: Image(
                  image: AssetImage("assets/icons/icons_download.png"),
                ),
                title: Text(
                  "Publication",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Icon(Ionicons.chevron_forward_outline),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 51,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.changePasswordView);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Color(0xFFF9F9F9)),
                    foregroundColor: WidgetStatePropertyAll(AppColors.primary),
                    overlayColor: WidgetStatePropertyAll(AppColors.bgPrimary),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  child: Text(
                    "Change Password",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 51,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    SignOutBottomSheet(
                      context,
                      () {
                        authenticationController.logout();
                      },
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.bgDanger),
                    foregroundColor: WidgetStatePropertyAll(AppColors.danger),
                    overlayColor: WidgetStatePropertyAll(Colors.white30),
                    shadowColor: WidgetStatePropertyAll(Colors.transparent),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Ionicons.log_out_outline,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Sign Out",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
