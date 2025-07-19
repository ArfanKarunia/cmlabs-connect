import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/color.dart';
import '../utils/network_image.dart';

class CustomAvatar extends StatefulWidget {
  final String? link;
  final double radius;
  const CustomAvatar({super.key, this.link, this.radius = 20});

  @override
  State<CustomAvatar> createState() => _CustomAvatarState();
}

class _CustomAvatarState extends State<CustomAvatar> {
  String? link;

  @override
  void initState() {
    super.initState();
    link = widget.link;
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: AppColors.white,
      backgroundImage: link != null || (link ?? '').isNotEmpty
          ? getImageProvider(link.toString())
          : const AssetImage("assets/icons/cmlabs_icon.png"),
      onBackgroundImageError: (e, stackTrace) => setState(() => link = null),
    );
  }
}

class CustomChangeAvatar extends StatefulWidget {
  final XFile? newImage;
  final String? link;
  final double radius;
  const CustomChangeAvatar({super.key, this.newImage, this.link, this.radius = 20});

  @override
  State<CustomChangeAvatar> createState() => _CustomChangeAvatarState();
}

class _CustomChangeAvatarState extends State<CustomChangeAvatar> {
  String? link;

  @override
  void initState() {
    super.initState();
    link = widget.link;
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: widget.radius,
      backgroundColor: AppColors.white,
      backgroundImage: widget.newImage != null
          ? FileImage(File(widget.newImage!.path))
          : (link != null && (link ?? '').isNotEmpty)
              ? getImageProvider(link.toString())
              : const AssetImage("assets/icons/cmlabs_icon.png"),
      onBackgroundImageError: (e, stackTrace) => setState(() => link = null),
    );
  }
}
