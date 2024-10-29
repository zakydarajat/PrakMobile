// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyApp',
      initialRoute: Routes.LOGIN, // Set the initial route
      getPages: AppPages.routes,  // Use the configured routes
    );
  }
}
