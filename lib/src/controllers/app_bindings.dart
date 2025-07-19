import 'package:get/get.dart';

import '../../services/firebase_analytics_service.dart';
import 'account/account_bindings.dart';
import 'analytics/analytics_bindings.dart';
import 'authentication/authentication_bindings.dart';
import 'dashboard/dashboard_bindings.dart';
import 'filter/filter_bindings.dart';
import 'inbox/inbox_bindings.dart';
import 'notification/notification_bindings.dart';
import 'user/user_bindings.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // GA4
    Get.lazyPut<FirebaseAnalyticsService>(() => FirebaseAnalyticsService());

    // User and Auth
    UserBindings().dependencies();
    AuthenticationBindings().dependencies();

    // Features
    AccountBindings().dependencies();
    AnalyticsBindings().dependencies();
    DashboardBindings().dependencies();
    FilterBindings().dependencies();
    InboxBindings().dependencies();
    NotificationBindings().dependencies();
  }
}
