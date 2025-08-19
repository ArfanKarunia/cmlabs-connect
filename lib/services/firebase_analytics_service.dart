import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:flutter/material.dart';

class FirebaseAnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logEvent(String name, {Map<String, Object>? parameters}) async {
    await _analytics.logEvent(name: name, parameters: parameters);

    // debugPrint('Sent to Firebase Analytics | Event: $name | Parameters: $parameters');
  }

  Future<void> setUserProperty({required String name, required String? value}) async {
    await _analytics.setUserProperty(name: name, value: value);

    // debugPrint('Sent to Firebase Analytics | User Property: $name | Value: $value');
  }

  Future<void> setCurrentScreen(String screenName) async {
    await _analytics.logScreenView(screenName: screenName);

    // debugPrint('Sent to Firebase Analytics | Screen View: $screenName');
  }
}
