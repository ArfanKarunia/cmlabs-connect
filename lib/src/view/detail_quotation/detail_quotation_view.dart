import 'package:cmlabs_connect/src/controllers/detail_quotation_controller.dart';
import 'package:cmlabs_connect/src/controllers/edit_quotation/edit_quotation_controller.dart';
import 'package:cmlabs_connect/src/controllers/notification_controller.dart';
import 'package:cmlabs_connect/src/controllers/quotation_controller.dart';
import 'package:cmlabs_connect/src/models/quotation_model.dart';
import 'package:cmlabs_connect/src/utils/string_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../utils/color.dart';

class DetailQuotationView extends StatelessWidget {
  DetailQuotationView({super.key});

  final DetailQuotationController detailQuotationController =
      Get.put(DetailQuotationController());

  final NotificationController notificationController =
      Get.put(NotificationController());

  final QuotationController quotationController =
      Get.put(QuotationController());

  final EditQuotationController editQuotationController =
      Get.put(EditQuotationController());

  @override
  Widget build(BuildContext context) {
    // Clear previous data
    editQuotationController.clearSelectedData();
    editQuotationController.clearInitialValue();

    // Fetch the quotation details
    var quotation = detailQuotationController.quotation.value;

    if (quotation != null) {
      detailQuotationController.fetchDetailQuotation(quotation.id);
    }

    notificationController.updateReadParam(quotation!.id);

    detailQuotationController.isShowAll.value = false;

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Color(0xFFF9F9F9),
        surfaceTintColor: Color(0xFFF9F9F9),
        title: Text(
          "Detail Leads",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.text_1,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            children: [
              Obx(
                () {
                  var dataQuotation =
                      detailQuotationController.detailData.value;
                  return Text(
                    dataQuotation?['company'] ?? "N/A",
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.text_1,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                color: AppColors.white_1,
                padding: const EdgeInsets.only(right: 10, left: 10, top: 12),
                width: double.infinity,
                child: Obx(
                  () {
                    // Ambil data detailQuotation, pastikan null check
                    var dataQuotation =
                        detailQuotationController.detailData.value;

                    // Jika dataQuotation null, kembalikan widget kosong
                    if (dataQuotation == null) {
                      return Container();
                    }

                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: (detailQuotationController.isShowAll.value)
                          ? dataQuotation
                              .length // Menampilkan semua data jika isShowAll true
                          : dataQuotation.length > 8
                              ? 8
                              : dataQuotation
                                  .length, // Menampilkan hanya 8 data pertama jika isShowAll false
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // Ambil key berdasarkan index
                        final title = dataQuotation.keys.elementAt(index);
                        // Ambil value terkait key
                        final value = dataQuotation[title];

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              StringUtils.toCamelCase(title),
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.text_1,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              value ?? "-", // Menampilkan '-' jika value null
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.text_1,
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Divider(
                              color: AppColors.text_4,
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              Obx(
                () {
                  return detailQuotationController.isShowAll.value
                      ? Container(
                          color: AppColors.white_1,
                          padding: const EdgeInsets.only(
                            right: 12,
                            left: 12,
                            bottom: 12,
                          ),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  detailQuotationController
                                                  .serviceQuotation.value ==
                                              'social-media-copywriting' ||
                                          detailQuotationController
                                                  .serviceQuotation.value ==
                                              'expert-writing' ||
                                          detailQuotationController
                                                  .serviceQuotation.value ==
                                              "website-copywriting" ||
                                          detailQuotationController
                                                  .serviceQuotation.value ==
                                              "content-writing" ||
                                          detailQuotationController
                                                  .serviceQuotation.value ==
                                              "press-release" ||
                                          detailQuotationController
                                                  .serviceQuotation.value ==
                                              "seo-writing" ||
                                          detailQuotationController
                                                  .serviceQuotation.value ==
                                              "seo-services" ||
                                          (detailQuotationController
                                                      .serviceQuotation.value ==
                                                  'ads' &&
                                              detailQuotationController
                                                      .additionalData
                                                      .value?['proposal'] ==
                                                  null)
                                      ? AdditionalDataWithBottomSheet(
                                          detailQuotationController:
                                              detailQuotationController,
                                          quotation: quotation)
                                      : SizedBox.shrink(),
                                  detailQuotationController
                                                  .serviceQuotation.value ==
                                              'visuwisu' ||
                                          detailQuotationController
                                                  .serviceQuotation.value ==
                                              "development-service" ||
                                          (detailQuotationController
                                                      .serviceQuotation.value ==
                                                  'ads' &&
                                              detailQuotationController
                                                      .additionalData
                                                      .value?['proposal'] !=
                                                  null)
                                      ? AddtionalDataDirect(
                                          detailQuotationController:
                                              detailQuotationController,
                                          quotation: quotation,
                                        )
                                      : SizedBox.shrink(),
                                  detailQuotationController
                                              .serviceQuotation.value ==
                                          'aso-services'
                                      ? AddtionalDataAso(
                                          detailQuotationController:
                                              detailQuotationController,
                                          quotation: quotation)
                                      : SizedBox.shrink()
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                margin: EdgeInsets.only(
                                  right: 8,
                                  left: 8,
                                  bottom: 8,
                                  top: 8,
                                ),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: AppColors.bgPrimary,
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Pitching Duration",
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.text_1,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 6,
                                    ),
                                    Text(
                                      detailQuotationController
                                              .pitchDuration.value ??
                                          '-',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: AppColors.text_1,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.shrink();
                },
              ),
              Obx(
                () {
                  return Container(
                    width: 200,
                    child: TextButton(
                      onPressed: () {
                        detailQuotationController.changeShowValue();
                      },
                      style: ButtonStyle(
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        overlayColor: WidgetStatePropertyAll(Colors.white60),
                        foregroundColor:
                            WidgetStatePropertyAll(AppColors.primary),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (!detailQuotationController.isShowAll.value)
                              ? Text("Show more")
                              : Text("Show less"),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            (!detailQuotationController.isShowAll.value)
                                ? Ionicons.chevron_down_outline
                                : Ionicons.chevron_up_outline,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                height: 51,
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 42),
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed("/editQuotation",
                        arguments: {'quotation': quotation});
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.primary),
                    foregroundColor: WidgetStatePropertyAll(AppColors.white_1),
                    overlayColor: WidgetStatePropertyAll(Colors.white30),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  child: Text(
                    "Edit Data",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddtionalDataDirect extends StatelessWidget {
  const AddtionalDataDirect(
      {super.key,
      required this.detailQuotationController,
      required this.quotation});

  final DetailQuotationController detailQuotationController;
  final Quotation quotation;

  @override
  Widget build(BuildContext context) {
    final section = quotation.section;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              section == 'visuwisu'
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'FROM VISUWISU',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.text_1,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        )
                      ],
                    )
                  : SizedBox.shrink(),
              detailQuotationController.additionalData.value?['proposal'] != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Partnership',
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.text_1,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        )
                      ],
                    )
                  : SizedBox.shrink(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(15, 0, 0, 0),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...detailQuotationController
                              .additionalData.value!.entries
                              .map((entry) {
                            final key = StringUtils.toCamelCase(entry.key);
                            final value = entry.value;

                            // Handle default cases
                            return _buildSimpleText(
                              key,
                              value.toString(),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Button to Open Modal
                ],
              ),
            ],
          ),
        ),
        Divider(
          color: AppColors.text_4,
        ),
      ],
    );
  }
}

class AdditionalDataWithBottomSheet extends StatelessWidget {
  const AdditionalDataWithBottomSheet({
    super.key,
    required this.detailQuotationController,
    required this.quotation,
  });

  final DetailQuotationController detailQuotationController;
  final Quotation quotation;

  @override
  Widget build(BuildContext context) {
    return quotation.data.category.join(', ') != 'new-amber' &&
            detailQuotationController.additionalData.value != null
        ? Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Additional Data',
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.text_1,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Text(
                        "${quotation.data.category.isNotEmpty == true ? quotation.data.category.join(', ') : StringUtils.toCamelCase(quotation.section)}",
                        style: GoogleFonts.plusJakartaSans(
                          color: AppColors.text_1,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Button to Open Modal

                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(AppColors.white_1),
                        foregroundColor:
                            WidgetStatePropertyAll(AppColors.primary),
                        overlayColor:
                            WidgetStatePropertyAll(AppColors.bgPrimary),
                        shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                          side: BorderSide(width: 1, color: AppColors.primary),
                        ))),
                    onPressed: () {
                      if (detailQuotationController.additionalData.value !=
                          null) {
                        _showAdditionalDataModal(
                          context,
                          detailQuotationController.additionalData.value!,
                        );
                      }
                    },
                    child: Text(
                      'View Details',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(
                color: AppColors.text_4,
              ),
            ],
          )
        : SizedBox.shrink();
  }
}

class AddtionalDataAso extends StatelessWidget {
  AddtionalDataAso(
      {super.key,
      required this.detailQuotationController,
      required this.quotation});

  final DetailQuotationController detailQuotationController;
  final Quotation quotation;

  final isShowData = Rx<bool>(false);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "App Name Inputted",
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.text_1,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 6,
        ),
        Obx(
          () {
            return Text(
              StringUtils.toCamelCase(detailQuotationController
                      .additionalData.value?['app_name_inputted']),
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.text_1,
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
            );
          },
        ),
        Divider(
          color: AppColors.text_4,
        ),
        Text(
          'Mobile App Name',
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.text_1,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),

        // Button to Open Modal
        ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(AppColors.white_1),
              foregroundColor: WidgetStatePropertyAll(AppColors.primary),
              overlayColor: WidgetStatePropertyAll(AppColors.bgPrimary),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                  side: BorderSide(width: 1, color: AppColors.primary),
                ),
              ),
            ),
            onPressed: () {
              isShowData.value = !isShowData.value;
            },
            child: Obx(
              () {
                return Text(
                  detailQuotationController.additionalData.value?['app_name'] !=
                          '-'
                      ? '${detailQuotationController.additionalData.value?['app_name'] ?? '-'}'
                      : '-',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                );
              },
            )),
        Obx(
          () {
            return isShowData.value
                ? Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(15, 0, 0, 0),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ...detailQuotationController
                                            .additionalData.value!.entries
                                            .map((entry) {
                                          final key = StringUtils.toCamelCase(
                                              entry.key);
                                          final value = entry.value;

                                          print(entry.key);

                                          if (entry.key == 'icon_App') {
                                            return Center(
                                              child: Container(
                                                height: 50,
                                                width: 50,
                                                margin: EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  image: DecorationImage(
                                                    image: NetworkImage(value),
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                            );
                                          }

                                          // Handle default cases
                                          return _buildSimpleText(
                                            key,
                                            value.toString(),
                                          );
                                        }).toList(),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),

                                // Button to Open Modal
                              ],
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: AppColors.text_4,
                      ),
                    ],
                  )
                : SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

