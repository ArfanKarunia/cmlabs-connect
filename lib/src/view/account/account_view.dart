import 'package:cmlabs_connect/src/controllers/account/account_controller.dart';
import 'package:cmlabs_connect/src/controllers/authentication/authentication_controller.dart';
import 'package:cmlabs_connect/src/controllers/notification/notification_controller.dart';
import 'package:cmlabs_connect/src/controllers/user/user_controller.dart';
import 'package:cmlabs_connect/src/routes.dart';
import 'package:cmlabs_connect/src/utils/bottom_sheet.dart';
import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:cmlabs_connect/src/utils/icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../constant/fontstyle.dart';
import '../../widgets/custom_avatar.dart';
import '../../widgets/custom_submit_button.dart';
import '../../widgets/default_appbar.dart';

class AccountView extends StatefulWidget {
  const AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  final AuthenticationController authenticationController = Get.find<AuthenticationController>();
  final AccountController accountController = Get.find<AccountController>();
  final NotificationController notificationController = Get.find<NotificationController>();
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar('Account Setting'),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Obx(
              () => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomAvatar(
                        radius: 24,
                        link: userController.user.value?.picUrl,
                      ),
                      const SizedBox(width: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            userController.user.value?.name ?? 'cmlabs User',
                            style: bold.copyWith(fontSize: 16),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            userController.roleName.value,
                            style: regular.copyWith(fontSize: 13, color: AppColors.text_3),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            userController.user.value?.email ?? 'user@cmlabs.co',
                            style: regular.copyWith(fontSize: 12, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        onPressed: () => Get.toNamed(AppRoutes.notification),
                        icon: const Icon(
                          Ionicons.notifications_outline,
                          color: AppColors.text_1,
                          size: 28,
                        ),
                      ),
                      Obx(
                        () => notificationController.unreadAll.value != 0
                            ? Positioned(
                                top: 10,
                                right: 13,
                                child: Container(
                                  height: 10,
                                  width: 10,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.danger,
                                  ),
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          CustomSubmitButton(
            title: 'Edit Profile',
            onTap: () async => Get.toNamed(AppRoutes.editProfileView),
          ),
          const SizedBox(height: 20),
          AccountMenu(
            title: 'Summary',
            iconUrl: AppIcons.summaryIcon,
            onTap: () => Get.toNamed(AppRoutes.summaryView),
          ),
          AccountMenu(
            title: 'Experiences',
            iconUrl: AppIcons.experienceIcon,
            onTap: () => Get.toNamed(AppRoutes.experienceView),
          ),
          AccountMenu(
            title: 'Education',
            iconUrl: AppIcons.educationIcon,
            onTap: () => Get.toNamed(AppRoutes.educationView),
          ),
          AccountMenu(
            title: 'Organization',
            iconUrl: AppIcons.organizationIcon,
            onTap: () => Get.toNamed(AppRoutes.organizationView),
          ),
          AccountMenu(
            title: 'Volunteer',
            iconUrl: AppIcons.volunteerIcon,
            onTap: () => Get.toNamed(AppRoutes.volunteerView),
          ),
          AccountMenu(
            title: 'Certification',
            iconUrl: AppIcons.certificationIcon,
            onTap: () => Get.toNamed(AppRoutes.certificationView),
          ),
          AccountMenu(
            title: 'Achievement',
            iconUrl: AppIcons.achievementIcon,
            onTap: () => Get.toNamed(AppRoutes.achievementView),
          ),
          AccountMenu(
            title: 'Publication',
            iconUrl: AppIcons.publicationIcon,
            onTap: () => Get.toNamed(AppRoutes.publicationView),
          ),
          AccountMenu(
            title: 'Notification Setting',
            iconUrl: AppIcons.setNotification,
            onTap: () => Get.toNamed(AppRoutes.settingNotification),
          ),
          const SizedBox(height: 20),
          CustomSubmitButton(
            title: "Change Password",
            onTap: () => Get.toNamed(AppRoutes.changePasswordView),
            color: Colors.transparent,
            borderColor: AppColors.primary,
            textColor: AppColors.primary,
          ),
          const SizedBox(height: 20),
          CustomSubmitButton(
            icon: Ionicons.log_out_outline,
            title: "Sign Out",
            onTap: () => signOutBottomSheet(context, onSignOut: () => authenticationController.logout()),
            color: AppColors.bgDanger,
            textColor: AppColors.danger,
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class AccountMenu extends StatelessWidget {
  final String title;
  final String iconUrl;
  final VoidCallback? onTap;
  const AccountMenu({
    super.key,
    required this.title,
    required this.iconUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      splashColor: Colors.black12,
      tileColor: AppColors.white_1,
      onTap: onTap,
      leading: ImageIcon(AssetImage(iconUrl)),
      title: Text(title, style: bold),
      trailing: const Icon(Ionicons.chevron_forward_outline),
    );
  }
}
