import 'package:cmlabs_connect/src/controllers/account_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../../routes.dart';
import '../../../utils/bottom_sheet.dart';
import '../../../utils/color.dart';

class CertificationView extends StatelessWidget {
  CertificationView({super.key});

  final AccountController accountController = Get.put(AccountController());

  @override
  Widget build(BuildContext context) {
    accountController.fetchCertification();

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFFF9F9F9),
        surfaceTintColor: Color(0xFFF9F9F9),
        title: Text(
          "Certification",
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
          child: Obx(
            () {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  (accountController.certificationList.value.isEmpty)
                      ? Container(
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
                                "Certification",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text_2,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Text(
                                "-",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: AppColors.text_2,
                                ),
                              )
                            ],
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount:
                              accountController.certificationList.value.length,
                          itemBuilder: (context, index) {
                            final certification = accountController
                                .certificationList.value[index];
                            return Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(bottom: 16),
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
                                    certification?.name ?? '-',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.text_2,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 14,
                                  ),
                                  Text(
                                    "${certification?.url ?? "-"} | ${certification?.institutionName ?? "-"}",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: AppColors.text_2,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "${certification?.startTime != null ? DateFormat('d MMM yyyy').format(certification!.startTime) : "-"}"
                                    " until "
                                    "${certification?.finishTime != null ? DateFormat('d MMM yyyy').format(certification!.finishTime!) : "now"}",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: AppColors.text_2,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Description",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14,
                                      color: AppColors.text_2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "${certification?.description ?? "-"}",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13,
                                      color: AppColors.text_2,
                                    ),
                                  ),
                                  Container(
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
                                                      AppRoutes
                                                          .formCertificationnView,
                                                      arguments: {
                                                        "status": "edit",
                                                        "id": certification!.id
                                                      },
                                                    );
                                                  },
                                                  style: ButtonStyle(
                                                    shadowColor:
                                                        WidgetStatePropertyAll(
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
                                                    shape:
                                                        WidgetStatePropertyAll(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          Icon(Icons
                                                              .chat_bubble_outline),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
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
                                                        style: GoogleFonts
                                                            .plusJakartaSans(
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
                                                        "Are you sure wanna delete this Certification?";

                                                    DeleteBottomSheet(context,
                                                        () {
                                                      accountController
                                                          .deleteCertification(
                                                              certification!
                                                                  .id);
                                                      Get.back();
                                                    }, message);
                                                  },
                                                  style: ButtonStyle(
                                                    shadowColor:
                                                        WidgetStatePropertyAll(
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
                                                    shape:
                                                        WidgetStatePropertyAll(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
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
                                                        style: GoogleFonts
                                                            .plusJakartaSans(
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
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    height: 51,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(
                          AppRoutes.formCertificationnView,
                          arguments: {"status": "add", "id": null},
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(AppColors.primary),
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
                            "Add Certification",
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
