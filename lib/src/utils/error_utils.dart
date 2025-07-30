import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'toast.dart';

void handleDioException(DioException e) {
  if (e.response?.data is Map && e.response?.data['errors'] != null) {
    final errors = e.response?.data['errors'] as Map;
    final firstError = errors.values.firstWhere(
      (value) => value is List && value.isNotEmpty,
      orElse: () => [],
    );
    if (firstError is List && firstError.isNotEmpty) {
      showErrorToast("Error: ${firstError.first}");
    } else {
      showErrorToast("Error: ${e.response?.data ?? 'An unexpected error occurred.'}");
    }
  } else {
    showErrorToast("Error: ${e.response?.data['message'] ?? 'An unexpected error occurred.'}");
  }
  debugPrint('Error: ${e.response?.data}');
}
