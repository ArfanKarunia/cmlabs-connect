import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'color.dart';

class ImageUtils {
  Future<File?> pickImage() async {
    final XFile? pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      final CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: pickedImage.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        compressQuality: 100,
        compressFormat: ImageCompressFormat.png,
        uiSettings: [
          AndroidUiSettings(
            activeControlsWidgetColor: AppColors.primary,
            lockAspectRatio: true,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
          ),
          IOSUiSettings(
            aspectRatioLockEnabled: true,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
          ),
        ],
      );

      if (croppedImage != null) {
        return File(croppedImage.path);
      }
    }
    return null;
  }

  ImageProvider getImageProvider(String url) {
    try {
      return CachedNetworkImageProvider(url);
    } catch (e) {
      return const AssetImage('assets/images/example.jpg');
    }
  }
}
