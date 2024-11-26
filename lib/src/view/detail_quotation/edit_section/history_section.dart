import 'package:cmlabs_connect/src/controllers/edit_quotation/history_changes_controller.dart';
import 'package:cmlabs_connect/src/controllers/user_controller.dart';
import 'package:cmlabs_connect/src/routes.dart';
import 'package:cmlabs_connect/src/utils/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../../../constant/const.dart';
import '../../../controllers/edit_quotation/edit_quotation_controller.dart';
import '../../../utils/color.dart';
import '../../../widgets/quotation_list_tile.dart';

class HistorySection extends StatelessWidget {
  HistorySection({
    super.key,
  });

  final EditQuotationController detailQuotationController =
      Get.put(EditQuotationController());
  final HistoryChangesController historyChangesController =
      Get.put(HistoryChangesController());
  final UserController userController = Get.put(UserController());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "History",
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.text_1,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () {
            if (historyChangesController.historyList.value.isEmpty) {
              return Container(
                height: 150,
                width: double.infinity,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Ionicons.briefcase_outline,
                        color: AppColors.text_4,
                        size: 40,
                      ),
                      Text(
                        'No available data',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.text_4,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: historyChangesController.historyList.value.length,
              itemBuilder: (context, index) {
                var data = historyChangesController.historyList.value[index];
                var isAvailableToUser = (data?.availableToUser
                            .contains(userController.user.value!.id) ??
                        false)
                    .obs;
                var status = data?.status ?? 0;
                var tagStatus = StatusLead.newLead;

                switch (status) {
                  case 0:
                    tagStatus = StatusLead.newLead;
                    break;
                  case 1:
                    tagStatus = StatusLead.followedUp;
                    break;
                  case 2:
                    tagStatus = StatusLead.accepted;
                    break;
                  case 3:
                    tagStatus = StatusLead.rejected;
                    break;
                  case 4:
                    tagStatus = StatusLead.onHold;
                    break;
                }

                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  margin: EdgeInsets.only(bottom: 15),
                  width: double.infinity,
                  color: AppColors.white_1,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Activity",
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.text_1,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          data?.name ?? "",
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.text_2,
                            fontSize: 12,
                          ),
                        ),
                        Divider(),
                        Text(
                          "Date Time",
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.text_1,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          data?.createdAtLabel ?? "",
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.text_2,
                            fontSize: 12,
                          ),
                        ),
                        Divider(),
                        Text(
                          "Created by",
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.text_1,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          data?.createdBy ?? "",
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.text_2,
                            fontSize: 12,
                          ),
                        ),
                        Divider(),
                        Text(
                          "Status",
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.text_1,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        StatusLeadUI(statusLead: tagStatus),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              "Available to User",
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14, color: AppColors.text_1),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Obx(
                              () {
                                return SizedBox(
                                  height: 35,
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: Switch(
                                      thumbColor: WidgetStatePropertyAll(
                                          AppColors.white_1),
                                      trackOutlineWidth:
                                          WidgetStatePropertyAll(0),
                                      trackOutlineColor: WidgetStatePropertyAll(
                                          Colors.transparent),
                                      trackColor: (!isAvailableToUser.value)
                                          ? WidgetStatePropertyAll(
                                              Color(0xFFD8DAE5))
                                          : WidgetStatePropertyAll(
                                              AppColors.primary),
                                      value: isAvailableToUser.value,
                                      onChanged: (bool value) {
                                        isAvailableToUser.value = value;
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 51,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.toNamed(
                                        AppRoutes.editHistoryChangesData,
                                        arguments: {'history': data});
                                  },
                                  style: ButtonStyle(
                                    shadowColor: WidgetStatePropertyAll(
                                        Colors.transparent),
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppColors.bgInfo),
                                    foregroundColor:
                                        WidgetStatePropertyAll(AppColors.info),
                                    overlayColor:
                                        WidgetStatePropertyAll(Colors.black12),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Icon(Icons.chat_bubble_outline),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 4),
                                            child: Icon(
                                              Icons.edit,
                                              size: 10,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Edit",
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Container(
                                height: 51,
                                child: ElevatedButton(
                                  onPressed: () {
                                    DeleteBottomSheet(context, () {
                                      historyChangesController
                                          .deleteHistory(data!.id);
                                      historyChangesController.historyList
                                          .refresh();
                                      Get.back();
                                    }, 'Are you sure wanna delete this History?');
                                  },
                                  style: ButtonStyle(
                                    shadowColor: WidgetStatePropertyAll(
                                        Colors.transparent),
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppColors.bgDanger),
                                    foregroundColor: WidgetStatePropertyAll(
                                        AppColors.danger),
                                    overlayColor:
                                        WidgetStatePropertyAll(Colors.black12),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Ionicons.trash_outline),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        "Delete",
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
