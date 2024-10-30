// lib\app\modules\signup\controllers\signup_controllers.dart

import 'package:get/get.dart';

class SignupController extends GetxController {
  var isPasswordVisible = false.obs;
  var isRePasswordVisible = false.obs;

  var username = ''.obs;
  var email = ''.obs;
  var password = ''.obs;
  var rePassword = ''.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRePasswordVisibility() {
    isRePasswordVisible.value = !isRePasswordVisible.value;
  }

  // Function to validate the signup form
  bool validateSignupForm() {
    if (username.value.isEmpty ||
        email.value.isEmpty ||
        password.value.isEmpty ||
        rePassword.value.isEmpty) {
      Get.snackbar('Error', 'All fields are required',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (password.value != rePassword.value) {
      Get.snackbar('Error', 'Passwords do not match',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    return true;
  }

  // Function to handle the signup process
  void signup() {
    if (validateSignupForm()) {
      // Add your signup logic here (e.g., API call)
      Get.snackbar('Success', 'Signup successful!',
          snackPosition: SnackPosition.BOTTOM);
      // Navigate to the login page after successful signup
      Get.toNamed('/login');
    }
  }
}
