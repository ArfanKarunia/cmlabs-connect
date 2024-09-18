import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quotation_app/src/routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Your Application with GetX",
      theme: ThemeData(
        primaryColor: Colors.blueGrey,
        primarySwatch: Colors.blueGrey,
      ),

      // Start with routing to Home View
      initialRoute: AppRoutes.loginForm,

      // Routing of the app
      getPages: AppRoutes.routes,
    );
  }
}