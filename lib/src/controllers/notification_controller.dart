import 'package:get/get.dart';

class NotificationController extends GetxController{
  var selectedIndex = 0.obs;
  var search = Rx<String?>(null);


  void updateIndex(int index) {
    selectedIndex.value = index;
  }

  void setSearch(String? query) {
    search.value = query;
  }

  List<dynamic> searchData(String select) {
    List result = [];

    // Debugging

    if (select.toLowerCase() == 'time_range') {
      result = timeRangeList;

      // Jika search tidak kosong, lakukan pencarian berdasarkan 'value' atau 'label'
      if (search.value != null && search.value!.isNotEmpty) {
        final query = search.value!.toLowerCase();
        result = result.where((type) {
          // print("Checking status: ${status['value']} - ${status['label']}");
          return type['value'].toLowerCase().contains(query) ||
              type['label'].toLowerCase().contains(query);
        }).toList();
      }
    }

    return result;
  }

  final timeRangeList = [
    {"value": "Scheduled", "label": "Scheduled"},
    {"value": "On Progress", "label": "On Progress"},
    {"value": "Canceled", "label": "Canceled"},
  ];

}