import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

import '../../constant/fontstyle.dart';
import '../../controllers/quotation_controller.dart';
import '../../models/quotation_model.dart';
import '../../utils/color.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/inbox_list_tile.dart';

class QuotationInbox extends StatelessWidget {
  final RefreshController refreshController;
  final ScrollController scrollController;
  const QuotationInbox({
    super.key,
    required this.refreshController,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final quotationController = Get.find<QuotationController>();
    return Obx(
      () {
        List<Quotation> quotationList = quotationController.filteredQuotations;

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
          onRefresh: () async {
            await Future.delayed(const Duration(milliseconds: 1000));
            await quotationController.fetchList(refreshData: true);
            refreshController.refreshCompleted();
          },
          onLoading: () async {
            await Future.delayed(const Duration(milliseconds: 1000));
            await quotationController.loadMore();
            refreshController.loadComplete();
          },
          controller: refreshController,
          child: quotationList.isEmpty
              ? const EmptyState()
              : ListView(
                  controller: scrollController,
                  children: [
                    ...quotationList.map((quotation) {
                      return QuotationListTile(
                        quotation: quotation,
                        quotationController: quotationController,
                      );
                    }),
                    if (quotationList.length % 10 == 0)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.text_4,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    else if (quotationList.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: Text(
                            "No more data",
                            style: regular.copyWith(color: AppColors.text_4),
                          ),
                        ),
                      ),
                  ],
                ),
          // : ListView.builder(
          //     controller: scrollController,
          //     itemCount: quotationList.length,
          //     itemBuilder: (context, index) {
          //       final quotation = quotationList[index];
          //       int lengthQuotation = quotationList.length;

          //       return Column(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           QuotationListTile(
          //             key: ValueKey(quotation.id),
          //             quotation: quotation,
          //             onDelete: () async {
          //               Get.back();
          //               await quotationController.deleteQuotation(quotation.id);
          //             },
          //             onChatWA: () => quotationController.redirectToWhatsapp(quotation),
          //           ),
          //           (index + 1 == lengthQuotation && lengthQuotation % 10 == 0)
          //               ? const Padding(
          //                   padding: EdgeInsets.symmetric(vertical: 10),
          //                   child: Center(
          //                     child: CircularProgressIndicator(
          //                       color: AppColors.text_4,
          //                       strokeWidth: 2,
          //                     ),
          //                   ),
          //                 )
          //               : (index + 1 == lengthQuotation)
          //                   ? Container(
          //                       width: double.infinity,
          //                       padding: const EdgeInsets.symmetric(vertical: 10),
          //                       child: Center(
          //                         child: Text(
          //                           "No more data",
          //                           style: regular.copyWith(color: AppColors.text_4),
          //                         ),
          //                       ),
          //                     )
          //                   : const SizedBox.shrink(),
          //         ],
          //       );
          //     },
          //   ),
        );
      },
    );
  }
}
