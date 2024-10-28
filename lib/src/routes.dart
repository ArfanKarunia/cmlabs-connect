import 'package:get/get.dart';

import 'view/filter_view.dart';
import 'view/login_view.dart';
import 'view/select_filter_view.dart';
import 'widgets/bottom_navigation.dart';

class AppRoutes {
  // initialization url of route
  static const String home = '/';
  static const String loginForm = '/login';
  static const String detailQuotation = '/detailQuotation';
  static const String profile = '/profile';

  static const String filter = '/filter';
  static const String filterSelect = '/filterSelect';

  // List of Route
  static List<GetPage> routes = [
    GetPage(
      name: loginForm,
      page: () => const LoginView(),
    ),
    GetPage(
      name: home,
      page: () => BottomNavigation(),
    ),
    GetPage(name: filter, page: () => FilterView()),
    GetPage(
      name: filterSelect,
      page: () {
        final args = Get.arguments as String;
        return SelectFilterView(filterData: args);
      },
      //   GetPage(
      //     name: detailQuotation,
      //     page: () {
      //       final args = Get.arguments as Map<String, dynamic>;
      //       return DetailQuotation(quotation: args['quotation']);
      //     },
      //   ),
      //   GetPage(name: profile, page: () => ProfileView()),
    ),
  ];
}
