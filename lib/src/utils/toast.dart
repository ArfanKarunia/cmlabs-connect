import 'package:cmlabs_connect/src/utils/color.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
