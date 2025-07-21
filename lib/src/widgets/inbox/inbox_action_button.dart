import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../constant/fontstyle.dart';
import '../../routes.dart';
import '../../utils/color.dart';

class InboxAddQuotationButton extends StatelessWidget {
  const InboxAddQuotationButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(AppRoutes.addQuotation),
      borderRadius: BorderRadius.circular(5),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.primary,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Ionicons.add, size: 20, color: AppColors.white),
            const SizedBox(width: 6),
            Text(
              'New Quotation',
              style: regular.copyWith(fontSize: 12, color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class InboxExportDataButton extends StatelessWidget {
  final VoidCallback onTap;
  const InboxExportDataButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(5),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.primary,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ImageIcon(AssetImage('assets/icons/icons_download.png'), size: 20, color: AppColors.white),
            const SizedBox(width: 6),
            Text(
              'Export Data',
              style: regular.copyWith(fontSize: 12, color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class InboxActionLoadingButton extends StatelessWidget {
  const InboxActionLoadingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        height: 28,
        width: 28,
        child: LoadingAnimationWidget.progressiveDots(color: AppColors.primary, size: 28),
      ),
    );
  }
}
