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

  @override
  State<InboxView> createState() => _InboxViewState();

  final QuotationController quotationController =
      Get.put(QuotationController());

  final EditQuotationController detailQuotationController =
      Get.put(EditQuotationController());
}

RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    
    QuotationController().fetchQuotationData();

    _refreshController.loadComplete();
  }

class _InboxViewState extends State<InboxView> {
  @override
  Widget build(BuildContext context) {
    widget.detailQuotationController.clearSelectedData();

    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                          Text(
                            "${widget.quotationController.quotationList.length}",
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.primary,
                              fontSize: 12,
                            ),
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
                              side:
                                  BorderSide(color: AppColors.text_3, width: 1),
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
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(
                    () {
                      List quotationList =
                          widget.quotationController.filteredQuotations;

                      if (quotationList.isEmpty) {
                        return Container(
                          height: 300,
                          width: double.infinity,
                          child: Center(
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
                          ),
                        );
                      }

                      return Container(
                        height: 550,
                        width: double.infinity,
                        child: SmartRefresher(
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
                          onRefresh: _onRefresh,
                          onLoading: _onLoading,
                          controller: _refreshController,
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: 0),
                            itemCount: widget
                                .quotationController.filteredQuotations.length,
                            itemBuilder: (context, index) {
                              final quotation = quotationList[index];

                              return Column(
                                children: [
                                  QuotationListTile(
                                    quotation: quotation,
                                    onDelete: () {
                                      print(quotation.id);
                                      // widget.quotationController.deleteDataQuotation(quotation.id);
                                    },
                                    onChatWA: () {
                                      // print(quotation);
                                      widget.quotationController
                                          .redirectToWhatsapp(quotation);
                                    },
                                  ),
                                  (index ==
                                          widget.quotationController
                                                  .filteredQuotations.length -
                                              1)
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 10),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              widget.quotationController
                                                  .loadMoreQuotations();
                                            },
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  WidgetStatePropertyAll(
                                                AppColors.white_1,
                                              ),
                                              foregroundColor:
                                                  WidgetStatePropertyAll(
                                                AppColors.text_2,
                                              ),
                                              shadowColor:
                                                  WidgetStatePropertyAll(
                                                AppColors.text_4,
                                              ),
                                              overlayColor:
                                                  WidgetStatePropertyAll(
                                                AppColors.bgPrimary,
                                              ),
                                              shape: WidgetStatePropertyAll(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              "Load more",
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                color: AppColors.text_3,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
