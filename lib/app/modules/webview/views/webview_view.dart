import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
//import 'dart:convert';
import '../controllers/webview_controller.dart';

class ToDoWebView extends GetView<ToDoWebviewController> {

const ToDoWebView({
super.key
});
@override
Widget build(BuildContext context) {
return Scaffold(
appBar: AppBar(
title: const Text("WebView"),
),
body: WebViewWidget(
controller: controller.webViewController('https://tweek.so/'),
));
}
}