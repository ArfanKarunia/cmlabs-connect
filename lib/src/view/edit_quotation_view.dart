import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/color.dart';

class EditQuotationView extends StatelessWidget {
  const EditQuotationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFFF9F9F9),
        surfaceTintColor: Color(0xFFF9F9F9),
        title: Text(
          "Detail Leads",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.text_1,
          ),
        ),
      ),
    );
  }
}