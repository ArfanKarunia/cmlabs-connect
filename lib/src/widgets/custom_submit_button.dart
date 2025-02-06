import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../constant/fontstyle.dart';
import '../utils/color.dart';

class CustomSubmitButton extends StatelessWidget {
  final String title;
  final bool isDisabled;
  final VoidCallback? onTap;
  const CustomSubmitButton({
    super.key,
    required this.title,
    this.isDisabled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !isDisabled ? onTap : null,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: !isDisabled ? AppColors.primary : AppColors.lightPrimaryColor,
        ),
        child: Text(
          title,
          style: bold.copyWith(color: AppColors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class CustomLoadingButton extends StatelessWidget {
  const CustomLoadingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(13.5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColors.primary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 28,
            width: 28,
            child: LoadingAnimationWidget.progressiveDots(color: AppColors.white_1, size: 28),
          ),
        ],
      ),
    );
  }
}
