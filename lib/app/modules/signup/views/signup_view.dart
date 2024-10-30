import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/signup/controllers/signup_controllers.dart';
import 'package:myapp/app/routes/app_pages.dart';

class SignupView extends GetView<SignupController> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF4CAF50); // Muted Emerald Green
    final accentColor = Color(0xFF8E44AD); // Rich Purple Accent
    final backgroundColor = Color(0xFFF8F9FA); // Light Warm Grey
    final fieldColor = Color(0xFFF2F3F5); // Very Light Grey for input fields

    // Ensure the controller is initialized
    final SignupController controller = Get.put(SignupController());

    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40),
                Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                _buildTextField(
                  hint: 'Username',
                  isPassword: false,
                  fieldColor: fieldColor,
                  onChanged: (value) => controller.username.value = value,
                ),
                SizedBox(height: 16),
                _buildTextField(
                  hint: 'Email',
                  isPassword: false,
                  fieldColor: fieldColor,
                  onChanged: (value) => controller.email.value = value,
                ),
                SizedBox(height: 16),
                Obx(() => _buildTextField(
                      hint: 'Password',
                      isPassword: true,
                      isVisible: controller.isPasswordVisible.value,
                      fieldColor: fieldColor,
                      onVisibilityPressed: controller.togglePasswordVisibility,
                      onChanged: (value) => controller.password.value = value,
                    )),
                SizedBox(height: 16),
                Obx(() => _buildTextField(
                      hint: 'Re-enter Password',
                      isPassword: true,
                      isVisible: controller.isRePasswordVisible.value,
                      fieldColor: fieldColor,
                      onVisibilityPressed: controller.toggleRePasswordVisibility,
                      onChanged: (value) => controller.rePassword.value = value,
                    )),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: controller.signup,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                    shadowColor: primaryColor.withOpacity(0.2),
                  ),
                ),
                SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.LOGIN);
                    },
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                        ),
                        children: [
                          TextSpan(
                            text: 'Log in',
                            style: TextStyle(
                              fontSize: 14,
                              color: accentColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    required Color fieldColor,
    bool isPassword = false,
    bool isVisible = false,
    Function()? onVisibilityPressed,
    Function(String)? onChanged,
  }) {
    return TextField(
      obscureText: isPassword && !isVisible,
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade600),
        filled: true,
        fillColor: fieldColor,
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.shade400,
            width: 1.2,
          ),
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey.shade600,
                ),
                onPressed: onVisibilityPressed,
              )
            : null,
      ),
      style: TextStyle(fontSize: 16),
    );
  }
}
