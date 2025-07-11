// ignore_for_file: library_private_types_in_public_api
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../constant/fontstyle.dart';
import '../../utils/color.dart';
import '../empty_state.dart';
import 'package:get/get.dart';

class ChartCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final String? value;
  final Color? valueColor;
  final Widget chart;
  final List<ChartDataDescription> chartDescriptions;
  final VoidCallback? onTapViewDetails;
  final VoidCallback? onTapExport;

  const ChartCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.value,
    this.valueColor = AppColors.text_2,
    required this.chart,
    required this.chartDescriptions,
    this.onTapViewDetails,
    this.onTapExport,
  });

  @override
  _ChartCardState createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard> {

 ScreenshotController screenshotController = ScreenshotController();

  // Fungsi untuk mengambil screenshot dan menyimpannya
  Future<void> _takeScreenshotAndSave() async {
    // Meminta izin penyimpanan
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Mengambil screenshot dari widget yang dibungkus oleh Screenshot
      screenshotController.capture(delay: const Duration(milliseconds: 10)).then((Uint8List? image) async {
        if (image != null) {
          try {
            // Menyimpan gambar ke galeri
            final result = await ImageGallerySaverPlus.saveImage(
              image,
              quality: 90,
              name: "${widget.title.replaceAll(' ', '_').toLowerCase()}_chart_${DateTime.now().millisecondsSinceEpoch}",
            );
            debugPrint("Image saved to gallery: $result");
            Get.snackbar(
              'Sukses',
              'Gambar grafik berhasil disimpan ke galeri!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          } catch (e) {
            debugPrint("Error saving image: $e");
            Get.snackbar(
              'Error',
              'Gagal menyimpan gambar: $e',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white,
            );
          }
        } else {
          debugPrint("Failed to capture screenshot.");
          Get.snackbar(
            'Gagal',
            'Gagal mengambil screenshot grafik.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
        }
      }).catchError((onError) {
        debugPrint("Error capturing screenshot: $onError");
        Get.snackbar(
          'Error',
          'Terjadi kesalahan saat mengambil screenshot: $onError',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      });
    } else {
      debugPrint("Storage permission denied.");
      Get.snackbar(
        'Izin Ditolak',
        'Izin penyimpanan diperlukan untuk menyimpan gambar.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.yellow,
        colorText: Colors.black,
        mainButton: TextButton(
          onPressed: () => openAppSettings(), // Membuka pengaturan aplikasi
          child: Text('Buka Pengaturan', style: TextStyle(color: Colors.blue)),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Screenshot( // Bungkus seluruh card dengan Screenshot widget
      controller: screenshotController,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3F3F3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), // Gunakan withOpacity
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Button (View Details / Export)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: bold.copyWith(fontSize: 18, color: AppColors.text_1),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.subtitle,
                        style: regular.copyWith(fontSize: 12, color: AppColors.text_3),
                      ),
                      if (widget.value != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.value!,
                          style: semibold.copyWith(fontSize: 15, color: widget.valueColor),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                // Logika kondisional untuk View Details atau Export
                if (widget.onTapViewDetails != null)
                  InkWell(
                    onTap: widget.onTapViewDetails,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF31393C),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        'View Details',
                        style: regular.copyWith(fontSize: 12, color: AppColors.white),
                      ),
                    ),
                  )
                else // Jika onTapViewDetails null, tampilkan tombol export
                  InkWell(
                    onTap: () {
                      _takeScreenshotAndSave(); // Panggil fungsi export di sini
                      // Jika Anda memiliki onTapExport dari parent, Anda bisa panggil juga:
                      // widget.onTapExport?.call();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8), // Padding lebih kecil untuk ikon
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255), // Warna latar belakang tombol
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Image.asset(
                        'assets/icons/icons_export.png', // Sesuaikan path icon Anda
                        width: 24, // Ukuran ikon
                        height: 24, // Ukuran ikon
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 8),
            widget.chart, // Chart itu sendiri

            if (widget.chartDescriptions.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 6,
                children: widget.chartDescriptions,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ChartDataDescription extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback? onTap;
  const ChartDataDescription({
    super.key,
    required this.label,
    required this.color,
    required this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 5, backgroundColor: color),
          const SizedBox(width: 6),
          Text(label, style: isSelected ? bold.copyWith(fontSize: 12) : regular.copyWith(fontSize: 12)),
        ],
      ),
    );
  }
}

class EmptyChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTapViewDetails;
  const EmptyChartCard({super.key, required this.title, required this.subtitle, this.onTapViewDetails});

  @override
  Widget build(BuildContext context) {
    return ChartCard(
      title: title,
      subtitle: subtitle,
      chart: const SizedBox(height: 200, child: EmptyState()),
      chartDescriptions: const [],
      onTapViewDetails: onTapViewDetails,
    );
  }
}
