import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:flutter/material.dart';

import '../constant/fontstyle.dart';
import '../widgets/custom_submit_button.dart';

Future<void> showCustomBottomSheet(
  BuildContext context, {
  required List<Widget> children,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
}) {
  return showModalBottomSheet(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            ...children,
            Center(
              child: Text(
                "Swipe down or Tap the screen to close",
                style: regular.copyWith(fontSize: 10, color: AppColors.text_2),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}

Future<void> deleteBottomSheet(
  BuildContext context, {
  VoidCallback? onDelete,
  required String message,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
}) {
  return showCustomBottomSheet(
    context,
    crossAxisAlignment: crossAxisAlignment,
    children: [
      const Text(
        "Delete",
        style: bold,
      ),
      const SizedBox(height: 10),
      Text(
        message,
        style: regular,
      ),
      const SizedBox(height: 10),
      CustomSubmitButton(
        title: 'Yes, Delete it',
        onTap: onDelete,
      ),
      const SizedBox(height: 10),
    ],
  );
}

Future<void> signOutBottomSheet(
  BuildContext context, {
  VoidCallback? onSignOut,
  CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
}) {
  return showCustomBottomSheet(
    context,
    crossAxisAlignment: crossAxisAlignment,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Sign Out",
            style: bold.copyWith(fontSize: 18),
          ),
          const SizedBox(width: 10),
          const Icon(
            Icons.login_rounded,
            weight: 3,
            color: AppColors.text_1,
          ),
        ],
      ),
      const SizedBox(height: 12),
      const Text(
        'Are you sure wanna Sign Out?',
        style: regular,
      ),
      const SizedBox(height: 12),
      CustomSubmitButton(
        title: 'Yes, Sign Out',
        color: AppColors.bgDanger,
        textColor: AppColors.danger,
        onTap: onSignOut,
      ),
      const SizedBox(height: 12),
    ],
  );
}
