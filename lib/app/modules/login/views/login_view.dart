import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/login/controllers/login_controller.dart';
import '../../signup/views/signup_view.dart';
import 'package:myapp/app/routes/app_pages.dart';

class LoginView extends GetView<LoginController> {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xFF4CAF50); // Muted Emerald Green
    final accentColor = Color(0xFFD08159); // Soft Blush Pink
    final backgroundColor = Color(0xFFFAFAFA); // Warm White
    final fieldColor = Color(0xFFF0F4F8); // Light Sage Grey

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Circular logo or placeholder at the top for branding
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(
                        'assets/app_logo.png'), // Add your app logo here
                    backgroundColor: Colors.transparent,
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: primaryColor,
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Center(
                  child: Text(
                    "Log in to continue",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                SizedBox(height: 40),
                _buildTextField(
                  hintText: "Email",
                  isPassword: false,
                  fieldColor: fieldColor,
                ),
                SizedBox(height: 16),
                Obx(() => _buildTextField(
                      hintText: "Password",
                      isPassword: true,
                      fieldColor: fieldColor,
                      isVisible: controller.isPasswordVisible.value,
                      onVisibilityPressed: controller.togglePasswordVisibility,
                    )),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Get.toNamed(Routes.HOME);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 14.0),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
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
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    "Or sign in with",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                _buildSocialButtons(primaryColor),
                SizedBox(height: 32),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade800,
                      ),
                      children: [
                        TextSpan(
                          text: "Sign up",
                          style: TextStyle(
                            fontSize: 14,
                            color: accentColor,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.to(SignupView());
                              Get.toNamed(Routes.SIGNUP);
                            },
                        ),
                      ],
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
    required String hintText,
    required bool isPassword,
    required Color fieldColor,
    bool isVisible = false,
    Function()? onVisibilityPressed,
  }) {
    return TextField(
      obscureText: isPassword && !isVisible,
      style: TextStyle(color: Color(0xFF333333)),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey.shade500),
        filled: true,
        fillColor: fieldColor,
        contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
                  color: Colors.grey.shade500,
                ),
                onPressed: onVisibilityPressed,
              )
            : null,
      ),
    );
  }

  Widget _buildSocialButtons(Color borderColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton('assets/images/google_logo.png', borderColor),
        SizedBox(width: 16),
        _buildSocialButton('assets/images/facebook_logo.png', borderColor),
      ],
    );
  }

  Widget _buildSocialButton(String assetPath, Color borderColor) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.HOME); // Direct to the same page as login
      },
      child: Container(
        width: 48,
        height: 48,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: borderColor.withOpacity(0.3), width: 1),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: borderColor.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Image.asset(assetPath),
      ),
    );
  }
}
