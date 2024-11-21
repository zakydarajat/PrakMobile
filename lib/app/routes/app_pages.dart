import 'package:get/get.dart';
import 'package:myapp/app/modules/profile/bindings/profile_binding.dart';
import 'package:myapp/app/modules/profile/view/profile_page.dart';
import 'package:myapp/app/modules/task/bindings/http_binding.dart';
import 'package:myapp/app/modules/task/views/http_view.dart';
import 'package:myapp/app/modules/webview/bindings/webview_binding.dart';
import 'package:myapp/app/modules/webview/views/webview_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/home/bindings/home_bindings.dart';
import '../modules/home/views/home_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SIGNUP;

  static final routes = [
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomePage(),
      binding: HomeBindings(),
    ),
    GetPage(
      name: _Paths.HTTP,
      page: () => HttpView(),
      binding: HttpBinding(),
    ),
    GetPage(
      name: _Paths.WEBVIEW,
      page: () => ToDoWebView(),
      binding: WebViewBinding(),
    ),
    GetPage(
      name: Routes.PROFILE,
      page: () => ProfilePage(),
      binding: ProfileBinding(),
    ),
  ];
}
