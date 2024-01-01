import 'package:flutter/material.dart';
import 'package:webview_flutter/src/webview_controller.dart';

class WebContent extends StatefulWidget {
  const WebContent({super.key, required WebViewController controller});

  @override
  State<WebContent> createState() => _WebContentState();
}

class _WebContentState extends State<WebContent> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}