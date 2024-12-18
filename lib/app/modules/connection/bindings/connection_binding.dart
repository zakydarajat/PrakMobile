import 'package:get/get.dart';
import 'package:myapp/app/modules/connection/controllers/connection_controller.dart';

class ConnectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ConnectionController>(ConnectionController(), permanent: true);
  }
}
