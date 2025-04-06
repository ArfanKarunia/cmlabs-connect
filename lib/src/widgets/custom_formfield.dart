import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../constant/fontstyle.dart';
import '../utils/color.dart';

class FormInputWidget extends StatelessWidget {
  final String title;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final bool isPassword;
  final String? errorText;
  final String? Function(String?)? validator;
  const FormInputWidget({
    super.key,
    required this.title,
    this.controller,
    this.keyboardType,
    this.hintText,
    this.isPassword = false,
    this.errorText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.left,
          style: bold.copyWith(color: AppColors.text_2),
        ),
        const SizedBox(height: 10),
        CustomFormField(
          controller: controller,
          hintText: "Enter your ${title.toLowerCase()}",
          isPassword: isPassword,
          errorText: errorText,
          validator: validator,
        ),
      ],
    );
  }
}

class CustomFormField extends StatefulWidget {
  final bool isEnabled;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final String? hintText;
  final bool isPassword;
  final String? errorText;
  final String? Function(String?)? validator;
  const CustomFormField({
    super.key,
    this.isEnabled = true,
    this.controller,
    this.keyboardType,
    this.hintText,
    this.isPassword = false,
    this.errorText,
    this.validator,
  });

  @override
  State<CustomFormField> createState() => _CustomFormFieldState();
}

class _CustomFormFieldState extends State<CustomFormField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.isEnabled,
      controller: widget.controller,
      keyboardType: widget.keyboardType,
      style: regular,
      obscureText: widget.isPassword ? _obscureText : false,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(width: 1, color: AppColors.primaryText),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(width: 1, color: AppColors.primaryText),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(width: 2, color: AppColors.primary),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          borderSide: BorderSide(width: 1, color: AppColors.danger),
        ),
        hintText: widget.hintText,
        hintStyle: regular.copyWith(color: AppColors.text_4),
        errorText: widget.errorText,
        errorStyle: regular.copyWith(color: AppColors.danger),
        errorMaxLines: 2,
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(_obscureText ? Ionicons.eye_off_outline : Ionicons.eye_outline),
                onPressed: () => setState(() => _obscureText = !_obscureText),
              )
            : null,
      ),
      validator: widget.validator,
    );
  }
}
