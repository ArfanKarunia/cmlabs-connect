import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:quotation_app/src/constant/const.dart';
import 'package:quotation_app/src/models/quotation_model.dart';

class QuotationController extends GetxController {
  var quotationList = <Quotation>[].obs;
  var filter = Rx<StatusLead?>(null);
  var search = Rx<String?>(null);

  Box<Quotation>? quotationBox;

  List<Quotation> dummyQuotations = [
      Quotation(
        id: 1,
        joinedAt: DateTime.now().subtract(const Duration(days: 1)),
        status: "Active",
        category: ["Web Development", "Mobile App"],
        clientSource: "Referral",
        name: "John Doe",
        email: "johndoe@example.com",
        whatsappNumber: "1234567890",
        companyWebsite: "https://example.com",
        companyName: "Example Inc.",
        companyProfile: "Software development company",
        pageSource: "Google",
        service: ["Design", "Development"],
        package: "Premium",
        language: "English",
        region: "USA",
        pic: "Jane Smith",
        statusLead: StatusLead.newLead,
      ),
      Quotation(
        id: 2,
        joinedAt: DateTime.now().subtract(const Duration(days: 5)),
        status: "Inactive",
        category: ["SEO", "Marketing"],
        clientSource: "Website",
        name: "Alice Johnson",
        email: "alicej@example.com",
        whatsappNumber: "0987654321",
        companyWebsite: "https://alicecompany.com",
        companyName: "Alice Co.",
        companyProfile: "Digital marketing agency",
        pageSource: "LinkedIn",
        service: ["SEO", "Social Media"],
        package: "Basic",
        language: "Spanish",
        region: "Mexico",
        pic: "John Smith",
        statusLead: StatusLead.followedUp,
      ),
      Quotation(
        id: 3,
        joinedAt: DateTime.now().subtract(const Duration(days: 5)),
        status: "Inactive",
        category: ["SEO", "Marketing"],
        clientSource: "Website",
        name: "Alice Johnson",
        email: "alicej@example.com",
        whatsappNumber: "0987654321",
        companyWebsite: "https://alicecompany.com",
        companyName: "Alice Co.",
        companyProfile: "Digital marketing agency",
        pageSource: "LinkedIn",
        service: ["SEO", "Social Media"],
        package: "Basic",
        language: "Spanish",
        region: "Mexico",
        pic: "John Smith",
        statusLead: StatusLead.accepted,
      ),
      Quotation(
        id: 4,
        joinedAt: DateTime.now().subtract(const Duration(days: 5)),
        status: "Inactive",
        category: ["SEO", "Marketing"],
        clientSource: "Website",
        name: "Alice Johnson",
        email: "alicej@example.com",
        whatsappNumber: "0987654321",
        companyWebsite: "https://alicecompany.com",
        companyName: "Alice Co.",
        companyProfile: "Digital marketing agency",
        pageSource: "LinkedIn",
        service: ["SEO", "Social Media"],
        package: "Basic",
        language: "Spanish",
        region: "Mexico",
        pic: "John Smith",
        statusLead: StatusLead.rejected,
      ),
      Quotation(
        id: 5,
        joinedAt: DateTime.now().subtract(const Duration(days: 5)),
        status: "Inactive",
        category: ["SEO", "Marketing"],
        clientSource: "Website",
        name: "Alice Johnson",
        email: "alicej@example.com",
        whatsappNumber: "0987654321",
        companyWebsite: "https://alicecompany.com",
        companyName: "Alice Co.",
        companyProfile: "Digital marketing agency",
        pageSource: "LinkedIn",
        service: ["SEO", "Social Media"],
        package: "Basic",
        language: "Spanish",
        region: "Mexico",
        pic: "John Smith",
        statusLead: StatusLead.newLead,
      ),
    ];

  /*

    Ketika aplikasi mulai berjalan (controller ini pertama kali di inisialisasi)

    akan membuka sebuah Box (tempat penyimpanan HIVE) bernama quotationBox

  */
  @override
  void onInit() async {
    super.onInit();
    quotationBox = await Hive.openBox<Quotation>('quotationBox');
    checkConnectionAndLoadData();
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
  Future<void> checkConnectionAndLoadData() async {
    var connection = await (Connectivity().checkConnectivity());
    print(connection);

    if (connection == ConnectivityResult.none) {
      loadDataFromHive();
    } else {
      loadDataFromAPI();
    }
  }

  /*
  
    FUNGSI Load Data from HIVE

    Fungsi ini digunakan untuk mengambil data dari locak storage HIVE (quotationBox)

  */
  void loadDataFromHive() {
    if (quotationBox!.isNotEmpty) {
      quotationList.assignAll(quotationBox!.values.toList());
    }else{
      quotationList.assignAll(dummyQuotations);
    }
  }

   /*
  
    FUNGSI Load Data from API

    Fungsi ini digunakan untuk mengambil data dari API 
    untuk SEMENTARA data dummy

  */
  void loadDataFromAPI() {
    

    // menyimpan data ke dalam quotationBox
    saveDataToHive(dummyQuotations);
    quotationList.assignAll(dummyQuotations);
  }

   /*
  
    FUNGSI Save Data to Hive

    Fungsi ini digunakan untuk menyimpan data ke dalam local Storage HIVE (quotationBox)

  */
  void saveDataToHive(List<Quotation> data) async {
    await quotationBox!.clear();
    for (var quotation in data) {
      await quotationBox!.put(quotation.id, quotation);
    }
  }

   /*
  
    FUNGSI Set Filter

    Fungsi ini digunakan untuk menyimpan data inputan filter

  */
  void setFilter(StatusLead? newFilter) {
    filter.value = newFilter;
  }

   /*
  
    FUNGSI Set Search

    Fungsi ini digunakan untuk menyimpan data inputan search

  */
  void setSearch(String? query) {
    search.value = query;
  }

  /*
  
    FUNGSI Filtered Quotation

    Fungsi ini digunakan untuk mengembalikan List Data Quotation sesuai dengan search dan filter dari user

  */
  List<Quotation> get filteredQuotations {
    List<Quotation> result = quotationList;

    // Jika filter status lead tidak null, lakukan filter berdasarkan status lead
    if (filter.value != null) {
      result = result
          .where((quotation) => quotation.statusLead == filter.value)
          .toList();
    }

    // Jika search tidak kosong, lakukan pencarian berdasarkan nama atau field lain
    if (search.value != null && search.value!.isNotEmpty) {
      result = result.where((quotation) {
        final query = search.value!.toLowerCase();
        return quotation.name!.toLowerCase().contains(query) ||
            quotation.email!.toLowerCase().contains(query) ||
            quotation.companyName!.toLowerCase().contains(query) ||
            quotation.pic!.toLowerCase().contains(query);
      }).toList();
    }

    return result;
  }
}
