import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final Rx<File?> profileImage = Rx<File?>(null);

  final RxString userName = 'User Name'.obs;
  final RxString userEmail = 'user@example.com'.obs;
  final RxString birthDate = '01-01-1990'.obs;
  final RxString address = 'Your Address'.obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        profileImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e');
    }
  }
}
