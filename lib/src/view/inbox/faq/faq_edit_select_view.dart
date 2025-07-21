import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../../../constant/fontstyle.dart';
import '../../../controllers/inbox/faq/edit_faq_controller.dart';
import '../../../utils/color.dart';
import '../../../widgets/custom_submit_button.dart';
import '../../../widgets/default_appbar.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/tag_button.dart';

class FaqEditSelectView extends StatefulWidget {
  final String title;
  final String data;
  final bool isMultipleChoice;
  // final bool isActivity;
  // final bool isHistory;
  // final bool isContactForm;
  final int? index;
  const FaqEditSelectView({
    super.key,
    required this.title,
    required this.data,
    required this.isMultipleChoice,
    // required this.isActivity,
    // required this.isHistory,
    // required this.isContactForm,
    this.index,
  });

  @override
  State<FaqEditSelectView> createState() => _FaqEditSelectViewState();
}

class _FaqEditSelectViewState extends State<FaqEditSelectView> {
  late final List<Map<String, String>> choice;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  Rx<Map<String, String>?> tempData = Rx<Map<String, String>?>(null);
  Rx<List<Map<String, String>>> tempMapData = Rx<List<Map<String, String>>>([]);
  Rx<bool> canSelect = Rx<bool>(false);

  final controller = Get.find<EditFaqController>();
  // final contactController = Get.find<ClientPicContactController>();
  // final historyController = Get.find<EditHistoryFaqController>();

  @override
  void initState() {
    super.initState();
    // choice = widget.isContactForm
    //     ? contactController.getList(widget.data)
    //     : widget.isHistory
    //         ? historyController.getList(widget.data)
    //         :
    choice = controller.getList(widget.data);
    ever(tempData, (_) => _updateCanSelect());
    ever(tempMapData, (_) => _updateCanSelect());
  }

  void _updateCanSelect() {
    canSelect.value = tempData.value != null || tempMapData.value.isNotEmpty;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredChoice = choice.where((data) {
      return (data['label'] ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
          (data['value'] ?? '').toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: defaultAppBar('Select ${widget.title}'),
      backgroundColor: AppColors.scaffoldBgColor2,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: searchController,
                onChanged: (value) async {
                  await Future.delayed(Durations.extralong3, () => setState(() => searchQuery = value));
                },
                style: regular.copyWith(fontSize: 12),
                decoration: InputDecoration(
                  hintText: "Search ${widget.title}",
                  hintStyle: regular.copyWith(fontSize: 12, color: AppColors.text_4),
                  prefixIcon: const Icon(Ionicons.search_outline, size: 18),
                  isDense: true,
                  contentPadding: const EdgeInsets.only(top: 0, bottom: 5),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.primary, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  focusColor: AppColors.primary,
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: AppColors.text_3, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (widget.isMultipleChoice) ...[
                Obx(
                  () {
                    if (tempMapData.value.isNotEmpty) {
                      return SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: tempMapData.value.length,
                          itemBuilder: (context, index) {
                            final data = tempMapData.value[index];
                            return TagButton(
                              statusLabel: data['label'] ?? "-",
                              onPressed: () {
                                tempMapData.value.remove(data);
                                tempMapData.refresh();
                              },
                            );
                          },
                        ),
                      );
                    }

                    return Container();
                  },
                ),
                const SizedBox(height: 8),
              ],
              Text(
                'Select ${widget.title}',
                style: regular.copyWith(fontSize: 10, color: AppColors.text_3),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: filteredChoice.isEmpty
                    ? const EmptyState()
                    : ListView.builder(
                        itemCount: filteredChoice.length,
                        itemBuilder: (context, index) {
                          final data = filteredChoice[index];

                          return GestureDetector(
                            onTap: () {
                              if (widget.isMultipleChoice) {
                                if (tempMapData.value.contains(data)) {
                                  tempMapData.value.remove(data);
                                } else {
                                  tempMapData.value.add(data);
                                }
                                tempMapData.refresh();
                              } else {
                                if (tempData.value == data) {
                                  tempData.value = null;
                                } else {
                                  tempData.value = data;
                                }
                              }
                            },
                            child: Obx(
                              () {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: (widget.isMultipleChoice)
                                        ? (tempMapData.value.contains(data) ? AppColors.bgPrimary : AppColors.white_1)
                                        : (tempData.value == data)
                                            ? AppColors.bgPrimary
                                            : AppColors.white_1,
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  child: Text(
                                    data['label'] ?? '',
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
                () {
                  return CustomSubmitButton(
                    onTap: () {
                      // if (widget.isActivity) {
                      //   controller.setActivityValue(
                      //     data: widget.data,
                      //     index: widget.index!,
                      //     value: widget.isMultipleChoice ? tempMapData.value : tempData.value,
                      //   );
                      // } else if (widget.isContactForm) {
                      //   contactController.setValue(
                      //     data: widget.data,
                      //     value: widget.isMultipleChoice ? tempMapData.value : tempData.value,
                      //   );
                      // } else if (widget.isHistory) {
                      //   historyController.setValue(
                      //     data: widget.data,
                      //     value: widget.isMultipleChoice ? tempMapData.value : tempData.value,
                      //   );
                      // } else {
                      controller.setValue(
                        data: widget.data,
                        value: widget.isMultipleChoice ? tempMapData.value : tempData.value,
                      );
                      // }
                      Get.back();
                    },
                    isDisabled: !canSelect.value,
                    title: 'Select',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
