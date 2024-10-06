import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:quotation_app/src/utils/color.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Container(
        color: AppColors.white,
        width: double.infinity,
        padding: EdgeInsets.only(
          top: 60,
          left: 25,
          right: 25,
          bottom: 25,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Header
            Text(
              "Settings",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(
              height: 20,
            ),

            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  width: double.infinity,
                  height: 500,
                ),
                Container(
                  height: 350,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 60,
                      ),
                      Text(
                        "John Doe",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Admin",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 5),
                        width: MediaQuery.of(context).size.width - 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "About",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer mi urna, mollis quis leo ut, viverra lacinia massa. Ut mollis vestibulum magna eget lacinia. Pellentesque sed turpis nibh. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                                maxLines: 3,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(
                              "Specialization",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer mi urna, mollis quis leo ut, viverra lacinia massa. Ut mollis vestibulum magna eget lacinia. Pellentesque sed turpis nibh. Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                                maxLines: 3,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  child: Container(
                    height: 200,
                    width: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                  ),
                )
              ],
            ),

            SizedBox(
              height: 10,
            ),

            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.white),
                  foregroundColor:
                      WidgetStatePropertyAll(AppColors.primaryText),
                  overlayColor: WidgetStatePropertyAll(AppColors.lightBlue),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)))),
              onPressed: () => Get.toNamed('/profile'),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Ionicons.person_outline,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Profile",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                    Icon(
                      Ionicons.chevron_forward,
                    ),
                  ],
                ),
              ),
            ),

            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.white),
                  foregroundColor:
                      WidgetStatePropertyAll(AppColors.primaryText),
                  overlayColor: WidgetStatePropertyAll(AppColors.lightBlue),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)))),
              onPressed: () {},
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Ionicons.log_out_outline,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Logout",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        )
                      ],
                    ),
                    Icon(
                      Ionicons.chevron_forward,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
