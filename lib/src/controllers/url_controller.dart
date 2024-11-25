import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UrlController extends GetxController {
  // Fungsi untuk meluncurkan URL
  Future<void> launchUrl(String webUrl) async {
    final Uri url = Uri.parse(webUrl);

    // Mengecek apakah URL bisa dibuka
    if (await canLaunchUrl(url)) {
      print("can access the link");
      await launchUrlString(webUrl, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not launch $webUrl');
    }
  }
}
