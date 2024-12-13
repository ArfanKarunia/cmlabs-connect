import 'package:cmlabs_connect/src/constant/config.dart';
import 'package:cmlabs_connect/src/controllers/authentication_controller.dart';
import 'package:cmlabs_connect/src/controllers/notification_controller.dart';
import 'package:cmlabs_connect/src/controllers/quotation_controller.dart';
import 'package:cmlabs_connect/src/models/quotation_model.dart';
import 'package:cmlabs_connect/src/utils/string_utils.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DetailQuotationController extends GetxController {
  var isShowAll = false.obs;

  var quotation = Rx<Quotation?>(null);
  var pitchDuration = Rx<String?>(null);

  var serviceQuotation = Rx<String?>(null);
  var additionalData = Rx<Map<String, dynamic>?>(null);

  void changeShowValue() {
    isShowAll.value = !isShowAll.value;
  }

  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());

  final QuotationController quotationController =
      Get.put(QuotationController());
  
  final NotificationController notificationController = Get.put(NotificationController());

  final Dio dio = Dio();
  final baseUrl = Config.baseURL;

  final title = [
    "ID",
    "Joined at",
    "Status",
    "Category",
    "Client Source",
    "Name",
    "Email",
    "Whatsapp",
    "Company Website",
    "Registration Status",
    "Company Name",
    "Company Profile",
    "Page Source",
    "Service",
    "Region",
  ];

  Map<String, String> detailData() {
    String section = StringUtils.toCamelCase(quotation.value!.section);
    List<String?>? categories = quotation.value?.data.category;

    // Cek apakah category ada dan tidak kosong
    String category = categories != null && categories.isNotEmpty
        ? "$section, ${categories.join(', ')}"
        : section;
    return {
      "company": quotation.value!.data.company ?? "N/A",
      "ID": quotation.value!.id.toString(),
      "Joined at": DateFormat('d MMMM yyyy, HH:mm:ss')
          .format(quotation.value!.createdAt),
      "Status": labelStatusLead(quotation.value!.status),
      "Category": category,
      "Client Source": quotation.value!.data.clientSource?.name ?? "-",
      "Name": quotation.value!.data.name ?? "-",
      "Email": quotation.value!.email,
      "Whatsapp": quotation.value!.data.phoneNumber ?? "-",
      "Company Website": quotation.value!.data.website ?? "-",
      "Registration Status": "-",
      "Company Name": quotation.value!.data.company ?? "N/A",
      "Company Profile": quotation.value!.data.companyIndustry ?? "-",
      "Page Source": quotation.value!.url,
      "Service": StringUtils.toCamelCase(quotation.value!.section),
      "Region": quotation.value!.data.region ?? "-",
    };
  }

  Future<void> fetchDetailQuotation(int id) async {
    try {
      String? accessToken = authenticationController.accesToken.value;

      final response = await dio.get(
        '$baseUrl/quotation/$id',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final rawData = response.data['data'];

        if (rawData != null) {
          // Create a new Quotation object from the fetched data
          Quotation updatedQuotation = Quotation.fromJson(rawData);

          quotation.value = updatedQuotation;

          pitchDuration.value =
              StringUtils.setPitchDuration(rawData['pitching_duration']);
          serviceQuotation.value = rawData['section'];

          await getAdditionalData(serviceQuotation.value, rawData['data']);

          // Find the index of the existing quotation in the list
          int index = quotationController.quotationList
              .indexWhere((quotation) => quotation.id == id);

          // If the quotation exists, update it
          if (index != -1) {
            quotationController.quotationList[index] =
                updatedQuotation; // Update the existing quotation

            quotationController.fetchQuotationData(refreshData: true);
            notificationController.fetchNotification(refreshData: true);
            
          } else {
            // Optionally, you can add the new quotation if it doesn't exist
            quotationController.quotationList.add(updatedQuotation);
          }
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Future<Map<String, dynamic>?> fetchAppData(String appId) async {
    // Determine the platform based on the appId
    final String platform = appId.contains('com.') ? 'playstore' : 'appstore';
    String cleanedAppId = appId.replaceAll('"', '');

    final String url =
        '${platform == "playstore" ? "https://aso-rest-api.vercel.app/api/play-store" : "https://aso-rest-api.vercel.app/api/app-store"}/app-info?id=$cleanedAppId';

    try {
      // Make the GET request
      final response = await dio.get(url);

      // Check if the response is successful
      if (response.statusCode == 200) {
        final data = response.data['data'];
        return {
          "icon_App": data['icon'],
          "id_App": data['id'],
          "name_App": data['name'],
          "url_App": data['url'],
          "subtitle_App": data['subtitle'],
          "in_app": data['in_app'],
          "updates_app": data['updates'],
          "reviews_rating_App": data['reviews_rating'],
        };
      } else {
        print('Failed to load app data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching app data: $e');
      return null;
    }
  }

  Future<void> getAdditionalData(String? section, dynamic data) async {
    additionalData.value = null;
    if (section != null) {
      switch (section) {
        case 'website-copywriting': // DONE
          additionalData.value = {
            "language": data['language'] ?? '-',
            "page_type": data['page_type'] ?? '-',
            "word_count": data['word_count'] ?? '-',
            "bussiness_sector": data['bussiness_sector'],
            "copywriting_style": data['copywriting_style'] ?? '-',
            "meeting_appointment": data['meeting_appointment'] ?? '-',
            "message": data['message'] ?? '-',
          };
          break;
        case 'press-release': // DONE
          additionalData.value = {
            "language": data['language'] ?? '-',
            "word_count": data['word_count'] ?? '-',
            "bussiness_sector": data['bussiness_sector'] ?? '-',
            "project_duration": data['project_duration'] ?? '-',
            "total_press_release": data['total_press_release'] ?? '-',
            "media_placement": data['media_placement'] ?? '-',
            "meeting_appointment": data['meeting_appointment'] ?? '-',
            "message": data['message'] ?? '-',
          };
          break;
        case 'visuwisu': // DONE
          additionalData.value = {
            "package": data['package'] ?? '-',
            "level": data['level'] ?? '-',
            "contract": data['contract'] ?? '-',
            "message": data['message'] ?? '-',
          };
          break;
        case 'social-media-copywriting': // DONE
          additionalData.value = {
            "language": data['language'] ?? '-',
            "socmed_platform": data['socmed_platform'] ?? '-',
            "content_type": data['content_type'] ?? '-',
            "word_count": data['word_count'] ?? '-',
            "bussiness_sector": data['bussiness_sector'] ?? '-',
            "copywriting_style": data['copywriting_style'] ?? '-',
            "project_duration": data['project_duration'] ?? '-',
            "optimize_content": data['optimize_content'] ?? '-',
            "meeting_appointment": data['meeting_appointment'] ?? '-',
            "message": data['message'] ?? '-',
          };
          break;
        case 'seo-writing': // DONE
          additionalData.value = {
            "language": data['language'],
            "word_quantity": data['word_quantity'],
            "bussiness_sector": data['bussiness_sector'],
            "project_duration": data['project_duration'],
            "total_article": data['total_article'],
            "meeting_appointment": data['meeting_appointment'],
            "message": data['message'],
          };
          break;
        case 'content-writing':
          additionalData.value = {
            "language": data['language'] ?? '-',
            "word_quantity": data['word_quantity'] ?? '-',
            "bussiness_sector": data['bussiness_sector'] ?? '-',
            "project_duration": data['project_duration'] ?? '-',
            "total_article": data['total_article'] ?? '-',
            "meeting_appointment": data['meeting_appointment'] ?? '-',
            "message": data['message'] ?? '-',
          };
          break;
        case 'expert-writing': // DONE
          additionalData.value = {
            "language": data['language'] ?? '-',
            "word_count": data['word_count'] ?? '-',
            "bussiness_sector": data['bussiness_sector'] ?? '-',
            "total_article": data['total_article'] ?? '-',
            "project_duration": data['project_duration'] ?? '-',
            "meeting_appointment": data['meeting_appointment'] ?? '-',
            "message": data['message'] ?? '-',
          };
          break;
        case 'ads':
          if (data['section'] == "Evergreen SEO Service") {
            additionalData.value = {
              "section_ads": data['section'] ?? '-',
              "category_ads": data['category'] ?? '-',
              "market_/_niche": data['niche'] ?? '-',
              "language": data['language'] ?? '-',
              "your_SEO_Target": data['seo_target'] ?? '-',
              "age_of_website": data['age_website'] ?? '-',
              "SEO_team": data['seo_team'] ?? '-',
              "content_writer_team": data['writer_team'] ?? '-',
              "client's_SEO_understanding": data['seo_understand'] ?? '-',
              "is_have_targeted_keyword?": data['have_targeted_keyword'] ?? '-',
              "count_of_client's_website": data['count_website'] ?? '-',
              "cmlabs_is_first_client's_SEO_consultant":
                  data['first_seo_consultant'] ?? '-',
              "online_assets": data['online_assets'] ?? '-',
            };
          } else if (data['section'] == "Evergreen Media Buying") {
            additionalData.value = {
              "package": data['package'] ?? '-',
              "media": data['media'] ?? '-',
            };
          } else if (data['section'] == "Evergreen Writing") {
            additionalData.value = {
              "language": data['language'] ?? '-',
              "social_media_platform": data['socmed_platform'] ?? '-',
              "content_type": data['content_type'] ?? '-',
              "word_count": data['word_count'] ?? '-',
              "bussiness_sector": data['bussiness_sector'] ?? '-',
              "optimize_the_campaign_with_visuwisu":
                  data['optimize_the_campaign_with_visuwisu'] ?? '-',
              "copywriting_style": data['copywriting_style'] ?? '-',
              "project_duration": data['project_duration'] ?? '-',
              "meeting_appointment": data['meeting_appointment'] ?? '-',
              "message": data['message'] ?? '-',
            };
          } else if (data['section'] == "evergreen") {
            final type = data['quotation']['type'] ?? '-';
            final parts = type.split(' - ');
            additionalData.value = {
              "package": parts.isNotEmpty ? parts[0] : '-',
              "selected_language":
                  parts.length > 1 ? parts[1] : data['language'] ?? '-',
            };
          }
          break;
        case 'aso-services': // DONE
          if (data['data_app_id'] != '-') {
            Map<String, dynamic>? appData =
                await fetchAppData(data['data_app_id']);
            print(data['data_app_id']);
            print(appData);

            if (appData != null) {
              additionalData.value = {
                "icon_App": appData['icon_App'],
                "data_app_name": appData['name_App'] != ''
                    ? appData['name_App'] ?? '-'
                    : data['data_app_name'] ?? '-',
                "subtitle_App": appData['subtitle_App'] ?? '-',
                "data_app_platform": data['data_app_platform'] ?? '-',
                "data_app_in_app": appData['in_app'] != ''
                    ? appData['in_app'] ?? '-'
                    : data['data_app_in_app'] ?? '-',
                "data_app_cat": data['data_app_cat'] ?? '-',
                "updates": appData['updates_app'] ?? '-',
                "review_&_rating": appData['reviews_rating_App'] != ''
                    ? appData['reviews_rating_App'] ?? '-'
                    : data['data_app_rating'] ?? '-',
                "data_app_url": appData['url_App'] != ''
                    ? appData['url_App'] ?? '-'
                    : data['data_app_url'] ?? '-',
                "data_package": data['data_package'] ?? '-',
                // "data_app_id": data['data_app_id'],
              };
            } else {
              additionalData.value = {
                "data_package": data['data_package'],
                "data_app_id": data['data_app_id'],
                "data_app_platform": data['data_app_platform'],
                "data_app_url": data['data_app_url'],
                "data_app_cat": data['data_app_cat'],
                "data_app_rating": data['data_app_rating'],
                "data_app_in_app": data['data_app_in_app'],
                "data_app_name": data['data_app_name'],
                "custom_keyword": data['custom_keyword'],
                "appname": data['appname'],
              };
            }
          } else {
            additionalData.value = {
              "data_package": '-',
              "data_app_id": '-',
              "data_app_platform": '-',
              "data_app_url": '-',
              "data_app_cat": '-',
              "data_app_rating": '-',
              "data_app_in_app": '-',
              "data_app_name": '-',
              "custom_keyword": '-',
              "appname": '-',
            };
          }
          break;
        case 'development-service':
          additionalData.value = {
            "category": data['category'],
            "message": data['message'],
          };
          break;
        default:
          additionalData.value = {};
          break;
      }
    }
  }

  String labelStatusLead(int status) {
    var label = '';
    switch (status) {
      case 0:
        label = "New";
        break;
      case 1:
        label = "Followed Up";
        break;
      case 2:
        label = "Accepted";
        break;
      case 3:
        label = "Rejected";
        break;
      case 4:
        label = "On hold";
        break;
      default:
        label = "New";
    }

    return label;
  }
}
