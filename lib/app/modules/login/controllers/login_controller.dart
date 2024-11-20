import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var isPasswordVisible = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Function to validate login form
  bool validateLoginForm() {
    if (email.value.isEmpty || password.value.isEmpty) {
      Get.snackbar('Error', 'Email and Password are required',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }
    return true;
  }

  // Function to handle login process
  Future<void> login() async {
    if (validateLoginForm()) {
      try {
        // Sign in with Firebase Authentication
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email.value.trim(),
          password: password.value.trim(),
        );

        // Fetch user data from Firestore
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(userCredential.user?.uid)
            .get();

        if (userDoc.exists) {
          var userData = userDoc.data() as Map<String, dynamic>;
          print('User Data: ${userData['email']}');
        }

        Get.snackbar('Success', 'Login successful!',
            snackPosition: SnackPosition.BOTTOM);

        // Navigate to home page
        Get.toNamed('/home');
      } catch (e) {
        String errorMessage;
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'user-not-found':
              errorMessage = 'User not found. Please check your email.';
              break;
            case 'wrong-password':
              errorMessage = 'Invalid password. Please try again.';
              break;
            default:
              errorMessage = 'Login failed. Please try again.';
          }
        } else {
          errorMessage = 'An unknown error occurred.';
        }
        Get.snackbar('Login Error', errorMessage,
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }
}