import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../constant/fontstyle.dart';
import '../utils/color.dart';

class CustomSubmitButton extends StatelessWidget {
  final String title;
  final bool isTitleBold;
  final IconData? icon;
  final double? iconSize;
  final bool isDisabled;
  final Color color;
  final Color disabledColor;
  final Color? borderColor;
  final Color textColor;
  final VoidCallback? onTap;
  final double padding;
  const CustomSubmitButton({
    super.key,
    this.icon,
    this.iconSize,
    required this.title,
    this.isTitleBold = true,
    this.isDisabled = false,
    this.color = AppColors.primary,
    this.disabledColor = AppColors.lightPrimaryColor,
    this.borderColor,
    this.textColor = AppColors.white,
    this.onTap,
    this.padding = 17.5,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !isDisabled ? onTap : null,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: borderColor != null ? Border.all(color: borderColor!) : null,
          color: !isDisabled ? color : disabledColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, color: textColor, size: iconSize),
              const SizedBox(width: 10),
            ],
            Text(
              title,
              style: isTitleBold ? bold.copyWith(color: textColor) : regular.copyWith(color: textColor),
            ),
          ],
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
        borderRadius: BorderRadius.circular(10),
        color: AppColors.primary,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 28,
            width: 28,
            child: CustomLoading(color: AppColors.white_1, size: 28),
          ),
        ],
      ),
    );
  }
}

class CustomLoading extends StatelessWidget {
  final Color color;
  final double size;
  const CustomLoading({super.key, this.color = AppColors.primary, this.size = 28});

  @override
  Widget build(BuildContext context) {
    return LoadingAnimationWidget.progressiveDots(color: color, size: 28);
  }
}
