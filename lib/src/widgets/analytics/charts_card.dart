import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:flutter/material.dart';

import '../../constant/fontstyle.dart';
import '../../utils/bottom_sheet.dart';
import '../../utils/color.dart';
import '../../utils/permission_utils.dart';
import '../../utils/toast.dart';
import '../custom_submit_button.dart';
import '../empty_state.dart';

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
  State<ChartCard> createState() => _ChartCardState();
}

class _ChartCardState extends State<ChartCard> {
  final ScreenshotController screenshotController = ScreenshotController();

  Future<void> exportToImage() async {
    await PermissionUtils().requestStoragePermission();

    final image = await screenshotController.capture(delay: const Duration(milliseconds: 10)).catchError((e) {
      showErrorToast("Error capturing screenshot: $e");
      return null;
    });

    if (image != null) {
      try {
        await ImageGallerySaverPlus.saveImage(
          image,
          quality: 90,
          name: "${widget.title.replaceAll(' ', '_').toLowerCase()}_chart_${DateTime.now().millisecondsSinceEpoch}",
        );

        showSuccessToast("Image saved to gallery!");
      } catch (e) {
        showErrorToast("Error saving image: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF3F3F3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

                // View Details or Export
                widget.onTapViewDetails != null
                    ? InkWell(
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
                    : InkWell(
                        onTap: () {
                          showCustomBottomSheet(
                            context,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "Export Analytics",
                                style: bold.copyWith(fontSize: 18),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Choose the format you want to export',
                                style: regular,
                              ),
                              const SizedBox(height: 12),
                              CustomSubmitButton(
                                title: 'Excel (.xlsx)',
                                onTap: widget.onTapExport,
                              ),
                              const SizedBox(height: 10),
                              CustomSubmitButton(
                                title: 'Image (.png)',
                                onTap: () async {
                                  await exportToImage();
                                  Get.back();
                                },
                              ),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Image.asset(
                            'assets/icons/icons_export.png',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 8),

            widget.chart,

            // Chart Description
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
