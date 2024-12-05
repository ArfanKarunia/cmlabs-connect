import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pull_to_refresh_new/pull_to_refresh.dart';

import '../../widgets/notification_tile.dart';

class ReminderNotificationView extends StatelessWidget {
  ReminderNotificationView({super.key});

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    // quotationController.fetchQuotationData();

    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SmartRefresher(
          enablePullDown: true,
          header: ClassicHeader(
            refreshStyle: RefreshStyle.Follow,
            refreshingIcon: SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: AppColors.text_4,
                strokeWidth: 2,
              ),
            ),
          ),
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          controller: _refreshController,
          child: ListView(
            children: [
              Text(
                "Today",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text_1,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return NotificationTile(
                    name: 'Nama Perusahaan',
                    date: DateTime.now(),
                    isRead: index % 2 == 0,
                    isReminder: true,
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "This Week",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text_1,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return NotificationTile(
                    name: 'Nama Perusahaan',
                    date: DateTime.now(),
                    isRead: index % 2 == 0,
                    isReminder: true,
                  );
                },
              ),
              Text(
                "This Month",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text_1,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return NotificationTile(
                    name: 'Nama Perusahaan',
                    date: DateTime.now(),
                    isRead: index % 2 == 0,
                    isReminder: true,
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
