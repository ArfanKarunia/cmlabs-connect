import 'package:cmlabs_connect/src/controllers/account_controller.dart';
import 'package:cmlabs_connect/src/routes.dart';
import 'package:cmlabs_connect/src/utils/bottom_sheet.dart';
import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';

class SummaryView extends StatelessWidget {
  SummaryView({super.key});

  final AccountController accountController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    accountController.fetchSpecializationList();
    accountController.fetchSummary();

    print("isi about: ${accountController.about.value}");
    print("ini specialization :${accountController.about.value}");

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFFF9F9F9),
        surfaceTintColor: Color(0xFFF9F9F9),
        title: Text(
          "Summary",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.text_1,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.white_1,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(30, 0, 0, 0),
                      offset: Offset(3, 3),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "About",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text_2,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Obx(
                      () {
                        return Text(
                          accountController.about.value ?? "-",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.text_2,
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      "Spesialization",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.text_2,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Obx(
                      () {
                        return Text(
                          (accountController.specialization.value.isEmpty)
                              ? "-"
                              : accountController.specialization.value
                                  .join(', '),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: AppColors.text_2,
                          ),
                        );
                      },
                    ),
                    Obx(
                      () {
                        if (!(accountController.about.value == null &&
                            accountController.specialization.value.isEmpty)) {
                          return Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 40,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Get.toNamed(
                                              AppRoutes.formSummaryView,
                                              arguments: "edit",
                                            );
                                          },
                                          style: ButtonStyle(
                                            shadowColor: WidgetStatePropertyAll(
                                              Colors.transparent,
                                            ),
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                              AppColors.bgInfo,
                                            ),
                                            foregroundColor:
                                                WidgetStatePropertyAll(
                                              AppColors.info,
                                            ),
                                            overlayColor:
                                                WidgetStatePropertyAll(
                                              Colors.black12,
                                            ),
                                            shape: WidgetStatePropertyAll(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Stack(
                                                alignment: Alignment.center,
                                                children: [
                                                  Icon(Icons
                                                      .chat_bubble_outline),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      bottom: 4,
                                                    ),
                                                    child: Icon(
                                                      Icons.edit,
                                                      size: 10,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Edit",
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            var message =
                                                "Are you sure wanna delete this Summary?";

                                            DeleteBottomSheet(context, () {
                                              accountController.deleteSummary();
                                              accountController.specialization
                                                  .refresh();
                                              Get.back();
                                            }, message);
                                          },
                                          style: ButtonStyle(
                                            shadowColor: WidgetStatePropertyAll(
                                                Colors.transparent),
                                            backgroundColor:
                                                WidgetStatePropertyAll(
                                                    AppColors.bgDanger),
                                            foregroundColor:
                                                WidgetStatePropertyAll(
                                                    AppColors.danger),
                                            overlayColor:
                                                WidgetStatePropertyAll(
                                                    Colors.black12),
                                            shape: WidgetStatePropertyAll(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Ionicons.trash_outline,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                "Delete",
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          );
                        } else {
                          return SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Obx(
                () {
                  return SizedBox(
                    height: 51,
                    child: ElevatedButton(
                      onPressed: () {
                        ((accountController.about.value == null &&
                                accountController.specialization.value.isEmpty))
                            ? Get.toNamed(
                                AppRoutes.formSummaryView,
                                arguments: "add",
                              )
                            : null;
                      },
                      style: ButtonStyle(
                        backgroundColor: (!(accountController.about.value ==
                                    null &&
                                accountController.specialization.value.isEmpty))
                            ? WidgetStatePropertyAll(Color(0xff8FCAFA))
                            : WidgetStatePropertyAll(AppColors.primary),
                        foregroundColor:
                            WidgetStatePropertyAll(AppColors.white_1),
                        overlayColor: WidgetStatePropertyAll(Colors.white30),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Ionicons.add_outline),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Add Summary",
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
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
