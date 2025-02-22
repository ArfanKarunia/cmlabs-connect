import 'package:cmlabs_connect/src/controllers/quotation_controller.dart';
import 'package:cmlabs_connect/src/view/inbox_view.dart';
import 'package:cmlabs_connect/src/view/account_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ionicons/ionicons.dart';

import '../constant/fontstyle.dart';
import '../controllers/bottom_nav_controller.dart';
import '../utils/color.dart';
import '../view/home_view.dart';

class BottomNavigation extends StatelessWidget {
  BottomNavigation({super.key});

  final BottomNavController navController = Get.find<BottomNavController>();
  final QuotationController quotationController = Get.find<QuotationController>();

  final List<Widget> _pages = [
    const HomeView(),
    const InboxView(),
    const AccountView(),
  ];

  final Rx<DateTime?> _lastBackPressed = Rx<DateTime?>(null);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _handleBackPress(),
      child: Obx(
        () => Scaffold(
          body: SafeArea(
            child: SizedBox.expand(
              child: Stack(
                children: [
                  _pages[navController.currentIndex.value],
                ],
              ),
            ),
          ),
          bottomNavigationBar: navController.isFilterActive.value
              ? const SizedBox.shrink()
              : Container(
                  decoration: const BoxDecoration(
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
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            _buildNavItem(
                              icon: Ionicons.file_tray_full_outline,
                              label: 'Inbox Lead',
                              index: 1,
                              controller: navController,
                            ),
                            Positioned(
                              top: 10,
                              right: 50,
                              child: Obx(
                                () => quotationController.newQuotationCount.value != 0
                                    ? Container(
                                        width: 15,
                                        height: 15,
                                        decoration:
                                            const BoxDecoration(shape: BoxShape.circle, color: AppColors.danger),
                                        child: Center(
                                          child: Text(
                                            "${quotationController.newQuotationCount.value}",
                                            style: regular.copyWith(fontSize: 8, color: AppColors.white_1),
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _buildNavItem(
                          icon: Ionicons.person_outline,
                          label: 'Account',
                          index: 2,
                          controller: navController,
                        ),
                      ),
                    ],
                  ),
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
      onTap: () => controller.changePage(index),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 5,
              color: controller.currentIndex.value == index ? AppColors.primary : Colors.transparent,
            ),
          ),
          color: controller.currentIndex.value == index ? AppColors.bgNavActive : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: controller.currentIndex.value == index ? AppColors.primary : Colors.grey,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: controller.currentIndex.value == index
                  ? bold.copyWith(fontSize: 12, color: AppColors.primary)
                  : regular.copyWith(fontSize: 12, color: AppColors.text_3),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _handleBackPress() async {
    final now = DateTime.now();
    const backPressThreshold = Duration(seconds: 2);

    if (_lastBackPressed.value == null || now.difference(_lastBackPressed.value!) > backPressThreshold) {
      _lastBackPressed.value = now;

      Get.snackbar(
        "",
        "", // Kosongkan default title dan message
        titleText: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Container(
              width: double.infinity,
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Press back again to exit the app', // Gunakan hanya titleText
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: regular.copyWith(color: AppColors.white_1),
              ),
            ),
          ],
        ),
        messageText: Container(
          height: 10,
        ),
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(20),
        duration: const Duration(seconds: 3),
        animationDuration: const Duration(milliseconds: 500),
        backgroundColor: Colors.black45,
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10), // Mengurangi padding vertikal
        isDismissible: true,
        barBlur: 0, // Menghilangkan blur background jika tidak diperlukan
      );

      return false; // Prevent exit
    } else {
      return true; // Allow exit
    }
  }

  void showCustomSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Text(
                  'Press back again to exit the app',
                  style: regular.copyWith(fontSize: 12, color: AppColors.white_1),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black38,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
