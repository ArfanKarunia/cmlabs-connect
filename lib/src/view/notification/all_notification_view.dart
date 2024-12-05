import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:cmlabs_connect/src/widgets/notification_tile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AllNotificationView extends StatelessWidget {
  const AllNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text(
              "Today",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.text_1,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: 2,
              itemBuilder: (context, index) {
                return NotificationTile(
                  name: 'Nama Perusahaan',
                  date: DateTime.now(),
                  isRead: index % 2 == 0,
                  isReminder: false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


