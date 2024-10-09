import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:quotation_app/src/constant/const.dart';
import 'package:quotation_app/src/controllers/bottom_nav_controller.dart';
import 'package:quotation_app/src/controllers/quotation_controller.dart';
import 'package:quotation_app/src/utils/color.dart';

class SelectStatus extends StatelessWidget {
  SelectStatus({
    super.key,
    required this.controller,
    this.isFilterButton = false,
    this.isViewAllButton = false,
    this.isNewLead = true,
    this.isFollowedUp = true,
    this.isAccepted = true,
    this.isRejected = true,
  });

  QuotationController controller;
  final bool isFilterButton;
  final bool isViewAllButton;
  final bool isNewLead;
  final bool isFollowedUp;
  final bool isAccepted;
  final bool isRejected;

  final BottomNavController navController = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    controller = Get.find();

    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Obx(
              () => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 25,
                    child: GestureDetector(
                      onTap: () => controller.setFilterStatus(null),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 3,
                        ),
                        decoration: (controller.filterStatus.value == null)
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.primary,
                              )
                            : BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.transparent,
                                border: Border.all(
                                  color: AppColors.text_4,
                                  width: 1,
                                ),
                              ),
                        child: Center(
                          child: Text('Recently',
                              style: (controller.filterStatus.value == null)
                                  ? GoogleFonts.plusJakartaSans(
                                      color: AppColors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                    )
                                  : GoogleFonts.plusJakartaSans(
                                      color: AppColors.text_4,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                    )),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Flexible(
                    child: SizedBox(
                      height: 25,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: StatusLead.values.length,
                        itemBuilder: (context, index) {
                          final status = StatusLead.values[index];

                          String label;

                          bool shouldShow = false;

                          switch (status) {
                            case StatusLead.newLead:
                              label = 'New';
                              shouldShow = isNewLead;
                              break;
                            case StatusLead.followedUp:
                              label = 'Followed Up';
                              shouldShow = isFollowedUp;
                              break;
                            case StatusLead.accepted:
                              label = 'Accepted';
                              shouldShow = isAccepted;
                              break;
                            case StatusLead.rejected:
                              label = 'Rejected';
                              shouldShow = isRejected;
                              break;
                          }

                          return (!shouldShow)
                              ? Container()
                              : Container(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap: () => controller.setFilterStatus(
                                        StatusLead.values[index]),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 3,
                                      ),
                                      decoration:
                                          (controller.filterStatus.value ==
                                                  StatusLead.values[index])
                                              ? BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: AppColors.primary,
                                                )
                                              : BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  color: Colors.transparent,
                                                  border: Border.all(
                                                    color: AppColors.text_4,
                                                    width: 1,
                                                  ),
                                                ),
                                      child: Center(
                                        child: Text(
                                          label,
                                          style: (controller
                                                      .filterStatus.value ==
                                                  StatusLead.values[index])
                                              ? GoogleFonts.plusJakartaSans(
                                                  color: AppColors.white,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w400,
                                                )
                                              : GoogleFonts.plusJakartaSans(
                                                  color: AppColors.text_4,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //
          (isFilterButton && isViewAllButton)
              ? Row(
                  children: [
                    //
                    (isFilterButton)
                        ? IconButton(
                            onPressed: () {
                              navController.toggleFilterVisibility();
                            },
                            icon: Icon(
                              Ionicons.options_outline,
                              color: AppColors.text_1,
                            ),
                            style: ButtonStyle(
                              overlayColor: WidgetStatePropertyAll(
                                  const Color.fromARGB(33, 31, 149, 245)),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          )
                        : Container(),

                    //
                    (isViewAllButton)
                        ? GestureDetector(
                            onTap: () {},
                            child: Text(
                              "View all",
                              style: GoogleFonts.plusJakartaSans(
                                decoration: TextDecoration.underline,
                                fontSize: 10,
                                fontWeight: FontWeight.w400,
                                color: AppColors.primary,
                              ),
                            ),
                          )
                        : Container(),
                  ],
                )
              : Container()
        ],
      ),
    );
  }
}
