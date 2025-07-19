import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/historical_lead/historical_lead_controller.dart';
import '../../constant/fontstyle.dart';
import '../../routes.dart';
import '../../utils/color.dart';
import '../../utils/toast.dart';
import '../../widgets/custom_select_field.dart';
import '../../widgets/custom_submit_button.dart';
import '../../widgets/default_appbar.dart';
import '../../widgets/inbox_add_field.dart';

class HistoricalLeadView extends StatefulWidget {
  const HistoricalLeadView({super.key});

  @override
  State<HistoricalLeadView> createState() => _HistoricalLeadViewState();
}

class _HistoricalLeadViewState extends State<HistoricalLeadView> {
  final HistoricalLeadController controller = Get.find<HistoricalLeadController>();

  @override
  void initState() {
    super.initState();
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar('Leads Historical Data New', titleSpacing: 0),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          InboxAddField(
            title: 'Select Filter Data Range 1',
            child: Row(
              children: [
                Expanded(
                  child: InboxAddField(
                    title: 'Year',
                    child: CustomSelectField(
                      onTap: () => Get.toNamed(
                        AppRoutes.historicalLeadSelect,
                        arguments: {
                          'data': HistoricalLeadSelectType.year,
                          'index': 1,
                        },
                      ),
                      child: Obx(
                        () => InboxTextOnField(
                          title: 'Select Year',
                          selected: controller.year1.value,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: InboxAddField(
                    title: 'Month',
                    child: CustomSelectField(
                      onTap: () => Get.toNamed(
                        AppRoutes.historicalLeadSelect,
                        arguments: {
                          'data': HistoricalLeadSelectType.month,
                          'index': 1,
                        },
                      ),
                      child: Obx(
                        () => InboxTextOnField(
                          title: 'Select Month',
                          selected: controller.month1.value,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          InboxAddField(
            title: 'Select Filter Data Range 2',
            child: Row(
              children: [
                Expanded(
                  child: InboxAddField(
                    title: 'Year',
                    child: CustomSelectField(
                      onTap: () => Get.toNamed(
                        AppRoutes.historicalLeadSelect,
                        arguments: {
                          'data': HistoricalLeadSelectType.year,
                          'index': 2,
                        },
                      ),
                      child: Obx(
                        () => InboxTextOnField(
                          title: 'Select Year',
                          selected: controller.year2.value,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: InboxAddField(
                    title: 'Month',
                    child: CustomSelectField(
                      onTap: () => Get.toNamed(
                        AppRoutes.historicalLeadSelect,
                        arguments: {
                          'data': HistoricalLeadSelectType.month,
                          'index': 2,
                        },
                      ),
                      child: Obx(
                        () => InboxTextOnField(
                          title: 'Select Month',
                          selected: controller.month2.value,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Button Search
          Obx(
            () => controller.isLoading.value
                ? const CustomLoadingButton()
                : CustomSubmitButton(
                    title: 'Search',
                    onTap: () {
                      if (controller.isDatePairFilled()) {
                        controller.submit();
                      } else {
                        showErrorToast("Please fill in one of the month and year combinations!");
                      }
                    },
                  ),
          ),

          const SizedBox(height: 30),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Result",
                style: bold.copyWith(fontSize: 18, color: AppColors.text_1),
              ),
              const SizedBox(height: 14),
              Obx(
                () {
                  return controller.isLoading.value
                      ? const Center(child: CustomLoading())
                      : Row(
                          children: [
                            if (controller.historicalData1.value != null) ...[
                              ResultDataHistoricalWidget(
                                index: 1,
                                year: controller.year1.value?['label'] ?? '-',
                                month: controller.month1.value?['label'] ?? '-',
                              )
                            ],
                            if (controller.historicalData2.value != null) ...[
                              ResultDataHistoricalWidget(
                                index: 2,
                                year: controller.year2.value?['label'] ?? '-',
                                month: controller.month2.value?['label'] ?? '-',
                              )
                            ],
                          ],
                        );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ResultDataHistoricalWidget extends StatefulWidget {
  final int index;
  final String year;
  final String month;
  const ResultDataHistoricalWidget({
    super.key,
    required this.index,
    required this.year,
    required this.month,
  });

  @override
  State<ResultDataHistoricalWidget> createState() => _ResultDataHistoricalWidgetState();
}

class _ResultDataHistoricalWidgetState extends State<ResultDataHistoricalWidget> {
  final HistoricalLeadController controller = Get.find<HistoricalLeadController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Data Range ${widget.index}",
            style: bold.copyWith(fontSize: 15, color: AppColors.text_1),
          ),
          const SizedBox(height: 12),
          Text(
            "${widget.month} ${widget.year}",
            style: regular.copyWith(fontSize: 13, color: AppColors.text_3),
          ),
          const SizedBox(height: 8),
          Container(
            padding:
                widget.index == 1 ? const EdgeInsets.fromLTRB(5, 10, 0, 10) : const EdgeInsets.fromLTRB(0, 10, 5, 10),
            decoration: const BoxDecoration(
              color: AppColors.white_1,
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(15, 0, 0, 0),
                  offset: Offset(4, 4),
                  blurRadius: 5,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "All Data",
                  style: bold.copyWith(fontSize: 14, color: AppColors.text_1),
                ),
                const SizedBox(height: 5),
                Text(
                  (widget.index == 1)
                      ? controller.historicalData1.value?.total.toString() ?? ''
                      : controller.historicalData2.value?.total.toString() ?? '',
                  style: regular.copyWith(fontSize: 13, color: AppColors.text_3),
                ),
                const Divider(),
                Text(
                  "Isi Form User",
                  style: bold.copyWith(fontSize: 14, color: AppColors.text_1),
                ),
                const SizedBox(height: 5),
                Text(
                  (widget.index == 1)
                      ? controller.historicalData1.value!.formUser.toString()
                      : controller.historicalData2.value!.formUser.toString(),
                  style: regular.copyWith(fontSize: 13, color: AppColors.text_3),
                ),
                const Divider(),
                Text(
                  "Google Ads",
                  style: bold.copyWith(fontSize: 14, color: AppColors.text_1),
                ),
                const SizedBox(height: 5),
                Text(
                  (widget.index == 1)
                      ? controller.historicalData1.value!.googleAds.toString()
                      : controller.historicalData2.value!.googleAds.toString(),
                  style: regular.copyWith(fontSize: 13, color: AppColors.text_3),
                ),
                const Divider(),
                Text(
                  "Meta Ads",
                  style: bold.copyWith(fontSize: 14, color: AppColors.text_1),
                ),
                const SizedBox(height: 5),
                Text(
                  (widget.index == 1)
                      ? controller.historicalData1.value!.metaAds.toString()
                      : controller.historicalData2.value!.metaAds.toString(),
                  style: regular.copyWith(fontSize: 13, color: AppColors.text_3),
                ),
                const Divider(),
                Text(
                  "Isi Mkt Sendiri",
                  style: bold.copyWith(fontSize: 14, color: AppColors.text_1),
                ),
                const SizedBox(height: 5),
                Text(
                  (widget.index == 1)
                      ? controller.historicalData1.value!.marketing.toString()
                      : controller.historicalData2.value!.marketing.toString(),
                  style: regular.copyWith(fontSize: 13, color: AppColors.text_3),
                ),
                const Divider(),
              ],
            ),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
