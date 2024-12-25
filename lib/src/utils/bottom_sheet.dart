import 'dart:ui';

import 'package:cmlabs_connect/src/controllers/edit_quotation/edit_quotation_controller.dart';
import 'package:cmlabs_connect/src/models/quotation_model.dart';
import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

Future<dynamic> DeleteBottomSheet(
    BuildContext context, VoidCallback onDelete, String message) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Wrap(
            children: [
              Container(
                padding:
                    const EdgeInsets.only(left: 15, right: 15, bottom: 50, top: 25),
                decoration: const BoxDecoration(
                  color: AppColors.white_1,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
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
                    const SizedBox(
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
                    const SizedBox(
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
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 51,
                      child: ElevatedButton(
                        onPressed: onDelete,
                        style: ButtonStyle(
                          backgroundColor:
                              const WidgetStatePropertyAll(AppColors.primary),
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        child: Text(
                          "Yes, Delete it",
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.white_1,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
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
          ),
        ],
      );
    },
  );
}

Future<dynamic> SignOutBottomSheet(
    BuildContext context, VoidCallback onPressed) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Wrap(
            children: [
              Container(
                padding:
                    const EdgeInsets.only(left: 15, right: 15, bottom: 40, top: 25),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.white_1,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
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
                    const SizedBox(height: 26),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sign Out",
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.text_1,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.login_rounded,
                          weight: 3,
                          size: 28,
                          color: AppColors.text_1,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Are you sure wanna Sign Out?",
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.text_1,
                        fontWeight: FontWeight.w400,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 51,
                      child: ElevatedButton(
                        onPressed: onPressed,
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(AppColors.bgDanger),
                          foregroundColor:
                              WidgetStateProperty.all(AppColors.danger),
                          overlayColor: WidgetStateProperty.all(
                              const Color.fromRGBO(253, 208, 208, 0.7)),
                          shadowColor:
                              WidgetStateProperty.all(Colors.transparent),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        child: Text(
                          "Yes, Sign Out",
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Swipe down or Tap the screen to close",
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.text_2,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}


class BottomSheetSaveChanges extends StatefulWidget {
  BottomSheetSaveChanges({super.key, this.quotation, required this.onPressed, this.name});

  Quotation? quotation;
  String? name;

  final VoidCallback onPressed;

  @override
  State<BottomSheetSaveChanges> createState() => _BottomSheetSaveChangesState();
}

class _BottomSheetSaveChangesState extends State<BottomSheetSaveChanges> {
  EditQuotationController detailQuotationController =
      Get.put(EditQuotationController());

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: AppColors.white_1,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(30, 0, 0, 0),
                offset: Offset(0, -4),
                blurRadius: 10,
              ),
            ],
          ),
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
            bottom: 20,
            top: 25,
          ),
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
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: widget.onPressed,
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all(AppColors.primary),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: Text(
                    widget.name ?? "Save",
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.white_1,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Click to ${widget.name ?? 'save'} all changes",
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
  }
}