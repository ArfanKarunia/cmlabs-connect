import 'package:cmlabs_connect/src/constant/config.dart';
import 'package:cmlabs_connect/src/controllers/authentication_controller.dart';
import 'package:cmlabs_connect/src/controllers/notification_controller.dart';
import 'package:cmlabs_connect/src/controllers/quotation_controller.dart';
import 'package:cmlabs_connect/src/controllers/user_controler.dart';
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
  var detailData = Rx<Map<String, dynamic>?>(null);
  var additionalData = Rx<Map<String, dynamic>?>(null);

  void changeShowValue() {
    isShowAll.value = !isShowAll.value;
  }

  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());

  final UserControler userControler = Get.put(UserControler());

  final QuotationController quotationController =
      Get.put(QuotationController());

  final NotificationController notificationController =
      Get.put(NotificationController());

  final Dio dio = Dio();
  final baseUrl = Config.baseURL;

  Future<void> fetchDetailQuotation(int id) async {
    try {
      String? accessToken = userControler.accesToken.value;

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

          // Set pitch duration and service quotation
          pitchDuration.value =
              StringUtils.setPitchDuration(rawData['pitching_duration']);
          serviceQuotation.value = rawData['section'];

          // Generate detail data
          detailData.value = null;
          print(id);
          generateDetailData(updatedQuotation, additionalData: rawData['data']);

          // Update additional data
          await getAdditionalData(serviceQuotation.value, rawData['data']);

          // Update quotation list
          int index = quotationController.quotationList
              .indexWhere((quotation) => quotation.id == id);

          if (index != -1) {
            quotationController.quotationList[index] = updatedQuotation;
          } else {
            quotationController.quotationList.add(updatedQuotation);
          }

          quotationController.fetchQuotationData(refreshData: true);
          notificationController.fetchNotification(refreshData: true);
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void generateDetailData(Quotation quotation, {dynamic additionalData}) {
    String section = StringUtils.toCamelCase(quotation.section);
    List<String?>? categories = quotation.data.category;

    // Format category
    String categoryText = categories.isNotEmpty
        ? StringUtils.toCamelCase(categories.map((cat) {
            return cat == null || cat.isEmpty
                ? '-'
                : cat.replaceAll('SEO Article', 'SEO Writing');
          }).join(', '))
        : section;

    // Prepare basic detail data
    Map<String, dynamic> details = {
      "ID": quotation.id.toString(),
      "joined_at": DateFormat('d MMMM yyyy, HH:mm:ss')
          .format(quotation.createdAt.toLocal()),
      "status": labelStatusLead(quotation.status),
      "category": categoryText,
      "client_source": quotation.data.clientSource?.name ?? "-",
      "name": quotation.data.name ?? "-",
      "email": quotation.email,
      "whatsapp": quotation.data.phoneNumber ?? "-",
      "company_website": quotation.data.website ?? "-",
      "registration_status": additionalData['registration-status'] ?? '-',
      "company_name": quotation.data.company ?? "N/A",
      "company_profile": quotation.data.companyIndustry ?? "-",
      "page_source": quotation.url,
    };

    // Check if the section is 'ramadan24' and add the additional data
    if (section.toLowerCase() == 'ramadan24') {
      details.addAll({
        "package_name": additionalData['package_name'] ?? "-",
        "package_price": additionalData['package_price'] ?? "-",
        "budget": additionalData['budget'] ?? "-",
      });
    }

    // Check for 'data_package' and add it to the details
    if (additionalData['data_package'] != null) {
      details.addAll({
        "aso_package": additionalData['data_package'] ?? "-",
      });
    }

    // Check for 'custom_keywrd_aso' and add it to the details
    if (additionalData['custom_keyword'] != null) {
      // If 'custom_keywrd_aso' is a list, join its elements into a single string
      String customKeywords = additionalData['custom_keyword'] is List
          ? (additionalData['custom_keyword'] as List).join(', ')
          : additionalData['custom_keyword'].toString();

      details.addAll({
        "custom_keyword_aso": customKeywords.isEmpty ? customKeywords : '-',
      });
    }

    // Check if it is evergreen and handle service and category accordingly
    bool isEvergreen = additionalData['isEvergreen'] ?? false;
    if (isEvergreen) {
      String serviceCategory = additionalData['service'] ?? '-';
      serviceCategory =
          serviceCategory.replaceAll('-', ' ').replaceAll('_', ' ');
      serviceCategory = serviceCategory.replaceAll(',', ', ');

      details.addAll({
        "service": StringUtils.toCamelCase(serviceCategory)
            .replaceAll('SEO Article', 'SEO Writing'),
      });
    } else {
      if (additionalData['category'] != null) {
        String categoryText = "";

        // Konversi category ke teks
        if (additionalData['category'] is List) {
          categoryText = (additionalData['category'] as List).map((cat) {
            return cat.replaceAll('SEO Article', 'SEO Writing');
          }).join(', ');
        } else {
          categoryText = additionalData['category'] ?? '-';
        }

        // Cek apakah section berbeda dengan categoryText
        if (StringUtils.toCamelCase(quotation.section!.toLowerCase()) != StringUtils.toCamelCase(categoryText.toLowerCase())) {
          details.addAll({
            "service":
                StringUtils.toCamelCase("${quotation.section}, $categoryText"),
          });
        } else {
          details.addAll({
            "service": StringUtils.toCamelCase(categoryText),
          });
        }
      } else {
        // Jika category kosong, gunakan section
        details.addAll({
          "service": StringUtils.toCamelCase(quotation.section ?? '-'),
        });
      }
    }

    // Process type using StringUtils.extractPackageLanguage
    var type = additionalData['type'];

    if (type != null) {
      if (type is String) {
        // Jika type berupa String, proses seperti biasa
        var packageLanguage = StringUtils.extractPackageLanguage(type);

        details.addAll({
          "package": packageLanguage["package"] ?? "-",
          "selected_language": packageLanguage["selected_language"] ?? "-",
        });
      }
    }

    // Process region
    String? region = additionalData['region'];
    if (region != null) {
      details.addAll({
        "region": region != 'en'
            ? region.toUpperCase()
            : (quotation.url.contains('/en/'))
                ? "GLOBAL"
                : "-",
      });
    }

    // Check for 'development-service' section
    if (quotation.section == 'development-service') {
      details.addAll({
        "development_service_message": additionalData['message'] ?? '-',
      });
    }

    // Check for 'Evergreen Media Buying' section
    if (additionalData['section'] == 'Evergreen Media Buying') {
      details.addAll({
        "evergreen_package": additionalData['package'] ?? '-',
        "evergreen_media": additionalData['media'] ?? '-',
      });
    }

    // Set the detailData
    detailData.value = details;
    // print("========== Pembatas ==========");
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
        case 'seo-services': // DONE

          if (data['seo_target'] != null) {
            additionalData.value = {
              "language": data['language'] ?? '', // "Multi langual"
              "niche": data['niche'] ?? '', // "1 Country"
              "seo_target": data['seo_target'] ?? '',
              "seo_team": data['seo_team'] ?? '',
              "online_asset": data['online_assets'] ?? '', // "30"
              "age_of_website": data['age_website'] ?? '', // "1 - 3 Years"
              "content_writer_team":
                  data['writer_team'] ?? '', // "Yes, 1-3 Writers"
              "your_seo_understanding": data['seo_understand'] ?? '', // "0"
              "do_you_have_targeted_keyword?":
                  data['have_targeted_keyword'] ?? '', // "Yes"
              "cmlabs_will_help_your_(?)_website":
                  data['count_website'] ?? '', // "2-5"
              "cmlabs_is_your_first_SEO_consultant?":
                  data['first_seo_consultant'] ?? '', // "Yes"
              "meeting_appointment":
                  data['meeting_appointment'] ?? '', // "2025-01-10"
              "message": data['message'] ??
                  '', // "Hi Marketing, can you please send me the quotation immediately? Thanks :)"
            };
          }
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
          if (data['word_quantity'] != null) {
            additionalData.value = {
              "language": data['language'] ?? '-',
              "word_quantity": data['word_quantity'] ?? '-',
              "bussiness_sector": data['bussiness_sector'] ?? '-',
              "project_duration": data['project_duration'] ?? '-',
              "total_article": data['total_article'] ?? '-',
              "meeting_appointment": data['meeting_appointment'] ?? '-',
              "message": data['message'] ?? '-',
            };
          }
          break;
        case 'expert-writing': // DONE
          additionalData.value = {
            "language": data['language'] ?? '-',
            "word_count": data['word_count'] ?? '-',
            "bussiness_sector": data['bussiness_sector'] ?? '-',
            "total_article": data['total_article'] ?? '-',
            "project_duration": data['project_duration'] != null
                ? "${data['project_duration']} month"
                : '-',
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
          } else if (data['partnership'] != null) {
            additionalData.value = {
              "proposal": data['partnership_detail']['proposal'] ?? '-',
              "urgency_level": StringUtils.toCamelCase(data['email-urgency']),
              "contact_me_by": data['follow_up_through'] ?? '-',
            };

            // Check if follow-up is 'meeting' and add meeting details
            if (data['follow_up_through'] == 'meeting') {
              additionalData.value!.addAll({
                "preferred_date": data['meeting_appointment'] ?? "-",
                "preferred_time": data['meeting_time'] != null
                    ? "${data['meeting_time']['clock'] != null ? data['meeting_time']['clock']['from'] : '00:00'} - ${data['meeting_time']['clock'] != null ? data['meeting_time']['clock']['to'] : '00:00'}"
                    : '00:00 - 00:00',
              });
            }
          }
          break;
        case 'aso-services': // DONE
          if (data['data_app_id'] != '-') {
            Map<String, dynamic>? appData =
                await fetchAppData(data['data_app_id']);

            if (appData != null) {
              additionalData.value = {
                "app_name_inputted": data['appname'],
                "icon_App": appData['icon_App'],
                "app_name": appData['name_App'] != ''
                    ? appData['name_App'] ?? '-'
                    : data['data_app_name'] ?? '-',
                "App Subtitle": appData['subtitle_App'] ?? '-',
                "platform": data['data_app_platform'] ?? '-',
                "in_app": appData['in_app'] != ''
                    ? appData['in_app'] ?? '-'
                    : data['data_app_in_app'] ?? '-',
                "category": data['data_app_cat'] ?? '-',
                "updates": appData['updates_app'] ?? '-',
                "review_&_rating": appData['reviews_rating_App'] != ''
                    ? appData['reviews_rating_App'] ?? '-'
                    : data['data_app_rating'] ?? '-',
                "app_url": appData['url_App'] != ''
                    ? appData['url_App'] ?? '-'
                    : data['data_app_url'] ?? '-',
                "aso_package": data['data_package'] ?? '-',
                "custom_keyword(ASO_package)": '-',
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
