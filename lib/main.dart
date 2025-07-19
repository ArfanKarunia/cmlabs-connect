import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

import 'services/firebase_analytics_service.dart';
import 'services/notification_service.dart';
import 'src/controllers/app_bindings.dart';
import 'src/routes.dart';
import 'src/utils/custom_http_overrides.dart';

Future<void> main() async {
  // Ensure the widgets is initialized
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize the notification service
  await NotificationService.instance.initialize();

  // Set the HTTP overrides
  HttpOverrides.global = CustomHttpOverrides();

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "CMLABS CONNECT",
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        primarySwatch: Colors.blueGrey,
      ),

      // Start with routing to Home View
      initialRoute: AppRoutes.loginForm,
      initialBinding: AppBindings(),

      // Routing of the app
      getPages: AppRoutes.routes,
      routingCallback: (routing) {
        if (routing?.current != null) {
          final analyticsService = Get.find<FirebaseAnalyticsService>();
          analyticsService.setCurrentScreen(routing!.current);
        }
      },
      defaultTransition: Transition.rightToLeft,
    );
  }
}
