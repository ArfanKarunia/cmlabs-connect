import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../constant/const.dart';
import '../constant/fontstyle.dart';
import '../controllers/filter/filter_controller.dart';
import '../controllers/inbox/inbox_controller.dart';
import '../routes.dart';
import '../utils/color.dart';

class SelectStatus extends StatelessWidget {
  final List<InboxController> controllers;
  final bool enableFilter;
  final bool enableHistory;

  const SelectStatus({
    super.key,
    required this.controllers,
    this.enableFilter = false,
    this.enableHistory = false,
  });

  @override
  Widget build(BuildContext context) {
    final FilterController filterController = Get.find<FilterController>();

    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Obx(
              () {
                String? statusSelected = controllers.firstOrNull?.filterStatus.value;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Menjadikan scroll horizontal
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 25,
                        child: GestureDetector(
                          onTap: () {
                            for (InboxController controller in controllers) {
                              controller.clearFilterStatus();
                              controller.fetchList();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: statusSelected == null ? AppColors.primary : AppColors.inactiveOption,
                            ),
                            child: Center(
                              child: Text(
                                'Recently',
                                style: regular.copyWith(
                                  color: statusSelected == null ? AppColors.white : AppColors.text_3,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        height: 25,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal, // Scroll horizontal
                          itemCount: statusLead.length,
                          itemBuilder: (context, index) {
                            final status = statusLead[index];
                            bool selected = statusSelected == status.query;

                            if (status.isEnabled) {
                              return GestureDetector(
                                onTap: () {
                                  for (InboxController controller in controllers) {
                                    controller.addFilterStatus(status.query.toString());
                                    controller.fetchList();
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: selected ? AppColors.primary : AppColors.inactiveOption,
                                  ),
                                  child: Center(
                                    child: Text(
                                      status.title,
                                      style: regular.copyWith(
                                        fontSize: 11,
                                        color: selected ? AppColors.white : AppColors.text_3,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }

                            return Container();
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          if (enableFilter) const SizedBox(width: 10),

          // Filter Section button & Historical Lead Button
          Row(
            children: [
              if (enableFilter)
                Obx(
                  () => GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.filter),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(2.5),
                          child: Icon(
                            Ionicons.options_outline,
                            color: AppColors.text_1,
                          ),
                        ),
                        if (filterController.isFilterApplied)
                          const Align(
                            alignment: Alignment.topRight,
                            child: CircleAvatar(radius: 4, backgroundColor: AppColors.primary),
                          ),
                      ],
                    ),
                  ),
                ),
              // if (enableFilter && enableHistory) const SizedBox(width: 14),
              // if (enableHistory)
              //   CustomButton(
              //     onPressed: () => Get.toNamed(AppRoutes.historicalLead),
              //     backgroundColor: Colors.transparent,
              //     overlayColor: const Color.fromARGB(33, 31, 149, 245),
              //     child: const Icon(
              //       Icons.history,
              //       color: AppColors.text_1,
              //     ),
              //   ),
            ],
          ),
        ],
      ),
    );
  }
}
