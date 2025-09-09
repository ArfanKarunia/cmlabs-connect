import 'package:cmlabs_connect/src/view/account/achievement/achievement_view.dart';
import 'package:cmlabs_connect/src/view/account/achievement/form_achievement_view.dart';
import 'package:cmlabs_connect/src/view/account/certification/certification_view.dart';
import 'package:cmlabs_connect/src/view/account/certification/form_certification_view.dart';
import 'package:cmlabs_connect/src/view/account/change_password_view.dart';
import 'package:cmlabs_connect/src/view/account/education/education_view.dart';
import 'package:cmlabs_connect/src/view/account/education/form_education_view.dart';
import 'package:cmlabs_connect/src/view/account/experience/experience_view.dart';
import 'package:cmlabs_connect/src/view/account/experience/form_experience_view.dart';
import 'package:cmlabs_connect/src/view/account/notification/setting_notification_view.dart';
import 'package:cmlabs_connect/src/view/account/organization/form_organization_view.dart';
import 'package:cmlabs_connect/src/view/account/organization/organization_view.dart';
import 'package:cmlabs_connect/src/view/account/profile/edit_profile_view.dart';
import 'package:cmlabs_connect/src/view/account/publication/form_publication_view.dart';
import 'package:cmlabs_connect/src/view/account/publication/publication_view.dart';
import 'package:cmlabs_connect/src/view/account/account_select_view.dart';
import 'package:cmlabs_connect/src/view/account/summary/form_summary_view.dart';
import 'package:cmlabs_connect/src/view/account/summary/summary_view.dart';
import 'package:cmlabs_connect/src/view/account/volunteer/form_volunteer_view.dart';
import 'package:cmlabs_connect/src/view/account/volunteer/volunteer_view.dart';
import 'package:cmlabs_connect/src/view/historical_lead/historical_lead_view.dart';
import 'package:cmlabs_connect/src/view/notification/notification_view.dart';
import 'package:get/get.dart';

import 'controllers/filter/filter_controller.dart';
import 'controllers/historical_lead/historical_lead_controller.dart';
import 'controllers/notification/notification_controller.dart';
import 'models/inbox/case_studies_model.dart';
import 'models/inbox/property/client_pic_model.dart';
import 'models/inbox/contact_us_model.dart';
import 'models/inbox/faq_model.dart';
import 'models/inbox/property/project_history_model.dart';
import 'models/inbox/quotation_model.dart';
import 'view/analytics/analytics_filter_view.dart';
import 'view/analytics/analytics_view.dart';
import 'view/analytics/detail_quotation_traffic_view.dart';
import 'view/analytics/detail_quotation_trends_view.dart';
import 'view/analytics/detail_top_pics_view.dart';
import 'view/analytics/detail_top_services_view.dart';
import 'view/auth_wrapper.dart';
import 'view/filter/filter_view.dart';
import 'view/historical_lead/historical_lead_select_view.dart';
import 'view/home_view.dart';
import 'view/inbox/case_studies/case_studies_detail_view.dart';
import 'view/inbox/case_studies/case_studies_edit_history_view.dart';
import 'view/inbox/case_studies/case_studies_edit_pic_contact_view.dart';
import 'view/inbox/case_studies/case_studies_edit_select_view.dart';
import 'view/inbox/case_studies/case_studies_edit_view.dart';
import 'view/inbox/contact_us/contact_us_detail_view.dart';
import 'view/inbox/contact_us/contact_us_edit_history_view.dart';
import 'view/inbox/contact_us/contact_us_edit_pic_contact_view.dart';
import 'view/inbox/contact_us/contact_us_edit_select_view.dart';
import 'view/inbox/contact_us/contact_us_edit_view.dart';
import 'view/inbox/faq/faq_detail_view.dart';
import 'view/inbox/faq/faq_edit_select_view.dart';
import 'view/inbox/faq/faq_edit_status_view.dart';
import 'view/inbox/quotation/quotation_add_pic_contact_view.dart';
import 'view/inbox/quotation/quotation_add_select_new_view.dart';
import 'view/inbox/quotation/quotation_add_select_view.dart';
import 'view/inbox/quotation/quotation_add_view.dart';
import 'view/inbox/quotation/quotation_detail_view.dart';
import 'view/inbox/quotation/quotation_edit_history_view.dart';
import 'view/inbox/quotation/quotation_edit_pic_contact_view.dart';
import 'view/inbox/quotation/quotation_edit_select_view.dart';
import 'view/inbox/quotation/quotation_edit_view.dart';
import 'view/login_view.dart';
import 'view/notification/notification_select_view.dart';
import 'view/filter/select_filter_view.dart';