void _showAdditionalDataModal(
    BuildContext context, Map<String, dynamic> additionalData) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Render Additional Data
              ...additionalData.entries
                  .where((entry) =>
                      entry.key != 'package' &&
                      entry.key != 'selected_language') // Skip keys
                  .map((entry) {
                final key = StringUtils.toCamelCase(entry.key);
                final value = entry.value;

                // Handle socmed_platform as a list of links
                if (entry.key == 'socmed_platform' && value is Map) {
                  return _buildOrderedList(key, value);
                }

                if (entry.key == 'social_media_platform' && value is Map) {
                  return _buildOrderedList(key, value);
                }

                // Handle content_type.list and copywriting_style.list
                if ((entry.key == 'content_type' ||
                        entry.key == 'page_type' ||
                        entry.key == 'copywriting_style') &&
                    value is Map &&
                    value['list'] != null) {
                  return _buildSimpleText(
                    key,
                    (value['list'] as String),
                  );
                }

                // Handle default cases
                return _buildSimpleText(
                  key,
                  value ?? "-",
                );
              }).toList(),

              const SizedBox(height: 16),
              // Close Button
              SizedBox(
                height: 51,
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(AppColors.primary),
                    foregroundColor: WidgetStatePropertyAll(AppColors.white_1),
                    overlayColor: WidgetStatePropertyAll(Colors.white30),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close the modal
                  },
                  child: Text(
                    'Close',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildOrderedList(String title, Map data) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title:",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        ...data.entries.map((entry) {
          final platform = entry.key;
          final platformData = entry.value as Map;
          final url = platformData['url'];

          return Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Row(
              children: [
                Text("• "),
                InkWell(
                  onTap: () {
                    if (url != null) {
                      launchUrl(Uri.parse(url));
                    }
                  },
                  child: Text(
                    platform,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    ),
  );
}

Widget _buildSimpleText(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title:",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
          ),
        ),
      ],
    ),
  );
}
