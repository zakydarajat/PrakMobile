import 'package:get/get.dart';

class NavBarController extends GetxController {
  // Reactive variable to track the active index
  var selectedIndex = 0.obs;

  // Method to update the selected index
  void updateIndex(int index) {
    selectedIndex.value = index;
  }
}
