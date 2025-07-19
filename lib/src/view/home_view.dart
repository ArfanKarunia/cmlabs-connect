import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:double_tap_to_exit/double_tap_to_exit.dart';

import '../constant/fontstyle.dart';
import '../utils/color.dart';
import 'account/account_view.dart';
import 'analytics/analytics_view.dart';
import 'dashboard_view.dart';
import 'inbox/inbox_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  void updateIndex(int newIndex) {
    setState(() => _currentIndex = newIndex);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      DashboardView(updateIndex: updateIndex),
      const InboxView(),
      const AnalyticsView(),
      const AccountView(),
    ];

    return SafeArea(
      top: false,
      child: DoubleTapToExit(
        snackBar: const SnackBar(content: Text('Double tap to exit')),
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0),
            child: Container(),
          ),
          body: pages[_currentIndex],
          bottomNavigationBar: Container(
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
                  child: HomeMenu(
                    icon: Ionicons.cube_outline,
                    label: 'Home',
                    isActive: _currentIndex == 0,
                    onTap: () => setState(() => _currentIndex = 0),
                  ),
                ),
                Expanded(
                  child: HomeMenu(
                    icon: Ionicons.file_tray_full_outline,
                    label: 'Inbox Lead',
                    isActive: _currentIndex == 1,
                    onTap: () => setState(() => _currentIndex = 1),
                  ),
                ),
                Expanded(
                  child: HomeMenu(
                    icon: Ionicons.stats_chart,
                    label: 'Analytics',
                    isActive: _currentIndex == 2,
                    onTap: () => setState(() => _currentIndex = 2),
                  ),
                ),
                Expanded(
                  child: HomeMenu(
                    icon: Ionicons.person_outline,
                    label: 'Account',
                    isActive: _currentIndex == 3,
                    onTap: () => setState(() => _currentIndex = 3),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeMenu extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback? onTap;
  const HomeMenu({super.key, required this.icon, required this.label, required this.isActive, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: 5,
              color: isActive ? AppColors.primary : Colors.transparent,
            ),
          ),
          color: isActive ? AppColors.bgNavActive : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primary : Colors.grey,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: isActive
                  ? bold.copyWith(fontSize: 12, color: AppColors.primary)
                  : regular.copyWith(fontSize: 12, color: AppColors.text_3),
            ),
          ],
        ),
      ),
    );
  }
}
