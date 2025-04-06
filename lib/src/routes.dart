import 'package:cmlabs_connect/src/view/account_setting/achievement/achievement_view.dart';
import 'package:cmlabs_connect/src/view/account_setting/achievement/form_achievement_view.dart';
import 'package:cmlabs_connect/src/view/account_setting/certification/certification_view.dart';
import 'package:cmlabs_connect/src/view/account_setting/certification/form_certification_view.dart';
import 'package:cmlabs_connect/src/view/account_setting/change_password_view.dart';
import 'package:cmlabs_connect/src/view/account_setting/education/education_view.dart';
import 'package:cmlabs_connect/src/view/account_setting/education/form_education_view.dart';
import 'package:cmlabs_connect/src/view/account_setting/experience/experience_view.dart';
import 'package:cmlabs_connect/src/view/account_setting/experience/form_experience_view.dart';
import 'package:cmlabs_connect/src/view/account_setting/notification/setting_notification_view.dart';
import 'package:cmlabs_connect/src/view/account_setting/organization/form_organization_view.dart';
import 'package:cmlabs_connect/src/view/account_setting/organization/organization_vew.dart';
import 'package:cmlabs_connect/src/view/account_setting/profile/form_profile_view.dart';
import 'package:cmlabs_connect/src/view/account_setting/publication/form_publication_view.dart';
import 'package:cmlabs_connect/src/view/account_setting/publication/publication_view.dart';
import 'package:cmlabs_connect/src/view/account_setting/select_data.dart';
import 'package:cmlabs_connect/src/view/account_setting/summary/form_summary_view.dart';
import 'package:cmlabs_connect/src/view/account_setting/summary/summary_view.dart';
import 'package:cmlabs_connect/src/view/account_setting/volunteer/form_volunteer_view.dart';
import 'package:cmlabs_connect/src/view/account_setting/volunteer/volunteer_view.dart';
import 'package:cmlabs_connect/src/view/detail_quotation/edit_section/add_contact_view.dart';
import 'package:cmlabs_connect/src/view/detail_quotation/detail_quotation_view.dart';
import 'package:cmlabs_connect/src/view/detail_quotation/edit_section/edit_history_view.dart';
import 'package:cmlabs_connect/src/view/detail_quotation/edit_quotation_view.dart';
import 'package:cmlabs_connect/src/view/historical_lead_view.dart';
import 'package:cmlabs_connect/src/view/notification/layout_notification.dart';
import 'package:cmlabs_connect/src/view/select_edit_view.dart';
import 'package:get/get.dart';

import 'models/case_studies_model.dart';
import 'models/client_pic_model.dart';
import 'models/project_history_model.dart';
import 'view/filter_view.dart';
import 'view/inbox/case_studies/case_studies_detail_view.dart';
import 'view/inbox/case_studies/case_studies_edit_history_view.dart';
import 'view/inbox/case_studies/case_studies_edit_pic_contact_view.dart';
import 'view/inbox/case_studies/case_studies_edit_select_view.dart';
import 'view/inbox/case_studies/case_studies_edit_view.dart';
import 'view/inbox/quotation/quotation_add_pic_contact_view.dart';
import 'view/inbox/quotation/quotation_add_select_new_view.dart';
import 'view/inbox/quotation/quotation_add_select_view.dart';
import 'view/inbox/quotation/quotation_add_view.dart';
import 'view/login_view.dart';
import 'view/select_filter_view.dart';
import 'widgets/bottom_navigation.dart';

class AppRoutes {
  // initialization url of route
  static const String home = '/';
  static const String loginForm = '/login';
  static const String addQuotation = '/addQuotation';
  static const String addQuotationSelect = '/addQuotationSelect';
  static const String addQuotationSelectNew = '/addQuotationSelectNew';
  static const String addQuotationContact = '/addQuotationContact';
  static const String detailQuotation = '/detailQuotation';
  static const String detailCaseStudies = '/detailCaseStudies';
  static const String editQuotation = '/editQuotation';
  static const String editCaseStudies = '/editCaseStudies';
  static const String editCaseStudiesSelect = '/editCaseStudiesSelect';
  static const String editCaseStudiesContact = '/editCaseStudiesContact';
  static const String editCaseStudiesHistory = '/editCaseStudiesHistory';
  static const String addContactClientPIC = '/addContactClientPIC';
  static const String editHistoryChangesData = '/editHistoryChangesData';
  // static const String profile = '/profile';

  static const String filter = '/filter';
  static const String filterSelect = '/filterSelect';
  static const String editSelect = '/editSelect';

  static const String notification = '/notification';

  static const String historicalLead = '/historicalLead';

  // account menu
  static const String editProfileView = '/editProfileView';
  static const String selectDataProfile = '/editProfileView/form/select';

  static const String summaryView = '/summaryView';
  static const String formSummaryView = '/summaryView/form';

  static const String experienceView = '/experienceView';
  static const String formExperienceView = '/experienceView/form';
  static const String selectDataExperience = '/experienceView/form/select';

  static const String educationView = '/educationView';
  static const String formEducationView = '/educationView/form';
  static const String selectDataEducation = '/educationView/form/select';

  static const String certificationView = '/certificationView';
  static const String formCertificationnView = '/certificationView/form';
  static const String selectDataCertification = '/certificationView/form/select';

