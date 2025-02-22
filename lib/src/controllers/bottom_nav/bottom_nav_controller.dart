import 'package:get/get.dart';

class BottomNavController extends GetxController {
  var currentIndex = 0.obs;

  var isFilterActive = false.obs;
  var blurValue = 0.0.obs;
  var opacityValue = 0.0.obs;
  RxBool blurVisible = false.obs;

  void changePage(int index) {
    currentIndex.value = index;
    isFilterActive.value = false;
  }

  void toggleFilterVisibility() {
    isFilterActive.value = !isFilterActive.value;

    if (isFilterActive.value) {
      _showFilterWithBlur();
      _showFilterWithOpacity();
    } else {
      _hideFilterWithOpacity();
      _hideFilterWithBlur();
    }
  }

  Future<void> _showFilterWithBlur() async {
    // Meningkatkan nilai blur dari 0 hingga 5
    for (int i = 0; i <= 3; i++) {
      await Future.delayed(const Duration(milliseconds: 100));
      blurValue.value = i.toDouble(); // Update nilai blur
    }
  }

  Future<void> _showFilterWithOpacity() async {
    for (int i = 0; i <= 38; i++) {
      await Future.delayed(const Duration(milliseconds: 0));
      opacityValue.value = i.toDouble(); // Update nilai blur
    }
  }

  Future<void> _hideFilterWithBlur() async {
    // Tunggu selama 200ms sebelum mengurangi blur

    // Mengurangi nilai blur dari 5 ke 0
    for (int i = 3; i >= 0; i--) {
      await Future.delayed(const Duration(milliseconds: 0));
      blurValue.value = i.toDouble(); // Update nilai blur
    }

    // Setelah selesai, toggle filter visibility
    isFilterActive.value = false; // Sembunyikan filter
  }

  Future<void> _hideFilterWithOpacity() async {
    // Tunggu selama 200ms sebelum mengurangi blur

    for (int i = 38; i >= 0; i--) {
      await Future.delayed(const Duration(milliseconds: 0));
      opacityValue.value = i.toDouble(); // Update nilai blur
    }

    // Setelah selesai, toggle filter visibility
    isFilterActive.value = false; // Sembunyikan filter
  }
}
