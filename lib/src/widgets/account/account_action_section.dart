import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../utils/color.dart';
import '../custom_submit_button.dart';

class AccountActionSection extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  const AccountActionSection({super.key, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: CustomSubmitButton(
                title: 'Edit',
                textSize: 12,
                icon: Ionicons.pencil_outline,
                iconSize: 20,
                padding: 10,
                color: AppColors.bgInfo,
                textColor: AppColors.info,
                onTap: onEdit,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: CustomSubmitButton(
                title: 'Delete',
                textSize: 12,
                icon: Ionicons.trash_outline,
                iconSize: 20,
                padding: 10,
                color: AppColors.bgDanger,
                textColor: AppColors.danger,
                onTap: onDelete,
              ),
            ),
          ],
        )
      ],
    );
  }
}
