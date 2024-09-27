import 'package:get/get.dart';

class FilterController extends GetxController{

  var filterVisible = false.obs;

  void toggleFilterVisibility() {
    filterVisible.value = !filterVisible.value;
  }

}