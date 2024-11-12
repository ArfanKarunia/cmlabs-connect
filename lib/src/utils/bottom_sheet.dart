import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Future<dynamic> DeleteBottomSheet(BuildContext context, VoidCallback onDelete, String message) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white_1,
      isScrollControlled: true,
      builder: (context) {
        return Wrap(
          children: [
            Container(
              padding:
                  EdgeInsets.only(left: 15, right: 15, bottom: 50, top: 25),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 140,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.text_4,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Delete",
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.text_1,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    message,
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.text_1,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onDelete,
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(AppColors.primary),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      child: Text(
                        "Yes, delete it",
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.white_1,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Swipe down or Tap the screen to close",
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.text_2,
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }