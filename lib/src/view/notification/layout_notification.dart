import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:cmlabs_connect/src/view/notification/all_notification_view.dart';
import 'package:cmlabs_connect/src/view/notification/history_notification_view.dart';
import 'package:cmlabs_connect/src/view/notification/new_notification_view.dart';
import 'package:cmlabs_connect/src/view/notification/reminder_notification_view.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LayoutNotification extends StatefulWidget {
  const LayoutNotification({super.key});

  @override
  State<LayoutNotification> createState() => _LayoutNotificationState();
}

class _LayoutNotificationState extends State<LayoutNotification>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(length: 4, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFFF9F9F9),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Color(0xFFF9F9F9),
          appBar: AppBar(
            toolbarHeight: 80,
            backgroundColor: Color(0xFFF9F9F9),
            surfaceTintColor: Color(0xFFF9F9F9),
            title: Text(
              "Notification",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.text_1,
              ),
            ),
            bottom: TabBar(
              labelColor: AppColors.primary,
              overlayColor: WidgetStatePropertyAll(Colors.transparent),
              controller: tabController,
              indicatorWeight: 2,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorPadding: EdgeInsets.symmetric(),
              unselectedLabelColor: AppColors.text_4,
              labelStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 14, fontWeight: FontWeight.bold),
              indicatorColor: AppColors.primary,
              dividerHeight: 0,
              
              tabs: const [
                Tab(
                  text: '     All     ',
                ),
                Tab(
                  text: "     New     ",
                ),
                Tab(
                  text: " Reminder ",
                ),
                Tab(
                  text: "   History   ",
                )
              ],
            ),
          ),
          body: Container(
            color: AppColors.bgDanger,
            child: TabBarView(
              controller: tabController,
              children: [
                AllNotificationView(),
                NewNotificationView(),
                ReminderNotificationView(),
                HistoryNotificationView()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
