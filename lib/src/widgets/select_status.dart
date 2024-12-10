import 'package:cmlabs_connect/src/view/historical_lead_view.dart';
import 'package:cmlabs_connect/src/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

import '../constant/const.dart';
import '../controllers/bottom_nav_controller.dart';
import '../controllers/quotation_controller.dart';
import '../utils/color.dart';
import '../view/filter_view.dart';

// ignore: must_be_immutable
class SelectStatus extends StatelessWidget {
  SelectStatus({
    super.key,
    required this.controller,
    this.isFilterButton = false,
    this.isHistorycalLeadButton = false,
    this.isNewLead = true,
    this.isFollowedUp = true,
    this.isAccepted = true,
    this.isRejected = true,
    this.isOnHold = false,
  });

  QuotationController controller;
  final bool isFilterButton;
  final bool isHistorycalLeadButton;
  final bool isNewLead;
  final bool isFollowedUp;
  final bool isAccepted;
  final bool isRejected;
  final bool isOnHold;

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
              () => SingleChildScrollView(
                scrollDirection:
                    Axis.horizontal, // Menjadikan scroll horizontal
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 25,
                      child: GestureDetector(
                        onTap: () => controller.clearFilterStatus(),
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
                                  color: AppColors.inactiveOption,
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
                                        color: AppColors.text_3,
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
                    SizedBox(
                      height: 25,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal, // Scroll horizontal
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
                            case StatusLead.onHold:
                              label = 'On Hold';
                              shouldShow = isOnHold;
                              break;
                          }

                          return (!shouldShow)
                              ? Container()
                              : Container(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      controller.addFilterStatus(status);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 7,
                                        vertical: 3,
                                      ),
                                      decoration: (controller
                                                  .filterStatus.value ==
                                              StatusLead.values[index])
                                          ? BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: AppColors.primary,
                                            )
                                          : BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: AppColors.inactiveOption,
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
                                                  color: AppColors.text_3,
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
                  ],
                ),
              ),
            ),
          ),

          // Filter Section button & Historical Lead Button
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              children: [
                (isFilterButton)
                    ? CustomButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return FilterView();
                              },
                            ),
                          );
                        },
                        backgroundColor: Colors.transparent,
                        overlayColor: Color.fromARGB(33, 31, 149, 245),
                        child: Icon(
                          Ionicons.options_outline,
                          color: AppColors.text_1,
                        ),
                      )
                    : Container(),
                SizedBox(
                  width: 14,
                ),
                (isHistorycalLeadButton)
                    ? CustomButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return HistoricalLeadView();
                              },
                            ),
                          );
                        },
                        backgroundColor: Colors.transparent,
                        overlayColor: Color.fromARGB(33, 31, 149, 245),
                        child: Icon(
                          Icons.history,
                          color: AppColors.text_1,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
