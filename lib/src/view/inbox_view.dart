import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:quotation_app/src/utils/color.dart';

class InboxView extends StatelessWidget {
  const InboxView({super.key});

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
                            borderSide: BorderSide(color: Colors.transparent),
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
                            child: Container()),
                      ],
                    ),
                  )
                  // Container(
                  //   padding: EdgeInsets.all(5),
                  //   decoration: BoxDecoration(
                  //       border: Border.all(
                  //         color: AppColors.primaryText,
                  //         width: 1,
                  //       ),
                  //       borderRadius: BorderRadius.circular(5)),
                  // child: Icon(
                  //   Ionicons.options_outline,
                  //   color: AppColors.primaryText,
                  //   size: 24,
                  // ),
                  // )
                ],
              ),
            ),

            SizedBox(
              height: 15,
            ),

            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.primary),
                        child: Text(
                          'All',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.white,
                            border: Border.all(
                              color: AppColors.primaryText,
                              width: 1,
                            )),
                        child: Text(
                          'New',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.white,
                            border: Border.all(
                              color: AppColors.primaryText,
                              width: 1,
                            )),
                        child: Text(
                          'Followed up',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.white,
                            border: Border.all(
                              color: AppColors.primaryText,
                              width: 1,
                            )),
                        child: Text(
                          'Accepted',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: AppColors.white,
                            border: Border.all(
                              color: AppColors.primaryText,
                              width: 1,
                            )),
                        child: Text(
                          'Rejected',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.primaryText,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              width: double.infinity,
              height: 300,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 0),
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    margin: EdgeInsets.only(
                      bottom: 10,
                    ),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondaryText,
                          offset: Offset(2, 2),
                          blurRadius: 2,
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.lightBlue,
                          AppColors.white,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Nama Perusahaan",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryText,
                              ),
                            ),
                            Text(
                              "SEO Services",
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primaryText,
                              ),
                            ),
                            Text(
                              "PIC : Larasati",
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primaryText,
                              ),
                            )
                          ],
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            "New",
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
