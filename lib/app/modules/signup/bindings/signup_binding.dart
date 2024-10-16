import 'package:get/get.dart';
import 'package:myapp/app/modules/signup/controllers/signup_controllers.dart';

class SignupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupController>(
      () => SignupController(),
    );
  }
}
