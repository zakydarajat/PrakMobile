import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var rePassword = ''.obs;
  var username = ''.obs;

  var isPasswordVisible = false.obs;
  var isRePasswordVisible = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRePasswordVisibility() {
    isRePasswordVisible.value = !isRePasswordVisible.value;
  }

  // Function to validate signup form
  bool validateSignupForm() {
    if (username.value.isEmpty || email.value.isEmpty || password.value.isEmpty || rePassword.value.isEmpty) {
      Get.snackbar('Error', 'All fields are required',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (password.value != rePassword.value) {
      Get.snackbar('Error', 'Passwords do not match',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (password.value.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    return true;
  }

  // Function to handle signup process
  Future<void> signup() async {
    if (validateSignupForm()) {
      try {
        // Create user with Firebase Authentication
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email.value.trim(),
          password: password.value.trim(),
        );

        // Store additional user information in Firestore
        await _firestore.collection('users').doc(userCredential.user?.uid).set({
          'username': username.value.trim(),
          'email': email.value.trim(),
          'createdAt': DateTime.now().toIso8601String(),
        });

        Get.snackbar('Success', 'Account created successfully!',
            snackPosition: SnackPosition.BOTTOM);

        // Navigate to login page
        Get.toNamed('/login');
      } catch (e) {
        Get.snackbar('Signup Error', e.toString(),
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }
}