class AppRoutes {
  static const String first = '/';
  static const String login = '/login';
  static const String home = '/home';

  static const String addQuotation = '/addQuotation';
  static const String addQuotationSelect = '/addQuotationSelect';
  static const String addQuotationSelectNew = '/addQuotationSelectNew';
  static const String addQuotationContact = '/addQuotationContact';
  static const String detailQuotation = '/detailQuotation';
  static const String editQuotation = '/editQuotation';
  static const String editQuotationSelect = '/editQuotationSelect';
  static const String editQuotationContact = '/editQuotationContact';
  static const String editQuotationHistory = '/editQuotationHistory';

  static const String detailCaseStudies = '/detailCaseStudies';
  static const String editCaseStudies = '/editCaseStudies';
  static const String editCaseStudiesSelect = '/editCaseStudiesSelect';
  static const String editCaseStudiesContact = '/editCaseStudiesContact';
  static const String editCaseStudiesHistory = '/editCaseStudiesHistory';

  static const String detailContactUs = '/detailContactUs';
  static const String editContactUs = '/editContactUs';
  static const String editContactUsSelect = '/editContactUsSelect';
  static const String editContactUsContact = '/editContactUsContact';
  static const String editContactUsHistory = '/editContactUsHistory';

  static const String detailFaq = '/detailFaq';
  static const String editFaqStatus = '/editFaqStatus';
  static const String editFaqSelect = '/editFaqSelect';

  static const String filter = '/filter';
  static const String filterSelect = '/filterSelect';

  static const String notification = '/notification';
  static const String notificationSelect = '/notificationSelect';

  static const String historicalLead = '/historicalLead';
  static const String historicalLeadSelect = '/historicalLeadSelect';
  // account menu
  static const String accountSelectView = '/accountSelectView';

  static const String editProfileView = '/editProfileView';
  static const String changePasswordView = '/changePasswordView';

  static const String summaryView = '/summaryView';
  static const String formSummaryView = '/summaryView/form';

  static const String experienceView = '/experienceView';
  static const String formExperienceView = '/experienceView/form';

  static const String educationView = '/educationView';
  static const String formEducationView = '/educationView/form';

  static const String certificationView = '/certificationView';
  static const String formCertificationnView = '/certificationView/form';

  static const String organizationView = '/organizationView';
  static const String formOrganizationView = '/organizationView/form';

  static const String achievementView = '/achievementView';
  static const String formAchievementView = '/achievementView/form';

  static const String volunteerView = '/volunteerView';
  static const String formVolunteerView = '/volunteerView/form';

  static const String publicationView = '/publicationView';
  static const String formPublicationView = '/publicationView/form';

  static const String settingNotification = '/settingNotification';

  static const String analyticsView = '/analyticsView';
  static const String analyticsFilterView = '/analyticsFilterView';
  static const String detailQuotationTrafficView = '/detailQuotationTrafficView';
  static const String detailTopServicesView = '/detailTopServicesView';
  static const String detailTopPICsView = '/detailTopPICsView';
  static const String detailQuotationTrendsView = '/detailQuotationTrendsView';

