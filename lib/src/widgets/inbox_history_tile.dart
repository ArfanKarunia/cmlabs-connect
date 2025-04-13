import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../constant/const.dart';
import '../constant/fontstyle.dart';
import '../controllers/inbox/edit_form_controller.dart';
import '../utils/bottom_sheet.dart';
import '../utils/color.dart';
import 'custom_submit_button.dart';
import 'inbox_list_tile.dart';

class HistoryTile extends StatelessWidget {
  final String onEditRoute;
  final EditFormController controller;
  final int index;
  const HistoryTile({
    super.key,
    required this.onEditRoute,
    required this.controller,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Activity',
          style: regular.copyWith(color: AppColors.primaryText),
        ),
        const SizedBox(height: 5),
        Text(
          '${controller.historyList[index].name}',
          style: regular.copyWith(fontSize: 12, color: AppColors.text_2, letterSpacing: 0),
        ),
        const Divider(thickness: 0.5),
        const SizedBox(height: 5),
        Text(
          'Date Time',
          style: regular.copyWith(color: AppColors.primaryText),
        ),
        const SizedBox(height: 5),
        Text(
          controller.historyList[index].createdAt != null
              ? DateFormat('d MMMM yyyy, HH:mm:ss').format(controller.historyList[index].createdAt!)
              : '-',
          style: regular.copyWith(fontSize: 12, color: AppColors.text_2, letterSpacing: 0),
        ),
        const Divider(thickness: 0.5),
        const SizedBox(height: 5),
        Text(
          'Created by',
          style: regular.copyWith(color: AppColors.primaryText),
        ),
        const SizedBox(height: 5),
        Text(
          controller.historyList[index].createdBy ?? '-',
          style: regular.copyWith(fontSize: 12, color: AppColors.text_2, letterSpacing: 0),
        ),
        const Divider(thickness: 0.5),
        const SizedBox(height: 5),
        Text(
          'Status',
          style: regular.copyWith(fontSize: 13, color: AppColors.primaryText),
        ),
        const SizedBox(height: 10),
        Row(children: [StatusLeadTag(status: statusLead[controller.historyList[index].status ?? 0])]),
        const SizedBox(height: 10),
        Row(
          children: [
            Text('Available to User', style: regular.copyWith(fontSize: 12)),
            const SizedBox(width: 10),
            Obx(
              () => SizedBox(
                height: 32,
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: Switch(
                    value: controller.historyList[index].availableToUser ?? false,
                    onChanged: (_) => Get.toNamed(
                      onEditRoute,
                      arguments: {'history': controller.historyList[index]},
                    ),
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: const Color(0xFFD8DAE5),
                    trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
                    inactiveThumbColor: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomSubmitButton(
                title: 'Edit',
                onTap: () => Get.toNamed(
                  onEditRoute,
                  arguments: {'history': controller.historyList[index]},
                ),
                icon: Icons.edit_note_outlined,
                color: const Color(0x00ffecc6).withOpacity(0.7),
                textColor: AppColors.yellow,
                padding: 8,
                isTitleBold: false,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: CustomSubmitButton(
                title: 'Delete',
                onTap: () => deleteBottomSheet(
                  context,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  message: 'Are you sure wanna delete this history?',
                  onDelete: () async {
                    Get.back();
                    await controller.deleteHistory(controller.historyList[index].id);
                  },
                ),
                icon: Icons.delete_outline,
                color: AppColors.bgDanger,
                textColor: AppColors.danger,
                padding: 8,
                isTitleBold: false,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
