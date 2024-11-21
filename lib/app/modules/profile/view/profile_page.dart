import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/app/modules/profile/controllers/profile_controller.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController profileController = Get.find();

  @override
  Widget build(BuildContext context) {
    final primaryColor = Color(0xff34794e);
    final textColor = Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: primaryColor,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(context, primaryColor, textColor), // Berikan context
                SizedBox(height: 24),
                _buildProfileInfo(textColor),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    // Edit profile logic
                    Get.snackbar("Profile", "Edit profile feature coming soon!");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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

  Widget _buildHeader(BuildContext context, Color primaryColor, Color textColor) {
    return Stack(
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () => _showImagePickerDialog(),
              child: Obx(() {
                return CircleAvatar(
                  radius: 60,
                  backgroundColor: primaryColor,
                  backgroundImage: profileController.profileImage.value != null
                      ? FileImage(profileController.profileImage.value!)
                      : null,
                  child: profileController.profileImage.value == null
                      ? Icon(Icons.person, size: 60, color: Colors.white)
                      : null,
                );
              }),
            ),
            SizedBox(height: 16),
            Obx(() {
              return Column(
                children: [
                  Text(
                    profileController.userName.value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                  Text(
                    profileController.userEmail.value,
                    style: TextStyle(
                      fontSize: 14,
                      color: textColor.withOpacity(0.6),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
        Positioned(
          bottom: 8,
          right: MediaQuery.of(context).size.width * 0.5 - 40,
          child: InkWell(
            onTap: () => _showImagePickerDialog(),
            child: Container(
              decoration: BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              padding: EdgeInsets.all(8),
              child: Icon(Icons.add, color: Colors.white, size: 24),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo(Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Account Details",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        SizedBox(height: 16),
        Obx(() {
          return Column(
            children: [
              ListTile(
                leading: Icon(Icons.person, color: textColor),
                title: Text("Username"),
                subtitle: Text(profileController.userName.value),
              ),
              ListTile(
                leading: Icon(Icons.calendar_today, color: textColor),
                title: Text("Birth Date"),
                subtitle: Text(profileController.birthDate.value),
              ),
              ListTile(
                leading: Icon(Icons.home, color: textColor),
                title: Text("Address"),
                subtitle: Text(profileController.address.value),
              ),
            ],
          );
        }),
      ],
    );
  }

  void _showImagePickerDialog() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Choose Profile Picture",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Get.back();
                    profileController.pickImage(ImageSource.camera);
                  },
                  icon: Icon(Icons.camera_alt),
                  label: Text("Camera"),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.back();
                    profileController.pickImage(ImageSource.gallery);
                  },
                  icon: Icon(Icons.photo_library),
                  label: Text("Gallery"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
