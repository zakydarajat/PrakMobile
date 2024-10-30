import 'package:get/get.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isPasswordVisible = false.obs;

  // Function to toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Function to handle user login
  void login() {
    if (email.value.isNotEmpty && password.value.isNotEmpty) {
      // Perform login logic, e.g., authentication check
      if (_validateCredentials(email.value, password.value)) {
        // Assume successful login, navigate to home
        Get.toNamed('/home');
      } else {
        // Show error message if credentials are invalid
        Get.snackbar('Login Failed', 'Invalid email or password',
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      // Show error message if fields are empty
      Get.snackbar('Error', 'Please fill in all fields',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Private method to validate user credentials (for demonstration purposes)
  bool _validateCredentials(String email, String password) {
    // Placeholder logic, replace with actual authentication mechanism
    return email == 'user@example.com' && password == 'password123';
  }

  // Function to reset the login form
  void resetForm() {
    email.value = '';
    password.value = '';
    isPasswordVisible.value = false;
  }
}
