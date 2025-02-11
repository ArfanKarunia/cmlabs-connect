import 'package:cmlabs_connect/src/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../constant/const.dart';
import '../constant/fontstyle.dart';
import '../controllers/bottom_nav_controller.dart';
import '../controllers/quotation_controller.dart';
import '../routes.dart';
import '../utils/color.dart';

// ignore: must_be_immutable
class SelectStatus extends StatelessWidget {
  SelectStatus({
    super.key,
    required this.controller,
    this.isFilterButton = false,
    this.isHistoricalLeadButton = false,
    this.isNewLead = true,
    this.isFollowedUp = true,
    this.isAccepted = true,
    this.isRejected = true,
    this.isOnHold = false,
  });

  QuotationController controller;
  final bool isFilterButton;
  final bool isHistoricalLeadButton;
  final bool isNewLead;
  final bool isFollowedUp;
  final bool isAccepted;
  final bool isRejected;
  final bool isOnHold;

  final BottomNavController navController = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    controller = Get.find();

    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Obx(
              () => SingleChildScrollView(
                scrollDirection: Axis.horizontal, // Menjadikan scroll horizontal
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 25,
                      child: GestureDetector(
                        onTap: () {
                          controller.clearFilterStatus();
                          controller.fetchQuotationData(refreshData: true);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: controller.filterStatus.value == null ? AppColors.primary : AppColors.inactiveOption,
                          ),
                          child: Center(
                            child: Text(
                              'Recently',
                              style: regular.copyWith(
                                color: controller.filterStatus.value == null ? AppColors.white : AppColors.text_3,
                                fontSize: 11,
                              ),
                            ),
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
                                      controller.fetchQuotationData(refreshData: true);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        color: controller.filterStatus.value == StatusLead.values[index]
                                            ? AppColors.primary
                                            : AppColors.inactiveOption,
                                      ),
                                      child: Center(
                                        child: Text(
                                          label,
                                          style: regular.copyWith(
                                            color: (controller.filterStatus.value == StatusLead.values[index])
                                                ? AppColors.white
                                                : AppColors.text_3,
                                            fontSize: 11,
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
                        onPressed: () => Get.toNamed(AppRoutes.filter),
                        backgroundColor: Colors.transparent,
                        overlayColor: const Color.fromARGB(33, 31, 149, 245),
                        child: const Icon(
                          Ionicons.options_outline,
                          color: AppColors.text_1,
                        ),
                      )
                    : Container(),
                const SizedBox(
                  width: 14,
                ),
                (isHistoricalLeadButton)
                    ? CustomButton(
                        onPressed: () => Get.toNamed(AppRoutes.historicalLead),
                        backgroundColor: Colors.transparent,
                        overlayColor: const Color.fromARGB(33, 31, 149, 245),
                        child: const Icon(
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
