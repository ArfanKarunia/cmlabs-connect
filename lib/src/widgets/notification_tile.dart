import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../constant/fontstyle.dart';
import '../models/inbox/quotation_model.dart';
import '../routes.dart';
import 'custom_submit_button.dart';

class NotificationTile extends StatelessWidget {
  final int id;
  final String name;
  final DateTime date;
  final bool isReminder;
  final bool isRead;

  const NotificationTile({
    super.key,
    required this.id,
    required this.name,
    required this.date,
    this.isReminder = false,
    this.isRead = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white_1,
        borderRadius: BorderRadius.circular(5),
        border: !isRead ? Border.all(color: AppColors.primary, width: 1) : null,
        boxShadow: const [BoxShadow(offset: Offset(2, 2), blurRadius: 30, color: Color(0x0D000000))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isReminder) ...[
                    Text(
                      'Reminder',
                      style: bold.copyWith(color: AppColors.text_1),
                    ),
                    const SizedBox(height: 5),
                  ],
                  Text(
                    'You have a new quotation from: ',
                    style: regular.copyWith(fontSize: 12, color: AppColors.text_3),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    name,
                    style: bold.copyWith(
                      fontSize: 16,
                      color: AppColors.text_1,
                    ),
                  ),
                  if (isReminder) ...[
                    const SizedBox(height: 5),
                    Text(
                      'that need to follow up',
                      style: regular.copyWith(fontSize: 12, color: AppColors.text_3),
                    ),
                  ],
                ],
              ),
              Text(
                DateFormat('dd/MM/yy HH:mm').format(date),
                style: regular.copyWith(fontSize: 10, color: AppColors.text_4),
              ),
            ],
          ),
          const SizedBox(height: 20),
          CustomSubmitButton(
            title: 'View Details',
            color: AppColors.white_1,
            borderColor: AppColors.primary,
            textColor: AppColors.primary,
            textSize: 12,
            isTitleBold: false,
            padding: 12,
            borderRadius: 5,
            onTap: () async {
              Get.toNamed(AppRoutes.detailQuotation, arguments: {'quotation': Quotation(id: id)});
            },
          ),
        ],
      ),
    );
  }
}
