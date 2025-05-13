import 'package:cmlabs_connect/src/controllers/inbox/quotation/quotation_controller.dart';
import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

import '../constant/fontstyle.dart';
import '../controllers/inbox/case_studies/case_studies_controller.dart';
import '../controllers/inbox/contact_us/contact_us_controller.dart';
import '../controllers/inbox/faq/faq_controller.dart';
import '../controllers/inbox/inbox_controller.dart';
import '../models/inbox_page_model.dart';
import '../routes.dart';
import '../utils/bottom_sheet.dart';
import '../widgets/custom_buttom.dart';
import '../widgets/inbox_action_button.dart';
import '../widgets/select_status.dart';
import 'inbox/case_studies/case_studies_inbox_view.dart';
import 'inbox/contact_us/contact_us_inbox_view.dart';
import 'inbox/faq/faq_inbox_view.dart';
import 'inbox/quotation/quotation_inbox_view.dart';

class InboxView extends StatefulWidget {
  const InboxView({super.key});

  @override
  State<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  final _lastBackPressed = Rx<DateTime?>(null);

  final TextEditingController searchController = TextEditingController();

  final ScrollController scrollController = ScrollController();
  bool isLoadMoreInProgress = false;

  final List<InboxController> controller = [
    Get.find<QuotationController>(),
    Get.find<CaseStudiesController>(),
    Get.find<ContactUsController>(),
    Get.find<FaqController>(),
  ];

  int index = 0;
  late List<InboxPage> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      InboxPage(
        title: 'Quotation',
        child: QuotationInbox(refreshController: RefreshController(), scrollController: scrollController),
      ),
      InboxPage(
        title: 'Case Studies',
        child: CaseStudiesInbox(refreshController: RefreshController(), scrollController: scrollController),
      ),
      InboxPage(
        title: 'Contact Us',
        child: ContactUsInbox(refreshController: RefreshController(), scrollController: scrollController),
      ),
      InboxPage(
        title: 'FAQ',
        child: FaqInbox(refreshController: RefreshController(), scrollController: scrollController),
      ),
    ];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(scrollToLoadMore);
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBgColor2,
      body: PopScope(
        onPopInvokedWithResult: _handlePop,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      pages[index].title,
                      style: bold.copyWith(color: AppColors.text_1, fontSize: 20),
                    ),
                    IconButton(
                      onPressed: () => showCustomBottomSheet(
                        context,
                        children: [
                          Text(
                            'Switch Inbox',
                            style: bold.copyWith(fontSize: 18),
                          ),
                          const SizedBox(height: 18),
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.text_4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              children: List.generate(
                                pages.length,
                                (i) {
                                  return ListTile(
                                    leading: const Icon(Ionicons.briefcase_outline),
                                    title: Text(
                                      'Inbox ${pages[i].title}',
                                      style: bold.copyWith(fontSize: 16, color: AppColors.text_1),
                                    ),
                                    onTap: () {
                                      Get.back();
                                      if (i < controller.length) {
                                        controller[i].addSearch(searchController.text);
                                      }
                                      setState(() => index = i);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.text_1,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      "Total Leads ",
                      style: regular.copyWith(
                        fontSize: 12,
                        color: AppColors.text_2,
                      ),
                    ),
                    Obx(
                      () => Text(
                        controller[index].totalLeads.value.toString(),
                        style: regular.copyWith(
                          fontSize: 12,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    // Search Field Input
                    Expanded(
                      child: SizedBox(
                        height: 40,
                        child: TextFormField(
                          controller: searchController,
                          onChanged: (value) async {
                            await Future.delayed(Durations.medium4);
                            if (index < controller.length) {
                              controller[index].addSearch(value);
                            }
                          },
                          style: regular.copyWith(fontSize: 12),
                          decoration: InputDecoration(
                            hintText: "Company name, email, etc",
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
                      ),
                    ),

                    const SizedBox(width: 14),

                    // Button Filter
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: CustomButton(
                        onPressed: () => Get.toNamed(AppRoutes.filter), // Icon as child
                        backgroundColor: AppColors.white_1, // Button background color
                        overlayColor: const Color.fromARGB(100, 149, 149, 149), // Ripple effect color
                        borderRadius: BorderRadius.circular(5),
                        side: const BorderSide(color: AppColors.text_3, width: 1),
                        child: const Icon(
                          Ionicons.options_outline,
                          color: AppColors.text_3,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),

                SelectStatus(controllers: controller),

                const SizedBox(height: 20),

                // Obx(
                //   () => quotationController.newQuotationCount.value > 0
                //       ? Padding(
                //           padding: const EdgeInsets.only(bottom: 10),
                //           child: IntrinsicWidth(
                //             child: ElevatedButton(
                //               style: ButtonStyle(
                //                 shape: WidgetStatePropertyAll(
                //                   RoundedRectangleBorder(
                //                     borderRadius: BorderRadius.circular(5),
                //                   ),
                //                 ),
                //                 backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
                //                 foregroundColor: const WidgetStatePropertyAll(AppColors.white_1),
                //                 overlayColor: const WidgetStatePropertyAll(Colors.white30),
                //               ),
                //               onPressed: () {
                //                 quotationController.fetchQuotation();
                //               },
                //               child: Row(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 children: [
                //                   const Icon(
                //                     Ionicons.arrow_up_outline,
                //                     size: 18,
                //                   ),
                //                   const SizedBox(
                //                     width: 10,
                //                   ),
                //                   Text(
                //                     "${quotationController.newQuotationCount.value}+ New Leads",
                //                     style: regular.copyWith(fontSize: 12),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ),
                //         )
                //       : const SizedBox.shrink(),
                // ),

                Align(
                  alignment: Alignment.centerRight,
                  child: index == 0
                      ? const InboxAddQuotationButton()
                      : Obx(
                          () => controller[index].isExportLoading.value
                              ? const InboxActionLoadingButton()
                              : InboxExportDataButton(
                                  onTap: () => controller[index].exportData(),
                                ),
                        ),
                ),
                const SizedBox(height: 10),

                Expanded(
                  child: Container(child: pages[index].child),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> scrollToLoadMore() async {
    // Mengecek apakah sudah mencapai bagian bawah list
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isLoadMoreInProgress) {
      if (isLoadMoreInProgress) return; // Mencegah pemanggilan load more jika masih ada proses load more sebelumnya

      // Tandai bahwa proses load more sedang berlangsung
      isLoadMoreInProgress = true;

      // await Future.delayed(const Duration(milliseconds: 500)); // Delay untuk mensimulasikan proses fetching data

      // Panggil method untuk load lebih banyak data
      if (index < controller.length) {
        await controller[index].loadMore();
      }

      // Tandai bahwa load more sudah selesai
      isLoadMoreInProgress = false;
    }
  }

  Future<bool> _handlePop(bool didPop, dynamic result) async {
    final now = DateTime.now();
    const backPressThreshold = Duration(seconds: 2);

    if (_lastBackPressed.value == null || now.difference(_lastBackPressed.value!) > backPressThreshold) {
      _lastBackPressed.value = now;

      Get.snackbar(
        "Confirm Exit",
        "Press back again to exit the app.",
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black.withOpacity(0.8),
        colorText: Colors.white,
      );

      return false; // Prevent app from closing
    }

    return true; // Allow app to close
  }
}