  // List of Route
  static List<GetPage> routes = [
    GetPage(
      name: first,
      page: () => const AuthWrapper(),
    ),
    GetPage(
      name: login,
      page: () => const LoginView(),
    ),
    GetPage(
      name: home,
      page: () => const HomeView(),
    ),

    // Filter
    GetPage(
      name: filter,
      page: () => const FilterView(),
    ),
    GetPage(
      name: filterSelect,
      page: () {
        final InboxFilterType filter = Get.arguments['filter'];
        final String title = Get.arguments['title'];
        final bool canSearch = Get.arguments['canSearch'] ?? true;
        final bool isMultipleChoice = Get.arguments['isMultipleChoice'] ?? true;

        return SelectFilterView(
          filter: filter,
          title: title,
          canSearch: canSearch,
          isMultipleChoice: isMultipleChoice,
        );
      },
    ),

    // Historical Lead
    GetPage(
      name: historicalLead,
      page: () => const HistoricalLeadView(),
    ),
    GetPage(
      name: historicalLeadSelect,
      page: () {
        final HistoricalLeadSelectType data = Get.arguments['data'];
        final int index = Get.arguments['index'];

        return HistoricalLeadSelectView(data: data, index: index);
      },
    ),

    // Notification
    GetPage(
      name: notification,
      page: () => const NotificationView(),
    ),
    GetPage(
      name: notificationSelect,
      page: () {
        final String title = Get.arguments['title'];
        final NotificationFilterType filter = Get.arguments['filter'];
        final bool isMultipleChoice = Get.arguments['isMultipleChoice'] ?? false;

        return NotificationSelectView(
          title: title,
          filter: filter,
          isMultipleChoice: isMultipleChoice,
        );
      },
    ),

    // Add Quotation
    GetPage(
      name: addQuotation,
      page: () => const QuotationAddView(),
    ),
    GetPage(
      name: addQuotationSelect,
      page: () {
        final String title = Get.arguments['title'];
        final String data = Get.arguments['data'];
        final bool isMultipleChoice = Get.arguments['isMultipleChoice'] ?? false;
        final bool isContactForm = Get.arguments['isContactForm'] ?? false;
        final bool canAdd = Get.arguments['canAdd'] ?? false;

        return QuotationAddSelectView(
          title: title,
          data: data,
          isMultipleChoice: isMultipleChoice,
          isContactForm: isContactForm,
          canAdd: canAdd,
        );
      },
    ),
    GetPage(
      name: addQuotationSelectNew,
      page: () {
        final String title = Get.arguments['title'];
        final String data = Get.arguments['data'];
        final int maxDigit = Get.arguments['maxDigit'] ?? 50;

        return QuotationAddSelectNewView(
          title: title,
          data: data,
          maxDigit: maxDigit,
        );
      },
    ),
    GetPage(
      name: addQuotationContact,
      page: () {
        final int contactIndex = Get.arguments['contactIndex'];

        return QuotationAddPicContactView(
          contactIndex: contactIndex,
        );
      },
    ),

    // Detail Leads
    GetPage(
      name: detailQuotation,
      page: () {
        final Quotation quotation = Get.arguments['quotation'];
        return QuotationDetailView(quotation: quotation);
      },
    ),
    GetPage(
      name: detailCaseStudies,
      page: () {
        final CaseStudies caseStudies = Get.arguments['caseStudies'];
        return CaseStudiesDetailView(caseStudies: caseStudies);
      },
    ),
    GetPage(
      name: detailContactUs,
      page: () {
        final ContactUs contactUs = Get.arguments['contactUs'];
        return ContactUsDetailView(contactUs: contactUs);
      },
    ),
    GetPage(
      name: detailFaq,
      page: () {
        final Faq faq = Get.arguments['faq'];
        return FaqDetailView(faq: faq);
      },
    ),

    // Edit Leads
    GetPage(
      name: editQuotation,
      page: () {
        final Quotation quotation = Get.arguments['quotation'];
        return QuotationEditView(quotation: quotation);
      },
    ),
    GetPage(
      name: editCaseStudies,
      page: () {
        final CaseStudies caseStudies = Get.arguments['caseStudies'];
        return CaseStudiesEditView(caseStudies: caseStudies);
      },
    ),
    GetPage(
      name: editContactUs,
      page: () {
        final ContactUs contactUs = Get.arguments['contactUs'];
        return ContactUsEditView(contactUs: contactUs);
      },
    ),
    GetPage(
      name: editFaqStatus,
      page: () {
        final Faq faq = Get.arguments['faq'];
        return FaqEditStatusView(faq: faq);
      },
    ),

    // Edit Select Leads
    GetPage(
      name: editQuotationSelect,
      page: () {
        final String title = Get.arguments['title'];
        final String data = Get.arguments['data'];
        final bool isMultipleChoice = Get.arguments['isMultipleChoice'] ?? false;
        final bool isActivity = Get.arguments['isActivity'] ?? false;
        final bool isHistory = Get.arguments['isHistory'] ?? false;
        final bool isContactForm = Get.arguments['isContactForm'] ?? false;
        final int? index = Get.arguments['index'];

        return QuotationEditSelectView(
          title: title,
          data: data,
          isMultipleChoice: isMultipleChoice,
          isActivity: isActivity,
          isHistory: isHistory,
          isContactForm: isContactForm,
          index: index,
        );
      },
    ),
    GetPage(
      name: editCaseStudiesSelect,
      page: () {
        final String title = Get.arguments['title'];
        final String data = Get.arguments['data'];
        final bool isMultipleChoice = Get.arguments['isMultipleChoice'] ?? false;
        final bool isActivity = Get.arguments['isActivity'] ?? false;
        final bool isHistory = Get.arguments['isHistory'] ?? false;
        final bool isContactForm = Get.arguments['isContactForm'] ?? false;
        final int? index = Get.arguments['index'];

        return CaseStudiesEditSelectView(
          title: title,
          data: data,
          isMultipleChoice: isMultipleChoice,
          isActivity: isActivity,
          isHistory: isHistory,
          isContactForm: isContactForm,
          index: index,
        );
      },
    ),
    GetPage(
      name: editContactUsSelect,
      page: () {
        final String title = Get.arguments['title'];
        final String data = Get.arguments['data'];
        final bool isMultipleChoice = Get.arguments['isMultipleChoice'] ?? false;
        final bool isActivity = Get.arguments['isActivity'] ?? false;
        final bool isHistory = Get.arguments['isHistory'] ?? false;
        final bool isContactForm = Get.arguments['isContactForm'] ?? false;
        final int? index = Get.arguments['index'];

        return ContactUsEditSelectView(
          title: title,
          data: data,
          isMultipleChoice: isMultipleChoice,
          isActivity: isActivity,
          isHistory: isHistory,
          isContactForm: isContactForm,
          index: index,
        );
      },
    ),
    GetPage(
      name: editFaqSelect,
      page: () {
        final String title = Get.arguments['title'];
        final String data = Get.arguments['data'];
        final bool isMultipleChoice = Get.arguments['isMultipleChoice'] ?? false;
        // final bool isActivity = Get.arguments['isActivity'] ?? false;
        // final bool isHistory = Get.arguments['isHistory'] ?? false;
        // final bool isContactForm = Get.arguments['isContactForm'] ?? false;
        // final int? index = Get.arguments['index'];

        return FaqEditSelectView(
          title: title,
          data: data,
          isMultipleChoice: isMultipleChoice,
          // isActivity: isActivity,
          // isHistory: isHistory,
          // isContactForm: isContactForm,
          // index: index,
        );
      },
    ),

    // Edit Contact Leads
    GetPage(
      name: editQuotationContact,
      page: () {
        final int clientIndex = Get.arguments['clientIndex'];
        final ContactClientPic? currentContact = Get.arguments['currentContact'];
        final int? currentContactIndex = Get.arguments['currentContactIndex'];

        return QuotationEditPicContactView(
          clientIndex: clientIndex,
          currentContact: currentContact,
          currentContactIndex: currentContactIndex,
        );
      },
    ),
    GetPage(
      name: editCaseStudiesContact,
      page: () {
        final int clientIndex = Get.arguments['clientIndex'];
        final ContactClientPic? currentContact = Get.arguments['currentContact'];
        final int? currentContactIndex = Get.arguments['currentContactIndex'];

        return CaseStudiesEditPicContactView(
          clientIndex: clientIndex,
          currentContact: currentContact,
          currentContactIndex: currentContactIndex,
        );
      },
    ),
    GetPage(
      name: editContactUsContact,
      page: () {
        final int clientIndex = Get.arguments['clientIndex'];
        final ContactClientPic? currentContact = Get.arguments['currentContact'];
        final int? currentContactIndex = Get.arguments['currentContactIndex'];

        return ContactUsEditPicContactView(
          clientIndex: clientIndex,
          currentContact: currentContact,
          currentContactIndex: currentContactIndex,
        );
      },
    ),

    // Edit History Leads
    GetPage(
      name: editQuotationHistory,
      page: () {
        final ProjectHistory history = Get.arguments['history'];
        return QuotationEditHistoryView(history: history);
      },
    ),
    GetPage(
      name: editCaseStudiesHistory,
      page: () {
        final ProjectHistory history = Get.arguments['history'];
        return CaseStudiesEditHistoryView(history: history);
      },
    ),
    GetPage(
      name: editContactUsHistory,
      page: () {
        final ProjectHistory history = Get.arguments['history'];
        return ContactUsEditHistoryView(history: history);
      },
    ),

    // CHANGE PASSWORD
    GetPage(
      name: changePasswordView,
      page: () => const ChangePasswordView(),
    ),

    // EDIT PROFILE
    GetPage(
      name: editProfileView,
      page: () => const EditProfileView(),
    ),
    GetPage(
      name: accountSelectView,
      page: () => AccountSelectView(data: Get.arguments['data']),
    ),

    // SUMMARY
    GetPage(
      name: summaryView,
      page: () => const SummaryView(),
    ),
    GetPage(
      name: formSummaryView,
      page: () {
        final args = Get.arguments as String;
        return FormSummaryView(status: args);
      },
    ),

    // EXPERIENCE
    GetPage(
      name: experienceView,
      page: () => const ExperienceView(),
    ),
    GetPage(
      name: formExperienceView,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final String status = args['status'];
        final int? id = args['id'] as int?;

        return FormExperienceView(status: status, id: id);
      },
    ),

