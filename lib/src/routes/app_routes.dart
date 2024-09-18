import 'package:get/get.dart';
import 'package:quotation_app/src/view/login_view.dart';

class AppRoutes {

  // initialization url of route
  static const String home = '/';
  static const String loginForm = '/login';

  // List of Route
  static List<GetPage> routes = [
    GetPage(name: loginForm, page: () => LoginView(),),
  ];
}