import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/fontstyle.dart';
import '../../controllers/notification/notification_controller.dart';
import '../../utils/color.dart';
import '../../utils/string_utils.dart';
import '../../widgets/custom_submit_button.dart';
import '../../widgets/default_appbar.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/tag_button.dart';
// import '../../widgets/tag_button.dart';

class NotificationSelectView extends StatefulWidget {
  final String title;
  final NotificationFilterType filter;
  final bool isMultipleChoice;
  const NotificationSelectView({
    super.key,
    required this.title,
    required this.filter,
    this.isMultipleChoice = false,
  });

  @override
  State<NotificationSelectView> createState() => _NotificationSelectViewState();
}

class _NotificationSelectViewState extends State<NotificationSelectView> {
  late List<Map<String, String>> data;
  Rx<Map<String, String>?> tempData = Rx<Map<String, String>?>(null);
  RxList<Map<String, String>?> tempDataList = RxList<Map<String, String>?>([]);
  Rx<bool> canSelect = Rx<bool>(false);

  final NotificationController controller = Get.find<NotificationController>();

  @override
  void initState() {
    super.initState();
    ever(tempData, (_) => _updateCanSelect());
    ever(tempDataList, (_) => _updateCanSelect());
    data = controller.getList(widget.filter);
  }

  void _updateCanSelect() {
    canSelect.value = tempData.value != null || tempDataList.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      appBar: defaultAppBar("Select ${capitalizeFirstLetter(widget.title)}", titleSpacing: 0),
      body: SafeArea(
        child: Stack(
          children: [
            ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              children: [
                // if (widget.canSearch) ...[
                //   Container(
                //     height: 45,
                //     alignment: AlignmentDirectional.centerStart,
                //     child: TextFormField(
                //       onChanged: (value) {
                //         Timer(Durations.long2, () {
                //           controller.setSearch(value);
                //           setState(() {});
                //         });
                //       },
                //       textAlignVertical: TextAlignVertical.center,
                //       style: regular.copyWith(fontSize: 12),
                //       decoration: InputDecoration(
                //         hintText: "Search ${capitalizeFirstLetter(widget.filter.name)}",
                //         hintStyle: regular.copyWith(fontSize: 12, color: AppColors.text_4),
                //         suffixIcon: const Icon(Ionicons.search_outline, size: 24),
                //         focusColor: AppColors.primary,
                //         focusedBorder: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(5),
                //           borderSide: const BorderSide(color: AppColors.primary, width: 2),
                //         ),
                //         border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(5),
                //           borderSide: const BorderSide(color: AppColors.text_3, width: 1),
                //         ),
                //       ),
                //     ),
                //   ),
                // ],
                if (widget.isMultipleChoice) ...[
                  Obx(
                    () {
                      if (tempDataList.isNotEmpty) {
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: tempDataList.length,
                            itemBuilder: (context, index) {
                              final data = tempDataList[index];
                              String label = data?['label'] ?? "-";

                              return TagButton(
                                statusLabel: label,
                                onPressed: () {
                                  tempDataList.remove(data);
                                  tempDataList.refresh();
                                },
                              );
                            },
                          ),
                        );
                      }

                      return Container();
                    },
                  )
                ],
                // const SizedBox(height: 10),
                // Text(
                //   "Select ${capitalizeFirstLetter(widget.filter.name)}",
                //   style: regular.copyWith(fontSize: 10, color: AppColors.text_4),
                // ),
                // const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white_1,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: data.isEmpty
                      ? Container(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          color: AppColors.scaffoldBgColor2,
                          child: const EmptyState(),
                        )
                      : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final item = data[index];

                            return GestureDetector(
                              onTap: () {
                                if (widget.isMultipleChoice) {
                                  // if (data['value'] == 'all') {
                                  //   if (tempMapData.value.isNotEmpty) {
                                  //     tempMapData.value.clear();
                                  //   }
                                  //   tempMapData.value.add(allData);
                                  // } else
                                  if (tempDataList.contains(item)) {
                                    tempDataList.remove(item);
                                  } else {
                                    if (tempDataList.contains(item)) {
                                      tempDataList.clear();
                                    }
                                    tempDataList.add(item);
                                  }
                                  tempDataList.refresh();
                                } else {
                                  if (tempData.value == item) {
                                    tempData.value = null;
                                  } else {
                                    tempData.value = item;
                                  }
                                }
                              },
                              child: Obx(
                                () {
                                  // Bungkus hanya bagian warna dan teks yang perlu dipantau
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: (widget.isMultipleChoice)
                                          ? (tempDataList.contains(item) ? AppColors.bgPrimary : AppColors.white_1)
                                          : (tempData.value == item)
                                              ? AppColors.bgPrimary
                                              : AppColors.white_1,
                                    ),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    child: Text(
                                      item['label'] ?? "-",
                                      style: regular.copyWith(fontSize: 13),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 20),
                Obx(
                  () => CustomSubmitButton(
                    title: 'Select',
                    isDisabled: !canSelect.value,
                    onTap: () {
                      controller.setValue(
                        filter: widget.filter,
                        value: widget.isMultipleChoice ? tempDataList : tempData.value,
                      );
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
