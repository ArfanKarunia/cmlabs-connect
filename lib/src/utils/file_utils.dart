import 'dart:io';

import 'package:dio/dio.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static String? getFilenameFromResponse(Response response) {
    // Check Content-Disposition header for filename
    String? contentDisposition = response.headers.value('content-disposition');
    if (contentDisposition != null && contentDisposition.contains('filename=')) {
      // Parse the filename from the header
      try {
        // For header format: attachment; filename="example.xlsx"
        if (contentDisposition.contains('filename="')) {
          return contentDisposition.split('filename="')[1].split('"')[0];
        }
        // For header format: attachment; filename=example.xlsx
        else if (contentDisposition.contains('filename=')) {
          return contentDisposition.split('filename=')[1].split(';')[0].trim();
        }
      } catch (_) {}
    }
    return null;
  }

  static Future<String> saveFile(List<int> bytes, String? serverFileName) async {
    final directory = await getDownloadPath();
    if (directory == null) {
      throw Exception('Could not access download directory');
    }

    final fileName = serverFileName ?? '${DateTime.now().millisecondsSinceEpoch}.xlsx';
    final safeFileName = fileName.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_');

    final filePath = '${directory.path}/$safeFileName';

    final file = File(filePath);
    await file.writeAsBytes(bytes);

    return file.path;
  }

  static Future<Directory?> getDownloadPath() async {
    if (Platform.isAndroid) {
      return Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      return await getApplicationDocumentsDirectory();
    }
    return null;
  }

  static Future<void> openFile(String path) async {
    await OpenFilex.open(path);
  }
}
