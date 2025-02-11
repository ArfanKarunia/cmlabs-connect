import 'package:cmlabs_connect/src/controllers/quotation_controller.dart';
import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

import '../constant/fontstyle.dart';
import '../routes.dart';
import '../widgets/custom_buttom.dart';
import '../widgets/quotation_list_tile.dart';
import '../widgets/select_status.dart';

class InboxView extends StatefulWidget {
  const InboxView({super.key});

  @override
  State<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  final QuotationController quotationController = Get.put(QuotationController());

  late ScrollController scrollController;
  final RefreshController _refreshInboxController = RefreshController();

  final _lastBackPressed = Rx<DateTime?>(null);

  void _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    quotationController.fetchQuotationData(refreshData: true);
    _refreshInboxController.refreshCompleted();
  }

  void _onLoading() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    quotationController.loadMoreQuotations();
    _refreshInboxController.loadComplete();
  }

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();

    // Menandakan apakah sedang ada proses load more atau tidak
    bool isLoadMoreInProgress = false;

    // Memastikan kita menunggu sampai widget selesai rendering untuk mulai deteksi scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.addListener(() async {
        // Mengecek apakah sudah mencapai bagian bawah list
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isLoadMoreInProgress) {
          // Mencegah pemanggilan load more jika masih ada proses load more sebelumnya
          if (isLoadMoreInProgress) return;

          // Tandai bahwa proses load more sedang berlangsung
          isLoadMoreInProgress = true;

          // Delay untuk mensimulasikan proses fetching data
          await Future.delayed(const Duration(milliseconds: 500));

          // Panggil method untuk load lebih banyak data
          await quotationController.loadMoreQuotations();

          // Tandai bahwa load more sudah selesai
          isLoadMoreInProgress = false;
        }
      });
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
            padding: const EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Quotation Inbox",
                        style: bold.copyWith(
                          color: AppColors.text_1,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
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
                              "${quotationController.totalLeads.value}",
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
                                onChanged: quotationController.setSearch,
                                style: regular.copyWith(fontSize: 12),
                                decoration: InputDecoration(
                                  hintText: "Company name, email, etc",
                                  hintStyle: regular.copyWith(
                                    fontSize: 12,
                                    color: AppColors.text_4,
                                  ),
                                  prefixIcon: const Icon(
                                    Ionicons.search_outline,
                                    size: 18,
                                  ),
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
                              borderRadius: BorderRadius.circular(
                                5,
                              ),
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
                      const SizedBox(
                        height: 15,
                      ),
                      SelectStatus(
                        controller: quotationController,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                Obx(
                  () => quotationController.newQuotationCount.value > 0
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: IntrinsicWidth(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: WidgetStatePropertyAll(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                backgroundColor: const WidgetStatePropertyAll(AppColors.primary),
                                foregroundColor: const WidgetStatePropertyAll(AppColors.white_1),
                                overlayColor: const WidgetStatePropertyAll(Colors.white30),
                              ),
                              onPressed: () {
                                quotationController.fetchQuotationData();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Ionicons.arrow_up_outline,
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${quotationController.newQuotationCount.value}+ New Leads",
                                    style: regular.copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Obx(
                      () {
                        List quotationList = quotationController.filteredQuotations;

                        if (quotationList.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Ionicons.briefcase_outline,
                                  color: AppColors.text_4,
                                  size: 40,
                                ),
                                Text(
                                  'No available data',
                                  style: bold.copyWith(
                                    fontSize: 24,
                                    color: AppColors.text_4,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return SmartRefresher(
                          enablePullDown: true,
                          header: const ClassicHeader(
                            refreshStyle: RefreshStyle.Follow,
                            refreshingIcon: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: AppColors.text_4,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                          footer: const ClassicFooter(
                            loadStyle: LoadStyle.HideAlways,
                            loadingIcon: CircularProgressIndicator(
                              color: AppColors.text_4,
                              strokeWidth: 2,
                            ),
                          ),
                          onRefresh: _onRefresh,
                          onLoading: _onLoading,
                          controller: _refreshInboxController,
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: quotationController.filteredQuotations.length,
                            itemBuilder: (context, index) {
                              final quotation = quotationController.filteredQuotations[index];

                              var lengthQuotation = quotationController.filteredQuotations.length;

                              // Periksa apakah item sedang dihapus
                              final isRemoving = quotationController.removingIndexes.contains(index);

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AnimatedSize(
                                    duration: const Duration(milliseconds: 500),
                                    child: AnimatedOpacity(
                                      duration: const Duration(milliseconds: 500),
                                      opacity: isRemoving ? 0 : 1,
                                      child: isRemoving
                                          ? const SizedBox.shrink() // Kosongkan jika sedang dihapus
                                          : QuotationListTile(
                                              key: ValueKey(quotation.id),
                                              quotation: quotation,
                                              onDelete: () async {
                                                Get.back();

                                                await quotationController.deleteQuotationWithAnimation(index);
                                              },
                                              onChatWA: () {
                                                quotationController.redirectToWhatsapp(quotation);
                                              },
                                            ),
                                    ),
                                  ),
                                  (index + 1 == quotationController.filteredQuotations.length &&
                                          lengthQuotation % 10 == 0)
                                      ? const Padding(
                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: AppColors.text_4,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        )
                                      : (index + 1 == quotationController.filteredQuotations.length)
                                          ? Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                              child: Center(
                                                child: Text(
                                                  "No more data",
                                                  style: regular.copyWith(color: AppColors.text_4),
                                                ),
                                              ),
                                            )
                                          : const SizedBox.shrink(),
                                ],
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
