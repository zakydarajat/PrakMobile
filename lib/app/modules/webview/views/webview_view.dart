import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:myapp/app/modules/home/views/custom_bottom_navbar.dart';
import '../controllers/webview_controller.dart';

class ToDoWebView extends GetView<ToDoWebviewController> {
  const ToDoWebView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("WebView"),
        backgroundColor: Color(0xff34794e),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          // The WebView content
          Positioned.fill(
            child: WebViewWidget(
              controller: controller.webViewController('https://tweek.so/'),
            ),
          ),
          // The floating navigation bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNavBar(),
          ),
        ],
      ),
    );
  }
}
