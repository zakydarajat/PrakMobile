import 'package:get/get.dart';

class SignupController extends GetxController {
  var isPasswordVisible = false.obs;
  var isRePasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRePasswordVisibility() {
    isRePasswordVisible.value = !isRePasswordVisible.value;
  }
}
