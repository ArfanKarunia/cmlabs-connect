import 'package:cmlabs_connect/src/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "CMLABS CONNECT",
      debugShowCheckedModeBanner: false,
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