  static const String organizationView = '/organizationView';
  static const String formOrganizationView = '/organizationView/form';
  static const String selectDataOrganization = '/organizationView/form/select';

  static const String achievementView = '/achievementView';
  static const String formAchievementView = '/achievementView/form';
  static const String selectDataAchievement = '/achievementView/form/select';

  static const String volunteerView = '/volunteerView';
  static const String formVolunteerView = '/volunteerView/form';
  static const String selectDataVolunteer = '/volunteerView/form/select';

  static const String publicationView = '/publicationView';
  static const String formPublicationView = '/publicationView/form';
  static const String selectDataPublication = '/publicationView/form/select';

  static const String settingNotification = '/settingNotification';

  static const String changePasswordView = '/changePasswordView';

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
        final bool isMultipleChoice = args['isMultipleChoice'] ?? true;

        return SelectFilterView(
          filter: filter,
          controller: controller,
          canSearch: canSearch,
          isMultipleChoice: isMultipleChoice,
        );
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

    GetPage(name: notification, page: () => const LayoutNotification()),

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

    GetPage(
      name: detailQuotation,
      page: () => DetailQuotationView(),
    ),
    GetPage(
      name: detailCaseStudies,
      page: () {
        final CaseStudies caseStudies = Get.arguments['caseStudies'];

        return CaseStudiesDetailView(caseStudies: caseStudies);
      },
    ),

    GetPage(
      name: addContactClientPIC,
      page: () {
        final args = Get.arguments as int;
        return AddContactView(
          indexClientPIC: args,
        );
      },
    ),

    GetPage(
      name: editHistoryChangesData,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return EditHistoryView(historyData: args['history']);
      },
    ),

    GetPage(
      name: editQuotation,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        return EditQuotationView(quotation: args['quotation']);
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
      name: editCaseStudiesHistory,
      page: () {
        final ProjectHistory history = Get.arguments['history'];

        return CaseStudiesEditHistoryView(
          history: history,
        );
      },
    ),

    // Account menu route

    // CHANGE PASSWORD
    GetPage(
      name: changePasswordView,
      page: () => ChangePasswordView(),
    ),

    // EDIT PROFILE
    GetPage(
      name: editProfileView,
      page: () => FormProfileView(),
    ),
    GetPage(
      name: selectDataProfile,
      page: () {
        final args = Get.arguments as String;
        return SelectData(data: args);
      },
    ),

    // SUUMMARY
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

    // EXPERIENCE
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

    // EDUCATION
    GetPage(
      name: educationView,
      page: () => EducationView(),
    ),
    GetPage(
      name: formEducationView,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final String status = args['status'];
        final int? id = args['id'] as int?;

        return FormEducationView(
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

    // CERTIFICATION
    GetPage(
      name: certificationView,
      page: () => CertificationView(),
    ),
    GetPage(
      name: formCertificationnView,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final String status = args['status'];
        final int? id = args['id'] as int?;

        return FormCertificationView(
          status: status,
          id: id,
        );
      },
    ),
    GetPage(
      name: selectDataCertification,
      page: () {
        final args = Get.arguments as String;
        return SelectData(data: args);
      },
    ),

    // ORGANIZATION
    GetPage(
      name: organizationView,
      page: () => OrganizationVew(),
    ),
    GetPage(
      name: formOrganizationView,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final String status = args['status'];
        final int? id = args['id'] as int?;

        return FormOrganizationView(
          status: status,
          id: id,
        );
      },
    ),
    GetPage(
      name: selectDataOrganization,
      page: () {
        final args = Get.arguments as String;
        return SelectData(data: args);
      },
    ),

    // ACHIEVEMENT
    GetPage(
      name: achievementView,
      page: () => AchievementView(),
    ),
    GetPage(
      name: formAchievementView,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final String status = args['status'];
        final int? id = args['id'] as int?;

        return FormAchievementView(
          status: status,
          id: id,
        );
      },
    ),
    GetPage(
      name: selectDataAchievement,
      page: () {
        final args = Get.arguments as String;
        return SelectData(data: args);
      },
    ),

    // VOLUNTEER
    GetPage(
      name: volunteerView,
      page: () => VolunteerView(),
    ),
    GetPage(
      name: formVolunteerView,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final String status = args['status'];
        final int? id = args['id'] as int?;

        return FormVolunteerView(
          status: status,
          id: id,
        );
      },
    ),
    GetPage(
      name: selectDataVolunteer,
      page: () {
        final args = Get.arguments as String;
        return SelectData(data: args);
      },
    ),

    // PUBLICATION
    GetPage(
      name: publicationView,
      page: () => PublicationView(),
    ),
    GetPage(
      name: formPublicationView,
      page: () {
        final args = Get.arguments as Map<String, dynamic>;
        final String status = args['status'];
        final int? id = args['id'] as int?;

        return FormPublicationView(
          status: status,
          id: id,
        );
      },
    ),
    GetPage(
      name: selectDataPublication,
      page: () {
        final args = Get.arguments as String;
        return SelectData(data: args);
      },
    ),

    // SETTING NOTIFICATION
    GetPage(
      name: settingNotification,
      page: () => SettingNotificationView(),
    ),
  ];
}
