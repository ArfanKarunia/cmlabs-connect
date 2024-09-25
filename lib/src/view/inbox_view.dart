import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:quotation_app/src/constant/const.dart';
import 'package:quotation_app/src/controllers/quotation_controller.dart';
import 'package:quotation_app/src/utils/color.dart';
import 'package:quotation_app/src/widgets/filter_status.dart';
import 'package:quotation_app/src/widgets/quotation_list_tile.dart';

class InboxView extends StatelessWidget {
  InboxView({super.key});

  final QuotationController quotationController =
      Get.put(QuotationController());

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 50),
      color: AppColors.white,
      child: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Quotations Inbox",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryText,
              ),
            ),
            SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      "1.469",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      " Leads",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 8,
            ),
    
            // Search & Filter
            Container(
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 40,
                      child: TextFormField(
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.transparent),
                          ),
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.primaryText),
                          ),
                          hintText: "Search",
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Color(0xff9C9C9C),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 40,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(
                          Ionicons.options_outline,
                          color: AppColors.primaryText,
                          size: 24,
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            alignment: Alignment.center,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {},
                          child: Container(),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
    
            SizedBox(
              height: 15,
            ),
    
            SelectStatus(
              controller: quotationController,
            ),
    
            SizedBox(
              height: 15,
            ),
    
            Obx(
              () {
                if (quotationController.filteredQuotations.isEmpty) {
                  return Center(child: Text('No quotations available.'));
                }
    
                return SizedBox(
                  width: double.infinity,
                  height: 500,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 0),
                    itemCount:
                        quotationController.filteredQuotations.length,
                    itemBuilder: (context, index) {
                      var quotation =
                          quotationController.filteredQuotations[index];
                      return QuotationListTile(
                        companyName:
                            quotation.companyName ?? "Nama Perusahaan",
                        category: quotation.category ?? ['-'],
                        pic: quotation.pic ?? '-',
                        statusLead: quotation.statusLead,
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
