import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant/config.dart';
import '../constant/const.dart';
import '../models/quotation_model.dart';
import '../utils/toast.dart';
import 'authentication_controller.dart';

class QuotationController extends GetxController {
  var quotationList = <Quotation>[].obs;
  var totalLeads = Rx<int>(0);

  var isLoadingMore = false.obs;
  var start = 0.obs;
  var limit = 10.obs;
  var newestIdQuotation = Rx<int>(0);
  var newQuotationCount = Rx<int>(0);

  var filterCategory = <String>[].obs;
  // var filterStatus = <StatusLead>[].obs;
  var filterStatus = Rx<StatusLead?>(null);
  var filterClientSource = <String>[].obs;
  var filterPic = <String>[].obs;

  var filterStartDate = Rx<DateTime?>(null);
  var filterEndDate = Rx<DateTime?>(null);

  var search = Rx<String?>(null);

  final AuthenticationController authenticationController =
      Get.put(AuthenticationController());
  final Dio dio = Dio();
  final baseUrl = Config.baseURL;

  Box<Quotation>? quotationBox;

  /*

    Ketika aplikasi mulai berjalan (controller ini pertama kali di inisialisasi)

    akan membuka sebuah Box (tempat penyimpanan HIVE) bernama quotationBox

  */
  @override
  void onInit() async {
    super.onInit();
    quotationBox = await Hive.openBox<Quotation>('quotationBox');
    await fetchTotalLeads();
    fetchQuotationData();
    checkNewQuotationsPeriodically();
  }

  /*
  
    Ketika controller ini tidak lagi diperlukan

    akan menutup koneksi ke local storage. hal ini dapat mencegah 
    kebocoran memori sehingga performa aplikasi tetap terjaga. 

  */
  @override
  void dispose() {
    quotationBox?.close();
    super.dispose();
  }

  /*
  
    FUNGSI Check Connection and Load Data

    Fungsi ini digunakan untuk mengecek aplikasi yang terhubung dengan internet
    rule:
    - jika terhubung maka akan mengambil data dari API (sementara data dummy) lalu disimpan dalam quotationBox
    - jika TIDAK terhubung maka langsung load data pada quotationBox 

  */

