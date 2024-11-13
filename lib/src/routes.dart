import 'package:cmlabs_connect/src/view/account_setting/experience/experience_view.dart';
import 'package:cmlabs_connect/src/view/account_setting/experience/form_experience_view.dart';
import 'package:cmlabs_connect/src/view/account_setting/select_data.dart';
import 'package:cmlabs_connect/src/view/account_setting/summary/form_summary_view.dart';
import 'package:cmlabs_connect/src/view/account_setting/summary/summary_view.dart';
import 'package:cmlabs_connect/src/view/add_contact_view.dart';
import 'package:cmlabs_connect/src/view/detail_quotation_view.dart';
import 'package:cmlabs_connect/src/view/edit_quotation_view.dart';
import 'package:cmlabs_connect/src/view/historical_lead_view.dart';
import 'package:cmlabs_connect/src/view/select_edit_view.dart';
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
  static const String editQuotation = '/editQuotation';
  static const String addContactClientPIC = '/addContactClientPIC';
  // static const String profile = '/profile';

  static const String filter = '/filter';
  static const String filterSelect = '/filterSelect';
  static const String editSelect = '/editSelect';

  static const String historicalLead = '/historicalLead';

  // account menu
  static const String summaryView = '/summaryView';
  static const String formSummaryView = '/summaryView/form';

  static const String experienceView = '/experienceView';
  static const String formExperienceView = '/experienceView/form';
  static const String selectDataExperience = '/experienceView/form/select';

  static const String educationView = '/educationView';
  static const String formEducationView = '/educationView/form';
  static const String selectDataEducation = '/educationView/form/select';

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
        final args = Get.arguments as Map<String, dynamic>;
        final String filter = args['selectData'];
        final dynamic controller = args['controller'];
        final bool canSearch = args['canSearch'] ?? true;
        return SelectFilterView(
            filter: filter, controller: controller, canSearch: canSearch);
      },
    ),
    GetPage(
      name: editSelect,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final String selectData = args['selectData'];
        final dynamic controller = args['controller'];
        return SelectEditView(
          selectData: selectData,
          controller: controller,
        );
      },
    ),
    GetPage(name: historicalLead, page: () => HistoricalLeadView()),
    GetPage(
      name: detailQuotation,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return DetailQuotationView(quotation: args['quotation']);
      },
    ),

    GetPage(
      name: addContactClientPIC,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return AddContactView(clientPIC: args['clientPic']);
      },
    ),

    GetPage(
      name: editQuotation,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return EditQuotationView(quotation: args['quotation']);
      },
    ),

    // Account menu route
    GetPage(
      name: summaryView,
      page: () => SummaryView(),
    ),

    GetPage(
      name: formSummaryView,
      page: () {
        final args = Get.arguments as String;
        return FormSummaryView(status: args);
      },
    ),

    GetPage(
      name: experienceView,
      page: () => ExperienceView(),
    ),
    GetPage(
      name: formExperienceView,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final String status = args['status'];
        final int? id = args['id'] as int?;

        return FormExperienceView(
          status: status,
          id: id,
        );
      },
    ),
    GetPage(
      name: selectDataExperience,
      page: () {
        final args = Get.arguments as String;
        return SelectData(data: args);
      },
    ),

    GetPage(
      name: educationView,
      page: () => ExperienceView(),
    ),
    GetPage(
      name: formEducationView,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final String status = args['status'];
        final int? id = args['id'] as int?;

        return FormExperienceView(
          status: status,
          id: id,
        );
      },
    ),
    GetPage(
      name: selectDataEducation,
      page: () {
        final args = Get.arguments as String;
        return SelectData(data: args);
      },
    ),
  ];
}
