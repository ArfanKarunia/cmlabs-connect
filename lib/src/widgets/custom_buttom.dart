import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final Color backgroundColor;
  final Color overlayColor;
  final BorderRadius borderRadius;

  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.child,
    this.backgroundColor = Colors.blue,
    this.overlayColor = Colors.white24,
    this.borderRadius = const BorderRadius.all(Radius.circular(5)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor, // Background color of the button
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius, // Button shape
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: borderRadius, // Ripple effect follows button shape
        splashColor: overlayColor, // Ripple color
        child: Container(
          alignment: Alignment.center,
          child: child
        ),
      ),
    );
  }
}