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
      title: 'MyApp',
      initialRoute: Routes.SIGNUP, // Rute awal
      getPages: AppPages.routes,
    );
  }
}
