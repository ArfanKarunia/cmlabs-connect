import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:quotation_app/src/controllers/bottom_nav_controller.dart';
import 'package:quotation_app/src/controllers/filter_controller.dart';
import 'package:quotation_app/src/utils/color.dart';
import 'package:quotation_app/src/view/home_view.dart';
import 'package:quotation_app/src/view/inbox_view.dart';
import 'package:quotation_app/src/view/setting_view.dart';
import 'package:quotation_app/src/widgets/filter_container.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({super.key});

  final BottomNavController navController = Get.put(BottomNavController());

  final List<Widget> _pages = [
    HomeView(), // Halaman pertama
    InboxView(), // Halaman kedua
    const SettingView() // Halaman ketiga
  ];

  final FilterController filterController = Get.put(FilterController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Container(
          child: Stack(
            children: [
              _pages[navController.currentIndex.value],
              FilterContainer(controller: navController),
            ],
          ),
        ),
        bottomNavigationBar: navController.isFilterActive.value
            ? SizedBox.shrink()
            : Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, -4),
                      blurRadius: 20,
                      color: Color.fromARGB(12, 53, 53, 53),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildNavItem(
                        icon: Ionicons.cube_outline,
                        label: 'Home',
                        index: 0,
                        controller: navController,
                      ),
                    ),
                    Expanded(
                      child: _buildNavItem(
                        icon: Ionicons.file_tray_full_outline,
                        label: 'Inbox Lead',
                        index: 1,
                        controller: navController,
                      ),
                    ),
                    Expanded(
                      child: _buildNavItem(
                        icon: Ionicons.settings_outline,
                        label: 'Setting',
                        index: 2,
                        controller: navController,
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required BottomNavController controller,
  }) {
    return GestureDetector(
      onTap: () {
        controller.changePage(index);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 5,
              color: controller.currentIndex.value == index
                  ? AppColors.primary
                  : Colors.transparent,
            ),
          ),
          color: controller.currentIndex.value == index
              ? AppColors.bgNavActive
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: controller.currentIndex.value == index
                  ? AppColors.primary
                  : Colors.grey,
            ),
            SizedBox(height: 3),
            Text(
              label,
              style: controller.currentIndex.value == index
                  ? GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    )
                  : GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.text_3,
                      fontWeight: FontWeight.w400,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
