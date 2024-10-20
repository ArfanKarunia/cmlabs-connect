import 'package:fluttertoast/fluttertoast.dart';
import 'package:quotation_app/src/utils/color.dart';
import 'package:flutter/material.dart';

void showSuccessToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: AppColors.bgSuccess,
    textColor: AppColors.success,
    fontSize: 12,
  );
}

void showErrorToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: AppColors.bgDanger,
    textColor: AppColors.danger,
    fontSize: 12,
  );
}
