import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:quotation_app/src/constant/config.dart';
import 'package:quotation_app/src/constant/const.dart';
import 'package:quotation_app/src/controllers/authentication_controller.dart';
import 'package:quotation_app/src/models/category_model.dart';
import 'package:quotation_app/src/models/client_source_model.dart';
import 'package:quotation_app/src/models/quotation_model.dart';

class QuotationController extends GetxController {
  var quotationList = <Quotation>[].obs;
  var isLoadingMore = false.obs;
  var start = 0.obs;
  final limit = 10;

  var filterStatus = Rx<StatusLead?>(null);
  var filterCategory = Rx<Category?>(null);
  var filterClientSource = Rx<ClientSource?>(null);

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
    fetchQuotationData();
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

  Future<void> fetchQuotationData({bool isLoadMore = false}) async {
    try {
      if (isLoadMore) {
        isLoadingMore.value = true;
      }

      // Cek apakah data sudah ada di Hive (local storage)
      if (quotationBox!.isNotEmpty) {
        // Jika data ada di local storage, ambil data dari Hive
        var localData =
            quotationBox!.values.skip(start.value).take(limit).toList();
        quotationList.addAll(localData);
        print("Data diambil dari local storage.");
      } else {
        // Jika data belum ada di local storage, fetch data dari API
        String? accessToken = authenticationController.accesToken.value;

        final response = await dio.get(
          '$baseUrl/dashboard/data_recent_quotation?start=${start.value}&limit=$limit',
          options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        );

        print(response.data);

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
    start.value += limit;
    await fetchQuotationData(isLoadMore: true);
  }

  void resetQuotatioinData() {
    start.value = 0;
    fetchQuotationData();
  }

  /*
  
    FUNGSI Set Filter Status

    Fungsi ini digunakan untuk menyimpan data inputan filter Status

  */
  void setFilterStatus(StatusLead? newFilter) {
    filterStatus.value = newFilter;
  }

  /*
  
    FUNGSI Set Filter Category

    Fungsi ini digunakan untuk menyimpan data inputan filter Category

  */
  void setFilterCategory(Category? newFilter) {
    filterCategory.value = newFilter;
  }

  /*
  
    FUNGSI Set Filter Client Source

    Fungsi ini digunakan untuk menyimpan data inputan filter Client Source

  */
  void setFilterClientSource(ClientSource? newFilter) {
    filterClientSource.value = newFilter;
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
    filterCategory.value = null;
    filterClientSource.value = null;

    filterStartDate.value = null;
    filterEndDate.value = null;
  }

  /*
  
    FUNGSI Filtered Quotation

    Fungsi ini digunakan untuk mengembalikan List Data Quotation sesuai dengan search dan filter dari user

  */
  List<Quotation> get filteredQuotations {
    List<Quotation> result = quotationList;

    // Jika filter status lead tidak null, lakukan filter berdasarkan status lead
    if (filterStatus.value != null) {
      
      int filterStatusIndex = filterStatus.value!.index;

      result = result
          .where((quotation) => quotation.status == filterStatusIndex)
          .toList();
    }

    // // Jika filter category tidak null, lakukan filter berdasarkan category
    // if (filterCategory.value != null) {
    //   result = result.where((quotation) {
    //     // Mengecek jika quotation memiliki kategori yang dipilih
    //     return quotation.category!
    //         .any((cat) => cat.slug == filterCategory.value!.slug);
    //   }).toList();
    // }

    // // Jika filter client source tidak null, lakukan filter berdasarkan client source
    // if (filterClientSource.value != null) {
    //   result = result
    //       .where((quotation) =>
    //           quotation.clientSource!.id == filterClientSource.value!.id)
    //       .toList();
    // }

    // DateTime effectiveEndDate = filterEndDate.value ?? DateTime.now();
    // if (filterStartDate.value != null) {
    //   result = result
    //       .where((quotation) =>
    //           quotation.joinedAt.isAfter(filterStartDate.value!) &&
    //           quotation.joinedAt.isBefore(effectiveEndDate))
    //       .toList();
    // }

    // Jika search tidak kosong, lakukan pencarian berdasarkan nama atau field lain
    // if (search.value != null && search.value!.isNotEmpty) {
    //   result = result.where((quotation) {
    //     final query = search.value!.toLowerCase();
    //     return quotation.name!.toLowerCase().contains(query) ||
    //         quotation.email!.toLowerCase().contains(query) ||
    //         quotation.companyName!.toLowerCase().contains(query) ||
    //         quotation.pic!.toLowerCase().contains(query);
    //   }).toList();
    // }

    return result;
  }
}
