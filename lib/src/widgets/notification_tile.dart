import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.name,
    required this.date,
    required this.isReminder,
    required this.isRead,
  });

  final String name;
  final DateTime date;
  final bool isReminder;
  final bool isRead;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14),
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: AppColors.white_1,
          borderRadius: BorderRadius.circular(5),
          border: isRead
              ? Border.all(
                  color: AppColors.primary,
                  width: 1,
                )
              : null,
          boxShadow: [
            BoxShadow(
                offset: Offset(2, 2),
                blurRadius: 30,
                color: Color.fromRGBO(0, 0, 0, 0.05))
          ]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reminder',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.text_1,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'You have a new quotation from: ',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.text_3,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    name,
                    style: GoogleFonts.plusJakartaSans(
                        color: AppColors.text_1,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    'that need to follow up',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.text_3,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.only(top: 2),
                child: Text(
                  DateFormat('dd/MM/yy HH:mm').format(date),
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.text_4,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(AppColors.white_1),
                foregroundColor: WidgetStatePropertyAll(AppColors.primary),
                overlayColor: WidgetStatePropertyAll(Colors.black12),
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                      color: AppColors.primary,
                      width: 1,
                    ),
                  ),
                ),
              ),
              child: Text(
                "View details",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}