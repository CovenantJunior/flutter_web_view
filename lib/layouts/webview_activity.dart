import 'package:flutter/material.dart';
import 'package:flutter_web_view/layouts/web_content.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebView extends StatefulWidget {
  const WebView({super.key});

  @override
  State<WebView> createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()..loadRequest(
      Uri.parse('https://calculateall.net/')
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebContent(
        controller: controller,
      ),
    );
  }
}