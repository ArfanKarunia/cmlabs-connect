import 'package:cmlabs_connect/src/controllers/inbox/quotation/quotation_controller.dart';
import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

import '../../constant/fontstyle.dart';
import '../../controllers/filter/filter_controller.dart';
import '../../controllers/inbox/case_studies/case_studies_controller.dart';
import '../../controllers/inbox/contact_us/contact_us_controller.dart';
import '../../controllers/inbox/faq/faq_controller.dart';
import '../../controllers/inbox/inbox_controller.dart';
import '../../models/inbox/property/inbox_page_model.dart';
import '../../routes.dart';
import '../../utils/bottom_sheet.dart';
import '../../widgets/inbox/inbox_action_button.dart';
import '../../widgets/select_status.dart';
import 'case_studies/case_studies_inbox_view.dart';
import 'contact_us/contact_us_inbox_view.dart';
import 'faq/faq_inbox_view.dart';
import 'quotation/quotation_inbox_view.dart';

class InboxView extends StatefulWidget {
  const InboxView({super.key});

  @override
  State<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  final TextEditingController searchController = TextEditingController();

  final ScrollController scrollController = ScrollController();
  bool isLoadMoreInProgress = false;

  final List<InboxController> controller = [
    Get.find<QuotationController>(),
    Get.find<CaseStudiesController>(),
    Get.find<ContactUsController>(),
    Get.find<FaqController>(),
  ];

  final FilterController filterController = Get.find<FilterController>();

  int index = 0;
  late List<InboxPage> pages;

  @override
  void initState() {
    super.initState();
    pages = [
      InboxPage(
        title: 'Quotation',
        child: QuotationInbox(
          refreshController: RefreshController(),
          scrollController: scrollController,
        ),
      ),
      InboxPage(
        title: 'Case Studies',
        child: CaseStudiesInbox(
          refreshController: RefreshController(),
          scrollController: scrollController,
        ),
      ),
      InboxPage(
        title: 'Contact Us',
        child: ContactUsInbox(
          refreshController: RefreshController(),
          scrollController: scrollController,
        ),
      ),
      InboxPage(
        title: 'FAQ',
        child: FaqInbox(
          refreshController: RefreshController(),
          scrollController: scrollController,
        ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () => handleSwitchInbox(context),
            child: Row(
              children: [
                Text(
                  pages[index].title,
                  style: bold.copyWith(color: AppColors.text_1, fontSize: 20),
                ),
                const SizedBox(width: 10),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.text_1,
                  size: 24,
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

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

          SizedBox(height: index != 3 ? 16 : 20),

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

              if (index != 3) ...[
                const SizedBox(width: 10),

                // Button Filter (do not show for FAQ)
                Obx(
                  () => Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(5),
                          onTap: () => Get.toNamed(AppRoutes.filter),
                          child: Ink(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              color: AppColors.white_1,
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: AppColors.text_3, width: 1),
                            ),
                            child: const Icon(
                              Ionicons.options_outline,
                              color: AppColors.text_3,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                      if (filterController.isFilterApplied)
                        const CircleAvatar(radius: 6, backgroundColor: AppColors.primary),
                    ],
                  ),
                ),
              ],
            ],
          ),

          // Menyesuaikan tinggi search field dengan tombol filter
          // (FAQ tidak ada filter)
          SizedBox(height: index != 3 ? 14 : 18),

          // Quick Sort by Status
          SelectStatus(controllers: controller),

          const SizedBox(height: 20),

          // Button Add Quotation or Export Data
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

          // Inbox List
          Expanded(
            child: Container(child: pages[index].child),
          ),
        ],
      ),
    );
  }

  Future<void> handleSwitchInbox(BuildContext context) {
    return showCustomBottomSheet(
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
    );
  }

  Future<void> scrollToLoadMore() async {
    // Mengecek apakah sudah mencapai bagian bawah list
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent &&
        !isLoadMoreInProgress) {
      // Mencegah pemanggilan load more jika masih ada proses load more sebelumnya
      if (isLoadMoreInProgress) return;

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
}
