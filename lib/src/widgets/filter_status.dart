import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quotation_app/src/constant/const.dart';
import 'package:quotation_app/src/controllers/quotation_controller.dart';
import 'package:quotation_app/src/utils/color.dart';

class SelectStatus extends StatelessWidget {
  SelectStatus({
    super.key, required this.controller,
  });

  QuotationController controller;

  @override
  Widget build(BuildContext context) {
    controller = Get.find();

    return Obx(
      () => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 25,
            child: GestureDetector(
              onTap: () => controller.setFilter(null),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: (controller.filter.value == null)
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.primary,
                      )
                    : BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: AppColors.white,
                        border: Border.all(
                          color: AppColors.primaryText,
                          width: 1,
                        ),
                      ),
                child: Center(
                  child: Text(
                    'All',
                    style: (controller.filter.value == null)
                        ? const TextStyle(
                            fontSize: 10,
                            color: AppColors.white,
                          )
                        : const TextStyle(
                            fontSize: 10,
                            color: AppColors.primaryText,
                          ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
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

                  switch (status) {
                    case StatusLead.newLead:
                      label = 'New';
                      break;
                    case StatusLead.followedUp:
                      label = 'Followed Up';
                      break;
                    case StatusLead.accepted:
                      label = 'Accepted';
                      break;
                    case StatusLead.rejected:
                      label = 'Rejected';
                      break;
                  }

                  return Container(
                    padding: const EdgeInsets.only(right: 5),
                    child: GestureDetector(
                      onTap: () =>
                          controller.setFilter(StatusLead.values[index]),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        decoration: (controller.filter.value ==
                                StatusLead.values[index])
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.primary,
                              )
                            : BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: AppColors.white,
                                border: Border.all(
                                  color: AppColors.primaryText,
                                  width: 1,
                                ),
                              ),
                        child: Center(
                          child: Text(
                            label,
                            style: (controller.filter.value ==
                                    StatusLead.values[index])
                                ? const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.white,
                                  )
                                : const TextStyle(
                                    fontSize: 10,
                                    color: AppColors.primaryText,
                                  ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
