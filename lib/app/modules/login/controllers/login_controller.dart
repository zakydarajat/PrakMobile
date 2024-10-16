import 'package:get/get.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;

  // Function to handle user login
  void login() {
    // Perform login logic here
    if (email.value.isNotEmpty && password.value.isNotEmpty) {
      // Assume successful login, navigate to home
      Get.toNamed('/home');
    } else {
      // Show error message
      Get.snackbar('Error', 'Please fill in all fields');
    }
  }
}
