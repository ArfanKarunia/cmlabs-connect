import 'package:fluttertoast/fluttertoast.dart';
import 'package:quotation_app/src/utils/color.dart';
import 'package:flutter/material.dart';

void showSuccessToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: AppColors.success,
    textColor: AppColors.white_1,
    fontSize: 16,
  );
}

void showErrorToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: AppColors.danger,
    textColor: AppColors.white_1,
    fontSize: 16,
  );
}
