import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';

class AgentUtils {
  static Future<String> getDevice() async {
    final deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        return '${androidInfo.manufacturer} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        return 'Apple ${iosInfo.model}';
      } else {
        return '-';
      }
    } catch (e) {
      return '-';
    }
  }

  static Future<String> getIp() async {
    try {
      final dio = Dio();
      final response = await dio.get('https://api.ipify.org');
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return _getLocalIp();
      }
    } catch (e) {
      return _getLocalIp();
    }
  }

  static Future<String> _getLocalIp() async {
    try {
      final interfaces = await NetworkInterface.list();
      for (var interface in interfaces) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback && addr.address != '127.0.0.1') {
            return addr.address;
          }
        }
      }
      return '-';
    } catch (e) {
      return '-';
    }
  }

  static String getPlatform() {
    if (Platform.isAndroid) {
      return 'Android';
    } else if (Platform.isIOS) {
      return 'iOS';
    } else {
      return '-';
    }
  }
}