  Future<void> fetchQuotationData(
      {bool isLoadMore = false, bool refreshData = false}) async {
    try {
      // Cek apakah data sudah ada di Hive (local storage)
      if (quotationBox!.isNotEmpty) {
        // Jika data ada di local storage, ambil data dari Hive
        var localData =
            quotationBox!.values.skip(start.value).take(limit.value).toList();
        quotationList.addAll(localData);
        print("Data diambil dari local storage.");
      } else {
        // Jika data belum ada di local storage, fetch data dari API
        String? accessToken = authenticationController.accesToken.value;

        if (refreshData) {
          start.value = 0;
          limit.value = quotationList.length;
        }

        final response = await dio.get(
          '$baseUrl/dashboard/data_recent_quotation?start=${start.value}&limit=${limit.value}',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        );

        if (response.statusCode == 200 && response.data != null) {
          final rawData = response.data['data'];

          if (rawData != null && rawData is List) {
            List<Quotation> quotations = rawData.map<Quotation>((item) {
              return Quotation.fromJson(item);
            }).toList();

            // jika fetch itu untuk load more maka akan menambah quotation List. jika tidak maka akan menimpah atau mengganti dengan data baru.
            if (isLoadMore) {
              quotationList.addAll(quotations); // Menambah data baru
            } else {
              quotationList.value =
                  quotations; // Mengganti list dengan data baru
            }

            if (!isLoadMore) {
              newestIdQuotation.value = quotations.first.id;
            }
            newQuotationCount.value = 0;
            if (refreshData) {
              limit.value = 10;
            }

            // Simpan data baru ke Hive
            // saveDataToHive(quotations);
            print("Data diambil dari API dan disimpan ke local storage.");
          }
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
      if (!isLoadMore) {
        // Jika terjadi error, load dari Hive jika ada data
        var box = Hive.box<Quotation>('quotationBox');
        quotationList.value = box.values.toList();
      }
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> fetchTotalLeads() async {
    try {
      // Ambil access token dari AuthenticationController
      String? accessToken = authenticationController.accesToken.value;

      // Ambil data dari API
      final response = await dio.get(
        baseUrl + '/dashboard/total_all',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        var responseData = response.data;

        if (responseData['status'] == 'success') {
          // Kembalikan data yang di didapatkan dari API
          totalLeads.value = responseData['data'];
        } else {
          print("Status API tidak 'success'.");
        }
      } else {
        print(
            "Error: ${response.statusCode}, Message: ${response.statusMessage}");
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  /*
  
    FUNGSI Check new Data Quotation

    fungsi ini berfungsi untuk mengecek data terbaru dari API

  */

  void checkNewQuotationsPeriodically() {
    Timer.periodic(Duration(seconds: 10), (timer) async {
      await fetchCheckNewData();
      print("check new data : ${newQuotationCount.value}");
    });
  }

  Future<void> fetchCheckNewData() async {
    try {
      // Jika data belum ada di local storage, fetch data dari API
      String? accessToken = authenticationController.accesToken.value;
      var start = 0;
      var limit = 1;

      final response = await dio.get(
        '$baseUrl/dashboard/data_recent_quotation?start=${start}&limit=$limit',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final rawData = response.data['data'];

        if (rawData != null && rawData is List) {
          List<Quotation> quotations = rawData.map<Quotation>((item) {
            return Quotation.fromJson(item);
          }).toList();

          var newQuotationId = quotations.first.id;

          newQuotationCount.value = 0;

          if (newestIdQuotation.value < newQuotationId) {
            newQuotationCount.value = newQuotationId - newestIdQuotation.value;
            newestIdQuotation.value = newQuotationId;
          }

          print("check new data : ${newQuotationCount.value}");
        }
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  /*
  
    FUNGSI Save Data to Hive

    Fungsi ini digunakan untuk menyimpan data ke dalam local Storage HIVE (quotationBox)

  */
  void saveDataToHive(List<Quotation> data) async {
    await quotationBox!.clear();
    await quotationBox!.addAll(data);
  }

  /*
  
    FUNGSI Lod more Data to Hive

    Fungsi ini digunakan untuk menyimpan data ke dalam local Storage HIVE (quotationBox)

  */
  Future<void> loadMoreQuotations() async {
    start.value += limit.value;
    await fetchQuotationData(isLoadMore: true);
  }

  void resetQuotatioinData() {
    start.value = 0;
    quotationList.clear();

    clearFilter();
    fetchQuotationData();
  }

  /*
  
    FUNGSI Set Filter Status

    Fungsi ini digunakan untuk menyimpan data inputan filter Status

  */
  // void addFilterStatus(StatusLead status) {
  //   filterStatus.add(status);
  // }

  // void deleteFilterStatus(StatusLead status) {
  //   filterStatus.remove(status);
  // }

  // void clearFilterStatus() {
  //   filterStatus.clear();
  // }
  void addFilterStatus(StatusLead status) {
    filterStatus.value = status; // Set the single status
  }

  void clearFilterStatus() {
    filterStatus.value = null; // Clear the status
  }

  void clearFilterClientSource() {
    filterClientSource.clear();
  }

  void clearFilterPic() {
    filterPic.clear();
  }

  void clearFilterCategory() {
    filterPic.clear();
  }

  void clearDataRange() {
    filterStartDate.value = null;
    filterEndDate.value = null;
  }

  /*
  
    FUNGSI Set Filter Category

    Fungsi ini digunakan untuk menyimpan data inputan filter Category

  */
  void addFilterCategory(String category) {
    filterCategory.add(category);
  }

  void removeFilterCategory(String category) {
    filterCategory.remove(category);
  }

  /*
  
    FUNGSI Set Filter Client Source

    Fungsi ini digunakan untuk menyimpan data inputan filter Client Source

  */
  void addFilterClientSource(String clientSource) {
    filterClientSource.add(clientSource);
  }

  void removeClientSource(String clientSource) {
    filterClientSource.remove(clientSource);
  }

  /*
  
    FUNGSI Set Filter PIC

    Fungsi ini digunakan untuk menyimpan data inputan filter PIC

  */
  void addFilterPic(String pic) {
    filterPic.add(pic);
  }

  void removeFilterPic(String pic) {
    filterPic.remove(pic);
  }

  /*
  
    FUNGSI Set Search

    Fungsi ini digunakan untuk menyimpan data inputan search

  */
  void setSearch(String? query) {
    search.value = query;
  }

  /*
  
    FUNGSI Set Search

    Fungsi ini digunakan untuk menyimpan data inputan search

  */
  void clearFilter() {
    search.value = null;
    filterStatus.value = null;
    filterCategory.clear();
    filterClientSource.clear();

    filterStartDate.value = null;
    filterEndDate.value = null;
  }

  /*
  
    FUNGSI Filtered Quotation

    Fungsi ini digunakan untuk mengembalikan List Data Quotation sesuai dengan search dan filter dari user

  */
  List<Quotation> get filteredQuotations {
    List<Quotation> result = quotationList;

    if (filterStatus.value != null) {
      int filterStatusIndex = filterStatus.value!.index;

      result = result
          .where((quotation) => quotation.status == filterStatusIndex)
          .toList();
    }

    // Jika filterClientSource tidak kosong, lakukan filter berdasarkan client source
    if (filterClientSource.isNotEmpty) {
      if (filterClientSource.contains('all')) {
        filterClientSource.clear();
        result = quotationList;
      } else {
        result = result.where((quotation) {
          // Pastikan clientSource memiliki nilai dan cocok dengan salah satu dari filterClientSource
          final clientSourceValue =
              quotation.data.clientSource?.value?.toLowerCase() ?? '';
          return filterClientSource.contains(clientSourceValue);
        }).toList();
      }
    }

    if (filterPic.isNotEmpty) {
      if (filterPic.contains('all')) {
        filterPic.clear();
        result = quotationList;
      } else {
        result = result.where((quotation) {
          // Pastikan clientSource memiliki nilai dan cocok dengan salah satu dari filterClientSource
          final picValue = quotation.data.pic?.toLowerCase() ?? '';
          return filterPic.contains(picValue);
        }).toList();
      }
    }

    // Jika filter category tidak null, lakukan filter berdasarkan category
    if (filterCategory.isNotEmpty) {
      if (filterCategory.contains('all')) {
        filterCategory.clear();
        result = quotationList;
      } else {
        result = result.where((quotation) {
          // Mengecek apakah ada nilai category dalam quotation yang sesuai dengan filterCategory
          final categories =
              quotation.data.category.map((cat) => cat?.toLowerCase());
          return categories.any((cat) => filterCategory.contains(cat));
        }).toList();
      }
    }

    // Filter berdasarkan rentang tanggal
    DateTime effectiveEndDate = filterEndDate.value ?? DateTime.now();
    if (filterStartDate.value != null) {
      result = result
          .where((quotation) =>
              quotation.createdAt.isAfter(filterStartDate.value!) &&
              quotation.createdAt
                  .isBefore(effectiveEndDate.add(Duration(days: 1))))
          .toList();
    }

    // Jika search tidak kosong, lakukan pencarian berdasarkan nama atau field lain
    // Filter berdasarkan pencarian (search) jika search tidak kosong
    if (search.value != null && search.value!.isNotEmpty) {
      final query = search.value!.toLowerCase();

      result = result.where((quotation) {
        // Memastikan setiap properti non-null sebelum digunakan
        return (quotation.email.toLowerCase().contains(query)) ||
            (quotation.section?.toLowerCase().contains(query) ?? false) ||
            (quotation.data.company?.toLowerCase().contains(query) ?? false) ||
            (quotation.data.name?.toLowerCase().contains(query) ?? false) ||
            (quotation.data.category
                .any((cat) => cat!.toLowerCase().contains(query))) ||
            (quotation.data.clientSource?.value
                    ?.toLowerCase()
                    .contains(query) ??
                false);
      }).toList();
    }

    return result;
  }

  void redirectToWhatsapp(Quotation quotation) async {
    final phoneCode = quotation.data.phoneCode;
    final phoneNumber = quotation.data.phoneNumber;

    if (phoneCode == null ||
        phoneNumber == null ||
        phoneCode.isEmpty ||
        phoneNumber.isEmpty) {
      showErrorToast('Nomor telepon tidak tersedia');
      return;
    }

    final url = Uri.parse("https://wa.me/$phoneNumber");

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  /*
  
    FUNGSI Delete Data Quotation

    Fungsi ini digunakan untuk menyimpan data ke dalam local Storage HIVE (quotationBox)

  */
  void deleteDataQuotation(int id) async {
    try {
      // Ambil access token dari AuthenticationController
      String? accessToken = authenticationController.accesToken.value;

      // Ambil data dari API
      final response = await dio.delete(
        '$baseUrl/quotation/delete/$id',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200 && response.data != null) {
        showSuccessToast('Berhasil menghapus Quotation');
      } else {
        showErrorToast('Gagal menghapus Quotation');

        print(
            "Error: ${response.statusCode}, Message: ${response.statusMessage}");
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }
}
