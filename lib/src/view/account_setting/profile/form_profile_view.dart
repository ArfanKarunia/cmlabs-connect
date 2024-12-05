import 'package:cmlabs_connect/src/controllers/account_controller.dart';
import 'package:cmlabs_connect/src/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../models/user_model.dart';
import '../../../routes.dart';
import '../../../utils/color.dart';
import '../select_field.dart';

class FormProfileView extends StatelessWidget {
  FormProfileView({super.key});

  final UserController userController = Get.put(UserController());
  final AccountController accountController = Get.put(AccountController());

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  final TextEditingController weblinkController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController mediumController = TextEditingController();
  final TextEditingController quoraController = TextEditingController();
  final TextEditingController tiktokController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    accountController.fetchRoleList();
    accountController.fetchProfile();

    User? user = userController.user.value;
    user!.picUrl;

    try {
      usernameController.text = accountController.profileUsername.value ?? '';
      fullNameController.text = accountController.profileFullName.value ?? '';
      numberController.text = accountController.profileNumber.value ?? '';
      linkedinController.text = accountController.profileLinkedin.value ?? '';
      weblinkController.text = accountController.profileWebsite.value ?? '';
      instagramController.text = accountController.profileInstagram.value ?? '';
      mediumController.text = accountController.profileMedium.value ?? '';
      quoraController.text = accountController.profileQuora.value ?? '';
      tiktokController.text = accountController.profileTiktok.value ?? '';
    } catch (e) {
      // Handle any errors that occur while fetching experience
      print('Error fetching experience: $e');
    }

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFFF9F9F9),
        surfaceTintColor: Color(0xFFF9F9F9),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.text_1,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(
                  () {
                    return Container(
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                        image: DecorationImage(
                          image: accountController.selectedImage.value != null
                              ? FileImage(
                                  accountController.selectedImage.value!)
                              : (user.picUrl != null && user.picUrl!.isNotEmpty)
                                  ? NetworkImage(user.picUrl!) as ImageProvider
                                  : const AssetImage(
                                      "assets/icons/cmlabs_icon.png",
                                    ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 16,
                ),
                SizedBox(
                  height: 51,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => accountController.pickImage(),
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(
                        Color(0xFFF9F9F9),
                      ),
                      foregroundColor:
                          WidgetStatePropertyAll(AppColors.primary),
                      overlayColor: WidgetStatePropertyAll(Colors.black12),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(
                            width: 1,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    child: Text(
                      'Change Photo Profile',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextField(
                  title: "Username",
                  hintText: "Username",
                  controller: usernameController,
                  isMandatory: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "The 'Username' field is required";
                    }

                    if (value.length > 20) {
                      return "The maximum character of username is 20 characters";
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextField(
                  title: "Full Name",
                  hintText: "Full Name",
                  controller: fullNameController,
                  isMandatory: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "The 'Username' field is required";
                    }

                    if (value.length > 20) {
                      return "The maximum character of name is 20 characters";
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                Obx(
                  () {
                    return SelectField(
                      name: "Role/Position",
                      onPressed: () {
                        Get.toNamed(
                          AppRoutes.selectDataProfile,
                          arguments: "role",
                        )?.then(
                          (value) {
                            accountController.addRole(value);
                            print(
                                "role selected: ${accountController.profileRole.value}");
                            accountController.profileRole.refresh();
                          },
                        );
                      },
                      isMandatory: false,
                      child: (accountController.profileRole.value != null)
                          ? Obx(
                              () {
                                return Text(
                                  accountController
                                          .profileRole.value?['name'] ??
                                      '',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 13,
                                    color: AppColors.text_1,
                                  ),
                                );
                              },
                            )
                          : Text(
                              "Select Role/Position",
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: AppColors.text_4,
                              ),
                            ),
                    );
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextField(
                  title: "Phone Number",
                  hintText: "Phone Number",
                  controller: numberController,
                
                  isMandatory: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null; // Allow empty values since it's not mandatory
                    }

                    // Check if the phone number contains only digits
                    final numericRegExp = RegExp(r'^[0-9]+$');
                    if (!numericRegExp.hasMatch(value)) {
                      return "The phone number must contain only digits";
                    }

                    // Check the maximum length of the phone number
                    if (value.length > 13) {
                      return "The maximum digits of phone number is 13 digits";
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextField(
                  title: "Linkedin Account",
                  hintText: "Linkedin Account",
                  controller: linkedinController,
                  isMandatory: false,
                  validator: (value) {
                    if (value!.length > 64) {
                      return "The maximum character of Linkedin is 64 Characters";
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextField(
                  title: "Website Link",
                  hintText: "Website Link",
                  controller: weblinkController,
                  isMandatory: false,
                  validator: (value) {
                    // Regular expression for validating URLs
                    if (value != '') {
                      final urlPattern =
                          r"^(https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}(:[0-9]{1,5})?(\/.*)?$";
                      final urlRegExp = RegExp(urlPattern);

                      if (!urlRegExp.hasMatch(value!)) {
                        return "The format link is invalid!";
                      }
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextField(
                  title: "Instagram Account",
                  hintText: "Instagram Account",
                  controller: instagramController,
                  isMandatory: false,
                  validator: (value) {
                    if (value!.length > 30) {
                      return "The maximum characters of instagram is 30 characters";
                    }

                    if (value.contains("http")) {
                      return "The Instagram account must not contain http or https";
                    }

                    if (value.contains("https")) {
                      return "The Instagram account must not contain http or https";
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextField(
                  title: "Medium Account",
                  hintText: "Medium Account",
                  controller: mediumController,
                  isMandatory: false,
                  validator: (value) {
                    if (value!.contains("http")) {
                      return "The Medium account must not contain http or https";
                    }

                    if (value.contains("https")) {
                      return "The Medium account must not contain http or https";
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextField(
                  title: "Quora Acccount",
                  hintText: "Quora Acccount",
                  controller: quoraController,
                  isMandatory: false,
                  validator: (value) {
                    if (value!.contains("http")) {
                      return "The Quora account must not contain http or https";
                    }

                    if (value.contains("https")) {
                      return "The Quora account must not contain http or https";
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                TextField(
                  title: "Tiktok Account",
                  hintText: "Tiktok Account",
                  controller: tiktokController,
                  isMandatory: false,
                  validator: (value) {
                    if (value!.contains("http")) {
                      return "The Tiktok account must not contain http or https";
                    }

                    if (value.contains("https")) {
                      return "The Tiktok account must not contain http or https";
                    }

                    return null;
                  },
                ),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  height: 51,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Save the form
                        accountController.profileUsername.value =
                            usernameController.text;
                        accountController.profileFullName.value =
                            fullNameController.text;
                        accountController.profileNumber.value =
                            numberController.text;

                        accountController.profileLinkedin.value =
                            linkedinController.text;
                        accountController.profileWebsite.value =
                            weblinkController.text;
                        accountController.profileInstagram.value =
                            instagramController.text;

                        accountController.profileMedium.value =
                            mediumController.text;
                        accountController.profileQuora.value =
                            quoraController.text;
                        accountController.profileTiktok.value =
                            tiktokController.text;

                        accountController.editProfile();
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

class TextField extends StatelessWidget {
  TextField({
    super.key,
    required this.title,
    required this.hintText,
    this.isMandatory = true,
    required this.controller,
    this.validator,
  });

  String title;
  String hintText;
  bool isMandatory;
  TextEditingController controller;
  String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppColors.text_2,
                fontWeight: FontWeight.bold,
              ),
            ),
            isMandatory
                ? Text(
                    "*",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: AppColors.danger,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        TextFormField(
          controller: controller,
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
            hintText: hintText,
          ),
          validator: validator,
        )
      ],
    );
  }
}
