import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/account/account_controller.dart';
import '../../../controllers/user/user_controller.dart';
import '../../../models/user_model.dart';
import '../../../routes.dart';
import '../../../utils/color.dart';
import '../../../utils/image_utils.dart';
import '../../../utils/toast.dart';
import '../../../widgets/custom_avatar.dart';
import '../../../widgets/custom_formfield.dart';
import '../../../widgets/custom_select_field.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';
import '../../../widgets/inbox/inbox_add_field.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final UserController userController = Get.find<UserController>();
  final AccountController accountController = Get.find<AccountController>();

  File? selectedImage;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  final TextEditingController weblinkController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController mediumController = TextEditingController();
  final TextEditingController quoraController = TextEditingController();
  final TextEditingController tiktokController = TextEditingController();

  String? usernameError;
  String? fullNameError;
  String? numberError;
  String? linkedinError;
  String? weblinkError;
  String? instagramError;
  String? mediumError;
  String? quoraError;
  String? tiktokError;

  bool isFormValid() {
    usernameError = usernameController.text.isEmpty
        ? "The 'Username' field is required"
        : usernameController.text.length > 20
            ? "The maximum character of username is 20 characters"
            : null;
    fullNameError = fullNameController.text.isEmpty
        ? "The 'Full Name' field is required"
        : fullNameController.text.length > 20
            ? "The maximum character of name is 20 characters"
            : !RegExp(r'^[a-zA-Z\s]+$').hasMatch(fullNameController.text)
                ? "The name must contain only letters and spaces"
                : null;
    numberError = numberController.text.length > 13
        ? "The maximum digits of phone number is 13 digits"
        : (!RegExp(r'^[0-9]+$').hasMatch(numberController.text))
            ? "The phone number must contain only digits"
            : null;
    linkedinError = linkedinController.text.length > 64 ? "The maximum character of Linkedin is 64 Characters" : null;
    weblinkError = weblinkController.text.isEmpty
        ? null
        : !weblinkController.text.contains("http") || !weblinkController.text.contains("https")
            ? "The Website Link must contain http or https"
            : !RegExp(r"^(https?:\/\/)?([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}(:[0-9]{1,5})?(\/.*)?$")
                    .hasMatch(weblinkController.text)
                ? "The format link is invalid!"
                : null;
    instagramError = instagramController.text.contains("http") || instagramController.text.contains("https")
        ? "The Instagram account must not contain http or https"
        : instagramController.text.length > 30
            ? "The maximum characters of instagram is 30 characters"
            : null;
    mediumError = mediumController.text.contains("http") || mediumController.text.contains("https")
        ? "The Medium account must not contain http or https"
        : null;
    quoraError = quoraController.text.contains("http") || quoraController.text.contains("https")
        ? "The Quora account must not contain http or https"
        : null;
    tiktokError = tiktokController.text.contains("http") || tiktokController.text.contains("https")
        ? "The Tiktok account must not contain http or https"
        : null;
    setState(() {});

    bool isFormValid = usernameError == null &&
        fullNameError == null &&
        numberError == null &&
        linkedinError == null &&
        weblinkError == null &&
        instagramError == null &&
        mediumError == null &&
        quoraError == null &&
        tiktokError == null;

    if (!isFormValid) {
      showErrorToast("Error: Please check the form and try again!");
    }

    return isFormValid;
  }

  @override
  void initState() {
    super.initState();
    usernameController.text = accountController.profileUsername.value ?? '';
    fullNameController.text = accountController.profileFullName.value ?? '';
    numberController.text = accountController.profileNumber.value ?? '';
    linkedinController.text = accountController.profileLinkedin.value ?? '';
    weblinkController.text = accountController.profileWebsite.value ?? '';
    instagramController.text = accountController.profileInstagram.value ?? '';
    mediumController.text = accountController.profileMedium.value ?? '';
    quoraController.text = accountController.profileQuora.value ?? '';
    tiktokController.text = accountController.profileTiktok.value ?? '';
  }

  @override
  void dispose() {
    usernameController.dispose();
    fullNameController.dispose();
    numberController.dispose();
    linkedinController.dispose();
    weblinkController.dispose();
    instagramController.dispose();
    mediumController.dispose();
    quoraController.dispose();
    tiktokController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = userController.user.value;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar('Edit Profile', titleSpacing: 0),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Profile Picture
            SizedBox(
              height: 150,
              width: 150,
              child: FittedBox(
                child: CustomChangeAvatar(
                  radius: 75,
                  newImage: selectedImage,
                  link: user?.picUrl,
                ),
              ),
            ),
            const SizedBox(height: 16),
            CustomSubmitButton(
              title: 'Change Photo Profile',
              color: AppColors.scaffoldBgColor2,
              borderColor: AppColors.primary,
              textColor: AppColors.primary,
              onTap: () async {
                final img = await ImageUtils().pickImage();
                if (img != null) setState(() => selectedImage = img);
              },
            ),

            const SizedBox(height: 25),

            // Username
            InboxAddField(
              title: 'Username',
              isRequired: true,
              child: CustomFormField(
                controller: usernameController,
                hintText: 'Username',
                errorText: usernameError,
              ),
            ),

            const SizedBox(height: 12),

            // Full Name
            InboxAddField(
              title: 'Full Name',
              isRequired: true,
              child: CustomFormField(
                controller: fullNameController,
                hintText: 'Full Name',
                errorText: fullNameError,
              ),
            ),

            const SizedBox(height: 12),

            // Role/Position
            InboxAddField(
              title: 'Role/Position',
              child: CustomSelectField(
                onTap: () => Get.toNamed(
                  AppRoutes.accountSelectView,
                  arguments: {"data": AccountSelectData.role},
                ),
                child: Obx(
                  () => InboxTextOnField(
                    title: 'Select Role/Position',
                    selected: accountController.profileRole.value != null
                        ? {
                            'value': accountController.profileRole.value?['name'] ?? '',
                            'label': accountController.profileRole.value?['name'] ?? '',
                          }
                        : null,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Phone Number
            InboxAddField(
              title: 'Phone Number',
              child: CustomFormField(
                controller: numberController,
                keyboardType: TextInputType.phone,
                hintText: 'Phone Number',
                errorText: numberError,
              ),
            ),

            const SizedBox(height: 12),

            // Linkedin Account
            InboxAddField(
              title: 'Linkedin Account',
              child: CustomFormField(
                controller: linkedinController,
                hintText: 'Linkedin Account',
                errorText: linkedinError,
              ),
            ),

            const SizedBox(height: 12),

            // Website Link
            InboxAddField(
              title: 'Website Link',
              child: CustomFormField(
                controller: weblinkController,
                hintText: 'Website Link',
                errorText: weblinkError,
              ),
            ),

            const SizedBox(height: 12),

            // Instagram Account
            InboxAddField(
              title: 'Instagram Account',
              child: CustomFormField(
                controller: instagramController,
                hintText: 'Instagram Account',
                errorText: instagramError,
              ),
            ),

            const SizedBox(height: 12),

            // Medium Account
            InboxAddField(
              title: 'Medium Account',
              child: CustomFormField(
                controller: mediumController,
                hintText: 'Medium Account',
                errorText: mediumError,
              ),
            ),

            const SizedBox(height: 12),

            // Quora Account
            InboxAddField(
              title: 'Quora Account',
              child: CustomFormField(
                controller: quoraController,
                hintText: 'Quora Account',
                errorText: quoraError,
              ),
            ),

            const SizedBox(height: 12),

            // Tiktok Account
            InboxAddField(
              title: 'Tiktok Account',
              child: CustomFormField(
                controller: tiktokController,
                hintText: 'Tiktok Account',
                errorText: tiktokError,
              ),
            ),

            const SizedBox(height: 25),

            Obx(
              () => accountController.isLoadingProfile.value
                  ? const CustomLoadingButton()
                  : CustomSubmitButton(
                      title: 'Save',
                      onTap: () {
                        if (isFormValid()) {
                          accountController.profileUsername.value = usernameController.text;
                          accountController.profileFullName.value = fullNameController.text;
                          accountController.profileNumber.value = numberController.text;

                          accountController.profileLinkedin.value = linkedinController.text;
                          accountController.profileWebsite.value = weblinkController.text;
                          accountController.profileInstagram.value = instagramController.text;

                          accountController.profileMedium.value = mediumController.text;
                          accountController.profileQuora.value = quoraController.text;
                          accountController.profileTiktok.value = tiktokController.text;

                          accountController.editProfile(selectedImage);
                        }
                      },
                    ),
            ),
            const SizedBox(height: 200),
          ],
        ),
      ),
    );
  }
}
