import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:quotation_app/src/controllers/Tab_nav_controller.dart';
import 'package:quotation_app/src/controllers/filter_controller.dart';
import 'package:quotation_app/src/utils/color.dart';
import 'package:quotation_app/src/view/home_view.dart';
import 'package:quotation_app/src/view/inbox_view.dart';
import 'package:quotation_app/src/widgets/filter_container.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({super.key});

  final TabNavController tabController = Get.put(TabNavController());

  final List<Widget> _pages = [
    HomeView(), // Halaman pertama
    InboxView(), // Halaman kedua
    Container(color: Colors.blue), // Halaman ketiga
  ];

  final List<Widget> _tabList = [
    const Tab(
      icon: Icon(Ionicons.cube_outline),
      text: "Home",
    ),
    const Tab(
      icon: Icon(Ionicons.file_tray_full_outline),
      text: "Inbox",
    ),
    const Tab(
      icon: Icon(Ionicons.prism_outline),
      text: "Settings",
    ),
  ];

  final FilterController filterController = Get.put(FilterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: false,
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
                  overlayColor:
                      const WidgetStatePropertyAll(Colors.transparent),
                  dividerHeight: 0,
                  indicatorColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator:
                      const BoxDecoration(color: AppColors.activeBottomNav),
                  labelColor: AppColors.white,
                  unselectedLabelColor: AppColors.secondaryText,
                  controller: tabController.tabController,
                  tabs: _tabList,
                ),
              );
            },
          ),
          FilterContainer(filterController: filterController),
        ],
      ),
    );
  }
}
