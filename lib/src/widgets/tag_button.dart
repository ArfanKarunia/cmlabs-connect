import 'package:cmlabs_connect/src/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../utils/color.dart';

class TagButton extends StatelessWidget {
  const TagButton({
    super.key,
    required this.statusLabel, 
    required this.onPressed,
  });

  final String statusLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 5, vertical: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.bgPrimary,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          children: [
            CustomButton(
              onPressed: onPressed,
              backgroundColor: Colors.transparent,
              child: Icon(
                Ionicons.close_outline,
                size: 18,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              statusLabel,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}