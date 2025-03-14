import 'package:flutter/material.dart';

import '../constant/fontstyle.dart';
import '../utils/color.dart';

AppBar defaultAppBar(String title) {
  return AppBar(
    toolbarHeight: 70,
    backgroundColor: AppColors.scaffoldBgColor2,
    surfaceTintColor: AppColors.scaffoldBgColor2,
    title: Text(
      title,
      style: bold.copyWith(fontSize: 20),
    ),
  );
}
