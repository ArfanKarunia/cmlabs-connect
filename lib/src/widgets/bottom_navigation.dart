import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:quotation_app/src/controllers/bottom_nav_controller.dart';
import 'package:quotation_app/src/utils/color.dart';
import 'package:quotation_app/src/view/home_view.dart';
import 'package:quotation_app/src/view/inbox_view.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({super.key});

  final BottomNavController bottomNavController =
      Get.put(BottomNavController());

  final List<Widget> _pages = [
    HomeView(), // Halaman pertama
    InboxView(), // Halaman kedua
    Container(color: Colors.blue), // Halaman ketiga
  ];

  List<BottomNavigationBarItem> _navBarsItems() {
    return [
      BottomNavigationBarItem(
                icon: Icon(Ionicons.cube_outline),
                label: "Home",
                backgroundColor: AppColors.activeBottomNav),
            BottomNavigationBarItem(
              icon: Icon(Ionicons.file_tray_full_outline),
              label: "Inbox",
            ),
            BottomNavigationBarItem(
              icon: Icon(Ionicons.prism_outline),
              label: "Setting",
            ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
        index: bottomNavController.selectedIndex.value,
        children: _pages,
      ),),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          selectedItemColor: AppColors.white,
          unselectedItemColor: AppColors.secondaryText,
          backgroundColor: AppColors.inactiveBottomNav,
          currentIndex: bottomNavController.selectedIndex.value,
          onTap: bottomNavController.selectedIndex.call,
          items: _navBarsItems(),
        ),
      ),
    );
  }
}
