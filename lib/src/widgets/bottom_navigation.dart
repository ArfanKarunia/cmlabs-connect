import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:quotation_app/src/controllers/Tab_nav_controller.dart';
import 'package:quotation_app/src/utils/color.dart';
import 'package:quotation_app/src/view/home_view.dart';
import 'package:quotation_app/src/view/inbox_view.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({super.key});

  final TabNavController tabController = Get.put(TabNavController());

  final List<Widget> _pages = [
    HomeView(), // Halaman pertama
    InboxView(), // Halaman kedua
    Container(color: Colors.blue), // Halaman ketiga
  ];

  final List<Widget> _tabList = [
    Tab(
      icon: Icon(Ionicons.cube_outline),
      text: "Home",
    ),
    Tab(
      icon: Icon(Ionicons.cube_outline),
      text: "Inbox",
    ),
    Tab(
      icon: Icon(Ionicons.cube_outline),
      text: "Settings",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          GetBuilder<TabNavController>(
            builder: (_) {
              return TabBarView(
                controller: tabController.tabController,
                children: _pages,
              );
            },
          ),
          GetBuilder<TabNavController>(
            builder: (_) {
              return Container(
                color: AppColors.inactiveBottomNav,
                child: TabBar(
                  overlayColor: WidgetStatePropertyAll(Colors.transparent),
                  dividerHeight: 0,
                  indicatorColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(color: AppColors.activeBottomNav),
                  labelColor: AppColors.white,
                  unselectedLabelColor: AppColors.secondaryText,
                  controller: tabController.tabController,
                  tabs: _tabList,
                ),
              );
            },
          ),
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                color: Colors.black26,
              ),
              Container(
                padding: EdgeInsets.all(25),
                width: double.infinity,
                height: 400,
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: Border.all(
                    color: AppColors.primary,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Filter",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      "Data range",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
