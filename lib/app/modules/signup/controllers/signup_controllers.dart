import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;
  var confirmPassword = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Function to validate signup form
  bool validateSignupForm() {
    if (email.value.isEmpty ||
        password.value.isEmpty ||
        confirmPassword.value.isEmpty) {
      Get.snackbar('Error', 'All fields are required',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (password.value != confirmPassword.value) {
      Get.snackbar('Error', 'Passwords do not match',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    if (password.value.length < 6) {
      Get.snackbar('Error', 'Password must be at least 6 characters',
          snackPosition: SnackPosition.BOTTOM);
      return false;
    }

    // Email validation (basic regex check)
    if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
        .hasMatch(email.value)) {
      Get.snackbar('Error', 'Please enter a valid email address',
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
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: email.value.trim(),
          password: password.value.trim(),
        );

        // Store additional user information in Firestore
        await _firestore.collection('users').doc(userCredential.user?.uid).set({
          'email': email.value.trim(),
          'createdAt': DateTime.now().toIso8601String(),
        }).then((_) {
          // Success: show success message
          Get.snackbar('Success', 'Account created successfully!',
              snackPosition: SnackPosition.BOTTOM);

          // Navigate to login page
          Get.toNamed('/login');
        }).catchError((e) {
          // If there was an error writing to Firestore, delete user from Firebase Authentication
          userCredential.user?.delete();
          Get.snackbar(
              'Firestore Error', 'Failed to save user data. Please try again.',
              snackPosition: SnackPosition.BOTTOM);
        });
      } catch (e) {
        String errorMessage = 'Signup Error: Please try again later.';
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'email-already-in-use':
              errorMessage = 'The email address is already in use.';
              break;
            case 'invalid-email':
              errorMessage = 'The email address is not valid.';
              break;
            case 'weak-password':
              errorMessage = 'The password is too weak.';
              break;
            default:
              errorMessage = e.message ?? 'Unknown error occurred.';
          }
        }
        Get.snackbar('Signup Error', errorMessage,
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }
}
