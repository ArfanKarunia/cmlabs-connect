import 'package:get/get.dart';
import 'package:quotation_app/src/view/detail_quotation.dart';
import 'package:quotation_app/src/view/login_view.dart';
import 'package:quotation_app/src/widgets/bottom_navigation.dart';

class AppRoutes {
  // initialization url of route
  static const String home = '/';
  static const String loginForm = '/login';
  static const String detailQuotation = '/detailQuotation';

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
    GetPage(
      name: detailQuotation,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return DetailQuotation(quotation: args['quotation']);
      },
    ),
  ];
}
