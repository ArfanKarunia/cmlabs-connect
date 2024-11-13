import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../utils/color.dart';
import '../../widgets/custom_buttom.dart';

class SelectField extends StatelessWidget {
  const SelectField({
    super.key,
    required this.name,
    required this.child,
    required this.onPressed,
    this.isMandatory = false,
    this.validator,
  });

  final String name;
  final bool isMandatory;
  final VoidCallback onPressed;
  final Widget child;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              name,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.text_3,
              ),
            ),
            if (isMandatory)
              Text(
                "*",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.danger,
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        FormField<String>(
          validator: validator,
          builder: (formFieldState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: onPressed,
                  child: Container(
                    height: 51,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: formFieldState.hasError
                            ? AppColors.danger
                            : AppColors.text_4,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Container(
                          width: double.infinity,
                          child: child,
                        ),
                        Container(
                          height: 45,
                          width: 45,
                          child: CustomButton(
                            backgroundColor: AppColors.white_1,
                            onPressed: onPressed,
                            child: const Icon(
                              Ionicons.chevron_down_outline,
                              color: AppColors.text_1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (formFieldState.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 5, left: 10),
                    child: Text(
                      formFieldState.errorText!,
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.danger,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
