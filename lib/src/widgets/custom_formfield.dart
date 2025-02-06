import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../constant/fontstyle.dart';
import '../utils/color.dart';

class FormInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final String title;
  final bool isPassword;
  final String? errorText;
  final String? Function(String?)? validator;

  const FormInputWidget({
    super.key,
    required this.controller,
    required this.title,
    this.isPassword = false,
    this.errorText,
    this.validator,
  });

  @override
  State<FormInputWidget> createState() => _FormInputWidgetState();
}

class _FormInputWidgetState extends State<FormInputWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          textAlign: TextAlign.left,
          style: bold.copyWith(color: AppColors.text_2),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.isPassword ? TextInputType.text : TextInputType.emailAddress,
          style: regular,
          obscureText: widget.isPassword ? _obscureText : false,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: AppColors.primary),
            ),
            hintText: "Enter your ${widget.title.toLowerCase()}",
            hintStyle: regular.copyWith(fontSize: 12, color: AppColors.text_4),
            errorText: widget.errorText,
            errorStyle: regular.copyWith(fontSize: 12, color: AppColors.danger),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(_obscureText ? Ionicons.eye_off_outline : Ionicons.eye_outline),
                    onPressed: () => setState(() => _obscureText = !_obscureText),
                  )
                : null,
          ),
          validator: widget.validator,
        ),
      ],
    );
  }
}
