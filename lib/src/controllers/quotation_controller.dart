import 'package:get/get.dart';
import 'package:quotation_app/src/constant/const.dart';
import 'package:quotation_app/src/models/quotation_model.dart';

class QuotationController extends GetxController {
  var quotationList = <Quotation>[].obs;
  var filter = Rx<StatusLead?>(null);
  var search = Rx<String?>(null);

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

  @override
  void onInit() {
    super.onInit();
    loadDummyData(); // Memuat data dummy saat controller diinisialisasi
  }

  void loadDummyData() {
    // Memuat data dummy
    quotationList.assignAll(dummyQuotations);
  }

  void setFilter(StatusLead? newFilter) {
    filter.value = newFilter;
  }

  void setSearch(String? query){
    search.value = query;
  }


  List<Quotation> get filteredQuotations {
    List<Quotation> result = quotationList;

    // Jika filter status lead tidak null, lakukan filter berdasarkan status lead
    if (filter.value != null) {
      result = result.where((quotation) => quotation.statusLead == filter.value).toList();
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