    // EDUCATION
    GetPage(
      name: educationView,
      page: () => const EducationView(),
    ),
    GetPage(
      name: formEducationView,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final String status = args['status'];
        final int? id = args['id'] as int?;

        return FormEducationView(status: status, id: id);
      },
    ),

    // CERTIFICATION
    GetPage(
      name: certificationView,
      page: () => const CertificationView(),
    ),
    GetPage(
      name: formCertificationnView,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final String status = args['status'];
        final int? id = args['id'] as int?;

        return FormCertificationView(status: status, id: id);
      },
    ),

    // ORGANIZATION
    GetPage(
      name: organizationView,
      page: () => const OrganizationView(),
    ),
    GetPage(
      name: formOrganizationView,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final String status = args['status'];
        final int? id = args['id'] as int?;

        return FormOrganizationView(status: status, id: id);
      },
    ),

    // ACHIEVEMENT
    GetPage(
      name: achievementView,
      page: () => const AchievementView(),
    ),
    GetPage(
      name: formAchievementView,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final String status = args['status'];
        final int? id = args['id'] as int?;

        return FormAchievementView(status: status, id: id);
      },
    ),

    // VOLUNTEER
    GetPage(
      name: volunteerView,
      page: () => const VolunteerView(),
    ),
    GetPage(
      name: formVolunteerView,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final String status = args['status'];
        final int? id = args['id'] as int?;

        return FormVolunteerView(status: status, id: id);
      },
    ),

    // PUBLICATION
    GetPage(
      name: publicationView,
      page: () => const PublicationView(),
    ),
    GetPage(
      name: formPublicationView,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final String status = args['status'];
        final int? id = args['id'] as int?;

        return FormPublicationView(status: status, id: id);
      },
    ),

    // SETTING NOTIFICATION
    GetPage(
      name: settingNotification,
      page: () => const SettingNotificationView(),
    ),

    // ANALYTICS
    GetPage(
      name: analyticsView,
      page: () => const AnalyticsView(),
    ),
    GetPage(
      name: analyticsFilterView,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;

        return AnalyticsFilterView(
          analyticsType: args['analyticsType'],
          controller: args['controller'],
        );
      },
    ),
    GetPage(
      name: detailQuotationTrafficView,
      page: () => const DetailQuotationTrafficView(),
    ),
    GetPage(
      name: detailTopServicesView,
      page: () => const DetailTopServicesView(),
    ),
    GetPage(
      name: detailTopPICsView,
      page: () => const DetailTopPICsView(),
    ),
    GetPage(
      name: detailQuotationTrendsView,
      page: () => const DetailQuotationTrendsView(),
    ),
  ];
}
