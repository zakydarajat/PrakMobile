import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/app/modules/home/controllers/navbar_controller.dart';
import 'package:myapp/app/modules/task/bindings/http_binding.dart';
import 'package:myapp/app/modules/task/views/http_view.dart';
import 'package:myapp/app/modules/webview/bindings/webview_binding.dart';
import 'package:myapp/app/modules/webview/views/webview_view.dart';

class CustomBottomNavBar extends StatelessWidget {
  final Color primaryColor = Color(0xff34794e);

  // Initialize the NavBarController
  final NavBarController navBarController = Get.put(NavBarController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16, left: 20, right: 20),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.home,
            label: 'Home',
            index: 0,
            onTap: () {
              navBarController.updateIndex(0);
              Get.offAllNamed('/home');
            },
          ),
          _buildNavItem(
            icon: Icons.task,
            label: 'Tasks',
            index: 1,
            onTap: () {
              navBarController.updateIndex(1);
              Get.offAll(() => HttpView(), binding: HttpBinding());
            },
          ),
          _buildCenterButton(),
          _buildNavItem(
            icon: Icons.info_outline,
            label: 'Info',
            index: 2,
            onTap: () {
              navBarController.updateIndex(2);
              Get.to(() => ToDoWebView(), binding: WebViewBinding());
            },
          ),
          _buildNavItem(
            icon: Icons.settings,
            label: 'Settings',
            index: 3,
            onTap: () {
              navBarController.updateIndex(3);
              // Navigate to settings or implement settings logic
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Obx(() {
        bool isActive = navBarController.selectedIndex.value == index;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? primaryColor : Colors.grey.shade600,
              size: isActive ? 28 : 24,
            ),
            SizedBox(height: 4),
            if (isActive)
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: primaryColor,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildCenterButton() {
    return Container(
      width: 58,
      height: 58,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff42a87b), primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(Icons.add, color: Colors.white, size: 30),
        onPressed: () {
          // Define the action for the central button here
          // For example, navigate to a task creation page or open a modal
          Get.toNamed('/add-task');
        },
      ),
    );
  }
}
