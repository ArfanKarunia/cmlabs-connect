import 'package:cmlabs_connect/src/models/quotation_model.dart';
import 'package:get/get.dart';

class DetailQuotationController extends GetxController {
  var isShowAll = false.obs;

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
    "Company Profile",
    "Page Source",
    "Service",
    "Region",
    "Pitching Duration",
  ];

  void changeShowValue() {
    isShowAll.value = !isShowAll.value;
  }

  bool get getShowAllValue {
    return isShowAll.value;
  }

  Map<String, String> detailData(Quotation quotation) {
    return {
      "company": quotation.data.company ?? "Nama Perusahaan",
      "ID": quotation.id.toString(),
      "Joined at": quotation.createdAt.toString(),
      "Status": labelStatusLead(quotation.status),
      "Category": quotation.data.category.join(', '),
      "Client Source": quotation.data.clientSource?.name ?? "-",
      "Name": quotation.data.company ?? "-",
      "Email": quotation.email,
      "Whatsapp": quotation.data.phoneNumber ?? "-",
      "Company Website": quotation.data.website ?? "-",
      "Company Profile": quotation.data.companyIndustry ?? "-",
      "Page Source": quotation.url,
      "Service": quotation.section ?? "-",
      "Region": quotation.data.region ?? "-",
      "Pitching Duration": "??"
    };
  }

  String labelStatusLead(int status){
    var label = '';
    switch (status){
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
