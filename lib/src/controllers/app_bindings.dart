import 'package:get/get.dart';

import 'analytics/analytics_bindings.dart';
import 'authentication/authentication_bindings.dart';
import 'dashboard/dashboard_bindings.dart';
import 'filter/filter_bindings.dart';
import 'inbox/inbox_bindings.dart';
import 'user/user_bindings.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    UserBindings().dependencies();
    AuthenticationBindings().dependencies();

    AnalyticsBindings().dependencies();
    DashboardBindings().dependencies();
    FilterBindings().dependencies();
    InboxBindings().dependencies();
  }
}
