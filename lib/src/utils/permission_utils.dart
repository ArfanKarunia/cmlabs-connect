import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  Future<void> requestStoragePermission() async {
    if (Platform.isAndroid) {
      PermissionStatus status = await Permission.storage.status;
      if (status.isGranted) return;
      await Permission.storage.request();
    }
  }
}
