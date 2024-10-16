import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/login/views/login_view.dart';
import 'package:myapp/app/modules/signup/controllers/signup_controllers.dart';
import 'package:myapp/app/routes/app_pages.dart';
//import '../../../routes/app_routes.dart'; // Pastikan rute tersedia

class SignupView extends GetView<SignupController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(height: 50),
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 78, 148, 81),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Daftar',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                _buildTextField(
                  icon: Icons.person,
                  hint: 'Username',
                  isPassword: false,
                ),
                SizedBox(height: 10),
                _buildTextField(
                  icon: Icons.email,
                  hint: 'Email',
                  isPassword: false,
                ),
                SizedBox(height: 10),
                Obx(() => _buildTextField(
                      icon: Icons.lock,
                      hint: 'Password',
                      isPassword: true,
                      isVisible: controller.isPasswordVisible.value,
                      onVisibilityPressed: controller.togglePasswordVisibility,
                    )),
                SizedBox(height: 10),
                Obx(() => _buildTextField(
                      icon: Icons.lock,
                      hint: 'RePassword',
                      isPassword: true,
                      isVisible: controller.isRePasswordVisible.value,
                      onVisibilityPressed:
                          controller.toggleRePasswordVisibility,
                    )),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Logic untuk sign up bisa ditambahkan di sini
                  },
                  child: Text(
                    'Daftar',
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Menjadikan teks bold
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
                SizedBox(height: 20),

                // Bagian baru untuk teks dan button Log In
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Sudah punya akun?',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Routing ke halaman Log In menggunakan GetX
                        // Get.toNamed(Routes.LOGIN); // Routes.LOGIN harus didefinisikan di routes
                        Get.to(LoginView());
                        Get.to(Routes.LOGIN);
                      },
                      child: Text(
                        'Log in',
                        style: TextStyle(
                          fontSize: 16,
                          color:
                              Colors.purple, // Ubah warna teks sesuai kebutuhan
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required IconData icon,
    required String hint,
    bool isPassword = false,
    bool isVisible = false,
    Function()? onVisibilityPressed,
  }) {
    return TextField(
      obscureText: isPassword && !isVisible,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: onVisibilityPressed,
              )
            : null,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        filled: true,
        fillColor: Colors.grey.shade300,
      ),
    );
  }
}
