import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TabNavController extends GetxController with GetSingleTickerProviderStateMixin{

  late TabController tabController;
  
  @override
  void onInit() {
    // Inisialisasi TabController dengan 3 tab
    tabController = TabController(length: 3, vsync: this);
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

}