import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/fontstyle.dart';
import '../../controllers/historical_lead/historical_lead_controller.dart';
import '../../utils/color.dart';
import '../../utils/string_utils.dart';
import '../../widgets/custom_submit_button.dart';
import '../../widgets/default_appbar.dart';

class HistoricalLeadSelectView extends StatefulWidget {
  final HistoricalLeadSelectType data;
  final int index;
  const HistoricalLeadSelectView({
    super.key,
    required this.data,
    required this.index,
  });

  @override
  State<HistoricalLeadSelectView> createState() => _HistoricalLeadSelectViewState();
}

class _HistoricalLeadSelectViewState extends State<HistoricalLeadSelectView> {
  final HistoricalLeadController controller = Get.find<HistoricalLeadController>();

  Rx<Map<String, String>?> temporaryData = Rx<Map<String, String>?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar(capitalizeFirstLetter(widget.data.name), titleSpacing: 0),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.white_1,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: controller.getData(widget.data).length,
                  itemBuilder: (context, index) {
                    final point = controller.getData(widget.data)[index];

                    return GestureDetector(
                      onTap: () {
                        if (temporaryData.value == null) {
                          temporaryData.value = point;
                        } else {
                          if (temporaryData.value != point) {
                            temporaryData.value = point;
                          } else {
                            temporaryData.value = null;
                          }
                        }
                      },
                      child: Obx(
                        () {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: temporaryData.value == point ? AppColors.bgPrimary : AppColors.white_1,
                            ),
                            child: Text(
                              point['label'] ?? "-",
                              style: regular.copyWith(fontSize: 13, color: AppColors.text_1),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              CustomSubmitButton(
                title: 'Select',
                onTap: () {
                  if (temporaryData.value != null) {
                    controller.setValue(
                      data: widget.data,
                      index: widget.index,
                      value: temporaryData.value ?? {},
                    );
                    Get.back();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
