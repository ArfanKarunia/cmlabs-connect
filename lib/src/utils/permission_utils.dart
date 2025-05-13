import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  Future<bool> hasStoragePermission() async {
    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      return status.isGranted;
    }
    return true;
  }
}
