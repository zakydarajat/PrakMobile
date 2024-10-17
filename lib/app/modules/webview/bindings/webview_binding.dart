import 'package:get/get.dart';
import '../../webview/controllers/webview_controller.dart';
class WebViewBinding extends Bindings {
@override
void dependencies() {
Get.lazyPut(() => ToDoWebviewController());
}
}