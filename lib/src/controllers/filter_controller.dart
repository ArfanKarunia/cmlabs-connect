import 'package:get/get.dart';

class FilterController extends GetxController{

  var filterVisible = false.obs;

  RxBool opacityVisible = false.obs;

  void toggleFilterVisibility() {
    filterVisible.value = !filterVisible.value;


    if (filterVisible.value) {
      // Menambahkan delay 500ms sebelum opacity berubah
      Future.delayed(Duration(milliseconds: 100), () {
        opacityVisible.value = true;
      });
    } else {
      // Jika disembunyikan, opacity langsung 0 tanpa delay
      opacityVisible.value = false;
    }
  }

}