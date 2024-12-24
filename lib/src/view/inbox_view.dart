import 'package:cmlabs_connect/src/controllers/edit_quotation/edit_quotation_controller.dart';
import 'package:cmlabs_connect/src/controllers/quotation_controller.dart';
import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:cmlabs_connect/src/view/filter_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

import '../widgets/custom_buttom.dart';
import '../widgets/quotation_list_tile.dart';
import '../widgets/select_status.dart';

class InboxView extends StatefulWidget {
  InboxView({super.key});

  final QuotationController quotationController =
      Get.put(QuotationController());

  final EditQuotationController detailQuotationController =
      Get.put(EditQuotationController());

  // RefreshController _refreshInboxController =
  //     RefreshController(initialRefresh: false);

  late ScrollController scrollController;

  final RefreshController _refreshInboxController = RefreshController();

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    quotationController.fetchQuotationData(refreshData: true);

    _refreshInboxController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    quotationController.loadMoreQuotations();

    _refreshInboxController.loadComplete();
  }

  @override
  State<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  @override
  void initState() {
    super.initState();
    widget.scrollController = ScrollController();

    // Menandakan apakah sedang ada proses load more atau tidak
    bool isLoadMoreInProgress = false;

    // Memastikan kita menunggu sampai widget selesai rendering untuk mulai deteksi scroll
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.scrollController.addListener(() async {
        // Mengecek apakah sudah mencapai bagian bawah list
        if (widget.scrollController.position.pixels ==
                widget.scrollController.position.maxScrollExtent &&
            !isLoadMoreInProgress) {
          // Mencegah pemanggilan load more jika masih ada proses load more sebelumnya
          if (isLoadMoreInProgress) return;

          // Tandai bahwa proses load more sedang berlangsung
          isLoadMoreInProgress = true;

          // Delay untuk mensimulasikan proses fetching data
          await Future.delayed(Duration(milliseconds: 500));

          // Panggil method untuk load lebih banyak data
          await widget.quotationController.loadMoreQuotations();

          // Tandai bahwa load more sudah selesai
          isLoadMoreInProgress = false;
        }
      });
    });
  }

  @override
  void dispose() {
    // Dispose of the controller to avoid memory leaks
    widget.scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget.detailQuotationController.clearSelectedData();

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      body: SafeArea(
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
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.text_1,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Text(
                          "Total Leads ",
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.text_2,
                            fontSize: 12,
                          ),
                        ),
                        Obx(
                          () {
                            return Text(
                              "${widget.quotationController.totalLeads.value}",
                              style: GoogleFonts.plusJakartaSans(
                                color: AppColors.primary,
                                fontSize: 12,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        // Search Field Input
                        Expanded(
                          child: SizedBox(
                            height: 40,
                            child: TextFormField(
                              onChanged: widget.quotationController.setSearch,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                hintText: "Company name, email, etc",
                                hintStyle: GoogleFonts.plusJakartaSans(
                                  color: AppColors.text_4,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                                prefixIcon: Icon(
                                  Ionicons.search_outline,
                                  size: 18,
                                ),
                                isDense: true,
                                contentPadding:
                                    EdgeInsets.only(top: 0, bottom: 5),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.primary, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                focusColor: AppColors.primary,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: AppColors.text_3, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 14,
                        ),

                        // Button Filter

                        SizedBox(
                          height: 40,
                          width: 40,
                          child: CustomButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) {
                                    return FilterView();
                                  },
                                ),
                              );
                            },
                            child: Icon(
                              Ionicons.options_outline,
                              color: AppColors.text_3,
                              size: 28,
                            ), // Icon as child
                            backgroundColor:
                                AppColors.white_1, // Button background color
                            overlayColor: const Color.fromARGB(
                                100, 149, 149, 149), // Ripple effect color
                            borderRadius: BorderRadius.circular(
                              5,
                            ),
                            side: BorderSide(color: AppColors.text_3, width: 1),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SelectStatus(
                      controller: widget.quotationController,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Obx(
                () {
                  return widget.quotationController.newQuotationCount.value > 0
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
                                backgroundColor:
                                    WidgetStatePropertyAll(AppColors.primary),
                                foregroundColor:
                                    WidgetStatePropertyAll(AppColors.white_1),
                                overlayColor:
                                    WidgetStatePropertyAll(Colors.white30),
                              ),
                              onPressed: () {
                                widget.quotationController.fetchQuotationData();
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Ionicons.arrow_up_outline,
                                    size: 18,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    "${widget.quotationController.newQuotationCount.value}+ New Leads",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : SizedBox.shrink();
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(
                    () {
                      List quotationList =
                          widget.quotationController.quotationList;

                      if (quotationList.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Ionicons.briefcase_outline,
                                color: AppColors.text_4,
                                size: 40,
                              ),
                              Text(
                                'No available data',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.text_4,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return SmartRefresher(
                        enablePullDown: true,
                        header: ClassicHeader(
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
                        footer: ClassicFooter(
                          loadStyle: LoadStyle.HideAlways,
                          loadingIcon: CircularProgressIndicator(
                            color: AppColors.text_4,
                            strokeWidth: 2,
                          ),
                        ),
                        onRefresh: widget._onRefresh,
                        // onLoading: widget._onLoading,
                        controller: widget._refreshInboxController,
                        child: ListView.builder(
                          controller: widget.scrollController,
                          itemCount:
                              widget.quotationController.quotationList.length,
                          itemBuilder: (context, index) {
                            final quotation =
                                widget.quotationController.quotationList[index];

                            var lengthQuotation =
                                widget.quotationController.quotationList.length;

                            // Periksa apakah item sedang dihapus
                            final isRemoving = widget
                                .quotationController.removingIndexes
                                .contains(index);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AnimatedSize(
                                  duration: const Duration(milliseconds: 500),
                                  child: AnimatedOpacity(
                                    duration: const Duration(milliseconds: 500),
                                    opacity: isRemoving ? 0 : 1,
                                    child: isRemoving
                                        ? SizedBox
                                            .shrink() // Kosongkan jika sedang dihapus
                                        : QuotationListTile(
                                            key: ValueKey(quotation.id),
                                            quotation: quotation,
                                            onDelete: () async {
                                              Get.back();

                                              await widget.quotationController
                                                  .deleteQuotationWithAnimation(
                                                      index);
                                            },
                                            onChatWA: () {
                                              widget.quotationController
                                                  .redirectToWhatsapp(
                                                      quotation);
                                            },
                                          ),
                                  ),
                                ),
                                (index + 1 ==
                                            widget.quotationController
                                                .quotationList.length &&
                                        lengthQuotation % 10 == 0)
                                    ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: AppColors.text_4,
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      )
                                    : (index + 1 ==
                                            widget.quotationController
                                                .quotationList.length)
                                        ? Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            child: Center(
                                              child: Text(
                                                "No more data",
                                                style:
                                                    GoogleFonts.plusJakartaSans(
                                                  fontSize: 14,
                                                  color: AppColors.text_4,
                                                ),
                                              ),
                                            ),
                                          )
                                        : SizedBox.shrink(),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
