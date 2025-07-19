import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/fontstyle.dart';
import '../../controllers/account/account_controller.dart';
import '../../utils/color.dart';
import '../../utils/string_utils.dart';
import '../../widgets/custom_submit_button.dart';
import '../../widgets/default_appbar.dart';

class AccountSelectView extends StatefulWidget {
  final AccountSelectData data;
  const AccountSelectView({super.key, required this.data});

  @override
  State<AccountSelectView> createState() => _AccountSelectViewState();
}

class _AccountSelectViewState extends State<AccountSelectView> {
  final AccountController controller = Get.find<AccountController>();

  Rx<Map<String, dynamic>?> temporaryData = Rx<Map<String, dynamic>?>(null);

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
                              point['name'] ?? "-",
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
                    controller.setValue(data: widget.data, value: temporaryData.value);
                    Get.back();
                  }
                },
              ),
              // Container(
              //   width: double.infinity,
              //   margin: EdgeInsets.only(bottom: 100),
              //   height: 51,
              //   child: ElevatedButton(
              //     onPressed: () {
              //       controller.setValue(data: widget.data, value: temporaryData.value ?? {});
              //       Get.back();
              //     },
              //     style: ButtonStyle(
              //       backgroundColor: WidgetStatePropertyAll(AppColors.primary),
              //       foregroundColor: WidgetStatePropertyAll(AppColors.white_1),
              //       overlayColor: WidgetStatePropertyAll(Colors.white24),
              //       shape: WidgetStatePropertyAll(
              //         RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(5),
              //         ),
              //       ),
              //     ),
              //     child: Text(
              //       "Select",
              //       style: bold.copyWith(
              //         fontSize: 14,
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
