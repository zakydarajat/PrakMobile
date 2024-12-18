import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/data/services/notification_handler.dart';
import 'package:myapp/app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/depedency_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Inisialisasi SharedPreferences dengan GetX
  await Get.putAsync<SharedPreferences>(
      () async => SharedPreferences.getInstance());

  // Inisialisasi Dependency Injection
  DependencyInjection.init();

  // Run aplikasi terlebih dahulu sebelum inisialisasi notifikasi
  runApp(MyApp());

  // Inisialisasi Notifikasi Firebase setelah aplikasi siap
  await FirebaseMessagingHandler().initPushNotification();
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyApp',
      initialRoute: Routes.SPLASH, // Set the initial route
      getPages: AppPages.routes, // Use the configured routes
    );
  }
}
