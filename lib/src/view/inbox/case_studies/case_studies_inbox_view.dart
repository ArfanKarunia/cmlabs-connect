import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

import '../../../constant/fontstyle.dart';
import '../../../controllers/inbox/case_studies/case_studies_controller.dart';
import '../../../models/inbox/case_studies_model.dart';
import '../../../utils/color.dart';
import '../../../widgets/empty_state.dart';
import '../../../widgets/inbox/inbox_list_tile.dart';

class CaseStudiesInbox extends StatelessWidget {
  final RefreshController refreshController;
  final ScrollController scrollController;
  const CaseStudiesInbox({
    super.key,
    required this.refreshController,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final caseStudiesController = Get.find<CaseStudiesController>();
    return Obx(
      () {
        List<CaseStudies> caseStudiesList = caseStudiesController.filteredCaseStudies;

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
            await caseStudiesController.fetchList(refreshData: true);
            refreshController.refreshCompleted();
          },
          onLoading: () async {
            await Future.delayed(const Duration(milliseconds: 1000));
            await caseStudiesController.loadMore();
            refreshController.loadComplete();
          },
          controller: refreshController,
          child: caseStudiesList.isEmpty
              ? const EmptyState()
              : ListView(
                  controller: scrollController,
                  children: [
                    ...caseStudiesList.map((caseStudies) {
                      return CaseStudiesListTile(
                        caseStudies: caseStudies,
                        caseStudiesController: caseStudiesController,
                      );
                    }),
                    if (caseStudiesList.length % 10 == 0)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.text_4,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    else if (caseStudiesList.isNotEmpty)
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
          //     itemCount: quotationController.filteredCaseStudies.length,
          //     itemBuilder: (context, index) {
          //       final caseStudies = quotationController.filteredCaseStudies[index];
          //       var lengthQuotation = quotationController.filteredCaseStudies.length;

          //       return Column(
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: [
          //           CaseStudiesListTile(
          //             key: ValueKey(caseStudies.id),
          //             caseStudies: caseStudies,
          //             onDelete: () async {
          //               // Get.back();

          //               // await quotationController.deleteQuotation(index);
          //             },
          //             onChatWA: () {
          //               // quotationController.redirectToWhatsapp(quotation);
          //             },
          //           ),
          //           (index + 1 == quotationController.filteredCaseStudies.length && lengthQuotation % 10 == 0)
          //               ? const Padding(
          //                   padding: EdgeInsets.symmetric(vertical: 10),
          //                   child: Center(
          //                     child: CircularProgressIndicator(
          //                       color: AppColors.text_4,
          //                       strokeWidth: 2,
          //                     ),
          //                   ),
          //                 )
          //               : (index + 1 == quotationController.filteredCaseStudies.length)
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
