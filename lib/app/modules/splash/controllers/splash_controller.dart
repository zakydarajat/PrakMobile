import 'package:get/get.dart';
import 'package:myapp/app/routes/app_pages.dart'; // Pastikan path ini benar

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Navigasi setelah delay
    Future.delayed(Duration(seconds: 2), () {
      Get.offNamed(Routes.LOGIN); // Pastikan Routes.LOGIN ada
    });
  }
}
