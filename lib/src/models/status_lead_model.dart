import 'package:flutter/material.dart';

class StatusLead {
  final String title;
  final String query;
  final bool isEnabled;
  final Color bgColor;
  final Color color;

  StatusLead({
    required this.title,
    required this.query,
    required this.isEnabled,
    required this.bgColor,
    required this.color,
  });
}
