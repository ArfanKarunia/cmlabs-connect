import 'package:flutter/material.dart';

import '../constant/fontstyle.dart';
import '../utils/color.dart';

AppBar defaultAppBar(String title, {double? titleSpacing, List<Widget>? actions}) {
  return AppBar(
    toolbarHeight: 70,
    backgroundColor: AppColors.scaffoldBgColor2,
    surfaceTintColor: AppColors.scaffoldBgColor2,
    titleSpacing: titleSpacing,
    title: Text(
      title,
      style: bold.copyWith(fontSize: 20),
    ),
    actions: actions,
  );
}
