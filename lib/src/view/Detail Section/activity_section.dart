import 'package:cmlabs_connect/src/controllers/activity_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../controllers/detail_quotation_controller.dart';
import '../../utils/color.dart';
import '../../widgets/tag_button.dart';
import '../edit_quotation_view.dart';

class ActivitySection extends StatelessWidget {
  ActivitySection({
    super.key,
  });

  final DetailQuotationController detailQuotationController =
      Get.put(DetailQuotationController());

  final ActivityController activityController = Get.put(ActivityController());

  @override
  Widget build(BuildContext context) {
    print("meeting type ${activityController.selectedTypeActivity.value[0]}");
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Activity",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.text_1,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Obx(
              () {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: activityController.meetingTopic.value.length,
                  itemBuilder: (context, index) {
                    var topicController =
                        activityController.meetingTopic.value[index];
                    var scheduleController =
                        activityController.meetingSchedule.value[index];
                    var noteController =
                        activityController.meetingNote.value[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Topic/Name",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text_3,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: topicController,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: AppColors.text_1,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: AppColors.primary,
                              ),
                            ),
                            hintStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.text_4),
                            hintText: "Topic",
                            errorStyle: GoogleFonts.plusJakartaSans(
                                color: AppColors.danger,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          "Meeting Schedule",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text_3,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: scheduleController,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(
                                FocusNode()); // Hapus fokus untuk menghindari keyboard tampil
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );

                            if (selectedDate != null) {
                              final formattedDate =
                                  DateFormat('dd-MM-yyyy').format(selectedDate);
                              scheduleController.text =
                                  formattedDate; // Setel tanggal yang dipilih
                            }
                          },
                          onChanged: (value) {
                            // Tampilkan nilai yang dipilih
                            print(
                                "Updated schedule: ${scheduleController.text}");
                          },
                          readOnly: true,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: AppColors.text_1,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: AppColors.primary,
                              ),
                            ),
                            hintStyle: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.text_4,
                            ),
                            hintText: "Meeting Schedule",
                            errorStyle: GoogleFonts.plusJakartaSans(
                              color: AppColors.danger,
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                            suffixIcon: Icon(
                              Ionicons.calendar_outline,
                              color: AppColors.text_1,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SelectField(
                          name: "Status",
                          child: Obx(
                            () {
                              return 
                              (activityController.selectedStatusActivity.value[index] != null && activityController.selectedStatusActivity.value[index]?['label'] != null)
                                  ? Text(
                                      "${activityController.selectedStatusActivity.value[index]?['label']}",
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        color: AppColors.text_1,
                                      ),
                                    )
                                  : Text(
                                      "Select status",
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 13,
                                        color: AppColors.text_3,
                                      ),
                                    );
                            },
                          ),
                          onPressed: () {
                            Get.toNamed(
                              "/editSelect",
                              arguments: {
                                'selectData': "status_activity",
                                'controller': activityController,
                              },
                            )?.then(
                              (value) {
                                activityController.addStatus(index, value);
                                activityController.selectedStatusActivity
                                    .refresh();
                              },
                            );
                            
                            // activityController.selectedStatusActivity.trigger(null);
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SelectField(
                          name: "Type",
                          child: Obx(
                            () {
                              if (activityController
                                  .selectedTypeActivity.value[index].isEmpty) {
                                return Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Select type",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: AppColors.text_3,
                                    ),
                                  ),
                                );
                              } else {
                                return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: activityController
                                      .selectedTypeActivity.value[index].length,
                                  itemBuilder: (context, index2) {
                                    final type = activityController
                                        .selectedTypeActivity
                                        .value[index][index2];
                                    print("data type : $type");
                                    return Row(
                                      children: [
                                        TagButton(
                                          statusLabel: type?['label'] ?? '-',
                                          onPressed: () {
                                            activityController.deleteType(
                                                index, type!);
                                            activityController
                                                .selectedTypeActivity
                                                .refresh();
                                          },
                                        ),
                                        (type?.length == index2)
                                            ? SizedBox(
                                                width: 50,
                                              )
                                            : SizedBox()
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                          ),
                          onPressed: () {
                            Get.toNamed(
                              "/editSelect",
                              arguments: {
                                'selectData': "type_activity",
                                'controller': activityController,
                              },
                            )?.then(
                              (value) {
                                for (var data in value) {
                                  activityController.addType(index, data);
                                }
                                activityController.selectedTypeActivity
                                    .refresh();
                              },
                            );
                          },
                        ),
                        const SizedBox(
                          height: 8,
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
                                      trackColor: (!activityController
                                              .isAvailableToUser[index])
                                          ? WidgetStatePropertyAll(
                                              Color(0xFFD8DAE5))
                                          : WidgetStatePropertyAll(
                                              AppColors.primary),
                                      value: activityController
                                          .isAvailableToUser[index],
                                      onChanged: (bool value) {
                                        activityController
                                            .isAvailableToUser[index] = value;
                                        print(activityController
                                            .isAvailableToUser[index]);
                                      },
                                    ),
                                  ),
                                );
                              },
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Note",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.text_3,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: noteController,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            color: AppColors.text_1,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                width: 2,
                                color: AppColors.primary,
                              ),
                            ),
                            hintStyle: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.text_4),
                            hintText: "Note",
                            errorStyle: GoogleFonts.plusJakartaSans(
                                color: AppColors.danger,
                                fontSize: 12,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        (activityController.meetingTopic.value.length > 1)
                            ? Container(
                                height: 51,
                                child: ElevatedButton(
                                  onPressed: () {
                                    activityController.deleteActivity(index);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        const WidgetStatePropertyAll(
                                      AppColors.bgDanger,
                                    ),
                                    foregroundColor:
                                        const WidgetStatePropertyAll(
                                      AppColors.danger,
                                    ),
                                    overlayColor: const WidgetStatePropertyAll(
                                      Colors.black12,
                                    ),
                                    shadowColor: WidgetStatePropertyAll(
                                      Colors.transparent,
                                    ),
                                    shape: WidgetStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Ionicons.trash_outline,
                                        size: 20,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Delete activity ${index + 1}",
                                        style: GoogleFonts.plusJakartaSans(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                        const SizedBox(
                          height: 10,
                        ),
                        Divider(),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            Container(
              height: 51,
              child: ElevatedButton(
                onPressed: () {
                  activityController.addMoreActivity();
                },
                style: ButtonStyle(
                  backgroundColor:
                      const WidgetStatePropertyAll(AppColors.white_1),
                  foregroundColor:
                      const WidgetStatePropertyAll(AppColors.primary),
                  overlayColor: const WidgetStatePropertyAll(Colors.white30),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      side:
                          const BorderSide(color: AppColors.primary, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Ionicons.add_outline),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Add More Activity",
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Remarks",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.text_3,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: activityController.remarksMeeting,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppColors.text_1,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: AppColors.primary,
                  ),
                ),
                hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.text_4),
                hintText: "Remarks",
                errorStyle: GoogleFonts.plusJakartaSans(
                    color: AppColors.danger,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              "Additional Notes",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.text_3,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: activityController.addtionalNoteMeeting,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: AppColors.text_1,
                fontWeight: FontWeight.w400,
              ),
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: AppColors.primary,
                  ),
                ),
                hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.text_4),
                hintText: "Additional Notes",
                errorStyle: GoogleFonts.plusJakartaSans(
                    color: AppColors.danger,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
